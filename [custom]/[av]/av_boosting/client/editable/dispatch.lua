local dispatches = {}

function sendDispatch(vehicle, plates, class) -- Receives vehicle object, plates and class (D, C, B, etc)
    if class == 'D' or dispatches[plates] then return true end
    local data = exports['tk_dispatch']:getPlayerData()
    local chance = math.random(1, 100)
    dispatches[plates] = true

    exports['tk_dispatch']:addCall({
        title = ("Bil Boosting: %s Klasse"):format(class),
        code = 'Bil Alarm',
        priority = 'Prioritet 3',
        coords = GetEntityCoords(cache.ped),
        message = ('Køn: %s | Har stjålet et køretøj med GPS'):format(chance >= 50 and data.gender or 'Ukendt'),
        showLocation = true,
        showDirection = true,
        showGender = chance >= 50 and data.gender or 'Ukendt',
        showVehicle = false,
        showWeapon = false,
        showPerson = false,
        showNumber = false,
        color = 'red',
        flash = true,
        playSound = true,
        removeTime = 1000 * 60 * 5, -- will be removed after 10 minutes
        showTime = 10000, -- will be shown on screen (as notification) for 10 seconds
        blip = {
            color = 1,
            sprite = 227,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end