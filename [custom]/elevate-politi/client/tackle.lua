local tackleDuration = math.random(7500, 10000)

function GetTouchedPlayers()
    local players = {}

    local ped = PlayerPedId()

    for _, playerId in ipairs(GetActivePlayers()) do
        if IsEntityTouchingEntity(ped, GetPlayerPed(playerId)) then table.insert(players, playerId) end
    end

    return players
end

function Tackle()
    if not (ESX.PlayerData.job.name == "police") then return end
    local ped = PlayerPedId()

    if IsPedOnFoot(ped) then
        if IsPedJumping(ped) then
            local forwardVector = GetEntityForwardVector(ped)
            SetPedToRagdollWithFall(ped, tackleDuration, 2000, 0, forwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

            Citizen.CreateThread(function()
                local tackled = {}

                while IsPedRagdoll(ped) do
                    local justTackledServierIds = {}

                    for _, playerId in ipairs(GetTouchedPlayers()) do
                        if not tackled[playerId] then
                            tackled[playerId] = true
                            table.insert(justTackledServierIds, GetPlayerServerId(playerId))
                        end
                    end

                    if #justTackledServierIds > 0 then TriggerServerEvent('elevate_politi:TacklePlayer', justTackledServierIds, forwardVector) end
                    Wait(0)
                end
            end)
        end
    end
end

RegisterCommand('+Tackle', Tackle, false)
RegisterCommand('-Tackle', function() end, false)
RegisterKeyMapping('+Tackle', 'Tackle en anden spiller', 'keyboard', 'E', function()
    if IsPedJumping(PlayerPedId()) and ESX.PlayerData.job.name == "police" then
        TackePlayer()
    end
end, false)

RegisterNetEvent('elevate_politi:TacklePlayer')
AddEventHandler('elevate_politi:TacklePlayer', function(forwardVector)
    SetPedToRagdollWithFall(PlayerPedId(), tackleDuration, tackleDuration, 0, forwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end)
