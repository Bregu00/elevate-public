local open = false

RegisterNUICallback('callback', function(data, cb)
	SetNuiFocus(false, false)
    Callbackk(data.success)
    open = false
    cb('ok')
end)

function OpenHackingGame(callback, blocks, speed)
    if not open then
        Callbackk = callback
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "open",
            blocks = blocks,
            speed = speed,
        })

        open = true
    end

    while open do Wait(100) end
end

exports("OpenHackingGame", OpenHackingGame)