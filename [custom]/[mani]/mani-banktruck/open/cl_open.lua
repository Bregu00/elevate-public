local Banktruck = {}

function Banktruck.PinCracker(callback)
    local success = exports['bl_ui']:PathFind(1, {
        numberOfNodes = 10,
        duration = 12500,
    })

    callback(success)
end

function Banktruck.HackComputer(callback)
    local success = exports['bl_ui']:Untangle(2, {
        numberOfNodes = 10,
        duration = 12500,
    })

    callback(success)
end

function Banktruck.PlantBomb(callback)
    local success = exports['bl_ui']:CircleSum(3, {
        length = 4,
        duration = 7500,
    })

    callback(success)
end

function Banktruck.CallCops()
    local data = exports['tk_dispatch']:getPlayerData()
    exports['tk_dispatch']:addCall({
        title = "Eksplosion",
        code = 'Landmine',
        priority = 'Prioritet 2',
        coords = GetEntityCoords(cache.ped),
        message = 'En landmine har eksploderet et køretøj',
        showLocation = true,
        showDirection = true,
        showGender = false,
        showVehicle = true,
        showWeapon = false,
        showPerson = false,
        showNumber = false,
        color = 'red',
        flash = true,
        playSound = true,
        removeTime = 1000 * 60 * 5,
        showTime = 7500,
        blip = {
            color = 2,
            sprite = 67,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end

return Banktruck