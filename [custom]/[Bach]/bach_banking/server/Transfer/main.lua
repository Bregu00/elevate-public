local ESX = exports["es_extended"]:getSharedObject()

lib.callback.register("getContacts", function(source)
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    local contacts = {}

    if not phoneNumber then
        return nil
    end

    local response = MySQL.query.await([[
        SELECT * FROM `phone_phone_contacts` 
        WHERE `phone_number` = ? 
        ORDER BY firstname, lastname
    ]], {
        phoneNumber,
    })

    for i = 1, #response do
        local row = response[i]
        table.insert(contacts, {
            id = row.contact_phone_number,
            name = row.firstname .. " " .. row.lastname,
            value = row.contact_phone_number,
            profile_image = row.profile_image or nil,
        })
    end
    return contacts
end)

lib.callback.register("transfer", function(source, amount, recipient, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local yPlayer = ESX.GetPlayerFromId(recipient)
    if not xPlayer then
        return false, "Du har ikke nogen telefon"
    end

    print('transfer', source, amount, recipient, message)

    if exports["fh_accountclose"]:isAccountLocked(source, true) then return false, "Personens konto er låst." end
    if exports["fh_accountclose"]:isAccountLocked(recipient, true) then return false, "Din konto er låst. Domstolen har lukket din konto." end

    local recipientPhoneNumber

    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
    if not phoneNumber then
        return false, "Du har ikke nogen telefon"
    end

    if not recipient or type(recipient) ~= "string" then
        return false, "Du har ikke nogen telefon"
    end

    local recipientPlayer

    if string.match(recipient, "^%d%d%d%d%d%d%d%d$") then

        if tonumber(recipient) == phoneNumber then
            return false, "Du kan ikke sende penge til dig selv"
        end

        local sourcePlayer = exports["lb-phone"]:GetSourceFromNumber(recipient)
        if not sourcePlayer then
            return false, "Denne person er ikke i byen"
        end

        if sourcePlayer == source then
            return false, "Du kan ikke sende penge til dig selv"
        end

        recipientPhoneNumber = tonumber(recipient)
        recipientPlayer = ESX.GetPlayerFromId(sourcePlayer)
    else

        if tonumber(recipient) == source then
            return false, "Du kan ikke sende penge til dig selv"
        end

        recipientPhoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(tonumber(recipient))

        if not recipientPhoneNumber then
            return false, "Denne person er ikke i byen"
        end

        if recipientPhoneNumber == phoneNumber then
            return false, "Du kan ikke sende penge til dig selv"
        end

        recipientPlayer = ESX.GetPlayerFromId(recipient)
    end

    if not recipientPlayer then
        return false, "Denne person har ikke en telefon"
    end

    if recipientPlayer.source == source then
        return false, "Du kan ikke sende penge til dig selv"
    end

    if xPlayer.getAccount("bank").money < amount then
        return false, "Du har ikke nok penge på din konto"
    end

    messageFrom = xPlayer.getName() .. " " .. message or xPlayer.getName()
    messageTo = recipientPlayer.getName() .. " " .. message or recipientPlayer.getName()

    xPlayer.removeAccountMoney("bank", amount)

    local logMsg = "Har overført " .. amount .. " KR til " .. recipientPlayer.getName() .. "\nMed beskeden: " .. message

    exports['onl_logsender']:SendLog(source, logMsg, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,
        },
        discordTitle = "Banking",
        discordWebhook = "",
    })

    exports["lb-phone"]:AddTransaction(phoneNumber, -amount, messageTo, nil)
    Wait(1000)
    exports["lb-phone"]:AddTransaction(recipientPhoneNumber, amount, messageFrom, nil)

    Wait(1000)

    recipientPlayer.addAccountMoney("bank", amount)

    return true
end)
