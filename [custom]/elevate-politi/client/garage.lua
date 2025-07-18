local poly = {}
local allBlips = {}
local function SpawnCar(location, model, index, parkingSpot)
    local vehicle = exports['mani-bridge']:CreateVeh(location.parkingSpots[parkingSpot], model, { livery = 0, fuel = 100 })

    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent("elevate-politi:server:addItem", plate)
    local state = Entity(vehicle).state
    exports['mani-keys']:SetJobKey(vehicle, 'police')
    state:set('vehLocked', false, true)
    state:set('fuel', 100, true)

    for i = 1, 9 do
        SetVehicleExtra(vehicle, i, Config.garageTypes[location.garageType][index].extras[tostring(i)] == true and 0 or 1)
    end

    local playerCoords = GetEntityCoords(cache.ped)
    local parkingSpotCoords = location.parkingSpots[parkingSpot]
    if #(playerCoords.xy - parkingSpotCoords.xy) < 2.0 then
        TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
    end

    return vehicle
end

local function checkGrade(minGrade)
    local xPlayer = ESX.GetPlayerData()
    local playerGrade = xPlayer.job.grade
    return not (playerGrade >= minGrade)
end

local function GetClosestParkingSpot(parkVehicleZone)
    local closestParkingSpot = nil
    local closestDistance = math.huge
    for i = 1, #parkVehicleZone do
        local parkingSpot = parkVehicleZone[i]
        local distance = #(GetEntityCoords(cache.ped) - parkingSpot.xyz)
        if distance < closestDistance then
            closestDistance = distance
            closestParkingSpot = i
        end
    end
    return closestParkingSpot
end

local function OpenPoliceGarageMenu(location)
    local elements = {}
    for i = 1, #Config.garageTypes[location.garageType] do
        local vehicle = Config.garageTypes[location.garageType][i]
        table.insert(elements, {
            title = vehicle.label,
            icon = 'check',
            disabled = checkGrade(vehicle.minGrade),
            onSelect = function()
                local parkingSpotKey = GetClosestParkingSpot(location.parkingSpots)
                local isVehicleNearby = IsAnyVehicleNearPoint(location.parkingSpots[parkingSpotKey].x, location.parkingSpots[parkingSpotKey].y, location.parkingSpots[parkingSpotKey].z, 1.5)
                if isVehicleNearby then return lib.notify({title = "Du kan ikke spawne et køretøj her.", type = "error"}) end
                SpawnCar(location, vehicle.model, i, parkingSpotKey)
            end
        })
    end
    lib.registerContext({
        id = 'politi_garage',
        title = 'Politi Garage',
        options = elements
    })
    lib.showContext('politi_garage')
end

local function CreateGarageZones()
    for k, v in pairs(Config.policeGarage) do
        local location = v

        poly[k] = lib.zones.poly({
            points = location.parkVehicleZone,
            onEnter = function()
                lib.showTextUI('Politi Garage', { alignIcon = 'center', icon = 'car' })
                lib.addRadialItem({
                    id = 'politi_garage',
                    icon = 'car',
                    label = 'Åben/Parker',
                    onSelect = function()
                        if cache.vehicle then
                            SetEntityAsMissionEntity(cache.vehicle)
                            SetEntityAsNoLongerNeeded(cache.vehicle)
                            DeleteEntity(cache.vehicle)
                            TriggerServerEvent("elevate_police:removePatrolId")
                        else
                            OpenPoliceGarageMenu(location)
                        end
                    end,
                })
            end,
            onExit = function()
                lib.hideTextUI()
                lib.removeRadialItem('politi_garage')
            end,
            debug = false,
            thickness = 4,
        })
        if location.blip then
            allBlips[k] = AddBlipForCoord(location.blip.coords.x, location.blip.coords.y, location.blip.coords.z)
            SetBlipSprite(allBlips[k], location.blip.sprite)
            SetBlipDisplay(allBlips[k], 4)
            SetBlipScale(allBlips[k], location.blip.scale)
            SetBlipColour(allBlips[k], location.blip.color)
            SetBlipAsShortRange(allBlips[k], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(location.label)
            EndTextCommandSetBlipName(allBlips[k])
            SetBlipAlpha(allBlips[k], 255)
        end
    end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    if xPlayer.job.name == 'police' then
        CreateGarageZones()
    end
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)
    if (job.name == 'police') and (lastJob.name ~= "police") then
        CreateGarageZones()
    elseif (job.name ~= "police") and (lastJob.name == "police") then
        lib.removeRadialItem('politi_garage')
        for k, v in pairs(poly) do
            v:remove()
        end
        for k, v in pairs(allBlips) do
            RemoveBlip(v)
        end
    end
end)