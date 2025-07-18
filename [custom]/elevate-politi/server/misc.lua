lib.callback.register('elevate-politi:server:createTempStash', function(source)
    local stashId = exports['ox_inventory']:CreateTemporaryStash({
        label = 'Skraldespand',
        slots = 100,
        maxWeight = 5000000,
    })
    return stashId
end)

lib.callback.register('elevate-politi:server:giveCivilVehicle', function(source, targetId, model, vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not xPlayer or not targetPlayer then
        return false
    end
    if xPlayer.job.name ~= "police" then
        return false
    end
    if xPlayer.job.grade_name ~= "boss" then
        return false
    end
    if not vehicleProps or not Config.CivilBiler then
        return false
    end

    local foundVehicle = nil
    for _, v in ipairs(Config.CivilBiler) do
        if v.model == model then
            foundVehicle = v
            break
        end
    end

    if not foundVehicle then
        return false
    end

    vehicleProps.plate = exports["jg-dealerships"]:generatePlate()

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored)', {
        ['@owner'] = targetPlayer.identifier,
        ['@plate'] = vehicleProps.plate,
        ['@vehicle'] = json.encode(vehicleProps),
        ['@stored'] = 'global',

    }, function(rowsChanged)
        if rowsChanged > 0 then
        end
    end)

    return true
end)

lib.callback.register('elevate-politi:server:getOwnedCivilVehicles', function(source, targetId)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then return {} end

    local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = targetPlayer.identifier
    })

    local vehicles = {}
    for _, v in ipairs(result) do
        local vehicleProps = json.decode(v.vehicle)
        local getVehicleFromHash = exports['jungurum-lib']:getVehicleFromHash(vehicleProps.model)

        if getVehicleFromHash then
            vehicleLabel = ('%s %s'):format(getVehicleFromHash.brand, getVehicleFromHash.model)
            model = nil
        else
            vehicleLabel = vehicleProps.model
            model = vehicleProps.model
        end
        
        table.insert(vehicles, {
            name = vehicleLabel,
            plate = v.plate,
            model = model and model or nil,
        })
    end

    return vehicles
end)

lib.callback.register('elevate-politi:server:removeCivilVehicle', function(source, targetId, plate)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then return false end

    local rowsChanged = MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = targetPlayer.identifier,
        ['@plate'] = plate
    })

    return rowsChanged > 0
end)

RegisterServerEvent('elevate_politi:OpretZone')
AddEventHandler('elevate_politi:OpretZone', function(streetName, speed, radius, x, y, z)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' then
        
        local playerName = GetPlayerName(source)
        local msg = 'Vi beder alle være opmærksomme der er pt. nedsat hastighed på ' .. streetName .. ' - På nuværnede tidspunkt er alt trafik beordret til at holde stille.'

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(8, 69, 131, 0.5); color: rgba(255, 255, 255, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-globe" style="color: rgba(255, 255, 255, 1);"></i> <span style="color: white; font-weight: bold;">Politiet @ Vigtig Information: </span> {0}</span><span style="color: white; font-weight: bold;"></span></div>',
            args = {msg}
        })

        TriggerClientEvent('elevate_politi:OpretZone', -1, speed, radius, x, y, z)
    end
end)

RegisterCommand('pa', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' then
        if not args[1] then
            TriggerClientEvent('ox_lib:notify', source, { title = 'Du skal angive en besked', type = 'error' })
            return
        end
        
        local playerName = GetPlayerName(source)
        local msg = args[1]

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(8, 69, 131, 0.5); color: rgba(255, 255, 255, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-globe" style="color: rgba(255, 255, 255, 1);"></i> <span style="color: white; font-weight: bold;">Politiet @ Vigtig Information: </span> {0}</span><span style="color: white; font-weight: bold;"></span></div>',
            args = {msg}
        })

        TriggerClientEvent('elevate_politi:OpretZone', -1, speed, radius, x, y, z)
    end
end, false)

RegisterServerEvent('elevate_politi:RemoveZone')
AddEventHandler('elevate_politi:RemoveZone', function(blip)
    TriggerClientEvent('elevate_politi:RemoveZone', -1)
end)

RegisterNetEvent('elevatepoliti:server:useRambuk', function(closestDoor, itemData, failed)
	local src = source
	local currentItem = exports.ox_inventory:GetSlot(src, itemData.slot)
	if not failed then
		if currentItem.metadata.durability <= 20 then
			TriggerClientEvent('ox_lib:notify', src, { title = 'Din rambuk er gået i stykker', type = 'error' })
			exports.ox_inventory:RemoveItem(src, 'rambukpolice_stormram_lille', 1, nil, currentItem.slot)
		else
			exports.ox_inventory:SetDurability(src, currentItem.slot, currentItem.metadata.durability - 20)
		end
		exports.ox_doorlock:setDoorState(closestDoor.id, 0)
	else
		if currentItem.metadata.durability <= 30 then
			exports.ox_inventory:RemoveItem(src, 'police_stormram_lille', 1, nil, currentItem.slot)
			TriggerClientEvent('ox_lib:notify', src, { title = 'Din rambuk er gået i stykker', type = 'error' })
		else
			exports.ox_inventory:SetDurability(src, currentItem.slot, currentItem.metadata.durability - 30)
		end
	end
end)


lib.callback.register("elevate-politi:server:checkfingerPrintName", function(source, target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)
    local targetName = xTarget.getName()
    local fingerPrint = MySQL.Sync.fetchAll('SELECT * FROM snipe_evidence_identifiers WHERE identifier = @identifier', {
        ['@identifier'] = xTarget.identifier
    })
    if not fingerPrint or #fingerPrint == 0 then
        return false, "Ingen fingeraftryk fundet for denne person."
    end

    if fingerPrint[1].is_taken == "0" then
        return false, "Ingen fingeraftryk fundet for denne person."
    end

    return true, fingerPrint[1].fingerprint
end)
