function useEffects(ingredients, type) -- No need to modify this
    if Config.Debug then
        print("^3[DEBUG]:^7 ".."useEffects()", type, json.encode(ingredients))
    end
    local triggered = false
    if ingredients then
        for k, v in pairs(ingredients) do
            if Config.Effects and Config.Effects[v] then
                triggered = true
                if Config.Debug then
                    print("^3[DEBUG]:^7 ".."TriggerEffect()", v)
                end
                CreateThread(function()
                    Config.Effects[v]()
                end)
            end
        end
    end
    if Config.Debug then
        print("^3[DEBUG]:^7 ".."No ingredients effect, trigger default one?", type)
    end
    if not triggered and Config.DefaultEffects[type] then
        if Config.Debug then
            print("^3[DEBUG]:^7 ".."TriggerDefaultEffect()", type)
        end
        Config.DefaultEffects[type]()
    end
    if Config.Debug then
        print("^3[DEBUG]:^7 ".."useEffects() finished...")
    end
end

function alcohol(seconds)
    local time = seconds or 30
    local ped = PlayerPedId()
    DoScreenFadeOut(1000)
    Wait(1000)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(ped, true)
    lib.requestAnimSet("MOVE_M@DRUNK@VERYDRUNK", 10000)
    SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", true)
    SetPedIsDrunk(ped, true)
    SetPedAccuracy(ped, 0)
    DoScreenFadeIn(1000)
    Wait(seconds * 1000)
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetPedMotionBlur(ped, false)
end

function drugs(seconds)
    local time = seconds or 30
    local ped = PlayerPedId()
    DoScreenFadeOut(1000)
    Wait(1000)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(ped, true)
    lib.requestAnimSet("MOVE_M@DRUNK@VERYDRUNK", 10000)
    SetPedMoveRateOverride(ped, 10.0)
    SetRunSprintMultiplierForPlayer(ped, 1.49)
    SetPedIsDrunk(ped, true)
    SetPedAccuracy(ped, 0)
    DoScreenFadeIn(1000)
    Wait(seconds * 1000)
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(1000)
    SetPedMoveRateOverride(ped, 0.0)
    SetRunSprintMultiplierForPlayer(ped, 1.0)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetPedMotionBlur(ped, false)
end