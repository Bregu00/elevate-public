function GetMainGarageForSubGarage(subGarage)
    for mainGarage, subGarages in pairs(Config.MainGarages) do
        for _, garage in ipairs(subGarages) do
            if garage == subGarage then
                return mainGarage
            end
        end
    end
    return subGarage 
end

RegisterNetEvent('elevate_garage:addStatebag')
AddEventHandler('elevate_garage:addStatebag', function(networkId, rental)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local entity = NetworkGetEntityFromNetworkId(networkId)
    Entity(entity).state.data = { owner = xPlayer.identifier, name = xPlayer.getName(), rental = rental }
end)

RegisterNetEvent("elevate_garage:addCustomSound", function(netid, plate)
    local src = source
    local entity = NetworkGetEntityFromNetworkId(netid)
    exports["jungurum-engineSounds"]:setEntityIdEngineSound(entity, plate, src)
end)

MySQL.update('UPDATE owned_vehicles SET type = ? WHERE type = ?', { 'car', 'automobile' })

ESX.RegisterServerCallback('elevate_garage:fetchAllVehicles', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND (type = ? OR type = ?)', { xPlayer.identifier, 'car', 'motorcycle' }, function(result)
        if result then
            local vehicles = {}
            for k, v in pairs(result) do
                local area = v.stored
                if string.find(area, 'housing_') then
                    local housingArea = string.gsub(area, 'housing_', '')
                    local data = MySQL.single.await('SELECT garage FROM housing WHERE id = ?', { tonumber(housingArea) })
                    local garageData = json.decode(data.garage)
                    v.area = string.format("%s, %s, %s", garageData.x, garageData.y, garageData.z)
                elseif v.stored == 'global' then
                    v.area = 'Global Garage'
                else
                    v.area = v.stored
                end
                vehicles[#vehicles + 1] = {
                    plate = v.plate,
                    vehicle = v.vehicle,
                    area = v.area,
                    parked = v.parked,
                    name = v.name
                }
            end

            table.sort(vehicles, function(a, b)
                return a.plate < b.plate
            end)

            cb(vehicles)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:pullOutImpound', function(src, cb, plate, VehicleClass)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.single('SELECT * FROM owned_vehicles WHERE plate = ?', { plate }, function(row)
        if row then
            local impoundPrice = GetPoundCost(VehicleClass)

            if xPlayer.getAccount('bank').money >= impoundPrice then
                if exports["fh_accountclose"]:isAccountLocked(src) then return end
                xPlayer.removeAccountMoney('bank', impoundPrice)
                local data = { 
                    vehicle = row.vehicle, 
                    plate = row.plate
                }
                cb(data)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:rentMoney', function(src, cb, price)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getAccount('bank').money >= price then
        if exports["fh_accountclose"]:isAccountLocked(src) then return end
        xPlayer.removeAccountMoney('bank', price)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('elevate_garage:pullOutVehicle', function(src, cb, plate)
    MySQL.single('SELECT * FROM owned_vehicles WHERE plate = ?', { plate }, function(row)
        if row then
            MySQL.update.await('UPDATE owned_vehicles SET parked = ?, impounded = ? WHERE plate = ?', { 0, 1, plate })
            local data = { 
                vehicle = row.vehicle, 
                plate = row.plate
            }
            cb(data)
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:fetchfromgarage', function(src, cb, garage)
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local mainGarage = GetMainGarageForSubGarage(garage)
    
    local queryGarage = { mainGarage, 'global' }

    if string.sub(garage, 1, 5) == 'boat_' then
        queryGarage = { 'boat_garage', 'boat_perico_garage', 'global' }
    end

    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND stored IN (?) AND impounded = ? AND parked = ? AND (type = ? OR type = ?)', { xPlayer.identifier, queryGarage, 0, 1, 'car', 'motorcycle' }, function(result)
        if result then
            local vehicles = {}
            for k, v in pairs(result) do
                vehicles[#vehicles + 1] = { 
                    plate = v.plate, 
                    vehicle = v.vehicle,
                    name = v.name,
                }
            end

            table.sort(vehicles, function(a, b)
                return a.plate < b.plate
            end)

            cb(vehicles)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:fetchfromboatgarage', function(src, cb, garage)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND (stored = ? OR stored = ?) AND impounded = ? AND parked = ? AND type = ?', { xPlayer.identifier, garage, 'global', 0, 1, 'boat' }, function(result)
        if result then
            local vehicles = {}
            for k, v in pairs(result) do
                local vehicleData = json.decode(v.vehicle)
                vehicles[#vehicles + 1] = { 
                    plate = v.plate, 
                    model = vehicleData.model 
                }
            end

            table.sort(vehicles, function(a, b)
                return a.plate < b.plate
            end)

            cb(vehicles)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:fetchfromBoatimpound', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND parked = ? AND impounded = ? AND type = ?', { xPlayer.identifier, 0, 1, 'boat' }, function(result)
        if result then
            local table = {}
            for k, v in pairs(result) do
                table[#table + 1] = { 
                    plate = v.plate, 
                    vehicle = v.vehicle 
                }
            end
            cb(table)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:fetchfromimpound', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.query('SELECT * FROM owned_vehicles WHERE owner = ? AND parked = ? AND impounded = ? AND (type = ? OR type = ?)', { xPlayer.identifier, 0, 1, 'car', 'motorcycle' }, function(result)
        if result then
            local table = {}
            for k, v in pairs(result) do
                table[#table + 1] = { 
                    plate = v.plate, 
                    vehicle = v.vehicle 
                }
            end
            cb(table)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:parkVehicle', function(src, cb, plate, vehicleprops, store, networkId)
    local vehicle = NetworkGetEntityFromNetworkId(networkId)
    if not DoesEntityExist(vehicle) then return end
    local xPlayer = ESX.GetPlayerFromId(src)

    local mainGarage = GetMainGarageForSubGarage(store)
    local coords = json.encode(GetEntityCoords(GetPlayerPed(src)))
    local promise = MySQL.single.await('SELECT * FROM owned_vehicles WHERE plate = ?', { plate })
    if promise then
        if promise.owner == xPlayer.identifier then
            local vehicleData = json.decode(promise.vehicle)
            
            for k, v in pairs(vehicleprops) do
                vehicleData[k] = v
            end
            
            local encodedVehicle = json.encode(vehicleData)
            
            MySQL.update.await('UPDATE owned_vehicles SET parked = ?, vehicle = ?, stored = ?, impounded = ?, coords = ? WHERE plate = ?', { 1, encodedVehicle, mainGarage, 0, coords, plate })
            DeleteEntity(vehicle)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterServerEvent('elevate_garage:SetGPS')
AddEventHandler('elevate_garage:SetGPS', function(plate)
    local src = source
    MySQL.query('SELECT * FROM owned_vehicles WHERE plate = ?', { plate }, function(result)
        local veh = result[1]
        local garageName = veh.stored
        local garage = Config.Garages[garageName]
        if string.find(veh.stored, 'housing_') then
            local area = string.gsub(veh.stored, 'housing_', '')

            local data = MySQL.single.await('SELECT garage FROM housing WHERE id = ?', { tonumber(area) })
            local garageData = json.decode(data.garage)

            local coords = vector2(garageData.x, garageData.y)
            TriggerClientEvent('elevate_garage:SetGPS_C', src, coords)
        end
        if garage and veh.parked == 1 then
            local coords = vector2(garage.Zone.Shape[1].x, garage.Zone.Shape[1].y)
            TriggerClientEvent('elevate_garage:SetGPS_C', src, coords)
        end
    end)
end)

RegisterServerEvent('elevate_garage:renameVehicle')
AddEventHandler('elevate_garage:renameVehicle', function(plate, newName)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.update('UPDATE owned_vehicles SET name = ? WHERE plate = ? AND owner = ?', {
        newName,
        plate,
        xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                type = 'success',
                description = 'Køretøjets navn er blevet opdateret!'
            })
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                type = 'error',
                description = 'Kunne ikke finde køretøjet.'
            })
        end
    end)
end)

ESX.RegisterServerCallback('elevate_garage:getGPS', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = ?', { plate }, function(result)
        if result and #result > 0 then
            local veh = result[1]
            local garageName = veh.stored
            local garage = Config.Garages[garageName]

            if string.find(veh.stored, 'housing_') then
                local area = string.gsub(veh.stored, 'housing_', '')
                MySQL.Async.fetchScalar('SELECT garage FROM housing WHERE id = ?', { tonumber(area) }, function(data)
                    if data then
                        local garageData = json.decode(data)
                        local coords = vector2(garageData.x, garageData.y)
                        cb(coords)
                    end
                end)
            end
            if garage and veh.parked == 1 then
                local coords = vector2(garage.Zone.Shape[1].x, garage.Zone.Shape[1].y)
                cb(coords)
            elseif garage and veh.parked == 0 then
                local coords = vector2(410.57, -1636.62)
                cb(coords)
            end
        else
            cb(nil)
        end
    end)
end)

function sendToDiscord(color, name, message, footer)
    local embed = {
        {
            ["color"] = color,
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer .. " " .. os.date("%x %X %p"),
            },
        }
    }
    PerformHttpRequest('https://discord.com/api/webhooks/1264319687039389748/8FkaAvV0IuCdSlE9N1LZzPR6u6L32RT37zzJL1f_cWSmNIurCK8augujGn1JPhSKCwPT', function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed }), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('elevate_carwash:payForWash', function(src, cb, price)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getAccount('bank').money >= price then
        if exports["fh_accountclose"]:isAccountLocked(src) then return end
        xPlayer.removeAccountMoney('bank', price)
        cb(true)
    else
        cb(false)
    end
end)