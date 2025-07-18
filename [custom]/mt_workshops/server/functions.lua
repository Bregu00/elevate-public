---@param plate string
---@return any
isVehicleOwned = function(plate)
    if Config.framework == 'esx' then
        return MySQL.scalar.await('SELECT plate FROM owned_vehicles WHERE plate = ?', { plate })
    else
        return MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    end
    return false
end

---@param vehicle any
---@param mods any
saveVehicleMods = function(vehicle, mods)
    if Config.framework == 'esx' then
        MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', { json.encode(mods), mods.plate })
    else
        MySQL.update('UPDATE player_vehicles SET mods = ? WHERE plate = ?', { json.encode(mods), mods.plate })
    end
end

---@param plate string
---@return any
getVehicleDatabaseMods = function(plate)
    if Config.framework == 'esx' then
        return MySQL.scalar.await('SELECT vehicle FROM owned_vehicles WHERE plate = ?', { plate })
    else
        return MySQL.scalar.await('SELECT mods FROM player_vehicles WHERE plate = ?', { plate })
    end
end

---@param account string
---@param amount integer
addAccountMoney = function(account, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:addAccountMoney(account, amount)
    elseif Config.banking == 'esx_addonaccount' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. account, function(account)
            account.addMoney(amount)
        end)
    else
        exports[Config.banking]:AddMoney(account, amount)
    end
end

isValidItem = function(item)
    local isValidItem = false
    local workshopItems = {
        'body_repair_kit',
        'cosmetics',
        'mechanic_toolbox',
        'neons_controller',
        'mods_list',
        'extras_controller'
    }

    for _, workshopItem in pairs(workshopItems) do
        if workshopItem == item then
            isValidItem = true
            break
        end
    end

    if not isValidItem then
        for _, performance in pairs(Config.performance) do
            if performance.item == item then
                isValidItem = true
                break
            end
        end
    end

    return isValidItem
end

---@param item string
---@return boolean | table
isValidCraftItem = function(item)
    ---@type boolean | table
    local isValidItem = false
    for category, _ in pairs(Config.crafts) do
        for _, item in pairs(Config.crafts[category].items) do
            if item.name == item then
                isValidItem = item.ingredients
                break
            end
        end
    end
    return isValidItem
end