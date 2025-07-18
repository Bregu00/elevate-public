CreateThread(function()
    exports['ox_target']:addGlobalPlayer({
        {
            name = 'visiter',
            icon =  'fas fa-user-cog',
            label = 'Visiter',
            distance = 1.5,
            canInteract = function(entity)
                local targetPlayer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
                local targetState = Player(targetPlayer).state
                return hasJob('police') and targetState.isCuffed or targetState.isCuffed and not targetState.dead
            end,
            onSelect = function(entity)
                exports['ox_inventory']:openInventory('player', GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity.entity)))
            end
        },
    })

    exports['ox_target']:addGlobalVehicle({
        label = 'Vend Køretøjet',
        name = 'vend_køretøj',
        icon = 'fas fa-cars',
        distance = 2.0,
        onSelect = function(entity)
            if DoesEntityExist(entity.entity) then
                local playerPed = PlayerPedId()
                TaskTurnPedToFaceEntity(playerPed, entity.entity, 1000)
                Wait(1000)
                if lib.progressBar({
                        duration = 10000,
                        label = 'Vender køretøjet',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        },
                        anim = {
                            dict = 'missfinale_c2ig_11',
                            clip = 'pushcar_offcliff_m'
                        },
                    }) then
                    SetEntityAsMissionEntity(entity.entity, true, true)
                    SetEntityRotation(entity.entity, 1.0, 1.0, 1.0, 1.0, true)
                end
            end
        end,
        canInteract = function(entity)
            local rot = GetEntityRoll(entity)
            return (rot > 70 or rot < -70) and GetEntitySpeed(entity) < 2
        end
    })
end)