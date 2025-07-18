local headshotCount = 0
local headshotResetTimerStarted = false

local function StartHeadshotResetTimer()
    if headshotResetTimerStarted then return end
    headshotResetTimerStarted = true

    CreateThread(function()
        Wait(300000) -- 5 minutter (300,000 ms)

        headshotCount = 0
        headshotResetTimerStarted = false
        SetPedConfigFlag(cache.ped, 438, false)
    end)
end

AddEventHandler("gameEventTriggered", function(eventName, args)
    if eventName == "CEventNetworkEntityDamage" then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[7]

        if victim == cache.ped then
            local helmet = GetPedPropIndex(cache.ped, 0)
            if LocalPlayer.state.job.name ~= 'police' then return end
            if not Config.WhitelistedHelmets[helmet] then return end

            if Config.GunWeaponHashes[weaponHash] then
                local hit, boneIndex = GetPedLastDamageBone(victim)

                if boneIndex and boneIndex == 31086 then
                    headshotCount = headshotCount + 1

                    if headshotCount == 1 then
                        SetPedConfigFlag(victim, 438, true)
                        StartHeadshotResetTimer()
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    lib.onCache('ped', function(ped)
        local state = LocalPlayer.state
        if state.job and state.job.name == 'police' and headshotCount < 1 then
            SetPedConfigFlag(ped, 438, false)
        else
            SetPedConfigFlag(ped, 438, true)
        end
    end)
end)