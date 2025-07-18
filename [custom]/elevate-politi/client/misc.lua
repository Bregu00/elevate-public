CreateThread(function()
    for i = 1, #Config.trashBins do
        local coords = Config.trashBins[i]
        exports['ox_target']:addBoxZone({
            name = 'politiTrash',
            coords = coords,
            size = vector3(1, 1, 1),
            rotation = coords.w,
            options = {
                {
                    label = 'Skraldespand',
                    groups = {['police'] = 0},
                    onSelect = function()
                        local trashStash = lib.callback.await('elevate-politi:server:createTempStash', false)
                        exports['ox_inventory']:openInventory('stash', trashStash)
                    end
                }
            }
        })
    end
end)

exports.ox_target:addGlobalPlayer({
    {
        icon = 'fa-solid fa-cart-plus',
        label = 'Civil Biler',
        groups = {'police'},
        onSelect = function(data)
            local targetEntity = data.entity
            if not targetEntity or not DoesEntityExist(targetEntity) then
                lib.notify({
                    description = 'Kunne ikke finde spilleren (ugyldig entity)',
                    type = 'error',
                    duration = 5000,
                })
                return
            end

            local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetEntity))
            if not targetId then
                lib.notify({
                    description = 'Kunne ikke finde spilleren (ugyldigt ID)',
                    type = 'error',
                    duration = 5000,
                })
                return
            end

            local Options = {}
            
            local xPlayer = ESX.GetPlayerData()
            local job = xPlayer.job.name        

            if Config.CivilBiler and #Config.CivilBiler > 0 then
                for i = 1, #Config.CivilBiler do
                    local vehicle = Config.CivilBiler[i]
                    Options[#Options + 1] = {
                        title = vehicle.label,
                        icon = 'fa-solid fa-car',
                        onSelect = function(data)
                            ESX.Game.SpawnVehicle(vehicle.model, vector3(449.7281, -973.4147, 25.7097), 83.1369, function(vehicleSpawned)
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicleSpawned)
                                local success = lib.callback.await('elevate-politi:server:giveCivilVehicle', false, targetId, vehicle.model, vehicleProps)
                                if success then
                                    lib.notify({
                                        description = 'Giver spilleren en civil bil',
                                        type = 'inform',
                                        duration = 10000,
                                    })
                                    DeleteEntity(vehicleSpawned)
                                else
                                    lib.notify({
                                        description = 'Kunne ikke give spilleren en civil bil',
                                        type = 'error',
                                        duration = 10000,
                                    })
                                end
                            end)
                        end
                    }
                end
            end

            Options[#Options + 1] = {
                title = '',
                disabled = true,
            }

            local ownedVehicles = lib.callback.await('elevate-politi:server:getOwnedCivilVehicles', false, targetId)
            if not ownedVehicles or #ownedVehicles == 0 then
                Options[#Options + 1] = {
                    description = 'Spilleren ejer ingen civil biler',
                }
            end
            if ownedVehicles and #ownedVehicles > 0 then
                for i = 1, #ownedVehicles do
                    local vehicle = ownedVehicles[i]
                    
                    local name = not vehicle.model and vehicle.name and vehicle.name .. " (" .. vehicle.plate .. ")" or GetDisplayNameFromVehicleModel(vehicle.model) .. " (" .. vehicle.plate .. ")"

                    Options[#Options + 1] = {
                        title = name,
                        icon = 'fa-solid fa-car',
                        onSelect = function()
                            local success = lib.callback.await('elevate-politi:server:removeCivilVehicle', false, targetId, vehicle.plate)
                            if success then
                                lib.notify({
                                    description = 'Fjernede bilen: ' .. name,
                                    type = 'inform',
                                    duration = 10000,
                                })
                            else
                                lib.notify({
                                    description = 'Kunne ikke fjerne bilen',
                                    type = 'error',
                                    duration = 10000,
                                })
                            end
                        end
                    }
                end
            end

            lib.registerContext({
                id = 'police_civil_vehicles',
                title = 'Civil Biler',
                options = Options,
            })
            lib.showContext('police_civil_vehicles')
        end,
        canInteract = function()
            if ESX.GetPlayerData().job.grade_name == "boss" then
                return true
            end
            return false
        end,
        distance = 1.5,
    },
})

RegisterCommand('trafic', function()
    if not ESX.PlayerData.job.name == "police" then return end
    
    Options = {}

    Options[#Options + 1] = {
        title = 'Opret Trafik Zone',
        icon = 'fa-solid fa-lightbulb',
        onSelect = function()
            TrafficZone()
        end
    }

    Options[#Options + 1] = {
        title = 'Slet Trafik Zone',
        icon = 'fa-solid fa-xmark',
        onSelect = function()
            TriggerServerEvent('elevate_politi:RemoveZone')
            lib.notify({
                description = 'Sletter Hastigheds Zone',
                type = 'inform',
                duration = 10000,
            })
            zoneActive = false
        end
    }

    lib.registerContext({
        id = 'police_traffic',
        title = 'Trafik Menu',
        options = Options,
    })

    lib.showContext('police_traffic')
end)

local blip = {}
local speedzones = {}

function TrafficZone()
    local traffic = lib.inputDialog("Trafik Zone", {
        {type = "number", label = "Fartgrænsed (km/h)", default = 0, min = 0, max = 130},
        {type = "number", label = "Radius (m)", default = 25, min = 1, max = 100}
    })

    if traffic then
        local zoneRadius, zoneSpeed = traffic[2], traffic[1]
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        radius = zoneRadius + 0.0
        speed = zoneSpeed + 0.0

        local streetName, crossing = GetStreetNameAtCoord(x, y, z)
        streetName = GetStreetNameFromHashKey(streetName)

        local message = "" .. (streetName or "Øen") .. ""
        TriggerServerEvent('elevate_politi:OpretZone', message, speed, radius, x, y, z)
    end
end

RegisterNetEvent('elevate_politi:OpretZone')
AddEventHandler('elevate_politi:OpretZone', function(speed, radius, x, y, z)
    blip = AddBlipForRadius(x, y, z, radius)
    SetBlipSprite(blip, 9)
    SetBlipColour(blip, 70)
    SetBlipAlpha(blip, 75)

    speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)
    table.insert(speedzones, { x, y, z, speedZone, blip })
end)

RegisterNetEvent('elevate_politi:RemoveZone')
AddEventHandler('elevate_politi:RemoveZone', function()
    if not speedzones then
        return
    end

    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local closestSpeedZone = 0
    local closestDistance = 1000
    for i = 1, #speedzones, 1 do
        local distance = Vdist(speedzones[i][1], speedzones[i][2], speedzones[i][3], x, y, z)
        if distance < closestDistance then
            closestDistance = distance
            closestSpeedZone = i
        end
    end

    if closestSpeedZone == 0 then
        return
    end

    if speedzones[closestSpeedZone][4] then
        RemoveSpeedZone(speedzones[closestSpeedZone][4])

        if speedzones[closestSpeedZone][5] then
            RemoveBlip(speedzones[closestSpeedZone][5])
        end
    end

    table.remove(speedzones, closestSpeedZone)
end)

exports('useRambuk', function(itemData)
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer.job or xPlayer.job.name ~= 'police' then return end

    local closestDoor = exports.ox_doorlock:getClosestDoor()

    local playerPed = PlayerPedId()
    local dict = 'anim@heists@fleeca_bank@drilling'
    local anim = 'drill_straight_end'
    local prop = { prop = 'prop_tool_consaw', bone = 28422 }

    local difficulty = 'medium'

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    if closestDoor.distance < 2 then
        local success = lib.skillCheck({difficulty, difficulty, {areaSize = 60, speedMultiplier = 1}, difficulty}, {'w', 'a', 's', 'd'})
        if not success then TriggerServerEvent('elevatepoliti:server:useRambuk', nil, itemData, true) return end
        local playerCoords = GetEntityCoords(playerPed)
        local sawProp = CreateObject(GetHashKey(prop.prop), playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
        AttachEntityToEntity(sawProp, playerPed, GetPedBoneIndex(playerPed, prop.bone), 0.0, 0.0900, 0.0500, -70.3009797, 71.0092017, 83.759421, true, true, false, true, 1, true)
        TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
        if lib.progressBar({
            duration = 5000,
            label = 'Flækker lås op',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
        }) then
            DeleteEntity(sawProp)
            ClearPedTasks(playerPed)
            RemoveAnimDict(dict)
            TriggerServerEvent('elevatepoliti:server:useRambuk', closestDoor, itemData, false)
        else
            DeleteEntity(sawProp)
            ClearPedTasks(playerPed)
            RemoveAnimDict(dict)
            TriggerServerEvent('elevatepoliti:server:useRambuk', nil, itemData, true)
        end
    end
end)



CreateThread(function()
    exports['ox_target']:addGlobalPlayer({
        {
            icon = 'fa-solid fa-dna',
            label = 'Tjek fingeraftryk',
            groups = {'police'},
            onSelect = function(data)
                local fingerprint, msg = lib.callback.await("elevate-politi:server:checkfingerPrintName", false, GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
                if fingerprint then
                    lib.alertDialog({
                        header = 'Fingeraftryk Tjekker...',
                        content = 'Fingeraftryk: ' .. msg,
                        centered = true,
                        cancel = false
                    })
                else
                    lib.notify({
                        description = msg,
                        type = 'error',
                        duration = 5000,
                    })
                end
            end,
            distance = 1.5,
        },
    })
end)
