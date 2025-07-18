function GiveKeys(plates)
    -- Your give keys event/export goes here
    -- Example for qb-vehiclekeys:
    TriggerEvent("vehiclekeys:client:SetOwner", plates)
end

RegisterNetEvent('av_boosting:useCracker', function()
    if Config.Debug then
        print("useCracker")
    end
    if IsPedInAnyVehicle(cache.ped, false) then return end
    if Config.Debug then
        print("get nearby vehicles...")
    end
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 10, false)
    if vehicle then
        if Config.Debug then
            print("veh nearby")
        end
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        local state = Entity(vehicle).state
        if Config.Debug then
            print(state.boosting, state.class, state.lockpick)
        end
        if state.boosting and state.class and not state.lockpick then
            if Config.Debug then
                print('everything fine..')
            end
            local class = state.class
            local plates = GetPlate(vehicle)
            if Config.Debug then
                print('TaskStartScenarioInPlace..')
            end
            TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
            TriggerServerEvent('av_boosting:spawnGuards', netId)
            Wait(3500)
            SetVehicleAlarm(vehicle, true)
            sendDispatch(vehicle, plates, class)
            local success = lockpickMinigame(vehicle, class)
            if success then
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                GiveKeys(plates)
                TriggerServerEvent('av_boosting:lockpick', netId)
                SetVehicleAlarm(vehicle, false)
            end
            ClearPedTasks(cache.ped)
        else
            TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['lockpick_error'], "error")
        end
    else
        if Config.Debug then
            print("no veh nearby")
        end
    end
end)

function GetPlate(vehicle)
    local value = GetVehicleNumberPlateText(vehicle)
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

exports('isBoosting', function()
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5, false)
    if vehicle then
        local state = Entity(vehicle).state
        if state.boosting then
            return true
        end
    end
    return false
end)