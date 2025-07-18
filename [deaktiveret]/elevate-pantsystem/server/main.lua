ESX = exports["es_extended"]:getSharedObject()
local recyclableItems = {}
local dumpsterCooldowns = {}

local function sendToDiscord(source, result, isReceipt)
    local xPlayer = ESX.GetPlayerFromId(source)
    local messageText = ""

    if isReceipt then
        messageText = "Pantkvittering Indløst\n"
        messageText = messageText .. string.format("Beløb: %d KR\n", result)
    elseif result.success then
        messageText = "Skraldespand Search Resultat\n"

        if result.isCash then
            messageText = messageText .. string.format("Fund: %d Cash\n", result.amount)
        else
            messageText = messageText .. string.format("Fund: %dx %s\n", result.amount, result.label or result.item)
        end
    else
        messageText = "Skraldespand Search - Intet fundet"
    end

    exports.onl_logsender:SendLog(source, messageText, {
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
        discordTitle = isReceipt and "Pant System" or "Skraldespand Search",
        discordWebhook = "https://discord.com/api/webhooks/1341716211670712395/9hcBraU0WuaO8W-afd3OyT4zZs6XOxMvzCrWkIj-nJBa5o5nX1oKSnRSLq7JqmocTw1g?thread_id=1352768972025761913" -- Another webhook
    })
end

local function InitializeRecyclableItems()
    for _, reward in ipairs(Config.Rewards) do
        if not reward.cash and reward.item and string.find(reward.item, "flaske") then
            recyclableItems[reward.item] = {
                label = reward.label,
                value = Config.RecyclingValues[reward.item] or 5
            }
        end
    end
    
    for itemName, value in pairs(Config.RecyclingValues) do
        if not recyclableItems[itemName] then
            local label = itemName
            for _, reward in ipairs(Config.Rewards) do
                if reward.item == itemName then
                    label = reward.label
                    break
                end
            end
            
            recyclableItems[itemName] = {
                label = label,
                value = value
            }
        end
    end
end

lib.callback.register('pantsystem:server:checkDumpsterCooldown', function(source, dumpsterKey)
    if dumpsterCooldowns[dumpsterKey] and (os.time() - dumpsterCooldowns[dumpsterKey]) < Config.RecyclingSystem.Cooldown then
        local timeLeft = math.ceil(Config.RecyclingSystem.Cooldown - (os.time() - dumpsterCooldowns[dumpsterKey]))
        return true, timeLeft
    end
    return false, 0
end)

lib.callback.register('pantsystem:server:setDumpsterCooldown', function(source, dumpsterKey)
    dumpsterCooldowns[dumpsterKey] = os.time()
    return true
end)

lib.callback.register('pantsystem:server:giveReward', function(source)
    local src = source
    local player = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = {
        success = false,
        item = nil,
        amount = 0,
        label = nil,
        isCash = false
    }

    if math.random(1, 100) <= Config.RecyclingSystem.EmptyChance then
        return result
    end

    local possibleRewards = {}
    for i, reward in ipairs(Config.Rewards) do
        if math.random(1, 100) <= reward.chance then
            table.insert(possibleRewards, reward)
        end
    end

    if #possibleRewards == 0 then
        return result
    end

    local selectedReward = possibleRewards[math.random(1, #possibleRewards)]
    local amount = math.random(selectedReward.min, selectedReward.max)

    result.success = true
    result.amount = amount

    if selectedReward.cash then
        result.isCash = true
        exports.ox_inventory:AddItem(src, 'money', amount)
    else
        result.item = selectedReward.item
        result.label = selectedReward.label
        exports.ox_inventory:AddItem(src, selectedReward.item, amount)
    end
    
    sendToDiscord(source, result, false)
    
    return result
end)

lib.callback.register('pantsystem:server:getRecyclableItemsList', function(source)
    local items = {}

    if next(recyclableItems) == nil then
        InitializeRecyclableItems()
    end

    for itemName, data in pairs(recyclableItems) do
        table.insert(items, {
            name = itemName,
            label = data.label,
            value = data.value
        })
    end
    
    return items
end)

lib.callback.register('pantsystem:server:recycleItem', function(source, itemName)
    local src = source

    if not recyclableItems[itemName] then
        return false, 0, 0
    end

    local count = 0
    local success = pcall(function()
        local inventory = exports.ox_inventory:GetInventory(src)
        if inventory and inventory.items then
            for _, v in pairs(inventory.items) do
                if type(v) == 'table' and v.name and v.name == itemName and v.count then
                    count = v.count
                    break
                end
            end
        end
    end)

    if not success or count <= 0 then
        return false, 0, 0
    end

    local totalValue = recyclableItems[itemName].value * count
    local removeSuccess = exports.ox_inventory:RemoveItem(src, itemName, count)
    
    if removeSuccess then
        exports.ox_inventory:AddItem(src, 'pantkvittering', 1, {
            value = totalValue,
            description = string.format('Total værdi på %d KR.', totalValue)
        })
        return true, totalValue, count
    else
        return false, 0, 0
    end
end)

lib.callback.register('pantsystem:server:recycleAllItems', function(source)
    local src = source
    local totalValue = 0
    local totalCount = 0
    local anySuccess = false

    local inventory = nil
    pcall(function()
        inventory = exports.ox_inventory:GetInventory(src)
    end)
    
    if not inventory or not inventory.items then
        return false, 0, 0
    end

    for itemName, data in pairs(recyclableItems) do
        local count = 0

        for _, v in pairs(inventory.items) do
            if type(v) == 'table' and v.name and v.name == itemName and v.count and v.count > 0 then
                count = v.count
                break
            end
        end

        if count > 0 then
            if exports.ox_inventory:RemoveItem(src, itemName, count) then
                local itemValue = data.value * count
                totalValue = totalValue + itemValue
                totalCount = totalCount + count
                anySuccess = true
            end
        end
    end

    if anySuccess and totalValue > 0 then
        exports.ox_inventory:AddItem(src, 'pantkvittering', 1, {
            value = totalValue,
            description = string.format('Total værdi på %d KR.', totalValue)
        })
        return true, totalValue, totalCount
    else
        return false, 0, 0
    end
end)

lib.callback.register('pantsystem:server:getRecyclableItemsWithCounts', function(source)
    local src = source
    local items = {}

    if next(recyclableItems) == nil then
        InitializeRecyclableItems()
    end

    local inventory = nil
    local success = pcall(function()
        inventory = exports.ox_inventory:GetInventory(src)
    end)
    
    if not success or not inventory or not inventory.items then
        for itemName, data in pairs(recyclableItems) do
            table.insert(items, {
                name = itemName,
                label = data.label,
                value = data.value,
                count = 0
            })
        end
        return items
    end

    local itemCounts = {}
    for _, v in pairs(inventory.items) do
        if type(v) == 'table' and v.name and v.count and v.count > 0 then
            itemCounts[v.name] = v.count
        end
    end

    for itemName, data in pairs(recyclableItems) do
        table.insert(items, {
            name = itemName,
            label = data.label,
            value = data.value,
            count = itemCounts[itemName] or 0
        })
    end
    
    return items
end)

lib.callback.register('pantsystem:server:getReceiptItems', function(source)
    local src = source
    local receipts = {}
    
    local inventory = exports.ox_inventory:GetInventory(src)
    if not inventory or not inventory.items then
        return receipts
    end
    
    for _, item in pairs(inventory.items) do
        if item and item.name == 'pantkvittering' and item.count > 0 and item.metadata then
            table.insert(receipts, {
                slot = item.slot,
                count = item.count,
                metadata = item.metadata
            })
        end
    end
    
    return receipts
end)

lib.callback.register('pantsystem:server:cashReceipt', function(source, slot)
    local src = source
    if not slot then return false, 0 end
    
    local inventory = exports.ox_inventory:GetInventory(src)
    if not inventory or not inventory.items then
        return false, 0
    end
    
    local item = nil
    for _, v in pairs(inventory.items) do
        if v and v.slot == slot and v.name == 'pantkvittering' and v.count > 0 then
            item = v
            break
        end
    end
    
    if not item or not item.metadata or not item.metadata.value then
        return false, 0
    end
    
    local value = item.metadata.value
    
    if exports.ox_inventory:RemoveItem(src, 'pantkvittering', 1, nil, slot) then
        exports.ox_inventory:AddItem(src, 'money', value)
        sendToDiscord(src, value, true)
        return true, value
    else
        return false, 0
    end
end)

CreateThread(function()
    Wait(1000) 
    InitializeRecyclableItems()
end)
