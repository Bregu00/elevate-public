exports.ox_target:addGlobalPlayer({
    {
        icon = "fas fa-user",
        label = "Opret i databasen",
        groups = { 'police' },
        distance = 1.5,
        onSelect = function(data)
            local playerEntity = NetworkGetPlayerIndexFromPed(data.entity)
            TriggerServerEvent("elevate_police:RegisterPlayerInDatabase", GetPlayerServerId(playerEntity))
        end,
    },
}) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    if playerData.job and playerData.job.name == 'police' then
        TriggerServerEvent('elevate_police:isOnDuty', true)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job and job.name == 'police' then
        TriggerServerEvent('elevate_police:isOnDuty', true)
    else 
        TriggerServerEvent('elevate_police:isOnDuty', false)
    end
end)

lib.onCache('vehicle', function(entity)
    if not entity then
        lib.removeRadialItem('politi_blips')
        return 
    end

    if not LocalPlayer.state.job or LocalPlayer.state.job.name ~= 'police' then return end
    local networkId = NetworkGetNetworkIdFromEntity(entity)
    local model = GetEntityModel(entity)
    local modelName = GetDisplayNameFromVehicleModel(model)
    local patrolCategory = ''

    lib.addRadialItem({
        id = 'politi_blips',
        icon = 'fa-solid fa-location-dot',
        label = 'Skift Patrulje Type',
        menu = 'police_blips_menu'
    })

    ItemOptions = {}
    ItemOptions[#ItemOptions + 1] = {
        label = 'Almen',
        icon = 'car',
        onSelect = function()
            setPatrolCategory('betjent', 'Bravo')
        end
    }

    ItemOptions[#ItemOptions + 1] = {
        label = 'Motorcykel',
        icon = 'fa-solid fa-motorcycle',
        onSelect = function()
            setPatrolCategory('mc', 'Mike')
        end
    }

    ItemOptions[#ItemOptions + 1] = {
        label = 'Civil',
        icon = 'fa-solid fa-user',
        onSelect = function()
            setPatrolCategory('civil', 'Mike-Kilo')
        end
    }

    ItemOptions[#ItemOptions + 1] = {
        label = 'NSK',
        icon = 'fa-solid fa-user-secret',
        onSelect = function()
            setPatrolCategory('nsk', 'Kilo')
        end
    }

    ItemOptions[#ItemOptions + 1] = {
        label = 'Romeo',
        icon = 'fa-solid fa-vest',
        onSelect = function()
            setPatrolCategory('romeo', 'Romeo')
        end
    }

    ItemOptions[#ItemOptions + 1] = {
        label = 'Indsatsleder',
        icon = 'fa-solid fa-truck',
        onSelect = function()
            setPatrolCategory('lima', 'Lima')
        end
    }

    if modelName == 'POLMAV' then
        ItemOptions[#ItemOptions + 1] = {
            label = 'Helikopter',
            icon = 'fa-solid fa-helicopter',
            onSelect = function()
                setPatrolCategory('helikopter', 'Foxtrot')
            end
        }
    end

    ItemOptions[#ItemOptions + 1] = {
        label = 'Afmeld',
        icon = 'fa-solid fa-xmark',
        onSelect = function()
            TriggerServerEvent('visualz_blips:server:removeEntityFromGroup', "police", networkId)
        end
    }

    lib.registerRadial({
        id = 'police_blips_menu',
        items = ItemOptions
    })

    for vehicleModel, label in pairs(Tablet.VehicleBlipLabels) do
        local hash = GetHashKey(vehicleModel)
        if hash == model then
            lib.callback('elevate_police:getAvailablePatrolId', false, function(patrolId)
                if not patrolId then
                    lib.notify({
                        title = 'Ingen ledige patrulje numre!',
                        type = 'error',
                        duration = 10000,
                    })
                    return
                end

                if hash == model then
                    ESX.TriggerServerCallback('visualz_blips:server:checkEntityGroup', function(group, entityData)
                        if group and entityData then
                            lib.callback('elevate_police:setPatrolId', false, function(patrolData)
                                TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle", networkId, entityData.unitName, entityData.unitNumber, entityData.unitCategory)
                                exports['sd-policeradar']:updatePatrolId(entityData.unitName .. ' - ' .. entityData.unitNumber)
                            end, '10-'..patrolId, entityData.unitCategory, entityData.unitNumber)
                        else
                            lib.callback('elevate_police:setPatrolId', false, function(patrolData)
                                TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle", networkId, patrolData.category, '10-'..patrolId, patrolData.currentCategory)
                                exports['sd-policeradar']:updatePatrolId(patrolData.category .. ' - 10-'..patrolId)
                            end, '10-'..patrolId)
                        end            
                    end, networkId)
                end
            end, networkId)
            break
        end
    end
end)

setPatrolCategory = function(category, unitName)
    local entity = GetVehiclePedIsIn(cache.ped, false)
    local networkId = NetworkGetNetworkIdFromEntity(entity)
    local model = GetEntityModel(entity)
    local modelName = GetDisplayNameFromVehicleModel(model)

    for vehicleModel, label in pairs(Tablet.VehicleBlipLabels) do
        local hash = GetHashKey(vehicleModel)
        if hash == model then
            lib.callback('elevate_police:getAvailablePatrolId', false, function(patrolId)
                if not patrolId then
                    lib.notify({
                        title = 'Ingen ledige patrulje numre!',
                        type = 'error',
                        duration = 10000,
                    })
                    return
                end

                ESX.TriggerServerCallback('visualz_blips:server:checkEntityGroup', function(group, entityData)
                    if group and entityData then
                        TriggerServerEvent('visualz_blips:server:removeEntityFromGroup', "police", networkId)
                        lib.callback('elevate_police:setPatrolId', false, function(patrolData)
                            TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle", networkId, unitName, entityData.unitNumber, category)
                            exports['sd-policeradar']:updatePatrolId(unitName .. ' - ' .. entityData.unitNumber)
                        end, '10-'..patrolId, category, entityData.unitNumber)
                    else
                        lib.callback('elevate_police:setPatrolId', false, function(patrolData)
                            TriggerServerEvent('visualz_blips:server:addEntityToGroup', "police", "vehicle", networkId, unitName, '10-'..patrolId, category)
                            exports['sd-policeradar']:updatePatrolId(category .. ' - 10-'..patrolId)
                        end, '10-'..patrolId)
                    end
                end, networkId)
            end, networkId)
            break
        end
    end
end
