local GarageZones = {}
local Vehicles = {}

CreateThread(function()
    if not Config.Debug then return end

    Wait(5000)

    SendNUIMessage({
        init = true,
        NameResource = { GetCurrentResourceName(), GetCurrentServerEndpoint() },
    })
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer) -- Triggered when a player spawns
    Wait(5000)

    SendNUIMessage({
        init = true,
        NameResource = { GetCurrentResourceName(), GetCurrentServerEndpoint() },
    })
end)

function CreateBlips()
    for garageName, garageData in pairs(Config.Garages) do
        if garageData.showBlipOnMap then
            if garageData.vehicleType == 'car' then
                local center = find_center(garageData.Zone.Shape)
                local blip = AddBlipForCoord(center.x, center.y, garageData.Zone.minZ)
                SetBlipSprite(blip, 290)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 3)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Garage")
                EndTextCommandSetBlipName(blip)
            elseif garageData.vehicleType == 'boat' then
                local center = find_center(garageData.Zone.Shape)
                local blip = AddBlipForCoord(center.x, center.y, garageData.Zone.minZ)
                SetBlipSprite(blip, 290)
                SetBlipDisplay(blip, 2)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 6)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Båd Garage")
                EndTextCommandSetBlipName(blip)
            end
        end
    end
    for garageName, garageData in pairs(Config.Pounds) do
        if garageData.vehicleType == 'car' then
            local center = find_center(garageData.Zone.Shape)
            local blip = AddBlipForCoord(center.x, center.y, garageData.Zone.minZ)
            SetBlipSprite(blip, 67)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 0.5)
            SetBlipColour(blip, 47)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Impound")
            EndTextCommandSetBlipName(blip)
        end
    end
end

lib.addRadialItem({
    {
        id = 'garage_oversigt',
        label = 'Garage Oversigt',
        icon = 'warehouse',
        onSelect = function()
            OpenGarageOverview()
        end
    }
})

function CreateImpound(impound)
    local zone = lib.zones.poly({
        name = ('impound_%s'):format(tostring(impound)),
        points = Config.Pounds[impound].Zone.Shape,
        debugColour = vec4(51, 54, 92, 50.0),
        thickness = Config.Pounds[impound].Zone.maxZ - Config.Pounds[impound].Zone.minZ,
        debug = Config.Debug,
        inside = function()
            if IsControlJustReleased(0, 38) then
                OpenImpound(impound)
            end
        end,
        onEnter = function()
            lib.showTextUI('[E] Impound', { alignIcon = 'center', icon = 'fa-solid fa-car' })
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })
end

function CreatePublicGarage(garage)
    local isInVehicle = false
    local menuSent = false
    local category = Config.Garages[garage].vehicleType

    local zone = lib.zones.poly({
        name = ('garage_%s'):format((garage)),
        points = Config.Garages[garage].Zone.Shape,
        debugColour = vec4(51, 54, 92, 50.0),
        thickness = Config.Garages[garage].Zone.maxZ - Config.Garages[garage].Zone.minZ,
        debug = Config.Debug,
        inside = function()
            local playerPed = cache.ped
            local isInAnyVehicle = IsPedInAnyVehicle(playerPed, false)

            if IsControlJustReleased(0, 38) then
                if isInAnyVehicle then
                    ParkVehicle(GetVehiclePedIsIn(cache.ped, false), garage)
                elseif category == 'car' then
                    OpenGarage(garage)
                elseif category == 'boat' then
                    OpenBoatGarage(garage)
                end
            end
        end,
        onEnter = function()
            lib.showTextUI(('[E] %s'):format(Config.Garages[garage].label), { alignIcon = 'center', icon = 'fa-solid fa-car' })
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })

    GarageZones[#GarageZones + 1] = zone
end

function ParkVehicle(vehicle, garage)
    local vehicleInfo = Entity(vehicle).state.data
    if GetEntitySpeed(vehicle) >= 2.5 then lib.notify({ description = 'Hold stille!', type = 'error' }) return end
    if vehicleInfo ~= nil and vehicleInfo.rental then
        FreezeEntityPosition(vehicle, true)
        if lib.progressBar({
                duration = 1500,
                label = 'Parkere køretøj',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                },
            }) then
            FreezeEntityPosition(vehicle, false)
            ESX.Game.DeleteVehicle(vehicle)

            lib.notify({ description = 'Tak for at aflevere køretøjet tilbage!', type = 'success' })
        end
        return
    end
    ESX.TriggerServerCallback('elevate_garage:parkVehicle', function(cb)
        FreezeEntityPosition(vehicle, true)
        if cb then
            lib.notify({ description = 'Dit køretøj blev parkeret!', type = 'success' })
        else
            FreezeEntityPosition(vehicle, false)
            lib.notify({ description = 'Du ejer ikke dette køretøj!', type = 'error' })
        end
    end, ESX.Game.GetVehicleProperties(vehicle).plate, ESX.Game.GetVehicleProperties(vehicle), garage, NetworkGetNetworkIdFromEntity(vehicle))
end

RegisterNetEvent('elevate_garage:openGarage', function(garage)
    OpenGarage(garage, 'true')
end)

RegisterNetEvent('elevate_garage:parkVehicle', function(vehicle, garage)
    ParkVehicle(vehicle, garage)
end)

function OpenRental(garage)
    local options = {}

    if garage == 'boat_perico_garage' or garage == 'perico_garage_fly' then
        for i = 1, #Config.CarsForRentIsland do
            options[#options + 1] = {
                title = Config.CarsForRentIsland[i].model,
                icon = "car",
                iconColor = "lightblue",
                description = "Pris: " .. Config.CarsForRentIsland[i].price .. ",- DKK",
                onSelect = function()
                    RentVehicle(garage, Config.CarsForRentIsland[i].model, Config.CarsForRentIsland[i].price)
                end
            }
        end
    else
        for i = 1, #Config.CarsForRent do
            options[#options + 1] = {
                title = Config.CarsForRent[i].model,
                icon = "car",
                iconColor = "lightblue",
                description = "Pris: " .. Config.CarsForRent[i].price .. ",- DKK",
                onSelect = function()
                    RentVehicle(garage, Config.CarsForRent[i].model, Config.CarsForRent[i].price)
                end
            }
        end
    end

    lib.registerContext({
        id = 'udlej',
        title = 'Lej et køretøj',
        options = options
    })
    lib.showContext('udlej')
end

function RentVehicle(garage, model, pris)
    ESX.TriggerServerCallback('elevate_garage:rentMoney', function(harPenge)
        if not harPenge then
            lib.notify({ description = 'Du har ikke nok penge!', type = 'error' })
        else
            if lib.progressBar({
                    duration = 3000,
                    label = 'Finder køretøj',
                    useWhileDead = false,
                    canCancel = false,
                }) then
                local location = GetSpawnLocationAndHeading(garage, Config.Garages[garage].vehicleType, Config.Garages[garage].ParkingSpots, 'nil', 5.0)

                local vehicle, netId = exports['mani-bridge']:CreateVeh(location, model)

                SetVehicleNumberPlateText(vehicle, "UDLEJ" .. GetPlayerServerId(NetworkGetPlayerIndexFromPed(cache.ped)))
                exports['mani-keys']:GiveKey(vehicle, true)
                local state = Entity(vehicle).state
                state:set('vehLocked', false, true)
                state:set('fuel', 100, true)
                lib.notify({ title = 'Du har lejet et køretøj!', description = 'Du kan aflevere køretøjet tilbage i garagen!', type = 'success' })
                TriggerServerEvent('elevate_garage:addStatebag', NetworkGetNetworkIdFromEntity(vehicle), true)
                TriggerServerEvent('elevate_garage:addCustomSound', netId, GetVehicleNumberPlateText(vehicle))
                TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
            end
        end
    end, pris)
end

function OpenBoatGarage(garage)
    DrawBusySpinner("Henter køretøjsinformationer")
    menuAllVehs = {}

    ESX.TriggerServerCallback('elevate_garage:fetchfromboatgarage', function(vehicles)
        if #vehicles == 0 then
            lib.registerContext({
                id = 'garage_empty',
                title = 'Garage',
                options = {
                    {
                        title = 'Du har ingen køretøjer i denne garage!'
                    }
                }
            })
            lib.showContext('garage_empty')
            StopBusySpinner()
        end

        for k, v in pairs(vehicles) do
            menuAllVehs[#menuAllVehs + 1] = {
                title = GetLabelText(GetDisplayNameFromVehicleModel(v.model)),
                description = 'Nummerplade: ' .. v.plate,
                onSelect = function(args)
                    PullOutVehicle(v.plate, false, garage, true)
                end,
            }

            lib.registerContext({
                id = 'garage_overview',
                title = 'Garage',
                options = menuAllVehs
            })

            lib.showContext('garage_overview')
            StopBusySpinner()
        end
    end, garage)

    StopBusySpinner()
end

function OpenGarage(garage, isHouse)
    DrawBusySpinner("Henter køretøjsinformationer")
    menuAllVehs = {}

    if garage ~= "privatHus" then
        menuAllVehs[#menuAllVehs + 1] = {
            title = 'Lej Køretøj',
            description = 'Du kan leje et køretøj her',
            onSelect = function()
                OpenRental(garage)
            end,
        }
    end

    ESX.TriggerServerCallback('elevate_garage:fetchfromgarage', function(vehicles)
        if #vehicles == 0 then
            lib.registerContext({
                id = 'garage_empty',
                title = 'Garage',
                options = {
                    {
                        title = 'Du har ingen køretøjer i denne garage!',
                    }
                }
            })
            lib.showContext('garage_empty')
            StopBusySpinner()
        end

        for k, v in pairs(vehicles) do
            local vehicleData = json.decode(v.vehicle)
            local modelHash = vehicleData.model
            
            local displayName = GetLabelText(GetDisplayNameFromVehicleModel(modelHash))
            if displayName == 'NULL' then
                displayName = GetModelName(modelHash)
            end

            menuAllVehs[#menuAllVehs + 1] = {
                title = v.name or displayName,
                description = 'Nummerplade: ' .. v.plate,
                onSelect = function(args)
                    if isHouse then
                        PullOutVehicle(v.plate, true)
                    else
                        PullOutVehicle(v.plate, false, garage)
                    end
                end,
            }
        end

        lib.registerContext({
            id = 'garage_overview',
            title = 'Garage',
            options = menuAllVehs
        })

        lib.showContext('garage_overview')
        StopBusySpinner()
    end, garage)

    StopBusySpinner()
end

GetModelName = function(model)
    local modelMapping = {
        [2126083194] = "Pfister Neon CT",
    }

    local modelName = modelMapping[model]

    if modelName then
        return modelName
    else
        return "Ukendt Køretøj"
    end
end

function GetFreeParkingSpots(parkingSpots)
    local freeParkingSpots = {}
    for _, parkingSpot in ipairs(parkingSpots) do
        local veh, distance = ESX.Game.GetClosestVehicle(vector3(parkingSpot.x, parkingSpot.y, parkingSpot.z))
        if veh == -1 or distance >= 1.5 then
            freeParkingSpots[#freeParkingSpots + 1] = parkingSpot
        end
    end
    return freeParkingSpots
end

function GetFreeSingleParkingSpot(freeParkingSpots, vehicle)
    local checkAt = nil
    if Config.StoreParkinglotAccuratly and Config.SpawnAtLastParkinglot and vehicle and vehicle.parkingspot then
        checkAt = vector3(vehicle.parkingspot.x, vehicle.parkingspot.y, vehicle.parkingspot.z) or nil
    end
    local _, _, location = GetClosestLocation(freeParkingSpots, checkAt)
    return location
end

local function GetClosestLocation(locations, loc)
    local closestDistance = -1
    local closestIndex = -1
    local closestLocation = nil
    local plyCoords = loc or GetEntityCoords(cache.ped, 0)
    for i, v in ipairs(locations) do
        local location = vector3(v.x, v.y, v.z)
        local distance = #(plyCoords - location)
        if (closestDistance == -1 or closestDistance > distance) then
            closestDistance = distance
            closestIndex = i
            closestLocation = v
        end
    end
    return closestIndex, closestDistance, closestLocation
end

local function GetMainGarageForSubGarage(subGarage)
    for mainGarage, subGarages in pairs(Config.MainGarages) do
        for _, garage in ipairs(subGarages) do
            if garage == subGarage then
                return mainGarage
            end
        end
    end
    return subGarage 
end

local function IsSubGarage(garage)
    for _, subGarages in pairs(Config.MainGarages) do
        for _, subGarage in ipairs(subGarages) do
            if subGarage == garage then
                return true
            end
        end
    end
    return false
end
function GetSpawnLocationAndHeading(garage, garageType, parkingSpots, vehicle, spawnDistance)
    local location
    local heading
    local closestDistance = -1

    if garageType == "house" then
        location = garage.takeVehicle
        heading = garage.takeVehicle.w
    else
        if next(parkingSpots) then
            local freeParkingSpots = GetFreeParkingSpots(parkingSpots)
            if Config.AllowSpawningFromAnywhere then
                location = GetFreeSingleParkingSpot(freeParkingSpots, vehicle)
                if location == nil then
                    return
                end
                heading = location.w
            else
                _, closestDistance, location = GetClosestLocation(
                    Config.SpawnAtFreeParkingSpot and freeParkingSpots or parkingSpots)
                local plyCoords = GetEntityCoords(cache.ped, 0)
                local spot = vector3(location.x, location.y, location.z)
                if Config.SpawnAtLastParkinglot and vehicle and vehicle.parkingspot then
                    spot = vehicle.parkingspot
                end
                local dist = #(plyCoords - vector3(spot.x, spot.y, spot.z))
                if Config.SpawnAtLastParkinglot and dist >= spawnDistance then
                    lib.notify({
                        title = 'Der blev ikke fundet en ledig plads!',
                        type = 'error'
                    })
                    return
                elseif closestDistance >= spawnDistance then
                    lib.notify({
                        title = 'Der blev ikke fundet en ledig plads!',
                        type = 'error'
                    })
                    return
                else
                    local veh, distance = ESX.Game.GetClosestVehicle(vector3(location.x, location.y, location.z))
                    if veh ~= -1 and distance <= 1.5 then
                        lib.notify({
                            title = 'Køretøj i vejen',
                            type = 'error'
                        })
                        return
                    end
                    heading = location.w
                end
            end
        else
            local ped = GetEntityCoords(cache.ped)
            local pedheadin = GetEntityHeading(cache.ped)
            local forward = GetEntityForwardVector(cache.ped)
            local x, y, z = table.unpack(ped + forward * 3)
            location = vector3(x, y, z)
            if Config.VehicleHeading == 'forward' then
                heading = pedheadin
            elseif Config.VehicleHeading == 'driverside' then
                heading = pedheadin + 90
            elseif Config.VehicleHeading == 'hood' then
                heading = pedheadin + 180
            elseif Config.VehicleHeading == 'passengerside' then
                heading = pedheadin + 270
            end
        end
    end
    return vec4(location.xyz, heading)
end

function PullOutVehicle(plate, isHouse, PublicGarage, isboat)
    if isHouse then
        ESX.TriggerServerCallback('elevate_garage:pullOutVehicle', function(data)
            FreezeEntityPosition(cache.ped, true)
            if lib.progressBar({
                    duration = 1500,
                    label = 'Finder køretøj',
                    useWhileDead = false,
                    canCancel = false,
                }) then
                FreezeEntityPosition(cache.ped, false)
                
                local vehicleData = json.decode(data.vehicle)
                local modelHash = vehicleData.model
                
                local vehicle, netId = exports['mani-bridge']:CreateVeh(vec4(GetEntityCoords(cache.ped), GetEntityHeading(cache.ped)), modelHash, vehicleData)

                exports['mani-keys']:GiveKey(vehicle, true)
                local state = Entity(vehicle).state
                state:set('vehLocked', false, true)
                TriggerServerEvent('elevate_garage:addStatebag', netId, false)
                TriggerServerEvent('elevate_garage:addCustomSound', netId, GetVehicleNumberPlateText(vehicle))
                SetVehicleDirtLevel(vehicle, 0)
                TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
            end
        end, plate)
    end
    if PublicGarage then
        if isboat then
            local location = GetSpawnLocationAndHeading(PublicGarage, Config.Garages[PublicGarage].vehicleType, Config.Garages[PublicGarage].ParkingSpots, 'nil', 15.0)
            if location then
                ESX.TriggerServerCallback('elevate_garage:pullOutVehicle', function(data)
                    if lib.progressBar({
                            duration = 3000,
                            label = 'Finder køretøj',
                            anim = false,
                            useWhileDead = false,
                            canCancel = false,
                        }) then
                        local vehicleData = json.decode(data.vehicle)
                        local modelHash = vehicleData.model

                        local vehicle, netId = exports['mani-bridge']:CreateVeh(location, modelHash, vehicleData)

                        TriggerServerEvent('elevate_garage:addStatebag', netId, false)
                        exports['mani-keys']:GiveKey(vehicle, true)
                        local state = Entity(vehicle).state
                        TriggerServerEvent('elevate_garage:addCustomSound', netId, GetVehicleNumberPlateText(vehicle))
                        state:set('vehLocked', false, true)
                        TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
                    end
                end, plate)
            end
        else
            local location = GetSpawnLocationAndHeading(PublicGarage, Config.Garages[PublicGarage].vehicleType, Config.Garages[PublicGarage].ParkingSpots, 'nil', 5.0)
            if location then
                ESX.TriggerServerCallback('elevate_garage:pullOutVehicle', function(data)
                    if lib.progressBar({
                            duration = 3000,
                            label = 'Finder køretøj',
                            anim = false,
                            useWhileDead = false,
                            canCancel = false,
                        }) then
                        local vehicleData = json.decode(data.vehicle)
                        local modelHash = vehicleData.model

                        local vehicle, netId = exports['mani-bridge']:CreateVeh(location, modelHash, vehicleData)
                                                
                        TriggerServerEvent('elevate_garage:addStatebag', netId, false)
                        exports['mani-keys']:GiveKey(vehicle, true)
                        local state = Entity(vehicle).state
                        state:set('vehLocked', false, true)
                        TriggerServerEvent('elevate_garage:addCustomSound', netId, GetVehicleNumberPlateText(vehicle))
                        SetVehicleDirtLevel(vehicle, 0)

                        TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
                    end
                end, plate)
            end
        end
    end
end

local function PullOutCarImpound(plate, impound, model)
    local location = vec4(Config.Pounds[impound].SpawnPoint.xyz, Config.Pounds[impound].SpawnPoint.w)
    if ESX.Game.IsSpawnPointClear(location.xyz, 5) then
        if Config.BlockIfVehicleIsOnServer then
            local vehicles = ESX.Game.GetVehicles()

            for _, vehicle in ipairs(vehicles) do
                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                if vehicleProps and vehicleProps.plate == plate then
                    lib.notify({
                        description = 'Køretøjet er stadig ude!',
                        type = 'error'
                    })
                    return
                end
            end
        end
        ESX.TriggerServerCallback('elevate_garage:pullOutImpound', function(data)
            if not data then
                lib.notify({
                    description = 'Du har ikke nok penge!',
                    type = 'error'
                })
            else
                if lib.progressBar({
                        duration = 3000,
                        label = 'Finder køretøj',
                        useWhileDead = false,
                        canCancel = false,
                    }) then
                    local vehicleData = json.decode(data.vehicle)
                    local modelHash = vehicleData.model
                    
                    local vehicle, netId = exports['mani-bridge']:CreateVeh(location, modelHash, vehicleData)
      
                    SetVehicleDirtLevel(vehicle, 0)
                    TriggerServerEvent('elevate_garage:addStatebag', netId, false)
                    exports['mani-keys']:GiveKey(vehicle, true)
                    local state = Entity(vehicle).state
                    TriggerServerEvent('elevate_garage:addCustomSound', netId, plate)
                    state:set('vehLocked', false, true)
                end
            end
        end, plate, GetVehicleClassFromName(model))
    else
        lib.notify({
            description = 'Impounden er ikke ledig!',
            type = 'error'
        })
    end
end

local function PullOutBoatImpound(plate, impound, model)
    if Config.BlockIfVehicleIsOnServer then
        local vehicles = ESX.Game.GetVehicles()

        for _, vehicle in ipairs(vehicles) do
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            if vehicleProps and vehicleProps.plate == plate then
                lib.notify({
                    description = 'Køretøjet er stadig ude!',
                    type = 'error'
                })
                return
            end
        end
    end
    local location = GetSpawnLocationAndHeading(impound, Config.Garages[impound].vehicleType, Config.Garages[impound].ParkingSpots, 'nil', 15.0)
    if location then
        ESX.TriggerServerCallback('elevate_garage:pullOutImpound', function(data)
            if not data then
                lib.notify({
                    description = 'Du har ikke nok penge!',
                    type = 'error'
                })
            else
                if lib.progressBar({
                        duration = 3000,
                        label = 'Finder køretøj',
                        useWhileDead = false,
                        canCancel = false,
                    }) then
                    local vehicleData = json.decode(data.vehicle)
                    local modelHash = vehicleData.model

                    local vehicle, netId = exports['mani-bridge']:CreateVeh(location, modelHash, vehicleData)
                                          
                    exports['mani-keys']:GiveKey(vehicle, true)
                    local state = Entity(vehicle).state
                    state:set('vehLocked', false, true)
                    TriggerServerEvent('elevate_garage:addStatebag', netId, false, GetVehicleNumberPlateText(vehicle))
                end
            end
        end, plate, GetVehicleClassFromName(model))
    end
end

function OpenImpound(impound, isBoat)
    DrawBusySpinner("Henter køretøjsinformationer")
    menuAllVehs = {}

    if isBoat then
        ESX.TriggerServerCallback('elevate_garage:fetchfromBoatimpound', function(vehicles)
            if #vehicles == 0 then
                lib.registerContext({
                    id = 'garage_empty',
                    title = 'Garage',
                    options = {
                        {
                            title = 'Du har ingen køretøjer i impound!'
                        }
                    }
                })

                lib.showContext('garage_empty')
                StopBusySpinner()
            end

            for k, v in pairs(vehicles) do
                local vehicleData = json.decode(v.vehicle)
                local modelHash = vehicleData.model
                
                menuAllVehs[#menuAllVehs + 1] = {
                    title = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                    description = 'Nummerplade ' .. v.plate,
                    onSelect = function(args)
                        PullOutBoatImpound(v.plate, impound, modelHash)
                    end,
                }

                lib.registerContext({
                    id = 'garage_overview',
                    title = 'Garage',
                    options = menuAllVehs
                })

                lib.showContext('garage_overview')
                StopBusySpinner()
            end
        end)
    else
        ESX.TriggerServerCallback('elevate_garage:fetchfromimpound', function(vehicles)
            if #vehicles == 0 then
                lib.registerContext({
                    id = 'garage_empty',
                    title = 'Garage',
                    options = {
                        {
                            title = 'Du har ingen køretøjer i impound!'
                        }
                    }
                })

                lib.showContext('garage_empty')
                StopBusySpinner()
            end

            for k, v in pairs(vehicles) do
                local vehicleData = json.decode(v.vehicle)
                local modelHash = vehicleData.model
                
                menuAllVehs[#menuAllVehs + 1] = {
                    title = GetLabelText(GetDisplayNameFromVehicleModel(modelHash)),
                    description = 'Nummerplade ' .. v.plate,
                    onSelect = function(args)
                        PullOutCarImpound(v.plate, impound, modelHash)
                    end,
                }

                lib.registerContext({
                    id = 'garage_overview',
                    title = 'Garage',
                    options = menuAllVehs
                })

                lib.showContext('garage_overview')
                StopBusySpinner()
            end
        end)
    end
    
    StopBusySpinner()
end

RegisterNetEvent('elevate_garage:getArea', function(coords)
    local publicgarage = Config.Garages[v.area]
    if publicgarage and v.parked == 1 then
        local street = GetStreetNameAtCoord(publicgarage.Zone.Shape[1].x, publicgarage.Zone.Shape[1].y, publicgarage.Zone.minZ)
        return data.status == 'Parkeret i ' .. GetStreetNameFromHashKey(street)
    else
        local street = GetStreetNameAtCoord(v.area)
        return data.status == 'Parkeret i ' .. GetStreetNameFromHashKey(street)
    end
end)

function OpenGarageOverview()
    local allVehs = {}
    DrawBusySpinner("Henter køretøjsinformationer")

    ESX.TriggerServerCallback('elevate_garage:fetchAllVehicles', function(vehicles)
        for k, v in pairs(vehicles) do
            local vehicleData = json.decode(v.vehicle)
            local modelHash = vehicleData.model
            
            local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(modelHash))
            if vehicleLabel == 'NULL' then
                vehicleLabel = GetModelName(modelHash)
            end

            local data = {
                id = v.plate,
                plate = v.plate,
                model = vehicleLabel,
                name = v.name or vehicleLabel,
                status = (v.parked == 1) and "available" or "impounded",
                parked = v.parked == 1,
                stored = v.area,
                garage = v.area,
                durability = math.floor((vehicleData.engineHealth or 1000) / 10),
                vehicle = {
                    engineHealth = vehicleData.engineHealth or 1000,
                    bodyHealth = vehicleData.bodyHealth or 1000,
                    tankHealth = 1000,
                    fuelLevel = vehicleData.fuelLevel or 100
                },
                vehicleInfo = { 
                    Turbo = (vehicleData.modTurbo and vehicleData.modTurbo == 1) and 'Ja' or 'Nej', 
                    Motor = 'Tier: ' .. ((vehicleData.modEngine and vehicleData.modEngine >= 0) and vehicleData.modEngine or 1), 
                    Bremser = 'Tier: ' .. ((vehicleData.modBrakes and vehicleData.modBrakes >= 0) and vehicleData.modBrakes or 1) 
                }
            }

            if v.area == 'Global Garage' then
                data.status = 'available'
                data.garage = 'Global Garage'
            elseif Config.Garages[v.area] and v.parked == 1 then
                data.status = 'available'
                local garageLabel = Config.Garages[v.area].label or GetStreetNameFromHashKey(GetStreetNameAtCoord(Config.Garages[v.area].Zone.Shape[1].x, Config.Garages[v.area].Zone.Shape[1].y, Config.Garages[v.area].Zone.minZ))
                data.garage = garageLabel
            else
                if v.parked == 0 then
                    data.status = 'impounded'
                else
                    data.status = 'out'
                end
            end

            table.insert(allVehs, data)
        end

        table.sort(allVehs, function(a, b) return a.plate < b.plate end)
        StopBusySpinner()
        SetNuiFocus(true, true)
        SendNUIMessage({
            showUI = true,
            vehicles = allVehs,
        })
    end)

    StopBusySpinner()
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end

StopBusySpinner = function()
    RemoveLoadingPrompt()
end

Citizen.CreateThread(function()
    CreateBlips()
    CreateCarWashZones()
    for garageName, garage in pairs(Config.Garages) do
        CreatePublicGarage(garageName)
    end
    for Impound, garage in pairs(Config.Pounds) do
        CreateImpound(Impound)
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('SetGPS', function(data, cb)
    local plate = data.plate
    TriggerServerEvent('elevate_garage:SetGPS', plate)
    cb({success = true})
end)

RegisterNUICallback('renameVehicle', function(data, cb)
    local plate = data.plate
    local newName = data.newName
    
    if plate and newName then
        TriggerServerEvent('elevate_garage:renameVehicle', plate, newName)
    end
    
    cb({success = true})
end)

RegisterNUICallback('takeOutVehicle', function(data, cb)
    local plate = data.plate
    TriggerServerEvent('elevate_garage:takeOutVehicle', plate)
    cb({success = true})
end)

RegisterNetEvent('elevate_garage:SetGPS_C')
AddEventHandler('elevate_garage:SetGPS_C', function(coords)
    SetNewWaypoint(coords.x, coords.y)
    lib.notify({
        title = 'GPS',
        description = 'GPS indstillet til køretøj',
        type = 'success'
    })
end)

function CreateCarWashZones()
    for washName, washData in pairs(Config.CarWash) do
        local zone = lib.zones.sphere({
            coords = washData.xyz,
            radius = 3,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    WashVehicle(500)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] - Vask Køretøjet (500,- DKK)')
            end,
            onExit = function()
                if lib.isTextUIOpen() then
                    lib.hideTextUI()
                end
            end,
        })
    end
end

function WashVehicle(price)
    local playerPed = cache.ped
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        lib.notify({
            description = 'Du er ikke i et køretøj!',
            type = 'error'
        })
        return
    end

    ESX.TriggerServerCallback('elevate_carwash:payForWash', function(success)
        if success then
            if lib.progressBar({
                    duration = 5000,
                    label = 'Vasker køretøj...',
                    useWhileDead = false,
                    canCancel = false,
                    disable = {
                        car = true,
                        move = true,
                    },
                }) then
                SetVehicleDirtLevel(vehicle, 0.0)
                lib.notify({
                    description = 'Dit køretøj er nu rent!',
                    type = 'success'
                })
            end
        else
            lib.notify({
                description = 'Du har ikke nok penge!',
                type = 'error'
            })
        end
    end, price)
end
