local inVeh = false

local function DriveByControlLoop(veh)
    inVeh = false

    local ped = cache.ped
    local p_id = PlayerId()

    while not inVeh do
        local v_speed = GetEntitySpeed(veh)
        if Config.driveBy.DisableOnlyWhenSpeeding and v_speed >= (Config.driveBy.VehicleSpeedToDisable / 2.4) then
            SetPlayerCanDoDriveBy(p_id, false)
        else
            if GetPedInVehicleSeat(veh, -1) == ped then
                SetPlayerCanDoDriveBy(p_id, false)
            else
                SetPlayerCanDoDriveBy(p_id, true)
            end
        end
        Wait(1000)
    end
end

CreateThread(function()
    lib.onCache('vehicle', function(vehicle, oldVehicle)
        if vehicle and not oldVehicle then
            DriveByControlLoop(vehicle)
        elseif not vehicle and oldVehicle then
            inVeh = true
        end
    end)
end)