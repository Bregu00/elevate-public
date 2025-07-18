local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local function log(source, message, screnshot)
    exports.onl_logsender:SendLog(source, message, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = false,
            playerName = false,
            screenshot = screnshot,
            money = false,
            black_money = false,
            bank = false,
            coords = true,
            radio = false,

        },
        discordTitle = message,
        discordWebhook = ""
    })
end

ESX.RegisterServerCallback('elm_druglab:hasPerm', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasPerm = xPlayer.getGroup() == ConfigServer.admingroup
    cb(hasPerm)
end)

ESX.RegisterServerCallback('elm_druglab:doesGangHave', function(source, cb, gang)
    MySQL.query('SELECT * FROM druglabs WHERE gang = ?', {gang}, function(result)
        if result[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('elm_druglab:hasItem', function(source, cb, item, farmtype)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.hasItem(ConfigServer.Shells[item]['pack'].itemrequired) and xPlayer.hasItem(ConfigServer.Shells[item]['pack'].itemrequired).count >= ConfigServer.Shells[item]['pack'].amount_required then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('elm_druglab:getLabs', function(source, cb)
    MySQL.query('SELECT * FROM druglabs', function(result)
        if result then
            local labs = {}
            for i=1, #result, 1 do
                local json = json.decode(result[i].info)
                for k,v in pairs(json) do
                    local lab = {
                        gang = result[i].label,
                        x = nil,
                        y = nil,
                        z = nil,
                        id = result[i].id,
                        entryx = nil,
                        entryy = nil,
                        entryz = nil,
                        type = result[i].object,
                        pakx = nil,
                        paky = nil,
                        pakz = nil,
                        processx = nil,
                        processy = nil,
                        processz = nil,
                        farmx = nil,
                        farmy = nil,
                        farmz = nil,
                        rotationx = v.rotationx,
                        rotationy = v.rotationy,
                        rotationz = v.rotationz,
                        positionx = v.positionx,
                        positiony = v.positiony,
                        positionz = v.positionz,
                        handle = v.handle,
                        pin = result[i].pin
                    }
                    for k2, v2 in pairs(v) do
                        if k2 == 'entrypos' then
                            lab.x = v2.x
                            lab.y = v2.y
                            lab.z = v2.z
                        end
                        if k2 == 'shellpos' then
                            lab.entryx = v2.x
                            lab.entryy = v2.y
                            lab.entryz = v2.z
                        end
                        if k2 == 'door' then
                            lab.doorx = v2.x
                            lab.doory = v2.y
                            lab.doorz = v2.z
                        end
                        if k2 == 'pak' then
                            lab.pakx = v2.x
                            lab.paky = v2.y
                            lab.pakz = v2.z
                        end
                        if k2 == 'kemi_inv' then
                            lab.kemix = v2.x
                            lab.kemiy = v2.y
                            lab.kemiz = v2.z
                        end
                        if k2 == 'process' then
                            lab.processx = v2.x
                            lab.processy = v2.y
                            lab.processz = v2.z
                        end
                    end
                    table.insert(labs, lab)
                end
                exports.ox_inventory:RegisterStash("druglab" .. result[i].id, "Drug lab", 50, 10000000)
            end
            cb(labs)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elm_druglab:getLab', function(source, cb, gang)
    MySQL.query('SELECT * FROM druglabs WHERE gang = ?', {gang}, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('elm_druglab:canPoliceRaid', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().name == 'police')
end)

ESX.RegisterServerCallback('elm_druglab:canRaidLab', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().isgang)
end)

RegisterNetEvent('elm_druglab:logenter')
AddEventHandler('elm_druglab:logenter', function(stof, gang)
    local s = source
    local xPlayer = ESX.GetPlayerFromId(source)
end)

RegisterNetEvent('elm_druglab:opretLab')
AddEventHandler('elm_druglab:opretLab', function(object, info, gang, label, pin)
    local s = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        MySQL.Async.execute('INSERT INTO druglabs (object, gang, label, info, pin, timecreated, timeupdated) VALUES (@object, @gang, @label, @info, @pin, @timecreated, @timeupdated)', {
            ['@object'] = object,
            ['@gang'] = gang,
            ['@label'] = label,
            ['@info'] = info,
            ['@pin'] = tonumber(pin),
            ['@timecreated'] = os.date('%Y-%m-%d %H:%M:%S'),
            ['@timeupdated'] = os.date('%Y-%m-%d %H:%M:%S'),
        }, function(rowsChanged)
            MySQL.query('SELECT * FROM druglabs', function(result)
                if result then
                    local labs = {}
                    for i=1, #result, 1 do
                        local json = json.decode(result[i].info)
                        for k,v in pairs(json) do
                            local lab = {
                                gang = result[i].label,
                                x = nil,
                                y = nil,
                                z = nil,
                                id = result[i].id,
                                entryx = nil,
                                entryy = nil,
                                entryz = nil,
                                type = result[i].object,
                                pakx = nil,
                                paky = nil,
                                pakz = nil,
                                processx = nil,
                                processy = nil,
                                processz = nil,
                                farmx = nil,
                                farmy = nil,
                                farmz = nil,
                                rotationx = v.rotationx,
                                rotationy = v.rotationy,
                                rotationz = v.rotationz,
                                positionx = v.positionx,
                                positiony = v.positiony,
                                positionz = v.positionz,
                                handle = v.handle,
                                pin = result[i].pin
                            }
                            for k2, v2 in pairs(v) do
                                if k2 == 'entrypos' then
                                    lab.x = v2.x
                                    lab.y = v2.y
                                    lab.z = v2.z
                                end
                                if k2 == 'shellpos' then
                                    lab.entryx = v2.x
                                    lab.entryy = v2.y
                                    lab.entryz = v2.z
                                end
                                if k2 == 'door' then
                                    lab.doorx = v2.x
                                    lab.doory = v2.y
                                    lab.doorz = v2.z
                                end
                                if k2 == 'pak' then
                                    lab.pakx = v2.x
                                    lab.paky = v2.y
                                    lab.pakz = v2.z
                                end
                                if k2 == 'kemi_inv' then
                                    lab.kemix = v2.x
                                    lab.kemiy = v2.y
                                    lab.kemiz = v2.z
                                end
                                if k2 == 'process' then
                                    lab.processx = v2.x
                                    lab.processy = v2.y
                                    lab.processz = v2.z
                                end
                            end
                            table.insert(labs, lab)
                        end
                        exports.ox_inventory:RegisterStash("druglab" .. result[i].id, "Drug lab", 50, 10000000)
                    end
                    log(s, "Lab has been created for " .. gang .. " The drug is " .. object, true)
                    TriggerClientEvent("elm_druglab:client:fullSync", -1, labs)
                end
            end)
        end)
    end 
end)

lib.callback.register('elm_druglab:server:packDrug', function(source, drug, labid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer ~= nil then
        local item = exports.ox_inventory:GetItem("druglab" .. labid, "kemi", nil, false)
        if item.count < 1 then return false, 'Labbet er tom for kemikalier' end
        if exports['ox_inventory']:CanCarryItem(src, ConfigServer.Shells[drug]['pack'].itemgiven, ConfigServer.Shells[drug]['pack'].amount_given) then
            if not exports['ox_inventory']:RemoveItem(src, ConfigServer.Shells[drug]['pack'].itemrequired, ConfigServer.Shells[drug]['pack'].amount_required) then return false, 'Du har ikke de rette items' end
            exports['ox_inventory']:RemoveItem("druglab" .. labid, "kemi", 1)
            exports['ox_inventory']:AddItem(src, ConfigServer.Shells[drug]['pack'].itemgiven, ConfigServer.Shells[drug]['pack'].amount_given)
            log(src, xPlayer.getName() .. " made " .. ConfigServer.Shells[drug]['pack'].amount_given .. "x ".. ConfigServer.Shells[drug]['pack'].itemgiven .. " in a lab", false)
            return true
        else
            return false, 'Du har ikke plads nok til at bære dette'
        end
    else
        return false, 'fejl'
    end
end)

lib.callback.register("elm_lab:server:handleKemiBox", function(source, slot)
    local src = source
    if exports.ox_inventory:CanCarryItem(source, "kemi", 50) then
        if exports.ox_inventory:RemoveItem(src, "kemibox", 1, nil, slot) then
            if exports.ox_inventory:AddItem(src, "kemi", 50) then
                return true
            end
        end
    else
        lib.notify({
            title = "Ikke nok plads",
            description = "Du har ikke plads til at bære dette",
            type = "error"
        })
        return false
    end
    return false
end)