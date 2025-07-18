local cruiseEnabled = false

local function toggleLimiter(data)
    Wait(250)

    if not cruiseEnabled then
        SetEntityMaxSpeed(data.vehicle, data.cruiserSpeed)
        local cruiserNotification = math.floor(data.cruiserSpeed * 3.6 + 0.5)
        cruiseEnabled = true
        lib.notify({ title = ('Fartbegrænser aktiveret: %s KM/t'):format(cruiserNotification), type = 'success' })
    else
        SetEntityMaxSpeed(data.vehicle, data.maxSpeed)
        cruiseEnabled = false
        lib.notify({ title = "Fartbegrænser deaktiveret", type = 'error' })
    end
end

RegisterCommand("cc", function(_, args)
    local ped = cache.ped
    local vehicle = cache.vehicle
    if not vehicle or not (GetPedInVehicleSeat(vehicle, -1) == ped) then return end
    local maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
    local cruiserSpeed = args[1] and (args[1] * 1000 / 3600) or GetEntitySpeed(vehicle)

    toggleLimiter({
        vehicle = vehicle,
        maxSpeed = maxSpeed,
        cruiserSpeed = cruiserSpeed,
    })
end)