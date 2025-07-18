local polyzones = {}
local isLooping = false

local function ToggleFarm(item)
    local playerPed = cache.ped
    if isLooping then
        isLooping = false
        ClearPedTasks(playerPed)
        SetEntityCollision(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        if lib.progressActive() then lib.cancelProgress() end
        lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
    else
        isLooping = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
        FreezeEntityPosition(playerPed, true)
        SetEntityCollision(playerPed, false, false)
        lib.showTextUI('[E] Stop Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
        CreateThread(function()
            while isLooping do
                Wait(0)
                if lib.progressBar({
                    duration = Config.Marker[item].farmTime,
                    label = Config.Marker[item].label,
                    useWhileDead = false,
                    disable = {
                        car = true,
                    }
                }) then
                    local newPlayerped = cache.ped
                    if playerPed ~= newPlayerped or not IsPedUsingScenario(newPlayerped, 'WORLD_HUMAN_GARDENER_PLANT') then
                        isLooping = false
                        ClearPedTasks(newPlayerped)
                        SetEntityCollision(newPlayerped, true, true)
                        FreezeEntityPosition(playerPed, false)
                        lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
                        return
                    end
                    lib.callback.await('mani-drugs:server:giveItem', false, item, Config.Marker[item].amount)
                end
            end
            SetEntityCollision(playerPed, true, true)
            FreezeEntityPosition(playerPed, false)
        end)
    end
end

local function ToggleOmdan(item)
    local hasRecipe, missingItem = lib.callback.await('mani-drugs:server:hasRecipe', false, Config.Omdanner[item].requires)
    if not hasRecipe then lib.notify({ title = ('Du mangler %s for at omdanne'):format(missingItem), type = 'error' }) return end
    local dict = 'amb@prop_human_parking_meter@male@base'
    lib.requestAnimDict(dict)
    local playerPed = cache.ped
    if isLooping then
        isLooping = false
        ClearPedTasks(playerPed)
        SetEntityCollision(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        RemoveAnimDict(dict)
        if lib.progressActive() then lib.cancelProgress() end
        lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
    else
        isLooping = true
        FreezeEntityPosition(playerPed, true)
        TaskPlayAnim(playerPed, dict, 'base', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
        SetEntityCollision(playerPed, false, false)
        lib.showTextUI('[E] Stop Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
        CreateThread(function()
            while isLooping do
                Wait(0)
                hasRecipe, missingItem = lib.callback.await('mani-drugs:server:hasRecipe', false, Config.Omdanner[item].requires)
                if not hasRecipe then
                    isLooping = false
                    ClearPedTasks(playerPed)
                    SetEntityCollision(playerPed, true, true)
                    FreezeEntityPosition(playerPed, false)
                    RemoveAnimDict(dict)
                    lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
                    lib.notify({ title = ('Du mangler %s for at omdanne'):format(missingItem), type = 'error' })
                    return
                end
                if lib.progressBar({
                    duration = Config.Omdanner[item].omdanTime,
                    label = Config.Omdanner[item].label,
                    useWhileDead = false,
                    disable = {
                        car = true,
                    }
                }) then
                    local newPlayerped = cache.ped
                    if playerPed ~= newPlayerped or not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
                        isLooping = false
                        ClearPedTasks(newPlayerped)
                        SetEntityCollision(newPlayerped, true, true)
                        FreezeEntityPosition(newPlayerped, false)
                        RemoveAnimDict(dict)
                        lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
                        return
                    end
                    lib.callback.await('mani-drugs:server:giveItem', false, item, Config.Omdanner[item].amount)
                end
            end
            SetEntityCollision(playerPed, true, true)
            FreezeEntityPosition(playerPed, false)
        end)
    end
end

CreateThread(function()
    for k, v in pairs(Config.Marker) do
        polyzones[k] = lib.zones.poly({
            name = k,
            points = v.points,
            debugColour = vec4(51, 54, 92, 50.0),
            thickness = 10,
            debug = Config.Debug,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    ToggleFarm(k)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
            end,
            onExit = function()
                isLooping = false
                lib.hideTextUI()
            end
        })
    end

    for k, v in pairs(Config.Omdanner) do
        polyzones[k] = lib.zones.poly({
            name = k,
            points = v.points,
            debugColour = vec4(51, 54, 92, 50.0),
            thickness = 10,
            debug = Config.Debug,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    ToggleOmdan(k)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
            end,
            onExit = function()
                isLooping = false
                lib.hideTextUI()
            end
        })
    end
end)