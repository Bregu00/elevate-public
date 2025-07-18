local coords = vector4(-552.4795, -202.8306, 37.23903, 334.0822)
CreateThread(function()
    local pedModel = GetHashKey('cs_barry')

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(50)
    end
    
    local jobCenter = nil

    SetInterval(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vec3(coords.xyz))
        
        if distance < 150 then
            if not DoesEntityExist(jobCenter) then
                jobCenter = CreatePed(4, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)
                FreezeEntityPosition(jobCenter, true)
                SetEntityInvincible(jobCenter, true)
                TaskStartScenarioInPlace(jobCenter, "WORLD_HUMAN_GUARD_STAND", 0, true)
                SetBlockingOfNonTemporaryEvents(jobCenter, true)

                exports['ox_target']:addLocalEntity(jobCenter, {
                    {
                        name = 'idKort', 
                        label = 'Efterspørg ID',
                        icon = 'fas fa-card',
                        distance = 1.5,
                        onSelect = function(entity)
                            TriggerServerEvent('jungurum-smallresources:server:giveIdCard')
                        end
                    },

                })
            end
        else
            if DoesEntityExist(jobCenter) then
                exports['ox_target']:removeLocalEntity(jobCenter)
                DeleteEntity(jobCenter)
            end
        end
    end, 3000)
end)