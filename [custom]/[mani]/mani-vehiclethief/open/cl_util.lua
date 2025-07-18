local VehicleThief = {}

VehicleThief.Dispatch = function(Class)
    local data = exports['tk_dispatch']:getPlayerData()
    exports['tk_dispatch']:addCall({
        title = ('Biltyv [%s]'):format(Class),
        code = 'Biltyv',
        priority = 'Prioritet 2',
        coords = GetEntityCoords(cache.ped),
        message = ('Køn: %s | Har stjålet et køretøj med GPS'):format(data.gender or 'Ukendt'),
        showLocation = true,
        showDirection = true,
        showPerson = false,
        color = 'orange',
        flash = true,
        playSound = true,
        removeTime = 1000 * 60 * 5, -- will be removed after 10 minutes
        showTime = 10000, -- will be shown on screen (as notification) for 10 seconds
        blip = {
            color = 3,
            sprite = 523,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end

return VehicleThief