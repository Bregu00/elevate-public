local Prison = {}

function Prison.ResetPlayerArmor(playerPed)
	SetPedArmour(playerPed, 0)
    exports['mani-armorsystem']:resetArmor()
end

function Prison.Dispatch()
    local data = exports['tk_dispatch']:getPlayerData()
    exports['tk_dispatch']:addCall({
        title = 'Fængsel Flugt',
        code = 'Fængsel',
        priority = 'Prioritet 3',
        coords = GetEntityCoords(cache.ped),
        message = ('Køn: %s | Har flugt fra fængsel'):format(data.gender or 'Ukendt'),
        showLocation = true,
        showDirection = true,
        showGender = data.gender or 'Ukendt',
        showPerson = true,
        color = 'red',
        flash = true,
        playSound = true,
        removeTime = 1000 * 60 * 5, -- will be removed after 10 minutes
        showTime = 10000, -- will be shown on screen (as notification) for 10 seconds
        blip = {
            color = 1,
            sprite = 188,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end

return Prison