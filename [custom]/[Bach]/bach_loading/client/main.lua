local checkState = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        if NetworkIsPlayerActive(PlayerId()) and not checkState then

            Citizen.Wait(2000)

            ShutdownLoadingScreen()
            Citizen.Wait(100)

            ShutdownLoadingScreenNui()
            Citizen.Wait(100)

            SetNoLoadingScreen(true)

            checkState = true
            break
        end
    end
end)

