local mainserver = GetConvar("mainserver", false)

if not mainserver then return end

local function AFKNotification(time)
    lib.notify({
        title = 'AFK',
        description = string.format("%s %d %s", Config.AFK.description, time, Config.AFK.seconds),
        position = 'bottom',
        style = {
            borderRadius = 5,
            backgroundColor = '#000000bf',
            color = 'white'
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
    PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", 0)
end

local function AFKLoop()
    CreateThread(function()
        local time = Config.AFK.timeAFK or 30
        local prevPos = nil

        SetInterval(function()
            local playerPed = cache.ped
            if playerPed then
                local currentPos = GetEntityCoords(playerPed, true)
                if prevPos and #(currentPos - prevPos) < 0.01 then -- Use vector distance for comparison
                    if time > 0 then
                        if Config.AFK.kickWarning and time <= 30 then
                            AFKNotification(time)
                        end
                        time = time - 1
                    else
                        TriggerServerEvent("jungurum-smallresources:server:kickAFK")
                    end
                else
                    time = Config.AFK.timeAFK or 30
                end
                prevPos = currentPos
            end
        end, 1000)
    end)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    if xPlayer.group ~= 'god' then
        AFKLoop()
    end
end)