

local RefreshTime = os.time()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CargoRefresh * 1000)
        generateGlobalItemBatch()
        RefreshTime = os.time()
    end
end)

ESX.RegisterServerCallback('elevate_warehouse:laptop', function(src, cb, WareHouseID)
    local xPlayer = ESX.GetPlayerFromId(src)
    local PlayerIdentifier = xPlayer.getIdentifier()
    local warehouseColumn = 'warehouse' .. tostring(WareHouseID)

    MySQL.Async.fetchAll('SELECT identifier, hasTruck, exp, `' .. warehouseColumn .. '` FROM warehouse WHERE identifier = @identifier', {
        ['@identifier'] = PlayerIdentifier
    }, function(result)

        if not result[1] then
            MySQL.Async.execute('INSERT INTO warehouse (identifier, hasTruck, exp) VALUES (@identifier, 0, 1)', {
                ['@identifier'] = PlayerIdentifier
            }, function(affectedRows)
                cb({identifier = PlayerIdentifier, hasTruck = 0, exp = 0, warehouseCount = 0, warehouseValues = {}, TimeToRefresh = RefreshTime, CurrentTime = os.time()})
            end)
        else
            local warehouseData = result[1][warehouseColumn] or "[]"
            local warehouseItems = json.decode(warehouseData) or {}

            local warehouseCount = #warehouseItems

            cb({
                identifier = result[1].identifier, 
                hasTruck = result[1].hasTruck, 
                exp = result[1].exp, 
                warehouseCount = warehouseCount, 
                warehouseValues = warehouseItems,
                TimeToRefresh = RefreshTime,
                CurrentTime = os.time()
            })
        end
    end)
end)

ESX.RegisterServerCallback('elevate_warehouse:checkBalance', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
  
    if xPlayer.getAccount('black_money').money >= Config.AcquireMulePrice then
        cb({true, 'black_money'})
    elseif xPlayer.getAccount('money').money >= Config.AcquireMulePrice then
        cb({true, 'money'})
    else
        cb({false, nil}) 
    end
end)

ESX.RegisterServerCallback('elevate_warehouse:buyBox', function(source, cb, wareHouseID, boxTypeKey)
    local xPlayer = ESX.GetPlayerFromId(source)
    local warehouseColumn = 'warehouse' .. tostring(wareHouseID)
    local boxTypeInfo = Config.WarehouseCrates[boxTypeKey]
    local maxBoxes = Config.MaxCratePerUser

    MySQL.Async.fetchScalar('SELECT `' .. warehouseColumn .. '` FROM warehouse WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(warehouseDataJson)
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

            local newBox = {boxId = newBoxId, value = boxTypeKey, time = os.time() + Config.CargoCooldown, sellPrice = boxTypeInfo.sellPrice}
            table.insert(warehouseData, newBox)

            local updatedWarehouseDataJson = json.encode(warehouseData)

            MySQL.Async.execute('UPDATE warehouse SET `' .. warehouseColumn .. '` = @updatedData WHERE identifier = @identifier', {
                ['@updatedData'] = updatedWarehouseDataJson,
                ['@identifier'] = xPlayer.getIdentifier()
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)
end)

function removeBox(source, warehouseId, boxIdToRemove)

    local xPlayer = ESX.GetPlayerFromId(source)
    local warehouseColumn = 'warehouse' .. tostring(warehouseId)

    MySQL.Async.fetchScalar('SELECT `' .. warehouseColumn .. '` FROM warehouse WHERE identifier = @identifier', {
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

            MySQL.Async.execute('UPDATE warehouse SET `' .. warehouseColumn .. '` = @updatedData WHERE identifier = @identifier', {
                ['@updatedData'] = updatedWarehouseDataJson,
                ['@identifier'] = xPlayer.getIdentifier()
            }, function(rowsChanged)
            end)
        end
    end)
end

local globalItemBatch = {}

Chance = function(number)
    math.randomseed(GetGameTimer() + math.random(1, 99999))
    local random = math.random(1, 100)

    return random <= number
end

function generateGlobalItemBatch()
    local items = {}
    local crateKeys = {}

    for key, _ in pairs(Config.WarehouseCrates) do
        table.insert(crateKeys, key)
    end

    for i = 1, Config.MaxCrateLists do
        local HasFound = false
        local randomIndex = math.random(1, #crateKeys)
        local crateKey = crateKeys[randomIndex]
        local crate = Config.WarehouseCrates[crateKey]
        if not crate.chance then
            table.insert(items, {id = crateKey, label = crate.label, buyPrice = crate.buyPrice, requiredexp = crate.requiredexp})
        else

            local ChanceOverAll = Chance(crate.chance)

            if crate.chance and ChanceOverAll then
                table.insert(items, {id = crateKey, label = crate.label, buyPrice = crate.buyPrice, requiredexp = crate.requiredexp})
            end
    
            while crate.chance and not ChanceOverAll and not HasFound do
                randomIndex = math.random(1, #crateKeys)
                crateKey = crateKeys[randomIndex]
                crate = Config.WarehouseCrates[crateKey]
    
                if crate.chance and not Chance(crate.chance) then
                    HasFound = false
                else
                    table.insert(items, {id = crateKey, label = crate.label, buyPrice = crate.buyPrice, requiredexp = crate.requiredexp})
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

ESX.RegisterServerCallback('elevate_warehouse:getItemBatch', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT exp FROM warehouse WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    }, function(result)
        if result[1] then
            local playerExp = result[1].exp
            cb(globalItemBatch, playerExp)
        else
            cb(globalItemBatch, 0)
        end
    end)
end)
ESX.RegisterServerCallback('elevate_warehouse:getWarehouseData', function(source, cb, WareHouseID)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerIdentifier = xPlayer.getIdentifier()
    local warehouseColumn = 'warehouse' .. tostring(WareHouseID)
    print(warehouseColumn)

    MySQL.Async.fetchScalar('SELECT `' .. warehouseColumn .. '` FROM warehouse WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    }, function(warehouseDataJson)
        local warehouseData = warehouseDataJson and json.decode(warehouseDataJson) or {}
        local returnedData = {}
        print(returnedData)
        for _, item in ipairs(warehouseData) do
            if Config.WarehouseCrates[item.value] then
                local crateData = Config.WarehouseCrates[item.value]

                table.insert(returnedData, {
                    boxid = item.value,
                    id = item.boxId,
                    name = crateData.label,
                    sellPrice = crateData.sellPrice,
                    time = item.time,
                    expreward = crateData.expreward,
                    currentTime = os.time()
                })
            end
        end
        print(json.encode(returnedData))
        cb(returnedData)
    end)
end)

RegisterServerEvent('elevate_warehouse:sellBox')
AddEventHandler('elevate_warehouse:sellBox', function(warehouseId, sellPrice, id, expreward, boxId)
    
    removeBox(source, warehouseId, id)

    local randomIndex = math.random(#Config.SellCrateSpawns)
    local selectedSpawn = Config.SellCrateSpawns[randomIndex]

    local warehouseConfig = Config.WarehouseInteractions[warehouseId]
    local crateSpawn = warehouseConfig.crateSpawn

    local locations = {
        crateSpawn = crateSpawn,
        selectedSpawn = selectedSpawn
    }

    TriggerClientEvent('elevate_warehouse:spawnCrate', source, locations, warehouseId, boxId, sellPrice, expreward)
end)
local playerSaleCooldown = {}

ESX.RegisterServerCallback('elevate_warehouse:soldBox', function(source, cb, canDeliver, sellPrice, expreward, itemID)
    local xPlayer = ESX.GetPlayerFromId(source)
    if canDeliver then
        exports.ox_inventory:AddItem(source, 'black_money', sellPrice)
        local currentTime = os.time()
    
        if playerSaleCooldown[source] and (currentTime - playerSaleCooldown[source]) < 5 then
            exports["av_blackmarket"]:fg_BanPlayer(source, "Rate Limit Warehouse - 2 gange inden for 5 sekunder!", true)
    
            return false
        end
        
        playerSaleCooldown[source] = currentTime
        if Chance(10) then
            exports.ox_inventory:AddItem(source, 'lockpick', math.random(1, 3))
            TriggerClientEvent('ox_lib:notify', source, {
                description = 'Smuglerne var tilfredse med dine varer og gav lockpicks!',
                duration = 10000,
            })
        end
    
        MySQL.Async.execute('UPDATE warehouse SET exp = exp + @exp WHERE identifier = @identifier', {
            ['@exp'] = expreward,
            ['@identifier'] = xPlayer.getIdentifier(),
        }, function()
        end)

        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord  = v    
            end
        end

        sendToDiscord(xPlayer.source, 12845056, 'Warehouse - Salg', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Kasse:** '..itemID..'\n**Pris:** '..ESX.Math.GroupDigits(sellPrice)..' DKK', ' Warehouse | ') 

        cb(true)
    end
end)

RegisterServerEvent('elevate_warehouse:DeliverTruck')
AddEventHandler('elevate_warehouse:DeliverTruck', function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerIdentifier = xPlayer.getIdentifier()

    MySQL.Async.execute('UPDATE warehouse SET hasTruck = 1 WHERE identifier = @identifier', {
        ['@identifier'] = PlayerIdentifier
    }, function()
    end)
end)

RegisterServerEvent('elevate_warehouse:RemoveMoney')
AddEventHandler('elevate_warehouse:RemoveMoney', function(type)
    local xPlayer = ESX.GetPlayerFromId(source)

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord  = v    
        end
    end

    sendToDiscord(xPlayer.source, 3389516, 'Warehouse - Truck Køb', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Pris:** '..ESX.Math.GroupDigits(Config.AcquireMulePrice)..' DKK', ' Warehouse | ') 
    xPlayer.removeAccountMoney(type, Config.AcquireMulePrice)
end)

RegisterServerEvent('elevate_warehouse:purchaseBox')
AddEventHandler('elevate_warehouse:purchaseBox', function(itemId, itemLabel, itembuyPrice, warehouseId, model)
    local xPlayer = ESX.GetPlayerFromId(source)

    local playerIdentifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT hasTruck FROM warehouse WHERE identifier = @identifier', {
        ['@identifier'] = playerIdentifier
    }, function(result)
        if not result or not result[1] or result[1].hasTruck ~= 1 then
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                title = 'Fejl',
                description = 'Du har ikke en lastbil i lageret! Du skal have en for at kunne købe en kasse.',
                type = 'error'
            })
            return
        end
        local steamid, license, discord = nil, nil, nil
        for k, v in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                license = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                discord = v    
            end
        end
        local priceString = tostring(itembuyPrice):gsub("%D", "")
        local itembuyPrice = tonumber(priceString)

        if xPlayer.getAccount('black_money').money >= itembuyPrice then
            xPlayer.removeAccountMoney('black_money', itembuyPrice)
        elseif xPlayer.getAccount('money').money >= itembuyPrice then
            xPlayer.removeAccountMoney('money', itembuyPrice)
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                title = 'Fejl',
                description = 'Du har ikke penge nok! Du kan betale med sorte- eller hvide kontanter.',
                type = 'error'
            })
            return
        end
        local randomIndex = math.random(#Config.CrateSpawns)
        local selectedSpawn = Config.CrateSpawns[randomIndex]
        TriggerClientEvent('elevate_warehouse:spawnCrate', xPlayer.source, selectedSpawn, warehouseId, itemId, nil, model)

        sendToDiscord(xPlayer.source, 3389516, 'Warehouse - Køb', '**Spiller**: '..xPlayer.getName()..'\n**Licens**: '..license..'\n**Steam**: '..steamid..'\n**Discord**: '..discord..'\n\n**Kasse:** '..itemId..'\n**Pris:** '..ESX.Math.GroupDigits(itembuyPrice)..' DKK', ' Warehouse | ') 

        for i, crate in ipairs(globalItemBatch) do
            if crate.id == itemId then
                table.remove(globalItemBatch, i)
                break
            end
        end
    end)
end)


function sendToDiscord(id, color, name, message, footer)
    exports.onl_logsender:SendLog(id, name .. " - ".. message, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = true,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,

        },
        discordTitle = "Cargo Thief",
        discordWebhook = "https://discord.com/api/webhooks/1354236299267280946/EFH4ddG6ICu90G52cBGfCDZDvatQfyRVk0__NFa2PwRh_Mf0zqw9IJTftQG_Gg0BV_Nx?thread_id=1354236187224834089" -- Another webhook
    })
end
