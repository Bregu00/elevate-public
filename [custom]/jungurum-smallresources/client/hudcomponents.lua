local disableHudComponents = Config.Disable.hudComponents
local disableControls = Config.Disable.controls
local displayAmmo = Config.Disable.displayAmmo

local function decorSet(Type, Value)
    if Type == 'parked' then
        Config.Density.parked = Value
    elseif Type == 'vehicle' then
        Config.Density.vehicle = Value
    elseif Type == 'multiplier' then
        Config.Density.multiplier = Value
    elseif Type == 'peds' then
        Config.Density.peds = Value
    elseif Type == 'scenario' then
        Config.Density.scenario = Value
    end
end

CreateThread(function()
    SetInterval(function()
        for i = 1, #disableHudComponents do
            HideHudComponentThisFrame(disableHudComponents[i])
        end

        for i = 1, #disableControls do
            DisableControlAction(2, disableControls[i], true)
        end

        DisplayAmmoThisFrame(displayAmmo)

        SetParkedVehicleDensityMultiplierThisFrame(Config.Density.parked)
        SetVehicleDensityMultiplierThisFrame(Config.Density.vehicle)
        SetRandomVehicleDensityMultiplierThisFrame(Config.Density.multiplier)
        SetPedDensityMultiplierThisFrame(Config.Density.peds)
        SetScenarioPedDensityMultiplierThisFrame(Config.Density.scenario, Config.Density.scenario) -- Walking NPC Density
        SetPlayerStamina(PlayerId(), 100)
        ResetPlayerStamina(PlayerId())
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
    end, 0)
end)

CreateThread(function()
    local lastShotTime = GetGameTimer()
    SetInterval(function()
        local ped = cache.playerId
        local playerPed = cache.ped
        local weapon = GetSelectedPedWeapon(playerPed)
        local recoil = Config.Recoil[weapon]
        if recoil ~= nil and IsPedShooting(playerPed) then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', recoil)
            lastShotTime = GetGameTimer()
        elseif GetGameTimer() - lastShotTime > 2000 then
            SetPedUsingActionMode(playerPed, false, -1, "DEFAULT_ACTION")
        end
    end, 0)
end)

exports('addDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        disableControls[#disableControls + 1] = controls
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #controls do
            disableControls[#disableControls + 1] = controls[i]
        end
    end
end)

exports('removeDisableControls', function(controls)
    local controlsType = type(controls)
    if controlsType == 'number' then
        for i = 1, #disableControls do
            if disableControls[i] == controls then
                table.remove(disableControls, i)
                break
            end
        end
    elseif controlsType == 'table' and table.type(controls) == "array" then
        for i = 1, #disableControls do
            for i2 = 1, #controls do
                if disableControls[i] == controls[i2] then
                    table.remove(disableControls, i)
                end
            end
        end
    end
end)