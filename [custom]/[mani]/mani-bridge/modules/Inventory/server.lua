local function AddItem(src, item, amount, metadata)
    if Config.Inventory == 'ox' then
        exports['ox_inventory']:AddItem(src, item, amount, metadata)
    elseif Config.Inventory == 'codem' then
        exports['codem-inventory']:AddItem(src, item, amount, false, metadata or false)
    elseif Config.Inventory == 'qb' then
        exports['qb-inventory']:AddItem(src, item, amount, false, metadata or false,'mani-bridge:AddItem()')
    elseif Config.Inventory == 'ps' then
        exports['ps-inventory']:AddItem(src, item, amount, false, metadata or false,'mani-bridge:AddItem()')
    elseif Config.Inventory == 'qs' then
        exports['qs-inventory']:AddItem(src, item, amount, false, metadata or false)
    else
        local PlayerData = GetPlayer(src)
        if Config.Framework == 'esx' then
            PlayerData.addInventoryItem(item, amount, metadata)
        elseif Config.Framework == 'qb' then
            PlayerData.Functions.AddItem(item, amount, nil, metadata)
            TriggerClientEvent('inventory:client:ItemBox', src, Core.Shared.Items[item], 'add', amount)
        else
            -- ADD YOUR OWN INVENTORY SYSTEM HERE
        end
    end
end

exports('AddItem', AddItem)

local function RemoveItem(src, item, amount, slot)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:RemoveItem(src, item, amount, nil, slot)
    elseif Config.Inventory == 'codem' then
        return exports['codem-inventory']:RemoveItem(src, item, amount, slot or false)
    elseif Config.Inventory == 'qb' then
        return exports['qb-inventory']:RemoveItem(src, item, amount, slot or false, 'mani-bridge:RemoveItem()')
    elseif Config.Inventory == 'ps' then
        return exports['ps-inventory']:RemoveItem(src, item, amount, slot or false, 'mani-bridge:RemoveItem()')
    elseif Config.Inventory == 'qs' then
        return exports['qs-inventory']:RemoveItem(src, item, amount, slot or false)
    else
        local PlayerData = GetPlayer(src)
        if Config.Framework == 'esx' then
            return PlayerData.removeInventoryItem(item, amount, false, slot or false)
        elseif Config.Framework == 'qb' then
            if PlayerData.Functions.RemoveItem(item, amount, slot, metadata or false) then
                TriggerClientEvent('inventory:client:ItemBox', src, Core.Shared.Items[item], "remove", amount)
                return true
            end
            return false
        else
            -- ADD YOUR OWN INVENTORY SYSTEM HERE
            return false
        end
    end
end

exports('RemoveItem', RemoveItem)

local function getItemFromSlot(src, slot)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:GetSlot(src, slot)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
    end
end

exports('getItemFromSlot', getItemFromSlot)

local function updateMetadata(src, slot, metadata)
    if Config.Inventory == 'ox' then
        local item = exports['ox_inventory']:GetSlot(src, slot)
        exports['ox_inventory']:SetMetadata(src, slot, metadata)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
    end
end

exports('updateMetadata', updateMetadata)

local function HasItem(src, item)
    if Config.Inventory == 'codem' then
        return exports['codem-inventory']:GetItemsTotalAmount(src, item)
    elseif Config.Inventory == 'ox' then
        return exports['ox_inventory']:Search(src, 'count', item)
    elseif Config.Inventory == 'qb' then
        local itemAmount = exports['qb-inventory']:GetItemCount(src, item)
        return itemAmount or 0
    elseif Config.Inventory == 'ps' then
        local itemAmount = exports['ps-inventory']:GetItemCount(src, item)
        return itemAmount or 0
    elseif Config.Inventory == 'qs' then
        local itemData = exports['qs-inventory']:GetItemByName(src, item)
        if not itemData then return 0 end
        return itemData.amount or itemData.count or 0
    else
        local PlayerData = GetPlayer(src)
        if Config.Framwork == 'esx' then
            local itemData = PlayerData.getInventoryItem(item)
            if itemData then return itemData.count or itemData.amount else return 0 end
        elseif Config.Framwork == 'qb' then
            local itemData = PlayerData.Functions.GetItemByName(item)
            if itemData then return itemData.amount or itemData.count else return 0 end
        else
            -- ADD YOUR OWN INVENTORY SYSTEM HERE
        end
    end
end

exports('HasItem', HasItem)

local function GetItemMetadata(src, slot)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:GetSlot(src, slot).metadata
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
    end
end

exports('GetItemMetadata', GetItemMetadata)