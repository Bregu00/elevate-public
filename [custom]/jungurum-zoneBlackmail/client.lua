CreateThread(function()
    local blackMailNPC = {}

    for i = 1, #Config.locations do
        local location = Config.locations[i]

        RequestModel(location.ped)
        while not HasModelLoaded(location.ped) do
            Wait(50)
        end

        SetInterval(function()
            local playerCoords = GetEntityCoords(PlayerPedId())
            local npcCoords = vector3(location.coords.x, location.coords.y, location.coords.z)
            local distance = #(playerCoords - npcCoords)

            if distance < 150 then
                if not DoesEntityExist(blackMailNPC[i]) then
                    blackMailNPC[i] = CreatePed(4, location.ped, location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false, false)
                    FreezeEntityPosition(blackMailNPC[i], true)
                    SetEntityInvincible(blackMailNPC[i], true)
                    TaskStartScenarioInPlace(blackMailNPC[i], "WORLD_HUMAN_GUARD_STAND", 0, true)
                    SetBlockingOfNonTemporaryEvents(blackMailNPC[i], true)

                    exports['ox_target']:addLocalEntity(blackMailNPC[i], {
                        {
                            name = 'zoneBlackmail'.. i,  
                            label = location.label,
                            icon = 'fas fa-briefcase',
                            distance = 1.5,
                            canInteract = function()
                                return ESX.GetPlayerData().job.isgang
                            end,
                            onSelect = function(entity)
                                local xPlayer = ESX.GetPlayerData()
                                if xPlayer.job.grade_name ~= "boss" then
                                    return lib.notify({title = "Jeg snakker kun med en af dine bosser!", type = "error"})
                                end

                                local coords = GetEntityCoords(entity.entity)
                                local zoneName = GetZone(coords)
                                local Zone = lib.callback.await('visualz_zones:GetSpecificZone', false, zoneName)

                                if Zone.owner then
                                    local canProceed, timeRemaining = lib.callback.await("jungurum-zoneBlackmail:server:CheckCooldown", false, Zone, location, i, xPlayer.job.name)
                                    if not canProceed then
                                        lib.notify({title = timeRemaining, type = "error"})
                                        return
                                    end

                                    
                                    local progressDuration
                                    if xPlayer.job.name == Zone.owner then
                                        progressDuration = Config.Minutes(0.5) 
                                    else
                                        progressDuration = Config.Minutes(2)
                                    end

                                    local success = lib.progressBar({
                                        duration = progressDuration,
                                        label = location.label,
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            move = true,
                                            car = true,
                                        },
                                    })

                                    if success then
                                        ESX.TriggerServerCallback("jungurum-zoneBlackmail:server:RewardAndCoolDown", function(successful, reason)
                                            local notifyType = successful and "success" or "error"
                                            lib.notify({title = reason, type = notifyType})

                                            if successful and xPlayer.job.name ~= Zone.owner then
                                                local newPoints = math.max(0, Zone.points - location.deductPoints)
                                                local deductPoints = lib.callback.await("visualz_zones:SetPoint", false, zoneName, newPoints)

                                                if deductPoints then
                                                    lib.notify({title = Zone.owner .. " har fået fjernet " .. location.deductPoints .. " point", type = "success"})
                                                end
                                            end
                                        end, Zone, location, i)
                                    else
                                        lib.notify({title = "Du stoppede blackmail!", type = "error"})
                                    end
                                else
                                    lib.notify({title = "Ingen ejer denne zone!", type = "error"})
                                end
                            end
                        }
                    })
                end
            else
                if DoesEntityExist(blackMailNPC[i]) then
                    exports['ox_target']:removeLocalEntity(blackMailNPC[i])
                    DeleteEntity(blackMailNPC[i])
                    blackMailNPC[i] = nil
                end
            end
        end, 500)
    end
end)


function GetZone(coords)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    return zone:upper()
end

local cooldowns = {}

function setCooldown(key, cooldownTime)
    if cooldowns[key] then
        return true
    else
        cooldowns[key] = true
        SetTimeout(cooldownTime, function()
            cooldowns[key] = nil
        end)
        return false
    end
end