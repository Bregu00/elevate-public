Config = Config or {}
Inventory, Core, Framework = nil, nil, nil
CreateThread(function()
    if not Inventory then Inventory = exports['av_laptop']:getInventory() end
    if not Framework then Framework = exports['av_laptop']:getFramework() end
    if Framework == "qb" or Framework == "qbox" then
        Config.VehicleTable = "player_vehicles"
    elseif Framework == "esx" then
        Config.VehicleTable = "owned_vehicles"
    end
    if Inventory == "ox_inventory" then
        return
    end
    if Inventory == "origen_inventory" and Framework == "qb" then
        if not Core then Core = exports['av_laptop']:getCore() end
        Core.Functions.CreateUseableItem(Config.TrackerItem, function(source,item)
            tracker(source)
        end)
        Core.Functions.CreateUseableItem(Config.CrackerItem, function(source,item)
            cracker(source)
        end)
    else
        exports['av_laptop']:registerItem(Config.TrackerItem,tracker)
        exports['av_laptop']:registerItem(Config.CrackerItem,cracker)
    end
end)

AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata) 
    if name == Config.TrackerItem then
        tracker(playerId)
        return
    end
    if name == Config.CrackerItem then
        cracker(playerId)
        return
    end
end)

function tracker(source)
    if Config.Debug then
        print("used TrackerItem()")
    end
    TriggerClientEvent('av_boosting:trackerMinigame',source)
end

function cracker(source)
    if Config.Debug then
        print("used CrackerItem()")
    end
    TriggerClientEvent('av_boosting:useCracker',source)
end