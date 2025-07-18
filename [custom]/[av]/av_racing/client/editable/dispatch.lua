-- receives the starting checkpoint from the event NOT the racer coords
-- trackId just in case u need it for something
function sendDispatch(trackId, checkpoint)
    local coords = checkpoint['coords']
    if coords then
        local data = exports.tk_dispatch:getPlayerData()
        exports['tk_dispatch']:addCall({
            title = "Ulovlig Gade Ræs",
            code = 'Ræs',
            priority = 'Prioritet 3',
            coords = coords,
            message = ('Ulovligt Gade Ræs Igang | Direktion: %s'):format(data.direction),
            showLocation = true,
            showDirection = true,
            showGender = false,
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
end