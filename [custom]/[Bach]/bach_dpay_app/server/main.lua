local function logActivity(source, targetSource, amount, message, positive, isRequest)
    local xPlayer = ESX.GetPlayerFromId(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    local targetPhoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(targetSource)
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if not phoneNumber or not targetPhoneNumber or not xTarget then
        print("Failed to log activity: missing phone numbers.")
        return false
    end

    MySQL.insert.await([[
        INSERT INTO bach_dpay_activities (userNumber, name, number, amount, positive, message, date, isCompany, isRequest)
        VALUES (@userNumber, @name, @number, @amount, @positive, @message, NOW(), false, @isRequest)
    ]], {
        ["@userNumber"] = phoneNumber,
        ["@name"] = xTarget.getName(),
        ["@number"] = targetPhoneNumber,
        ["@amount"] = amount,
        ["@positive"] = positive,
        ["@message"] = message,
        ["@isRequest"] = isRequest,
    })
end

lib.callback.register("drp_dpay:server:getContacts", function(source)
    local Contacts = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)

    if not phoneNumber then
        print("Intet nummer fundet til " .. tostring(source))
        return {}
    end

    local response = MySQL.query.await(" SELECT * FROM phone_phone_contacts WHERE phone_number = @phone_number", {
        ["@phone_number"] = phoneNumber,
    })

    if not response then
        return {}
    end

    for k, v in pairs(response) do
        table.insert(Contacts, {
            name = v.firstname .. " " .. v.lastname,
            number = tonumber(v.contact_phone_number),
        })
    end

    return Contacts
end)

lib.callback.register("drp_dpay:server:getActivity", function(source)
    local Activity = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)

    if not phoneNumber then
        print("Intet nummer fundet til " .. tostring(source))
        return {}
    end

    local response = MySQL.query.await(" SELECT * FROM bach_dpay_activities WHERE userNumber = @userNumber AND requestPaid = false ORDER BY id DESC", {
        ["@userNumber"] = phoneNumber,
    })

    if not response then
        return {}
    end

    for k, v in pairs(response) do
        table.insert(Activity, {
            name = v.name,
            date = v.date,
            amount = tonumber(v.amount),
            positive = v.positive,
            isCompany = v.isCompany,
            number = tonumber(v.number),
            isRequest = v.isRequest,
            dbID = v.id,
        })
    end

    return Activity
end)

lib.callback.register("drp_dpay:server:getSuggestions", function(source)
    local Suggestions = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)

    if not phoneNumber then
        print("Intet nummer fundet til " .. tostring(source))
        return {}
    end

    local response = MySQL.query.await([[
        SELECT a.name, a.number, COUNT(a.id) AS interaction_count
        FROM bach_dpay_activities a
        WHERE a.userNumber = @userNumber
        GROUP BY a.number
        ORDER BY interaction_count DESC
        LIMIT 6
    ]], {
        ["@userNumber"] = phoneNumber,
    })

    if not response then
        return {}
    end

    for k, v in pairs(response) do
        table.insert(Suggestions, {
            name = v.name,
            number = tonumber(v.number),
        })
    end

    return Suggestions
end)

lib.callback.register("drp_dpay:server:getUserFromID", function(source, data)
    if data.id == source then
        return TriggerEvent("ox_lib:notify", source, {
            description = "Du kan ikke gøre dette med dig selv",
            type = "error",
            icon = "phone",
        })
    end

    local xTarget = ESX.GetPlayerFromId(data.id)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(data.id)

    if xTarget and phoneNumber then
        return {
            name = xTarget.getName(),
            number = phoneNumber,
        }
    end

    return false
end)

lib.callback.register("drp_dpay:server:sendMoney", function(source, data)
    local targetSource = exports["lb-phone"]:GetSourceFromNumber(tostring(data.userNumber))
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if not targetSource then
        return {
            state = false,
            msg = "Personen er ikke i byen.",
        }
    end

    if exports["fh_accountclose"]:isAccountLocked(targetSource, true) then 
        return {
            state = false,
            msg = "Din/personen du sender til konto er låst.",
        }
    end

    if exports["fh_accountclose"]:isAccountLocked(source, true) then 
        return {
            state = false,
            msg = "Din/personen du sender til konto er låst.",
        }
    end

    if targetSource == source then
        return TriggerEvent("ox_lib:notify", source, {
            description = "Du kan ikke gøre dette med dig selv",
            type = "error",
            icon = "phone",
        })
    end

    if xPlayer.getAccount("bank").money <= data.amount then
        return {
            state = false,
            msg = "Du har ikke nok på din bank konto.",
        }
    end

    xPlayer.removeAccountMoney("bank", data.amount)
    Wait(100)
    xTarget.addAccountMoney("bank", data.amount)

    logActivity(source, targetSource, data.amount, data.message or "Overførsel", false, false)
    logActivity(targetSource, source, data.amount, data.message or "Modtaget penge", true, false)

    exports["lb-phone"]:SendNotification(targetSource, {
        app = "dPay",
        title = "dPay",
        content = "Du har modtaget " .. lib.math.groupdigits(data.amount, ",") .. " fra " .. xPlayer.getName(),
    })

    if data.dbID then
        local affectedRowsPlayer = MySQL.update.await([[
            UPDATE bach_dpay_activities SET requestPaid = true WHERE id = @id
        ]], {
            ["@id"] = data.dbID
        })

        local affectedRowsTarget = MySQL.update.await([[
            UPDATE bach_dpay_activities SET requestPaid = true WHERE userNumber = @targetUserNumber AND number = @userNumber AND amount = @amount AND UNIX_TIMESTAMP(date) = @date AND isRequest = true
        ]], {
            ["@targetUserNumber"] = exports["lb-phone"]:GetEquippedPhoneNumber(targetSource),
            ["@userNumber"] = xPlayer.getPhoneNumber(),
            ["@amount"] = data.amount,
            ["@date"] = data.date / 1000,
        })
    end

    return {
        state = true,
    }
end)

lib.callback.register("drp_dpay:server:requestMoney", function(source, data)
    local targetSource = exports["lb-phone"]:GetSourceFromNumber(tostring(data.userNumber))

    if targetSource == source then
        return TriggerEvent("ox_lib:notify", source, {
            description = "Du kan ikke gøre dette med dig selv",
            type = "error",
            icon = "phone",
        })
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if not targetSource or not xTarget then
        return {
            state = false,
            msg = "Personen er ikke i byen.",
        }
    end

    logActivity(source, targetSource, data.amount, data.message or "Anmodning om penge", true, true)
    logActivity(targetSource, source, data.amount, data.message or "Modtaget anmodning", false, true)

    exports["lb-phone"]:SendNotification(targetSource, {
        app = "dPay",
        title = "dPay",
        content = xPlayer.getName() .. " har anmodet om..."
    })

    return {
        state = true,
    }
end)

lib.callback.register("drp_dpay:server:cancelRequest", function(source, data)
    local targetSource = exports["lb-phone"]:GetSourceFromNumber(tostring(data.number))
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if data.dbID then
        local affectedRowsPlayer = MySQL.update.await([[
            DELETE FROM bach_dpay_activities 
            WHERE id = @id AND userNumber = @userNumber AND number = @number AND isRequest = true
        ]], {
            ["@id"] = data.dbID,
            ["@userNumber"] = xPlayer.getPhoneNumber(),
            ["@number"] = data.number,
        })

        local affectedRowsTarget = MySQL.update.await([[
            DELETE FROM bach_dpay_activities 
            WHERE userNumber = @targetUserNumber AND number = @userNumber AND amount = @amount AND UNIX_TIMESTAMP(date) = @date AND isRequest = true
        ]], {
            ["@targetUserNumber"] = exports["lb-phone"]:GetEquippedPhoneNumber(targetSource),
            ["@userNumber"] = xPlayer.getPhoneNumber(),
            ["@amount"] = data.amount,
            ["@date"] = data.date / 1000,
        })

        if (affectedRowsPlayer and affectedRowsPlayer > 0) and (affectedRowsTarget and affectedRowsTarget > 0) then
            return {
                state = true,
                msg = "Anmodningen er annulleret.",
            }
        else
            return {
                state = false,
                msg = "Kunne ikke annullere anmodningen for begge brugere.",
            }
        end
    else
        return {
            state = false,
            msg = "Ingen gyldig anmodnings ID fundet.",
        }
    end
end)

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end
