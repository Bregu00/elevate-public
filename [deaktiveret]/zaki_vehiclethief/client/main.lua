ESX = exports["es_extended"]:getSharedObject()

-- UI Variables
local display = false
local CurrentWarehouse = nil

-- Original Variables
local hackingTimes = 0
local canDeliver = false
local isSelling = false
local spawnedProps = {}
local HasMission = nil
local isSpawnedVehicle = nil
local spawnedVehicle = nil
local vehiclehack = nil
local carID = nil
local carBlip = nil
local lastWarehouseBlip = nil
local policeBlip = nil
local LocationBlip = nil
local shownLocationBlip = nil
local CurrentHackingTime = 0
local CurrentVehicleHacking = 0
local hasCarjack = nil
local hasCalledPolice = false

-- UI Functions
function OpenUI(warehouseId)
    if display then return end
    
    display = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open"
    })
    
    -- Get data from server and update UI
    RefreshUIData(warehouseId)
end

function CloseUI()
    if not display then return end
    
    display = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "close"
    })
end

function RefreshUIData(warehouseId)
    -- Get player data
    lib.callback('fh_vehiclethief:laptop', false, function(data)
        if not data then
            print("Error: No data received from fh_vehiclethief:laptop callback")
            return
        end
        
        local level = determineLevelByExp(data.exp)
        local levelData = GetLevelDataByExp(data.exp)
        
        -- Get available vehicles
        lib.callback('elevate_vehiclethief:getItemBatch', false, function(globalItemBatch, playerExp)
            if not globalItemBatch then
                print("Error: No data received from elevate_vehiclethief:getItemBatch callback")
                return
            end
            
            -- Get warehouse vehicles
            lib.callback('fh_vehiclethief:getWarehouseData', false, function(warehouseData)
                if not warehouseData then
                    print("Error: No data received from fh_vehiclethief:getWarehouseData callback")
                    return
                end
                
                -- Calculate refresh time
                local timeUntilRefresh = GlobalState.RefreshTime + Config.VehiclesRefresh - data.CurrentTime
                local minutesUntilRefresh = math.floor(timeUntilRefresh / 60)
                local secondsUntilRefresh = timeUntilRefresh % 60
                local refreshTimeStr = string.format("%02d:%02d %02d:%02d", 
                    math.floor(minutesUntilRefresh / 60), 
                    minutesUntilRefresh % 60,
                    math.floor(secondsUntilRefresh / 60),
                    secondsUntilRefresh % 60)
                
                -- Format public vehicles
                local publicVehicles = {}
                for i, item in ipairs(globalItemBatch) do
                    local canBuy = playerExp >= item.requiredexp and not HasMission
                    
                    table.insert(publicVehicles, {
                        id = item.id,
                        name = GetVehicleDisplayName(item.id),
                        image = GetVehicleImage(item.id),
                        deposit = ESX.Math.GroupDigits(item.buyPrice) .. " kr.",
                        sellPrice = ESX.Math.GroupDigits(item.sellPrice) .. " kr.",
                        remaining = ESX.Math.GroupDigits(item.sellPrice - item.buyPrice) .. " kr.",
                        driverExp = item.requiredexp .. " EXP",
                        expreward = item.expreward .. " EXP",
                        canBuy = canBuy,
                        requiredExp = item.requiredexp,
                        playerExp = playerExp
                    })
                end
                
                -- Format user vehicles
                local userVehicles = {}
                for i, box in ipairs(warehouseData) do
                    local canSell = box.carid.time - data.CurrentTime < 0
                    local timeLeft = ""
                    
                    if not canSell then
                        local remainingTime = box.carid.time - data.CurrentTime
                        local hours = math.floor(remainingTime / 3600)
                        local minutes = math.floor((remainingTime % 3600) / 60)
                        local seconds = remainingTime % 60
                        timeLeft = string.format("%d timer %d min. & %d sek.", hours, minutes, seconds)
                    end
                    
                    table.insert(userVehicles, {
                        id = box.carid.boxId,
                        name = GetVehicleDisplayName(box.carid.value),
                        image = GetVehicleImage(box.carid.value),
                        sellPrice = Config.StorageVehicles[box.carid.value].sellPrice .. " kr.",
                        status = canSell and "Klar til afsending!" or "Venter...",
                        canSell = canSell,
                        timeLeft = not canSell and timeLeft or nil
                    })
                end
                
                -- Send data to NUI
                SendNUIMessage({
                    type = "update",
                    level = {
                        label = level,
                        current = data.exp,
                        max = levelData.nextLevelExp or data.exp,
                        percentage = levelData.percentage or 100
                    },
                    refreshTime = refreshTimeStr,
                    vehicleCount = data.count .. "/" .. Config.MaxVehiclesPerUser,
                    publicVehicles = publicVehicles,
                    userVehicles = userVehicles
                })
            end, warehouseId)
        end)
    end, warehouseId)
end

-- Helper function to get vehicle display name
function GetVehicleDisplayName(vehicleModel)
    local displayName = GetLabelText(vehicleModel)
    if displayName == "NULL" then
        displayName = GetDisplayNameFromVehicleModel(GetHashKey(vehicleModel))
        displayName = GetLabelText(displayName)
        if displayName == "NULL" then
            return vehicleModel:upper()
        end
    end
    return displayName
end

function GetVehicleImage(vehicleModel)
    local defaultImage = "ui/images/default.jpg"
    local vehicleImage = "https://docs.fivem.net/vehicles/"..vehicleModel..".webp"

    return vehicleImage
end

function GetLevelDataByExp(exp)
    local currentLevel = 1
    local nextLevelExp = 0
    local percentage = 0
    
    for level, data in pairs(Config.LevelManagement) do
        if exp >= data.requiredEXPAmount then
            currentLevel = level
            
            if level < #Config.LevelManagement then
                nextLevelExp = Config.LevelManagement[level + 1].requiredEXPAmount
                local currentLevelExp = data.requiredEXPAmount
                local expRange = nextLevelExp - currentLevelExp
                local playerProgress = exp - currentLevelExp
                percentage = math.min(math.floor((playerProgress / expRange) * 100), 100)
            else
                percentage = 100
                nextLevelExp = exp
            end
        end
    end
    
    return {
        level = currentLevel,
        nextLevelExp = nextLevelExp,
        percentage = percentage
    }
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('buyVehicle', function(data, cb)
    local vehicleId = data.vehicleId
    
    -- Find the vehicle in the global batch
    lib.callback('elevate_vehiclethief:getItemBatch', false, function(globalItemBatch, playerExp)
        for i, item in ipairs(globalItemBatch) do
            if item.id == vehicleId then
                if not HasMission then
                    lib.callback('elevate_vehiclethief:purchaseCar', false, function(result)
                        
                        if result[1] == false then
                            lib.notify({
                                title = 'Fejl',
                                description = result[2] or 'Du har ikke nok penge på dig! Du kan betale med sorte eller hvide kontanter!',
                                type = 'error',
                                duration = 10000,
                            })
                        else
                            HasMission = true
                            CloseUI()
                            SpawnCar(item, CurrentWarehouse)
                        end
                    end, item, item.buyPrice)
                else
                    lib.notify({
                        title = 'Fejl',
                        description = 'Du er allerede i gang med en bil!',
                        type = 'error'
                    })
                end
                break
            end
        end
    end)
    
    cb('ok')
end)

RegisterNUICallback('sellVehicle', function(data, cb)
    local boxId = tonumber(data.vehicleId)
    lib.callback('fh_vehiclethief:getWarehouseData', false, function(warehouseData)
        -- print(json.encode(warehouseData))
        for i, box in ipairs(warehouseData) do
            local boxId = tonumber(data.vehicleId)
            if tonumber(box.carid.boxId) == boxId then
                if not HasMission then
                    TriggerServerEvent('elevate_vehiclethief:sellCar', CurrentWarehouse, box.carid.value, boxId)
                    CloseUI()
                else
                    lib.notify({
                        title = 'Fejl',
                        description = 'Du er allerede i gang med en kasse!',
                        type = 'error'
                    })
                end
                break
            end
        end
    end, CurrentWarehouse)
    
    cb('ok')
end)

RegisterNUICallback('refreshData', function(data, cb)
    RefreshUIData(CurrentWarehouse)
    cb('ok')
end)

-- Original Functions
function DeleteSpawnedProps()
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    spawnedProps = {}
end

function SpawnVehiclesAtStorage(warehouseID)
    local warehouse = Config.VehicleStorageInteractions[warehouseID]
    if not warehouse then
        return
    end

    local storageLocation = warehouse.storageLocation
    for _, offset in ipairs(Config.StorageOffsets) do
        if math.random() <= 0.5 then
            local spawnPos = vector3(
                storageLocation.x + offset.x,
                storageLocation.y + offset.y,
                storageLocation.z + offset.z
            )
            local heading = offset.w

            local vehicles = {}
            for k, v in pairs(Config.StorageVehicles) do
                table.insert(vehicles, v)
            end

            local randomIndex = math.random(1, #vehicles)
            local randomVehicle = vehicles[randomIndex]

            local model = GetHashKey(randomVehicle.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1)
            end

            local vehicleProp = CreateObject(model, spawnPos.x, spawnPos.y, spawnPos.z, false, false, false)
            SetEntityHeading(vehicleProp, heading)
            SetModelAsNoLongerNeeded(model)

            FreezeEntityPosition(vehicleProp, true)
            SetEntityInvincible(vehicleProp, true)

            table.insert(spawnedProps, vehicleProp)
        end
    end
end

function SpawnVehiclesAtAllWarehouses()
    for warehouseID, _ in pairs(Config.VehicleStorageInteractions) do
        SpawnVehiclesAtStorage(warehouseID)
    end
end

WarehouseTeleport = function(coords)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z-1, false, false, true)
    SetEntityHeading(PlayerPedId(), coords.w)
    Wait(500)
    DoScreenFadeIn(1000)
end

function determineLevelByExp(exp)
    local levelLabel = "BEGYNDER"
    for level, data in pairs(Config.LevelManagement) do
        if exp >= data.requiredEXPAmount then
            if level == #Config.LevelManagement or exp < Config.LevelManagement[level + 1].requiredEXPAmount then
                levelLabel = data.label
                break
            end
        end
    end
    return levelLabel
end

-- Replace the original OpenComputer function
OpenComputer = function(Warehouses)
    CurrentWarehouse = Warehouses
    OpenUI(Warehouses)
end

SpawnCar = function(item, Warehouses)
    local randomIndex = math.random(#Config.CarSpawns)
    local selectedSpawn = Config.CarSpawns[randomIndex]

    RandomSpawn = GetRandomRoadPositionInRadius(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, 150)
    local distance = calculateDistance(selectedSpawn, RandomSpawn)

    if distance > 150 then
        RandomSpawn = selectedSpawn
    end
    
    lib.notify({
        title = 'Info',
        description = 'Find køretøjet og stjæl det.',
        type = 'inform',
    })

    DrawBusySpinner('Find den markerede ' .. GetLabelText(item.id) .. ' og stjæl den')

    CarSpawn = AddBlipForCoord(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z)
    SetBlipSprite(CarSpawn, 523)
    SetBlipColour(CarSpawn, 1)
    SetBlipDisplay(CarSpawn, 2)
    SetBlipScale(CarSpawn, 1.0)
    SetBlipAsShortRange(CarSpawn, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Markeret Køretøj')
    EndTextCommandSetBlipName(CarSpawn)
    SetBlipRoute(CarSpawn, true)
    
    hasCarjack = true
    hackingTimes = 0
    canDeliver = not item.hasPoliceGPS  -- Set initial delivery state based on GPS
    deliverySetup = false
    
    while hasCarjack do
        Citizen.Wait(1500)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local carDelivery = vector3(RandomSpawn.x, RandomSpawn.y, RandomSpawn.z)
        local distance = #(playerCoords - carDelivery)

        if distance <= 300 then
            RemoveBlip(CarSpawn)

            if not shownLocationBlip then
                shownLocationBlip = true
                LocationBlip = AddBlipForRadius(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z, 300.0)
                SetBlipSprite(LocationBlip, 9)
                SetBlipColour(LocationBlip, 1)
                SetBlipAlpha(LocationBlip, 75)
            end

            if distance <= 150 then
                RemoveBlip(LocationBlip)

                if not isSpawnedVehicle then
                    isSpawnedVehicle = true
                    ESX.Game.SpawnVehicle(item.id, vector3(RandomSpawn.x, RandomSpawn.y, RandomSpawn.z), 90, function(vehicle)
                        while not DoesEntityExist(vehicle) do 
                            Wait(200) 
                        end
                        SetVehicleDoorsLocked(vehicle, 1)

                        local state = Entity(vehicle).state
                        state:set('vehLocked', false, true)

                        SetEntityCoordsNoOffset(vehicle, RandomSpawn)
                        SetVehicleOnGroundProperly(vehicle)
                        SetVehicleEngineOn(vehicle, true, false, false)
                        Entity(vehicle).state.fuel = 100

                        local hash = GetHashKey("a_m_m_mexlabor_01")
                        local pedSpawn = vector3(RandomSpawn.x+1.0, RandomSpawn.y, RandomSpawn.z)
                        SpawnPed(hash, pedSpawn, 90.0, 8, function(spawnPed)
                            SetPedIntoVehicle(spawnPed, vehicle, -1)

                            local speed = 25.0
                            local drivingStyle = 447

                            SetDriverAbility(spawnPed, 1.0)
                            SetDriverAggressiveness(spawnPed, 0.0)
                            TaskVehicleDriveWander(spawnPed, vehicle, speed, drivingStyle)
                        end)

                        carBlip = AddBlipForEntity(vehicle)
                        SetBlipSprite(carBlip, 523)
                        SetBlipColour(carBlip, 1)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('Markeret Køretøj')
                        EndTextCommandSetBlipName(carBlip)

                        spawnedVehicle = vehicle
                    end)
                end
            end
        end

        if IsPedInVehicle(PlayerPedId(), spawnedVehicle, false) and not deliverySetup then
            deliverySetup = true
            Wait(2000)
            StopBusySpinner()
            RemoveBlip(carBlip)
            
            lib.notify({
                title = 'Info',
                description = 'Aflevere bilen på en af lagerhusene. Jeg har afmærket sidste lagerhus for dig.',
                type = 'inform'
            })

            local warehouseConfig = Config.VehicleStorageInteractions[Warehouses]
            local lastWarehouse = warehouseConfig.deliveryLocation                    

            lastWarehouseBlip = AddBlipForCoord(lastWarehouse.x, lastWarehouse.y, lastWarehouse.z)
            SetBlipSprite(lastWarehouseBlip, 524)
            SetBlipColour(lastWarehouseBlip, 2)
            SetBlipDisplay(lastWarehouseBlip, 2)
            SetBlipScale(lastWarehouseBlip, 1.0)
            SetBlipAsShortRange(lastWarehouseBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Varehus')
            EndTextCommandSetBlipName(lastWarehouseBlip)
            SetBlipRoute(lastWarehouseBlip, true)

            -- Create delivery target (only once)
            carID = exports.ox_target:addModel(GetEntityModel(spawnedVehicle), {
                icon = "fa-solid fa-car",
                label = "Aflevere bilen",
                distance = 2.0,
                canInteract = function()
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    local nearestDistance = math.huge

                    for warehouseId, warehouse in pairs(Config.VehicleStorageInteractions) do
                        local deliveryLocation = warehouse.deliveryLocation
                        local dx = playerCoords.x - deliveryLocation.x
                        local dy = playerCoords.y - deliveryLocation.y
                        local dz = playerCoords.z - deliveryLocation.z
                        local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestWarehouseId = warehouseId
                        end
                    end

                    -- IMPORTANT: Simplified condition - only check distance and canDeliver
                    -- Remove the "not vehiclehack" check that was causing the issue
                    return nearestDistance < 5 and canDeliver and not isSelling
                end,
                onSelect = function(data)
                    lib.callback('elevate_vehiclethief:buyCar', false, function(cb)
                        if cb then
                            lib.notify({
                                title = 'Bilen er leveret!',
                                type = 'success'
                            })
                            exports.ox_target:removeZone(carID)
                            ESX.Game.DeleteVehicle(spawnedVehicle)
                            RemoveBlip(lastWarehouseBlip)
                            HasMission = nil
                            hackingTimes = 0
                            isSpawnedVehicle = nil
                            canDeliver = nil
                            deliverySetup = nil
                            hasCarjack = nil
                        else
                            lib.notify({
                                title = 'Du har ikke plads i dette lagerhus!',
                                type = 'error'
                            })
                        end        
                    end, item, nearestWarehouseId)
                end
            })

            -- If the vehicle has GPS, set up hacking
            if item.hasPoliceGPS then
                -- Notify player they need to hack
                lib.notify({
                    title = 'Info',
                    description = 'Hack GPS for at kunne aflevere bilen.',
                    type = 'inform'
                })
                
                -- Start a separate thread for the hacking functionality
                Citizen.CreateThread(function()
                    while hackingTimes < 3 and hasCarjack do
                        Wait(5000)
                        if DoesEntityExist(spawnedVehicle) then
                            TriggerServerEvent('elevate_vehiclethief:addVehicleBlip', spawnedVehicle)

                            if IsPedInVehicle(PlayerPedId(), spawnedVehicle, false) then
                                if not vehiclehack then
                                    vehiclehack = true
                                    lib.addRadialItem({
                                        {
                                            id = 'vehiclehack',
                                            label = "Hack GPS'en i bilen",
                                            icon = 'fa-solid fa-mobile-screen-button',
                                            onSelect = function()
                                                HackVehicle('vehiclehack', spawnedVehicle)
                                            end,
                                        }
                                    })
                                end
                            else
                                vehiclehack = nil
                                lib.removeRadialItem('vehiclehack')
                            end
                        else
                            if DoesBlipExist(policeBlip) then
                                RemoveBlip(policeBlip)
                            end
                            break
                        end
                    end
                end)
            end
        end
    end
end

HackVehicle = function(id, spawnedVehicle)
    lib.callback('elevate_vehiclethief:hackVehicle', false, function(cb, CurrentTime)
        CurrentVehicleHacking = CurrentTime
        CurrentHackingTime = cb

        local timeUntilRefresh = CurrentHackingTime - CurrentVehicleHacking
        local minutesUntilRefresh = math.floor(timeUntilRefresh / 60)
        local secondsUntilRefresh = timeUntilRefresh % 60

        if timeUntilRefresh > 0 then
            lib.notify({
                description = string.format('Tid tilbage for du kan hack: %d min. & %d sek.', minutesUntilRefresh, secondsUntilRefresh),
                type = 'error'
            })            
        else
            exports['ps-ui']:Scrambler(function(success)
                if success then
                    lib.notify({
                        title = 'Hacking fuldført',
                        type = 'success'
                    })
                    
                    hackingTimes = hackingTimes + 1

                    if hackingTimes == 2 then
                        lib.notify({
                            title = 'GPS deaktiveret! Du kan nu aflevere bilen',
                            type = 'success'
                        })
                        lib.removeRadialItem(id)
                        vehiclehack = false
                        canDeliver = true  -- Set canDeliver to true after 3 successful hacks
                        
                        -- Add a debug notification to confirm canDeliver is set
                        lib.notify({
                            title = 'Debug',
                            description = 'canDeliver er nu sat til true',
                            type = 'inform'
                        })
                    else                    
                        lib.notify({
                            description = string.format('Du skal hacke %d gange mere', 3 - hackingTimes),
                            type = 'inform'
                        })
                        TriggerServerEvent('elevate_vehiclethief:setVehicleTime', spawnedVehicle)
                    end
                else
                    lib.notify({
                        title = 'Du fejlede prøv igen',
                        type = 'error'
                    })    
                end
            end, "greek", 60, 0)
        end
    end, spawnedVehicle)    
end

LoadAnim = function(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

toUpperCase = function(str)
    local replacements = { ['æ'] = 'Æ', ['ø'] = 'Ø', ['å'] = 'Å' }
    local upperStr = string.upper(str)

    for k, v in pairs(replacements) do
        upperStr = upperStr:gsub(k, v)
    end

    return upperStr
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end
StopBusySpinner = function()
    RemoveLoadingPrompt()
end

SpawnPed = function(hash, coords, heading, pedType, cb)
    local start = GetGameTimer()
    RequestModel(hash)
    while not HasModelLoaded(hash) and GetGameTimer() - start < 30000 do
        Wait(0);
    end

    if not HasModelLoaded(hash) then
        return
    end

    local ped = CreatePed(pedType, hash, coords.x, coords.y, coords.z, heading, true, true)

    start = GetGameTimer()
    while not DoesEntityExist(ped) and GetGameTimer() - start < 30000 do
        Wait(0);
    end

    if not DoesEntityExist(ped) then
        return
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetModelAsNoLongerNeeded(hash)

    if cb then
        cb(ped)
    end
end

function GetRandomRoadPositionInRadius(x, y, z, radius)
    local randomX, randomY, randomZ = 0.0, 0.0, 0.0
    local attempts = 0

    while attempts < 10 do
        randomX = x + math.random(-radius, radius)
        randomY = y + math.random(-radius, radius)
        randomZ = z

        local _, closestRoad, _ = GetClosestRoad(randomX, randomY, randomZ, 30, 1, true)

        if closestRoad then
            return closestRoad
        end

        attempts = attempts + 1
    end

    return nil
end

function calculateDistance(coord1, coord2)
    local dx = coord1.x - coord2.x
    local dy = coord1.y - coord2.y
    local dz = coord1.z - coord2.z

    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Event Handlers
RegisterNetEvent('elevate_vehiclethief:spawnCar')
AddEventHandler('elevate_vehiclethief:spawnCar', function(locations, warehouseId, itemID)
    canDeliver = true
    isSelling = true
    crateData = {
        warehouseId = warehouseId,
        itemID = itemID,
    }

    ESX.Game.SpawnVehicle(crateData.itemID, vector3(locations.carSpawn.x, locations.carSpawn.y, locations.carSpawn.z), locations.carSpawn.w, function(vehicle)
        while not DoesEntityExist(vehicle) do 
            Wait(200) 
        end

        Entity(vehicle).state.fuel = 100

        local carplate = GetVehicleNumberPlateText(vehicle)

        exports['mani-keys']:GiveKey(vehicle, true)
        local state = Entity(vehicle).state
        state:set('vehLocked', false, true)

        carBlip = AddBlipForEntity(vehicle)
        SetBlipSprite(carBlip, 523)
        SetBlipColour(carBlip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Markeret Køretøj')
        EndTextCommandSetBlipName(carBlip)

        deliverCar = AddBlipForCoord(locations.selectedSpawn.x, locations.selectedSpawn.y, locations.selectedSpawn.z)
        SetBlipColour(deliverCar, 2)
        SetBlipDisplay(deliverCar, 2)
        SetBlipScale(deliverCar, 1.0)
        SetBlipAsShortRange(deliverCar, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Sælg bil')
        EndTextCommandSetBlipName(deliverCar)
        SetBlipRoute(deliverCar, true)

        carID = exports.ox_target:addModel(GetEntityModel(vehicle), {
            icon = "far fa-dollar-sign",
            label = "Sælg køretøj",
            distance = 2.0,
            canInteract = function()
                if vehicle and DoesEntityExist(vehicle) then
                    local carCoords = GetEntityCoords(vehicle)
                    local distanceToTruckFromCrate = #(vector3(locations.selectedSpawn.x, locations.selectedSpawn.y, locations.selectedSpawn.z) - carCoords)

                    return distanceToTruckFromCrate <= 10 and canDeliver
                else
                    return false
                end
            end,
            onSelect = function(data)
                
                if canDeliver then
                 
                    lib.callback('elevate_vehiclethief:soldCar', false, function(cb)
                        if cb then
                            exports.ox_target:removeZone(carID)
                            isSpawnedVehicle = nil
                            RemoveBlip(deliverCar)
                            RemoveBlip(carBlip)
                            canDeliver = nil
                            HasMission = nil
                            isSelling = false
                        else
                            lib.notify({
                                title = 'FEJL!',
                                type = 'error',
                                duration = 10000,
                            })        
                        end
                    end, crateData.itemID, canDeliver, vehicle)

                end
                ESX.Game.DeleteVehicle(vehicle)
                canDeliver = false
            end
        })
    end)
end)

RegisterNetEvent('elevate_vehiclethief:pingVehicle')
AddEventHandler('elevate_vehiclethief:pingVehicle', function(vehicle)
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'police' then
        local vehicleCoords = GetEntityCoords(vehicle)
        if not DoesBlipExist(policeBlip) then
            policeBlip = AddBlipForCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
            SetBlipSprite(policeBlip, 523)
            SetBlipColour(policeBlip, 1)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Stjålet Køretøj')
            EndTextCommandSetBlipName(policeBlip)

            if not hasCalledPolice then
                hasCalledPolice = true
                local StreetName = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
                local data = {code = 'RØVERI', name = ' Biltyveri på en ' .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), loc = GetStreetNameFromHashKey(StreetName)}
                local length = 5000

                TriggerEvent('wf_alerts:SendAlert', 'police', data, length)
            end
        else
            RemoveBlip(policeBlip)
            policeBlip = AddBlipForCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
            SetBlipSprite(policeBlip, 523)
            SetBlipColour(policeBlip, 1)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Stjålet Køretøj')
            EndTextCommandSetBlipName(policeBlip)
        end
    end
end)

-- Setup warehouse teleport points and interactions
for Warehouses, warehousethings in pairs(Config.VehicleStorageInteractions) do
    local elevatorPoint = lib.points.new({
        coords = vector3(warehousethings.storageExit.x, warehousethings.storageExit.y, warehousethings.storageExit.z),
        distance = 1.5,
        nearby = function()
            if IsControlJustPressed(0, 46) then
                WarehouseTeleport(warehousethings.storageEnter)
            end
        end,
        onEnter = function()
            lib.showTextUI('[E] - Gå ud af Varehuset', {icon = 'fa-solid fa-elevator'} )
        end,
        onExit = function()
            if lib.isTextUIOpen() then
                lib.hideTextUI()
            end
        end
    })
    local elevatorPoint = lib.points.new({
        coords = vector3(warehousethings.storageEnter.x, warehousethings.storageEnter.y, warehousethings.storageEnter.z),
        distance = 1.5,
        nearby = function()
            if IsControlJustPressed(0, 46) then
                WarehouseTeleport(warehousethings.storageExit)
            end
        end,
        onEnter = function()
            lib.showTextUI('[E] - Gå ind i Varehuset', {icon = 'fa-solid fa-elevator'} )
        end,
        onExit = function()
            if lib.isTextUIOpen() then
                lib.hideTextUI()
            end
        end
    })

    exports.ox_target:addSphereZone({
        coords = vector3(warehousethings.interaction.x, warehousethings.interaction.y , warehousethings.interaction.z),
        radius = 0.35,
        distance = 1.5,
        options = {
            {
                icon = "fa-solid fa-warehouse",
                label = "Åben Computeren",
                distance = 1.5,
                onSelect = function(data)
                    OpenComputer(Warehouses)
                end
            },
        }
    })
end

-- Initialize
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteSpawnedProps()
        DoScreenFadeIn(100)
        Citizen.Wait(100)
        if display then
            CloseUI()
        end
    end
end)

-- Spawn vehicles at all warehouses on resource start
Citizen.CreateThread(function()
    Wait(1000) -- Wait for config to load
    SpawnVehiclesAtAllWarehouses()
end)