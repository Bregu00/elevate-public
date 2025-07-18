local webhook = ""
local vehiclesToUpdate = {}
local allVehicleSounds = {}

CreateThread(function()
    local result = MySQL.Sync.fetchAll('SELECT * FROM vehiclesounds')
    for i = 1, #result do
        allVehicleSounds[result[i].plate] = result[i].sound
    end
end)


local function checkVehicleOwned(cb, src, plate)
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end

local function setEntityEngineSound(plate, source)
    local src = source
    Wait(250)
    local veh = GetVehiclePedIsIn(GetPlayerPed(src) ,false)
    if allVehicleSounds[plate] ~= nil and veh ~= 0 then
        local ent = Entity(veh).state
        ent:set('muffler', allVehicleSounds[plate], true)
        local netid = NetworkGetNetworkIdFromEntity(veh)
        table.insert(vehiclesToUpdate,  {vehicle = netid,  sound = allVehicleSounds[plate]})
    end
end

local function setEntityIdEngineSound(entityid, plate, source)
    local src = source
    Wait(250)
    if allVehicleSounds[plate] ~= nil and veh ~= 0 then
        local ent = Entity(entityid).state
        ent:set('muffler', allVehicleSounds[plate], true)
        local netid = NetworkGetNetworkIdFromEntity(entityid)
        table.insert(vehiclesToUpdate,  {vehicle = netid,  sound = allVehicleSounds[plate]})
    end
end

exports('setEntityEngineSound', setEntityEngineSound)
exports('setEntityIdEngineSound', setEntityIdEngineSound)

RegisterNetEvent('syn-engineSound:server:removeEntityFromSoundTable', function()
    local src = source
    local veh = GetVehiclePedIsIn(GetPlayerPed(src) ,false)
    local netId = NetworkGetNetworkIdFromEntity(veh)
    for i = 1, #vehiclesToUpdate do
        if netId and netId == vehiclesToUpdate[i].vehicle then
            vehiclesToUpdate[i] = nil
        end
    end
end)

RegisterNetEvent('syn-engineSound:server:setEntityEngineSound', function(plate)
    local src = source
    checkVehicleOwned(function(owned)
        if not owned then return end
        setEntityEngineSound(plate, src)
    end, src, plate)
end)

ESX.RegisterServerCallback('syn-enginesounds:server:removeCustomSound', function(source, cb, plate, veh)
    if not allVehicleSounds[plate] then 
        return cb(false, "Denne bil har ingen custom lyd.", "error") 
    end
    checkVehicleOwned(function(owned)
        if not owned then 
            return cb(false, "Denne bil er ikke ejet af en person.", "error") 
        end
        MySQL.Sync.execute('DELETE FROM vehiclesounds WHERE plate = ?', {plate})
        allVehicleSounds[plate] = nil
        for i = 1, #vehiclesToUpdate do
            if veh then
                if veh == vehiclesToUpdate[i].vehicle then
                    vehiclesToUpdate[i] = nil
                end
            end
        end
        local type, license = GetLicense(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local characterName = xPlayer and xPlayer.getName() or "Unknown"
        if type == "discord" then license = "<@".. license .. ">" else license = license end
        sendToDiscord("[FJERNET] Engine Sound", "[" .. characterName .. "] " .. license .. " har fjernet en lyd på nummerplade " .. plate, 16711680)
        return cb(true, "Du har fjernet lyden fra ".. plate, "success")
    end, source, plate)
end)

ESX.RegisterServerCallback('syn-enginesounds:server:checkCustomSound', function(source, cb, plate)
    if not allVehicleSounds[plate] then return cb(false, "Denne bil har ingen custom lyd.", "error") end
    checkVehicleOwned(function(owned)
        if not owned then return cb(false, "Denne bil er ikke ejet af en person.", "error") end
        for i = 1, #Config.engineCategories do
            local v = Config.engineCategories[i]
            for index = 1, #v.engineTypes do
                local value = v.engineTypes[index]
                if value.name == allVehicleSounds[plate] then
                    return cb(true, "Denne bil har lyden ".. value.label, "success")
                end
            end
        end
    end, source, plate)
end)

ESX.RegisterServerCallback('syn-engineSound:server:updateVehicleSound', function(source, cb, category, plate, sound)
    local src = source
    if not Config.engineCategories[category].engineTypes[sound] then return cb(false, "Denne lyd eksistere ikke.", "error") end
    checkVehicleOwned(function(owned)
        if not owned then return cb(false, "Denne bil er ikke ejet af en person.", "error") end
        exports.oxmysql:query("INSERT INTO vehiclesounds (plate, sound) VALUES (?, ?) ON DUPLICATE KEY UPDATE sound = VALUES(sound)",{plate, Config.engineCategories[category].engineTypes[sound].name})
        allVehicleSounds[plate] = Config.engineCategories[category].engineTypes[sound].name
        local veh = GetVehiclePedIsIn(GetPlayerPed(src) ,false)
        local netid = NetworkGetNetworkIdFromEntity(veh)
        table.insert(vehiclesToUpdate,  {vehicle = netid,  sound = allVehicleSounds[plate]})
        setEntityEngineSound(plate, source)
        local type, license = GetLicense(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        local characterName = xPlayer.getName()
        if type == "discord" then license = "<@".. license .. ">" else license = license end
        sendToDiscord("[TILFØJET] Engine Sound", "[" .. characterName .. "] " .. license .. " har installeret ".. Config.engineCategories[category].engineTypes[sound].label .. " på nummerplade " .. "**" .. plate .. "**", 65280)
        return cb(true, "Du har installeret ".. Config.engineCategories[category].engineTypes[sound].label .. " på nummerplade " .. plate, "success" )
    end, src, plate)
end)

lib.callback.register("syn-engineSound:server:getVehiclesToUpdate",  function(source)
    return vehiclesToUpdate
end)


GetLicense = function(source)
    local identifiers = GetPlayerIdentifiers(source)
    for i = 1, #identifiers do
        if string.find(identifiers[i], "discord") then
            return "discord", string.gsub(identifiers[i], "discord:", "")
        elseif string.find(identifiers[i], "license") then
            return "license", identifiers[i]
        end
    end
end



sendToDiscord = function(name, message, color)
    local embed = {
        {
            ["color"] = color,
            ["title"] = name,
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Elevate Engine Sounds"
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Elevate Engine Sounds", embeds = embed}), { ['Content-Type'] = 'application/json' })
end