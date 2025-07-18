GlobalState.RefreshTime = os.time()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.VehiclesRefresh * 1000)
        generateGlobalItemBatch()
        GlobalState.RefreshTime = os.time()
    end
end)

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `vehiclewarehouse` (
            `identifier` varchar(50) DEFAULT NULL,
            `exp` int(11) DEFAULT NULL,
            `warehouse1` varchar(250) DEFAULT '[]',
            `warehouse2` varchar(250) DEFAULT '[]',
            `warehouse3` varchar(250) DEFAULT '[]',
            `warehouse4` varchar(250) DEFAULT '[]',
            `warehouse5` varchar(250) DEFAULT '[]'
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]], {}, function(rowsChanged)
    end)
end)

lib.callback.register('fh_vehiclethief:laptop', function(source, warehouseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return { error = "Player not found" }
    end

    local playerIdentifier = xPlayer.getIdentifier()
    local warehouseColumn = 'warehouse' .. tostring(warehouseId)

    local result, err = MySQL.query.await('SELECT identifier, exp, ?? FROM vehiclewarehouse WHERE identifier = ?', {
        warehouseColumn, playerIdentifier
    })

    if err then
        print('MySQL Error: ' .. tostring(err))
        return { error = "Database error" }
    end

    local data = {
        exp = 0,
        count = 0,
        items = {},
        CurrentTime = os.time()
    }

    if not result[1] then
        local success, insertErr = MySQL.insert.await('INSERT INTO vehiclewarehouse (identifier, exp) VALUES (?, ?)', {
            playerIdentifier, 0
        })
        if insertErr then
            print('MySQL Insert Error: ' .. tostring(insertErr))
            return { error = "Failed to initialize warehouse" }
        end
    else
        local warehouseData = result[1][warehouseColumn] or "[]"
        local warehouseItems = json.decode(warehouseData) or {}
        
        data.exp = result[1].exp
        data.count = #warehouseItems
        data.items = warehouseItems
    end

    return data
end)

lib.callback.register('fh_vehiclethief:getWarehouseData', function(source, warehouseId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return { error = "Player not found" }
    end

    local playerIdentifier = xPlayer.getIdentifier()
    local warehouseColumn = 'warehouse' .. tostring(warehouseId)

    local result, err = MySQL.query.await('SELECT ?? FROM vehiclewarehouse WHERE identifier = ?', {
        warehouseColumn, playerIdentifier
    })

    if err then
        print('MySQL Error: ' .. tostring(err))
        return { error = "Database error" }
    end

    local warehouseData = (result[1] and result[1][warehouseColumn] and json.decode(result[1][warehouseColumn])) or {}
    local returnedData = {}

    for _, item in ipairs(warehouseData) do
        table.insert(returnedData, {
            carid = item,
            CurrentTime = os.time()
        })
    end

    return returnedData
end)

local globalItemBatch = {}

Chance = function(number)
    math.randomseed(GetGameTimer() + math.random(1, 99999))
    local random = math.random(1, 100)

    if random <= number then
        return true
    else
        return false
    end
end

function generateGlobalItemBatch()
    local items = {}
    local crateKeys = {}

    for key, _ in pairs(Config.StorageVehicles) do
        table.insert(crateKeys, key)
    end

    for i = 1, Config.MaxVehicleLists do
        local HasFound = false
        local randomIndex = math.random(1, #crateKeys)
        local crateKey = crateKeys[randomIndex]
        local crate = Config.StorageVehicles[crateKey]
        if not crate.chance then
            table.insert(items, {id = crateKey, requiredexp = crate.requiredexp, expreward = crate.expreward, buyPrice = crate.buyPrice, sellPrice = crate.sellPrice, hasPoliceGPS = crate.hasPoliceGPS})
        else

            local ChanceOverAll = Chance(crate.chance)

            if crate.chance and ChanceOverAll then
                table.insert(items, {id = crateKey, requiredexp = crate.requiredexp, expreward = crate.expreward, buyPrice = crate.buyPrice, sellPrice = crate.sellPrice, hasPoliceGPS = crate.hasPoliceGPS})
            end
    
            while crate.chance and not ChanceOverAll and not HasFound do
                randomIndex = math.random(1, #crateKeys)
                crateKey = crateKeys[randomIndex]
                crate = Config.StorageVehicles[crateKey]
    
                if crate.chance and not Chance(crate.chance) then
                    HasFound = false
                else
                    table.insert(items, {id = crateKey, requiredexp = crate.requiredexp, expreward = crate.expreward, buyPrice = crate.buyPrice, sellPrice = crate.sellPrice, hasPoliceGPS = crate.hasPoliceGPS})
                    HasFound = true
                end
            end
        end
    end

    for i = #items, 2, -1 do
        local j = math.random(i)
        items[i], items[j] = items[j], items[i]
    end

    globalItemBatch = items
end

generateGlobalItemBatch()

lib.callback.register('elevate_vehiclethief:getItemBatch', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.getIdentifier()

    local result = MySQL.Sync.fetchAll('SELECT exp FROM vehiclewarehouse WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    })
    
    if result[1] then
        local playerExp = result[1].exp
        return globalItemBatch, playerExp
    else
        return globalItemBatch, 0
    end
end)

lib.callback.register('elevate_vehiclethief:purchaseCar', function(source, itemId, itembuyPrice)
   
    local xPlayer = ESX.GetPlayerFromId(source)
    local policeCount = 0
    local players = ESX.GetExtendedPlayers('job', 'police') 
    for _, player in ipairs(players) do
        policeCount = policeCount + 1
    end

    if Config.StorageVehicles[itemId.id] and Config.StorageVehicles[itemId.id].hasPoliceGPS then
        if policeCount < 1 then
            return {false, 'Ikke nok politi online, prøv igen senere!'}
        end
    end

    local steamid, license, discord = 'Ukendt', 'Ukendt', 'Ukendt'

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord  = v    
        end
    end

    if xPlayer.getAccount('black_money').money >= itembuyPrice then
        xPlayer.removeAccountMoney('black_money', itembuyPrice)

        for i, crate in ipairs(globalItemBatch) do
            if crate.id == itemId.id then
                table.remove(globalItemBatch, i)
                break
            end
        end

        sendToDiscord(xPlayer.source,3389516, 'Vehicle Thief - Køb', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Bil:**'..itemId.id..'\n**Pris:** '..ESX.Math.GroupDigits(itembuyPrice)..' DKK', 'Vehiclethief | ') 
        
        return {true, 'black_money'}

    elseif xPlayer.getAccount('money').money >= itembuyPrice then
        xPlayer.removeAccountMoney('money', itembuyPrice)

        for i, crate in ipairs(globalItemBatch) do
            if crate.id == itemId.id then
                table.remove(globalItemBatch, i)
                break
            end
        end

        sendToDiscord(xPlayer.source, 3389516, 'Vehicle Thief - Køb', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Bil:**'..itemId.id..'\n**Pris:** '..ESX.Math.GroupDigits(itembuyPrice)..' DKK', 'Vehiclethief | ') 
        
        return {true, 'money'}
    else
        return {false, nil}
    end
end)

lib.callback.register('elevate_vehiclethief:buyCar', function(source, data, Warehouses)
    local xPlayer = ESX.GetPlayerFromId(source)
    local warehouseColumn = 'warehouse' .. tostring(Warehouses)
    local maxBoxes = Config.MaxVehiclesPerUser

    local warehouseDataJson = MySQL.Sync.fetchScalar('SELECT `' .. warehouseColumn .. '` FROM vehiclewarehouse WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    })
    
    local warehouseData = warehouseDataJson and json.decode(warehouseDataJson) or {}

    if #warehouseData < maxBoxes then
        local newBoxId = 1
        while true do
            local idExists = false
            for _, box in ipairs(warehouseData) do
                if box.boxId == newBoxId then
                    idExists = true
                    break
                end
            end
            if not idExists then
                break
            else
                newBoxId = newBoxId + 1
            end
        end

        local newBox = {boxId = newBoxId, value = data.id, time = os.time() + Config.VehicleCooldown}
        table.insert(warehouseData, newBox)

        local updatedWarehouseDataJson = json.encode(warehouseData)

        local rowsChanged = MySQL.Sync.execute('UPDATE vehiclewarehouse SET `' .. warehouseColumn .. '` = @updatedData WHERE identifier = @identifier', {
            ['@updatedData'] = updatedWarehouseDataJson,
            ['@identifier'] = xPlayer.getIdentifier()
        })
        
        if rowsChanged > 0 then
            return true               
        else
            return false
        end
    else
        return false
    end
end)

RegisterServerEvent('elevate_vehiclethief:sellCar')
AddEventHandler('elevate_vehiclethief:sellCar', function(warehouseId, boxId, id)
    removeBox(source, warehouseId, id)

    local randomIndex = math.random(#Config.SellLocation)
    local selectedSpawn = Config.SellLocation[randomIndex]

    local warehouseConfig = Config.VehicleStorageInteractions[warehouseId]
    local carSpawn = warehouseConfig.deliveryLocation

    local locations = {
        carSpawn = carSpawn,
        selectedSpawn = selectedSpawn
    }

    TriggerClientEvent('elevate_vehiclethief:spawnCar', source, locations, warehouseId, boxId)
end)

function removeBox(source, warehouseId, boxIdToRemove)
    local xPlayer = ESX.GetPlayerFromId(source)
    local warehouseColumn = 'warehouse' .. tostring(warehouseId)

    MySQL.Async.fetchScalar('SELECT `' .. warehouseColumn .. '` FROM vehiclewarehouse WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(warehouseDataJson)
        if warehouseDataJson then
            local warehouseData = json.decode(warehouseDataJson) or {}

            for i, box in ipairs(warehouseData) do
                if box.boxId == boxIdToRemove then
                    table.remove(warehouseData, i)
                    break
                end
            end

            local updatedWarehouseDataJson = json.encode(warehouseData)

            MySQL.Async.execute('UPDATE vehiclewarehouse SET `' .. warehouseColumn .. '` = @updatedData WHERE identifier = @identifier', {
                ['@updatedData'] = updatedWarehouseDataJson,
                ['@identifier'] = xPlayer.getIdentifier()
            }, function(rowsChanged)
            end)
        end
    end)
end

local playerSaleCooldown = {}

lib.callback.register('elevate_vehiclethief:soldCar', function(source, itemID, securitycheck, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)
    local crateData = Config.StorageVehicles[itemID]
    
    local steamid, license, discord = 'Ukendt', 'Ukendt', 'Ukendt'
    
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord  = v    
        end
    end

    local currentTime = os.time()
    
    if playerSaleCooldown[source] and (currentTime - playerSaleCooldown[source]) < 5 then
        exports["av_blackmarket"]:fg_BanPlayer(source, "Rate Limit Vehiclethief - 2 gange inden for 5 sekunder!", true)

        return false
    end
    
    playerSaleCooldown[source] = currentTime

    if securitycheck and not DoesEntityExist(vehicle) then
        MySQL.Async.execute('UPDATE vehiclewarehouse SET exp = exp + @exp WHERE identifier = @identifier', {
            ['@exp'] = crateData.expreward,
            ['@identifier'] = xPlayer.getIdentifier(),
        })
    
        sendToDiscord(xPlayer.source, 12845056, 'Vehicle Thief - Salg', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Bil:**'..itemID..'\n**Pris:** '..ESX.Math.GroupDigits(crateData.sellPrice)..' DKK', 'Vehiclethief | ') 
        exports.ox_inventory:AddItem(source, 'black_money', crateData.sellPrice)
    
        return true
    else
        sendToDiscord(xPlayer.source, 3145631, 'Vehicle Thief - FEJL!', 'Data:\n securitycheck: ' .. tostring(securitycheck) .. '\nDoesEntityExist: ' .. tostring(not DoesEntityExist(vehicle)) , 'Vehiclethief | ') 
        return false
    end
end)

local vehiclesTime = {}

lib.callback.register('elevate_vehiclethief:hackVehicle', function(source, spawnedVehicle)
    CurrentTime = os.time()

    if vehiclesTime[spawnedVehicle] == nil then
        return 0, CurrentTime
    else
        return vehiclesTime[spawnedVehicle], CurrentTime
    end
end)

RegisterServerEvent('elevate_vehiclethief:setVehicleTime')
AddEventHandler('elevate_vehiclethief:setVehicleTime', function(spawnedVehicle)
    vehiclesTime[spawnedVehicle] = os.time() + Config.Minutes(1)
end)

RegisterServerEvent('elevate_vehiclethief:addVehicleBlip')
AddEventHandler('elevate_vehiclethief:addVehicleBlip', function(spawnedVehicle)
    TriggerClientEvent('elevate_vehiclethief:pingVehicle', -1, spawnedVehicle)
end)

function sendToDiscord(source, color, name, message, footer)
    exports.onl_logsender:SendLog(source, name .. " - ".. message, {
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
        discordTitle = "Vehicle Thief",
        discordWebhook = "https://discord.com/api/webhooks/1354128883154423848/AktId24z9-INNP6m0NBaYXYOB6E8ckQbq-RLqx7zYw2kUWx9nQrU1dGgYk88OB7tCF0P?thread_id=1354128862614913144" -- Another webhook
    })
end
