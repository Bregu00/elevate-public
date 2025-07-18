local function inventorySearch(search, item, metadata)
    if Config.Inventory == 'ox' then
        return exports['ox_inventory']:Search(search, item, metadata)
    elseif not Config.Inventory then
        -- ADD YOUR OWN INVENTORY SYSTEM HERE
        print('ERROR: This server does not have a supported inventory system.')
    end
end

exports('inventorySearch', inventorySearch)