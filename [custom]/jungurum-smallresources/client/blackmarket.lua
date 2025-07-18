local blackmarketLocation = lib.callback.await('jungurum-smallresources:server:getBlackmarket', false)

CreateThread(function()
    local pedModel = GetHashKey('g_m_m_chiboss_01')

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(50)
    end
    
    local blackmarketNPC = nil

    SetInterval(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vec3(blackmarketLocation))
        
        if distance < 150 then
            if not DoesEntityExist(blackmarketNPC) then
                blackmarketNPC = CreatePed(4, pedModel, blackmarketLocation.x, blackmarketLocation.y, blackmarketLocation.z, blackmarketLocation.w, false, false)
                FreezeEntityPosition(blackmarketNPC, true)
                SetEntityInvincible(blackmarketNPC, true)
                TaskStartScenarioInPlace(blackmarketNPC, "WORLD_HUMAN_GUARD_STAND", 0, true)
                SetBlockingOfNonTemporaryEvents(blackmarketNPC, true)

                exports['ox_target']:addLocalEntity(blackmarketNPC, {
                    {
                        name = 'blackmarket', 
                        label = 'Blackmarket',
                        icon = 'fas fa-shopping-cart',
                        distance = 1.5,
                        canInteract = function()
                            return not Config.Blackmarket.blacklistedJobs[ESX.GetPlayerData().job.name]
                        end,
                        onSelect = function(entity)
                            exports['ox_inventory']:openInventory('shop', { type = 'BlackMarket' })
                        end
                    },
                    {
                        name = 'gangMissions', 
                        label = 'Missioner',
                        icon = 'fas fa-briefcase',
                        distance = 1.5,
                        canInteract = function()
                            local job = ESX.GetPlayerData().job
                            return job.isgang and (job.grade >= 1)
                        end,
                        onSelect = function(entity)
                            exports['mani-drugmissions']:openMissionContext()
                        end
                    },
                })
            end
        else
            if DoesEntityExist(blackmarketNPC) then
                exports['ox_target']:removeLocalEntity(blackmarketNPC)
                DeleteEntity(blackmarketNPC)
            end
        end
    end, 3000)
end)