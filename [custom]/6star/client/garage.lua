local poly = {}
local allBlips = {}
local function SpawnCar(location, model, index, parkingSpot)
    local vehicle = exports['mani-bridge']:CreateVeh(location.parkingSpots[parkingSpot], model, { 
        livery = 0, 
        fuel = 100,
        color1 = 0,
        color2 = 0, 
        pearlescentColor = 0
    })

    -- lidt ren røv
    SetVehicleDirtLevel(vehicle, 0.0)

    -- Sætter tuning til max efter spawn
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 11, 3, false) -- Engine
    SetVehicleMod(vehicle, 12, 3, false) -- Brakes
    SetVehicleMod(vehicle, 13, 3, false) -- Transmission
    SetVehicleMod(vehicle, 15, 3, false) -- Suspension
    SetVehicleMod(vehicle, 16, 3, false) -- Armor
    ToggleVehicleMod(vehicle, 18, true) -- Turbo
    -- SetVehicleMod(vehicle, 0, Config.garageTypes[location.garageType][index].spoiler, false) -- Spoiler
    -- SetVehicleMod(vehicle, 1, 3, false) -- Front Bumper
    -- SetVehicleMod(vehicle, 2, 3, false) -- Rear Bumper
    -- SetVehicleMod(vehicle, 3, 3, false) -- Side Skirt
    -- SetVehicleMod(vehicle, 4, 3, false) -- Exhaust
    -- SetVehicleMod(vehicle, 5, 3, false) -- Frame
    -- SetVehicleMod(vehicle, 6, 3, false) -- Grille
    -- SetVehicleMod(vehicle, 7, 3, false) -- Hood
    -- SetVehicleMod(vehicle, 8, 3, false) -- Fender
    -- SetVehicleMod(vehicle, 9, 3, false) -- Right Fender
    -- SetVehicleMod(vehicle, 10, 3, false) -- Roof

    -- Sætter hjulfarve til sort
    SetVehicleExtraColours(vehicle, 0, 0) 

    local plate = GetVehicleNumberPlateText(vehicle)

    exports['mani-keys']:SetJobKey(vehicle, '6str')

    for i = 1, 9 do
        SetVehicleExtra(vehicle, i, Config.garageTypes[location.garageType][index].extras[tostring(i)] == true and 0 or 1)
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

local function Open6strGarageMenu(location)
    local elements = {}
    
    -- Opret kategori for bilmærker
    for manufacturer, vehicles in pairs(Config.garageTypes[location.garageType]) do
        local vehicleOptions = {}
        
        -- Tilføj "Tilbage" knap først i hver submenu
        table.insert(vehicleOptions, {
            title = 'Tilbage',
            icon = 'arrow-left',
            menu = '6str_garage'
        })
        
        -- Tilføjet køretøjer til kategori
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            table.insert(vehicleOptions, {
                title = vehicle.label,
                icon = 'check',
                disabled = checkGrade(vehicle.minGrade),
                onSelect = function()
                    local parkingSpotKey = GetClosestParkingSpot(location.parkingSpots)
                    local isVehicleNearby = IsAnyVehicleNearPoint(location.parkingSpots[parkingSpotKey].x, location.parkingSpots[parkingSpotKey].y, location.parkingSpots[parkingSpotKey].z, 5.0)
                    if isVehicleNearby then return lib.notify({title = "Du kan ikke spawne et køretøj her.", type = "error"}) end
                    SpawnCar(location, vehicle.model, i, parkingSpotKey)
                end
            })
        end
        
        -- Opret submenu for hver bilmærke
        lib.registerContext({
            id = '6str_garage_' .. manufacturer:lower(),
            title = manufacturer,
            options = vehicleOptions
        })
        
        -- Tilføjet kategori til menuen
        table.insert(elements, {
            title = manufacturer,
            icon = 'car',
            menu = '6str_garage_' .. manufacturer:lower()
        })
    end

    lib.registerContext({
        id = '6str_garage',
        title = '6str Garage',
        options = elements
    })
    lib.showContext('6str_garage')
end

local function CreateGarageZones()
    for k, v in pairs(Config["6strGarage"]) do
        local location = v

        poly[k] = lib.zones.poly({
            points = location.parkVehicleZone,
            onEnter = function()
                lib.showTextUI('6str Garage', { alignIcon = 'center', icon = 'car' })
                lib.addRadialItem({
                    id = '6str_garage',
                    icon = 'car',
                    label = 'Åben/Parker',
                    onSelect = function()
                        if cache.vehicle then
                            SetEntityAsMissionEntity(cache.vehicle)
                            SetEntityAsNoLongerNeeded(cache.vehicle)
                            DeleteEntity(cache.vehicle)
                        else
                            Open6strGarageMenu(location)
                        end
                    end,
                })
            end,
            onExit = function()
                lib.hideTextUI()
                lib.removeRadialItem('6str_garage')
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

-- Add initial job check when resource starts
CreateThread(function()
    local xPlayer = ESX.GetPlayerData()
    if xPlayer.job.name == '6str' then
        CreateGarageZones()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    if xPlayer.job.name == '6str' then
        CreateGarageZones()
    end
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)
    if (job.name == '6str') and (lastJob.name ~= "6str") then
        CreateGarageZones()
    elseif (job.name ~= "6str") and (lastJob.name == "6str") then
        lib.removeRadialItem('6str_garage')
        for k, v in pairs(poly) do
            v:remove()
        end
        for k, v in pairs(allBlips) do
            RemoveBlip(v)
        end
    end
end)