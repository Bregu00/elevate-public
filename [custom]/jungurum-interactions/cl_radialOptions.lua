CreateThread(function()
    local defaultOptions = Config.radialOptions()

    lib.addRadialItem(defaultOptions)

    lib.registerRadial({
        id = 'spiller_interactions_actions',
        items = {
          {
            label = 'Visiter',
            icon = 'fa-solid fa-people-robbery',
            onSelect = function()
                local serverId, playerPed, playerCoords = nearestPlayer()
                if serverId then
                    local targetState = Player(serverId).state
                    if hasJob('police') and targetState.isCuffed or targetState.isCuffed and not targetState.dead then
                        ExecuteCommand("do **Visiterer**")
                        exports['ox_inventory']:openInventory('player', serverId)
                    end
                end
            end,
          },
          {
            label = 'Eskorter',
            icon =  'fas fa-hands-bound',
            onSelect = function()
                local serverId, playerPed, playerCoords = nearestPlayer()
                if serverId then
                    local targetState = Player(serverId).state
                    print(targetState.isCuffed)
                    if not targetState.isCuffed then lib.notify('Det er ikke muligt at eskortere denne spiller') return end
                    if not IsEntityAttachedToEntity(playerPed, cache.ped) then

                        exports['ND_Police']:escortPlayer(playerPed)
                    else
                        exports['ND_Police']:StopEscortPlayer(serverId)
                        StopAnimTask(cache.ped, "amb@world_human_drinking@coffee@female@base", "base", 2.0)
                        ClearPedTasks(cache.ped)
                    end
                    
                end
            end
          },
          {
            label = 'Strips Af/På',
            icon =  'fa-solid fa-handcuffs',
            onSelect = function()
                local serverId, playerPed, playerCoords = nearestPlayer()
                if serverId then
                    local targetState = Player(serverId).state
                    if not targetState.isCuffed and exports['ND_Police']:canCuffPed(playerPed, 'zipties') then
                        if not hasItem('zipties') then lib.notify('Du har ikke nogen strips') return end

                        exports['ND_Police']:cuffPed(playerPed, 'zipties')
                    elseif targetState.isCuffed then
                        exports['ND_Police']:uncuffPed(playerPed, 'zipties')
                    end
                end
            end
          },
          {
            label = 'Sæt i/Fjern fra køretøj',
            icon =  'fa-solid fa-car',
            onSelect = function()
                local xPlayer = ESX.GetPlayerData()
                local serverId, playerPed, playerCoords = nearestPlayer()
                if serverId then
                    local targetState = Player(serverId).state
                    if targetState.isCuffed or targetState.dead or xPlayer.job.name == "police" then
                        if IsPedInAnyVehicle(playerPed) then
                            TriggerServerEvent('jungurum-interactions:server:pullOutAraba', serverId)
                            ExecuteCommand("do **Fjerner fra køretøj**")

                        else
                            local coords = GetEntityCoords(cache.ped)
                            local veh = lib.getClosestVehicle(coords, 4.0, true)
                            if not DoesEntityExist(veh) or not AreAnyVehicleSeatsFree(veh) then return end
                
                            local bones = {"seat_dside_r", "seat_pside_r"}
                            local closestDist = nil
                            local closestSeat = nil
                
                            for i=1, #bones do
                                local dist = #(coords - GetEntityBonePosition_2(veh, GetEntityBoneIndexByName(veh, bones[i])))
                                if (not closestDist or not closestSeat or dist < closestDist) and IsVehicleSeatFree(veh, i) then
                                    closestSeat = i
                                    closestDist = dist
                                end
                            end
                
                            if not closestSeat and IsVehicleSeatFree(veh, 0) then
                                closestSeat = 0
                            elseif not closestSeat then
                                return
                            end
                            ExecuteCommand("do **Putter i køretøj**")

                            exports['ND_Police']:StopEscortPlayer(serverId, VehToNet(veh), closestSeat)
                        end
                    end
                end
            end
          },
        }
    })
end)

RegisterNetEvent('jungurum-interactions:client:pullOutAraba', function()
    if not IsPedSittingInAnyVehicle(cache.ped) then return end
    
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    TaskLeaveVehicle(cache.ped, vehicle, 16)
end)