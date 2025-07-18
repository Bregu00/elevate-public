Dispatch = {}

--This function dispatches all the calls
function Dispatch.call(coords, data)
    exports['tk_dispatch']:addCall({
        title = data.Title,
        code = data.code,
        priority = 'Prioritet 3',
        message = data.Message,
        coords = coords,
        showTime = 10000, -- will be shown on screen (as notification) for 10 seconds
        removeTime = 1000 * 60 * 5, -- will be removed after 10 minutes
        color = 'red',
        flash = true,
        playSound = true,
        blip = {
            color = 3,
            sprite = 431,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end