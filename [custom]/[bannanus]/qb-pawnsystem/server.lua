local ESX = exports['es_extended']:getSharedObject()
local picks = {}
local itemFilter = {}
local inventoryFilter = {}

RegisterNetEvent('pawnshop:server:smelt', function(data)
    local src = source
    Sell(src, data)
end)

function GetPawnshopItems(stashName)
    local items = {}
    if Config.inventory == "ox" then
        local result = exports.ox_inventory:GetInventoryItems(stashName)
        return result
    else
        print("Custom inventory not implemented. Please configure for your system.")
        return items
    end
end

ESX.RegisterServerCallback('qb-pawnsystem:server:spawnvehicle', function(source, cb, model, coords, warp)
    local xPlayer = ESX.GetPlayerFromId(source)
    ESX.OneSync.SpawnVehicle(model, coords, coords.w, function(networkId)
        local veh = NetworkGetEntityFromNetworkId(networkId)
        SetEntityAsMissionEntity(veh, true, true)
        if warp then
            TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1)
        end
        cb(networkId)
    end)
end)

function Sell(src, data)
    local xPlayer = ESX.GetPlayerFromId(src)
    local stash = xPlayer.job.name .. "_" .. data.param
    local items = GetPawnshopItems(stash)
    if Config.inventory == "ox" then
        if items and next(items) then
            for key, item in pairs(items) do
                isRequired(xPlayer, item.name, item.count)
            end
        else
            lib.notify({ id = src, title = Config.Lang.machineEmpty, type = 'error', duration = 3000 })
        end
        exports.ox_inventory:ClearInventory(stash)
    else
        lib.notify({ id = src, title = Config.Lang.machineEmpty, type = 'error', duration = 3000 })
    end
end

function isRequired(xPlayer, requiredItem, requiredItemAmount)
    for itemName, itemTbl in pairs(Config.Items) do
        if requiredItem == itemName then
            if math.random(1, 100) <= itemTbl.rewardChance then
                xPlayer.addInventoryItem(itemTbl.reward, itemTbl.rewardAmount)
                TriggerClientEvent('ox_inventory:notify', xPlayer.source, { type = 'success', text = "Received " .. itemTbl.rewardAmount .. " " .. itemTbl.reward })
            end
            for newItemName, newItemAmount in pairs(itemTbl.item) do
                xPlayer.addInventoryItem(newItemName, newItemAmount * requiredItemAmount)
            end
            return itemName
        end
    end
    return false
end

local lastPickupTimes = {}

ESX.RegisterServerCallback("pawnshop:server:pickup", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local now = os.time()
    local lastTime = lastPickupTimes[source] or 0

    if now - lastTime < 5 then
        cb(false)
        return
    end

    lastPickupTimes[source] = now

    local totalChance = 0
    local weightedItems = {}

    for itemName, itemData in pairs(Config.Items) do
        if itemData.runChance and itemData.runChance > 0 then
            totalChance = totalChance + itemData.runChance
            table.insert(weightedItems, { name = itemName, chance = totalChance, amount = itemData.runAmount })
        end
    end

    local randomChance = math.random() * totalChance
    local selectedItem
    local amount
    for _, item in ipairs(weightedItems) do
        if randomChance <= item.chance then
            selectedItem = item.name
            amount = item.amount
            break
        end
    end

    if selectedItem then
        local givenItem = xPlayer.addInventoryItem(selectedItem, amount)
        cb(givenItem)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("pawnshop:server:checkmoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local paidFee = false
    if exports['elevate-multijob']:getAccountBalance(xPlayer.job.name) >= Config.PickupRunCost then
        exports['elevate-multijob']:removeAccountBalance(xPlayer.job.name, Config.PickupRunCost)
        exports['fh_bossmenu']:AddIncome(xPlayer.job.name, { amount = Config.PickupRunCost, type = "expense" }, xPlayer.getName())
        paidFee = true
    end
    cb(paidFee)
end)

ESX.RegisterServerCallback("pawnshop:server:checkpickamount", function(source, cb, add)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cid = xPlayer.identifier

    if picks[cid] then
        if picks[cid] >= Config.pickAmounts then
            cb(false)
        else
            TriggerClientEvent('ox_lib:notify', source, { title = Config.pickAmounts - picks[cid] .. " more runs to finish", type = 'inform', duration = 5000 })
            if add then
                picks[cid] = picks[cid] + 1
            end
            cb(true)
        end
    else
        if add then
            picks[cid] = 1
            TriggerClientEvent('ox_lib:notify', source, { title = "You have " .. Config.pickAmounts .. " runs to do", type = 'inform', duration = 5000 })
        end
        cb(true)
    end
end)
 
RegisterNetEvent('pawnshop:server:registerStash', function(stash)
    if stash then
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.maxWeight)
    end
end)


CreateThread(function()
    for itemName, itemTbl in pairs(Config.Items) do
        itemFilter[itemName] = true
    end

    for k, v in pairs(Config.Locations) do
        local name = v.job .. "_" .. v.name
        table.insert(inventoryFilter, name)
    end
    
    local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
        local isAllowedItem = itemFilter[payload.fromSlot.name]
        
        if isAllowedItem then
            return true
        else
            if payload.source then
                TriggerClientEvent('ox_lib:notify', payload.source, {
                    title = 'Begrænset genstand',
                    description = 'Denne genstand kan ikke smeltes',
                    type = 'error',
                    duration = 3000
                })
            end
            return false
        end
    end, {
        print = false,
        inventoryFilter = inventoryFilter,
    })
end)

ESX.RegisterServerCallback("pawnshop:server:checkDepositFee", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canAfford = false
    
    if exports['elevate-multijob']:getAccountBalance(xPlayer.job.name) >= Config.DeliveryDepositFee then
        exports['elevate-multijob']:removeAccountBalance(xPlayer.job.name, Config.DeliveryDepositFee)
        exports['fh_bossmenu']:AddIncome(xPlayer.job.name, { amount = Config.DeliveryDepositFee, type = "expense" }, xPlayer.getName())
        canAfford = true
    end
    
    cb(canAfford)
end)

ESX.RegisterServerCallback("pawnshop:server:getPlayerDeliveryItems", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerItems = {}
    
    for itemName, _ in pairs(Config.Items) do
        local item = xPlayer.getInventoryItem(itemName)
        if item and item.count > 0 then
            table.insert(playerItems, {
                name = itemName,
                label = item.label or ESX.GetItemLabel(itemName) or itemName,
                count = item.count
            })
        end
    end
    
    cb(playerItems)
end)

RegisterNetEvent('pawnshop:server:deliverItem', function(itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local item = xPlayer.getInventoryItem(itemName)
    if item and item.count > 0 then
        local amountToRemove = math.random(75, math.min(item.count, 300))
        if item.count < amountToRemove then
            amountToRemove = item.count
        end
        xPlayer.removeInventoryItem(itemName, amountToRemove)
        
        local payment = Config.DeliveryBaseReward * amountToRemove
        if Config.Items[itemName] and Config.Items[itemName].deliveryMoney then
            payment = Config.Items[itemName].deliveryMoney * amountToRemove
        end
        
        exports['elevate-multijob']:addAccountBalance(xPlayer.job.name, payment)
        exports['fh_bossmenu']:AddIncome(xPlayer.job.name, { amount = payment, type = "income" }, xPlayer.getName())
        
        lib.notify({ 
            id = src, 
            title = Config.Lang.deliveryPaid, 
            description = payment .. " " .. Config.Lang.currencyReceived, 
            type = 'success', 
            duration = 3500 
        })
    else
        lib.notify({ 
            id = src, 
            title = Config.Lang.deliveryFailed, 
            description = Config.Lang.noItemFound, 
            type = 'error', 
            duration = 3500 
        })
    end
end)

RegisterNetEvent('pawnshop:server:returnDeposit', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    exports['elevate-multijob']:addAccountBalance(xPlayer.job.name, Config.DeliveryDepositFee)
    exports['fh_bossmenu']:AddIncome(xPlayer.job.name, { amount = Config.DeliveryDepositFee, type = "income" }, xPlayer.getName())
    
    lib.notify({ 
        id = src, 
        title = Config.Lang.depositReturned, 
        type = 'success', 
        duration = 3500 
    })
end)

lib.callback.register('pawnshop:server:calculateTrayValue', function(source, trayName)
    local stashItems = exports.ox_inventory:GetInventoryItems(trayName)
    local totalValue = 0

    if stashItems then
        for _, itemData in pairs(stashItems) do
            if Config.Items[itemData.name] then
                totalValue = totalValue + (Config.Items[itemData.name].deliveryMoney * itemData.count)
            end
        end
    end

    return totalValue
end)

RegisterNetEvent('pawnshop:server:registerTray', function(procent, totalValue, kunde)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not procent or not totalValue then return end

    function urlencode(str)
        if str then
            str = string.gsub(str, "\n", "\r\n")
            str = string.gsub(str, "([^%w ])", function(c) 
                return string.format("%%%02X", string.byte(c)) 
            end)
            str = string.gsub(str, " ", "+")
        end
        return str or ""
    end
    
    local option1 = urlencode('Pawn')
    local option2 = urlencode(xPlayer.getJob().label or "Fejl (1)")
    local option3 = urlencode(xPlayer.getName() or "Fejl (2)")
    local option4 = urlencode(procent or "Fejl (3)")
    local option5 = urlencode(totalValue or "Fejl (4)")
    local option6 = urlencode(totalValue - (totalValue * (procent / 100)) or "Fejl (5)")
    local option7 = urlencode(totalValue * (procent / 100) or "Fejl (6)")
    local option8 = urlencode(kunde or "Fejl (7)")

    local url = "https://script.google.com/macros/s/AKfycbxkmkA6JdFAML54gngYQ-gjIrMdXrPe0cUiB4qiaMCCVmhch38_QU4WPP_-8ACHqS9EQw/exec"
    url = url .. "?option1=" .. option1 ..
        "&option2=" .. option2 ..
        "&option3=" .. option3 ..
        "&option4=" .. option4 ..
        "&option5=" .. option5 ..
        "&option6=" .. option6 ..
        "&option7=" .. option7 .. 
        "&option8=" .. option8
    
    PerformHttpRequest(url, function(statusCode, responseText, headers)
    end, "GET", "", {["User-Agent"] = "FiveM"})
end)

lib.callback.register('pawnshop:server:getNearbyPlayers', function(source)
    local players = {}

    local nearbyPlayers = lib.getNearbyPlayers(GetEntityCoords(GetPlayerPed(source)), 10, true)

    for _, player in ipairs(nearbyPlayers) do
        local xPlayer = ESX.GetPlayerFromId(player.id)
        if xPlayer then
            table.insert(players, {
                value = xPlayer.identifier,
                label = xPlayer.getName()
            })
        end
    end

    return players
end)

lib.callback.register('pawnshop:server:getdata', function(source, userId)
    local jsonData = json.encode({
        name = ESX.GetPlayerFromId(userId).identifier
    })

    local result = nil
    local done = false

    PerformHttpRequest('https://script.google.com/macros/s/AKfycbxf9BEByGW-hNrbkm-050Zs0WaW9uc4ErFixtSU-3TVJruhEF_YWDbRYK9ho8eDXwi-/exec', function(status, body, headers)
        if status == 405 then
            PerformHttpRequest('https://script.google.com/macros/s/AKfycbyuN_OR19m50548vzCI_3FuvYugNhvlbKr0Q9-gEDZS_JsskIO6h1QZXWlCH6fjSsXi/exec', function(status2, body2, headers2)
                local data = json.decode(body2)
                if type(data) == "table" and type(data[1]) == "table" then
                    local row = data[1]
                    local name = row[1]
                    local total = row[2]
                    local procent = row[3]
                    result = {
                        name = ESX.GetPlayerFromId(userId).getName(),
                        total = tonumber(total),
                        procent = math.round(procent, 2) .. '%',
                    }
                else
                    result = { error = "Unexpected data format" }
                end
                done = true
            end, 'GET')
        else
            result = { error = "Status: " .. tostring(status) }
            done = true
        end
    end, 'POST', jsonData, {
        ['Content-Type'] = 'application/json'
    })

    while not done do
        Wait(0)
    end

    return result
end)
