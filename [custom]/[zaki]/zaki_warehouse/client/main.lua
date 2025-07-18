ESX = exports["es_extended"]:getSharedObject()

local objects = {}
local spawnedMule = nil
local isMuleOut = false
local isCrateInTruck = nil
local crate = nil
local nearestWarehouseId = nil
local crateData = {}
local HasChecked = false
local HasMission = false
local CurrentPeds = {}
local display = false
local CurrentWarehouse = nil

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
    ESX.TriggerServerCallback('elevate_warehouse:laptop', function(data)
        if not data then
            print("Error: No data received from elevate_warehouse:laptop callback")
            return
        end
        
        local levelData = GetLevelDataByExp(data.exp)
        local levelLabel = determineLevelByExp(data.exp)
        
        -- Get available crates
        ESX.TriggerServerCallback('elevate_warehouse:getItemBatch', function(globalItemBatch, playerExp)
            if not globalItemBatch then
                print("Error: No data received from elevate_warehouse:getItemBatch callback")
                return
            end
            
            -- Get warehouse crates
            ESX.TriggerServerCallback('elevate_warehouse:getWarehouseData', function(warehouseData)
                if not warehouseData then
                    print("Error: No data received from elevate_warehouse:getWarehouseData callback")
                    return
                end
                
                -- Calculate refresh time
                local timeUntilRefresh = data.TimeToRefresh + Config.CargoRefresh - data.CurrentTime
                local minutesUntilRefresh = math.floor(timeUntilRefresh / 60)
                local secondsUntilRefresh = timeUntilRefresh % 60
                local refreshTimeStr = string.format("%02d:%02d %02d:%02d", 
                    math.floor(minutesUntilRefresh / 60), 
                    minutesUntilRefresh % 60,
                    math.floor(secondsUntilRefresh / 60),
                    secondsUntilRefresh % 60)
                
                -- Format available crates - ensure id is passed as the string key, not a number
                local availableCrates = {}
                for i, item in ipairs(globalItemBatch) do
                    local canBuy = playerExp >= item.requiredexp and not HasMission
                    
                    table.insert(availableCrates, {
                        id = item.id, -- This should be the string key like "clothing"
                        name = item.label,
                        buyPrice = ESX.Math.GroupDigits(item.buyPrice) .. " kr.",
                        sellPrice = ESX.Math.GroupDigits(Config.WarehouseCrates[item.id].sellPrice) .. " kr.",
                        requiredExp = item.requiredexp .. " EXP",
                        expReward = Config.WarehouseCrates[item.id].expreward .. " EXP",
                        canBuy = canBuy,
                        playerExp = playerExp
                    })
                end
                
                -- Format warehouse crates - ensure id is passed as the string key
                local warehouseCrates = {}
                for i, box in ipairs(warehouseData) do
                    local canSell = box.time - box.currentTime < 0
                    local timeLeft = ""
                    
                    if not canSell then
                        local remainingTime = box.time - box.currentTime
                        local hours = math.floor(remainingTime / 3600)
                        local minutes = math.floor((remainingTime % 3600) / 60)
                        local seconds = remainingTime % 60
                        timeLeft = string.format("%d timer %d min. & %d sek.", hours, minutes, seconds)
                    end
                    
                    table.insert(warehouseCrates, {
                        id = box.boxid, -- This should be the string key like "clothing"
                        name = box.name,
                        sellPrice = box.sellPrice .. " kr.",
                        expReward = box.expreward .. " EXP",
                        canSell = canSell,
                        timeLeft = not canSell and timeLeft or nil
                    })
                end
                
                -- Send data to NUI
                SendNUIMessage({
                    type = "update",
                    warehouseData = {
                        level = {
                            label = levelLabel,
                            current = data.exp,
                            max = levelData.nextLevelExp or data.exp,
                            percentage = levelData.percentage or 100
                        },
                        refreshTime = refreshTimeStr,
                        crateCount = data.warehouseCount .. "/" .. Config.MaxCratePerUser,
                        availableCrates = availableCrates,
                        warehouseCrates = warehouseCrates,
                        hasTruck = data.hasTruck == 1,
                        truckPrice = ESX.Math.GroupDigits(Config.AcquireMulePrice) .. " kr."
                    }
                })
            end, warehouseId)
        end)
    end, warehouseId)
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

RegisterNUICallback('refreshData', function(data, cb)
    RefreshUIData(CurrentWarehouse)
    cb('ok')
end)

RegisterNUICallback('buyCrate', function(data, cb)
    local crateId = data.crateId
    local crateName = data.crateName
    local buyPrice = data.buyPrice
    
    print(crateId, crateName, buyPrice)

    if not HasMission then
        TriggerServerEvent('elevate_warehouse:purchaseBox', crateId, crateName, buyPrice, CurrentWarehouse, Config.WarehouseCrates[crateId].model)
        CloseUI()
    else
        lib.notify({
            title = 'Fejl',
            description = 'Du er allerede i gang med en kasse!',
            type = 'error'
        })
    end
    
    cb('ok')
end)

RegisterNUICallback('sellCrate', function(data, cb)
    local crateId = data.crateId
    
    -- Debug output
    print("Received crateId from UI:", crateId, "Type:", type(crateId))
    
    if not HasMission then
        ESX.TriggerServerCallback('elevate_warehouse:getWarehouseData', function(warehouseData)
            for i, box in ipairs(warehouseData) do

                print(json.encode(warehouseData))
                local boxId = box.boxid
                local requestedId = tonumber(crateId) or crateId
                
                print("Comparing boxId:", boxId, "with requestedId:", requestedId)
                
                if boxId == requestedId then
                    TriggerServerEvent('elevate_warehouse:sellBox', CurrentWarehouse, box.sellPrice, box.id, box.expreward, box.boxid)
                    CloseUI()
                    break
                end
            end
        end, CurrentWarehouse)
    else
        lib.notify({
            title = 'Fejl',
            description = 'Du er allerede i gang med en kasse!',
            type = 'error'
        })
    end
    
    cb('ok')
  end)
RegisterNUICallback('spawnTruck', function(data, cb)
    local warehouseConfig = Config.WarehouseInteractions[CurrentWarehouse]
    local isPointClear = ESX.Game.IsSpawnPointClear(vector3(warehouseConfig.truckSpawn.x, warehouseConfig.truckSpawn.y, warehouseConfig.truckSpawn.z), 7.0)
    
    if isPointClear then
        SpawnMule(CurrentWarehouse)
        CloseUI()
    else
        lib.notify({
            title = 'Fejl',
            description = 'Der holder noget i vejen!',
            type = 'error'
        })
    end
    
    cb('ok')
end)

RegisterNUICallback('returnTruck', function(data, cb)
    if isMuleOut then
        SpawnMule(CurrentWarehouse) -- This function handles both spawning and returning
        CloseUI()
    end
    
    cb('ok')
end)

RegisterNUICallback('buyTruck', function(data, cb)
    BuyTruck(CurrentWarehouse)
    CloseUI()
    
    cb('ok')
end)

-- Replace the original LaptopWareHouse function
function LaptopWareHouse(WareHouseID)
    CurrentWarehouse = WareHouseID
    OpenUI(WareHouseID)
end

-- Original functions from the script
Citizen.CreateThread(function()
    SetupWarehouses()
end)

function SetupWarehouses()
    for Warehouses, warehousethings in pairs(Config.WarehouseInteractions) do

        exports.ox_target:addSphereZone({
            coords = vector3(warehousethings.warehouseEnter.x-0.2, warehousethings.warehouseEnter.y , warehousethings.warehouseEnter.z),
            radius = 0.8,
            distance = 1.5,
            options = {
                {
                    name = 'WarehouseEnter' .. Warehouses,
                    icon = "fa-solid fa-warehouse",
                    label = "Gå ind",
                    distance = 2,
                    canInteract = function()
                        return 'true'
                    end,
                    onSelect = function(data)
                        EnterWareHouse(Warehouses)
                    end
                },
            }
        })

        exports.ox_target:addSphereZone({
            coords = vector3(warehousethings.warehouseExit.x-0.2, warehousethings.warehouseExit.y , warehousethings.warehouseExit.z),
            radius = 0.8,
            distance = 1.5,
            options = {
                {
                    name = 'WarehouseExit' .. Warehouses,
                    icon = "fa-solid fa-warehouse",
                    label = "Gå ud",
                    distance = 2,
                    canInteract = function()
                        return 'true'
                    end,
                    onSelect = function(data)
                        ExitWareHouse(Warehouses)
                    end
                },
            }
        })

        exports.ox_target:addSphereZone({
            coords = vector3(warehousethings.interaction.x, warehousethings.interaction.y , warehousethings.interaction.z),
            radius = 0.35,
            distance = 1.5,
            options = {
                {
                    icon = "fa-solid fa-laptop",
                    label = "Brug Computeren",
                    distance = 1.0,
                    onSelect = function(data)
                        SetEntityCoords(PlayerPedId(), warehousethings.interaction.x-0.64, warehousethings.interaction.y-0.1, warehousethings.interaction.z-1, 269.0506, false, false, true)
                        SetEntityHeading(PlayerPedId(), 267.0)
                        ExecuteCommand("e type")     
                        Wait(1300)
                        LaptopWareHouse(Warehouses)

                    end
                },
            
            }
        })
    end
end

LoadAnim = function(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function SpawnMule(WarehouseID)
    local warehouseConfig = Config.WarehouseInteractions[WarehouseID]
    local truckSpawn = warehouseConfig.truckSpawn

    if spawnedMule and DoesEntityExist(spawnedMule) then
        local TruckPosition = GetEntityCoords(spawnedMule)
        local TruckSpawned = vector3(truckSpawn.x, truckSpawn.y, truckSpawn.z)
        local distance = #(TruckPosition - TruckSpawned)

        if distance <= 25.0 then
            DeleteVehicle(spawnedMule)
            spawnedMule = nil
            isMuleOut = false
        else
            lib.notify({
                title = 'Fejl',
                description = 'Lastbilen er ikke tæt nok på varehuset!',
                type = 'error'
            })
        end
    else
        RequestModel('mule')
        while not HasModelLoaded('mule') do
            Wait(500)
        end

        spawnedMule = CreateVehicle('mule', truckSpawn.x, truckSpawn.y, truckSpawn.z, truckSpawn.w, true, false)

        SetVehicleExtra(spawnedMule, 1)

        for i = 2, 7, 1 do
            SetVehicleExtra(spawnedMule, i, true)
        end

        SetEntityAsMissionEntity(spawnedMule, true, true)
        SetModelAsNoLongerNeeded('mule')
        isMuleOut = true

        local carplate = GetVehicleNumberPlateText(spawnedMule)

        exports['mani-keys']:GiveKey(spawnedMule, true)
        local state = Entity(spawnedMule).state
        state:set('vehLocked', false, true)

        lib.notify({
            title = 'Din lastbil står udenfor varehuset!',
            type = 'success'
        })

        if not muleTarget then
            muleTarget = true
            truckid = exports.ox_target:addModel(GetEntityModel(spawnedMule), {
                name = 'unloadCrate',
                icon = "fa-solid fa-box-open",
                label = "Tag kassen ud af lastbilen",
                distance = 2.0,
                canInteract = function()
                    return isCrateInTruck
                end,
                onSelect = function(data)
                    UnloadCrateFromTruck(truckid)
                end
            })
        end

        if Config.TruckBlip then
            if not DoesBlipExist(spawnedMuleBlip) then
                spawnedMuleBlip = AddBlipForEntity(spawnedMule)
                SetBlipSprite(spawnedMuleBlip, 477)
                SetBlipColour(spawnedMuleBlip, 2)
                SetBlipScale(spawnedMuleBlip, 0.8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Din Lastbil')
                EndTextCommandSetBlipName(spawnedMuleBlip)
            end

            while DoesEntityExist(spawnedMule) do
                Wait(5000)
                if DoesBlipExist(spawnedMuleBlip) then
                    local vehicleCoords = GetEntityCoords(spawnedMule)
                    SetBlipCoords(spawnedMuleBlip, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
                end
            end

            if DoesBlipExist(spawnedMuleBlip) then
                RemoveBlip(spawnedMuleBlip)
            end
        end
    end
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

function BuyTruck(WarehouseID)
    ESX.TriggerServerCallback('elevate_warehouse:checkBalance', function(cb)
        if cb[1] == true then

            TriggerServerEvent('elevate_warehouse:RemoveMoney', cb[2])

            Citizen.CreateThread(function()
                hasTruckDelivery = true
            
                while hasTruckDelivery do
                    Citizen.Wait(1000)

                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local randomIndex = math.random(#Config.TruckDelivery)
                    local selectedSpawn = Config.TruckDelivery[randomIndex]
                    local distance = #(playerCoords - selectedSpawn)

                    if not truckNotify then
                        truckSpawn = AddBlipForCoord(selectedSpawn.x, selectedSpawn.y, selectedSpawn.z)
                        SetBlipSprite(truckSpawn, 477)
                        SetBlipColour(truckSpawn, 5)
                        SetBlipDisplay(truckSpawn, 2)
                        SetBlipAsShortRange(CrateSpawn, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('Varevogn')
                        EndTextCommandSetBlipName(truckSpawn)
                        SetBlipRoute(truckSpawn, true)

                        lib.notify({
                            title = 'Stjæl Varevognen og kør den tilbage til et varehus!',
                            type = 'success',
                            duration = 10000,
                        })
                        truckNotify = true
                    end
        
                    if distance <= 50 then
                        RemoveBlip(truckSpawn)
                        SpawnVehicle("mule", selectedSpawn, 90.0, function(vehicle)
                            SetVehicleNumberPlateText(vehicle, 'WAR' .. math.random(111,999))
                            Entity(vehicle).state.fuel = 100
                            local pedSpawn = vector3(selectedSpawn.x+1.0, selectedSpawn.y, selectedSpawn.z)
                            local carBlip = AddBlipForEntity(vehicle)
                            SetBlipSprite(carBlip, 477)
                            SetBlipColour(carBlip, 5)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString('Varevogn')
                            EndTextCommandSetBlipName(carBlip)

                            TruckRob = exports.ox_target:addModel(GetEntityModel(vehicle), {
                                name = 'DropoffTruck',
                                icon = "fa-solid fa-box-open",
                                label = "Aflever varevogn",
                                distance = 2.0,
                                canInteract = function()
                                    local playerCoords = GetEntityCoords(PlayerPedId())
                                    local nearestDistance = math.huge
                    
                                    for warehouseId, warehouse in pairs(Config.WarehouseInteractions) do
                                        local warehouseEnter = warehouse.warehouseEnter
                                        local dx = playerCoords.x - warehouseEnter.x
                                        local dy = playerCoords.y - warehouseEnter.y
                                        local dz = playerCoords.z - warehouseEnter.z
                                        local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
                    
                                        if distance < nearestDistance then
                                            nearestDistance = distance
                                            nearestWarehouseId = warehouseId
                                        end
                                    end
                    
                                    return nearestDistance < 20
                                end,
                                onSelect = function(data)
                                    exports.ox_target:removeZone(TruckRob)
                                    local model = "mule"

                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(0);
                                    end

                                    DeliverTruck()
                                    SetEntityAsMissionEntity(vehicle, true, true)
                                    DeleteVehicle(vehicle)

                                    Wait(500)
                                    SetModelAsNoLongerNeeded(model)
                                end
                            })

                            local hash = GetHashKey("s_m_m_security_01")
                            SpawnPed(hash, pedSpawn, 90.0, 8, function(spawnPed)
                                SetPedRelationshipGroupHash(spawnPed, GetHashKey("KOS"))
                                SetPedCombatAttributes(spawnPed, 46, 1)
                                SetPedCombatAbility(spawnPed, 100)
                                SetPedCombatMovement(spawnPed, 2)
                                SetPedCombatRange(spawnPed, 2)
                                SetPedKeepTask(spawnPed, true)

                                SetPedAccuracy(spawnPed, 100)
                                SetPedArmour(spawnPed, 100)
                                SetPedIntoVehicle(spawnPed, vehicle, -1)

                                local speed = 25.0
                                local drivingStyle = 447
                                
                                SetDriverAbility(spawnPed, 1.0)
                                SetDriverAggressiveness(spawnPed, 0.0)
                                TaskVehicleDriveWander(spawnPed, vehicle, speed, drivingStyle)
                            end)
                        end)
                        hasTruckDelivery = false
                    end
                end
            end)
        elseif cb[1] == false then
            lib.notify({
                title = 'Fejl',
                description = 'Du har ikke nok penge på dig! Du kan betale med sorte eller hvide kontanter!',
                type = 'error'
            })
        end
    end)
end

DeliverTruck = function ()
    TriggerServerEvent('elevate_warehouse:DeliverTruck')
    hasTruck = true
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

SpawnVehicle = function(model, coords, heading, cb)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0);
    end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, true, true)
    while not DoesEntityExist(veh) do
        Wait(0);
    end

    SetEntityAsMissionEntity(veh, true, true)
    SetEntityHeading(veh, heading)
    SetVehicleOnGroundProperly(veh)

    while not NetworkHasControlOfEntity(veh) do
        NetworkRequestControlOfEntity(veh);
        Wait(0);
    end

    while not NetworkGetEntityIsNetworked(veh) do
        NetworkRegisterEntityAsNetworked(veh);
        Wait(0);
    end

    Wait(500)
    SetModelAsNoLongerNeeded(model)

    if cb then
        cb(veh)
    end
end

local function toUpperCase(str)
    local replacements = { ['æ'] = 'Æ', ['ø'] = 'Ø', ['å'] = 'Å' }
    local upperStr = string.upper(str)

    for k, v in pairs(replacements) do
        upperStr = upperStr:gsub(k, v)
    end

    return upperStr
end

RegisterNetEvent('elevate_warehouse:spawnCrate')
AddEventHandler('elevate_warehouse:spawnCrate', function(spawnLocation, warehouseId, itemID, sellPrice, expreward)
    
    crateData = {
        warehouseId = warehouseId,
        itemID = itemID,
        sellPrice = sellPrice,
        canDeliver = false,
    }

    HasMission = true
    local crateModel = Config.WarehouseCrates[crateData.itemID].model

    RequestModel(crateModel)
    while not HasModelLoaded(crateModel) do
        Wait(1)
    end

    if sellPrice == nil then
        local crateCoords = vec3(spawnLocation.x, spawnLocation.y, spawnLocation.z-1)

        CrateSpawn = AddBlipForCoord(spawnLocation.x, spawnLocation.y, spawnLocation.z)
        SetBlipSprite(CrateSpawn, 434)
        SetBlipColour(CrateSpawn, 5)
        SetBlipDisplay(CrateSpawn, 2)
        SetBlipScale(CrateSpawn, 1.0)
        SetBlipAsShortRange(CrateSpawn, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Crate Drop')
        EndTextCommandSetBlipName(CrateSpawn)
        SetBlipRoute(CrateSpawn, true)

        id = exports.ox_target:addSphereZone({
            coords = crateCoords + vec3(0, 0, 0.7),
            radius = 1.3,
            options = {
                {
                    icon = "fa-solid fa-truck-ramp-box",
                    label = "Placer kassen i lastbilen",
                    distance = 2.5,
                    canInteract = function()
                        if spawnedMule and DoesEntityExist(spawnedMule) then
                            local truckCoords = GetEntityCoords(spawnedMule)
                            local distanceToTruckFromCrate = #(crateCoords - truckCoords)
    
                            return distanceToTruckFromCrate <= 10
                        else
                            return false
                        end
                    end,
                    onSelect = function(data)
                        LoadCrateIntoTruck(id)
                        SetBlipRoute(CrateSpawn, false)
                        RemoveBlip(CrateSpawn)
                    end
                },
            }
        })

        lib.notify({
            title = 'Info',
            description = 'Find kassen, Husk at medbringe din lastbil!',
            type = 'inform',
            duration = 10000,
        })

        Citizen.CreateThread(function()
            HasActiveDelivery = true
        
            while HasActiveDelivery do
                Citizen.Wait(1000)
        
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local crateDelivery = vector3(spawnLocation.x, spawnLocation.y, spawnLocation.z)
                local distance = #(playerCoords - crateDelivery)
        
                if distance <= 25 then
                    if not isSpawned then
                        isSpawned = true
        
                        print("Spawner crate ved", spawnLocation.x, spawnLocation.y, spawnLocation.z)
                        
                        ESX.Game.SpawnLocalObject(crateModel, vector3(spawnLocation.x, spawnLocation.y, spawnLocation.z - 1), function(object)
                            if DoesEntityExist(object) then
                                crate = object
                                print("Crate successfully spawned:", json.encode(crate))
        
                                for i = 1, 3, 1 do
                                    if i == 1 then
                                        pedSpawnCrate = vector3(spawnLocation.x + 4.0, spawnLocation.y, spawnLocation.z + 0.50)
                                    elseif i == 2 then
                                        pedSpawnCrate = vector3(spawnLocation.x - 1.0, spawnLocation.y - 2.5, spawnLocation.z + 0.50)
                                    elseif i == 3 then
                                        pedSpawnCrate = vector3(spawnLocation.x, spawnLocation.y + 3.5, spawnLocation.z + 0.50)
                                    end
        
                                    local hash = GetHashKey("s_m_m_security_01")
                                    SpawnPed(hash, pedSpawnCrate, 90, 8, function(spawnPed)
                                        SetPedRelationshipGroupHash(spawnPed, GetHashKey("KOS"))
                                        SetPedRelationshipGroupHash(spawnPed, GetHashKey("SECURITY_GUARD"))
                                        SetPedRelationshipGroupDefaultHash(spawnPed, GetHashKey("SECURITY_GUARD"))
                                        SetPedSeeingRange(spawnPed, 100.0)
                                        SetPedHearingRange(spawnPed, 80.0)
                                        SetPedCombatAttributes(spawnPed, 46, 1)
                                        SetPedCombatAttributes(spawnPed, 0, 2)
                                        SetPedCombatAttributes(spawnPed, 5, 1)
                                        SetPedCombatAttributes(spawnPed, 38, 1)
                                        SetPedCombatAbility(spawnPed, 2)
                                        SetPedCombatMovement(spawnPed, 2)
                                        SetPedCombatRange(spawnPed, 1)
                                        SetPedKeepTask(spawnPed, true)
        
                                        SetPedDropsWeaponsWhenDead(spawnPed, false)
                                        SetPedAccuracy(spawnPed, 100)
        
                                        if Config.WarehouseCrates[crateData.itemID].hasGun then
                                            local randomWeapon = "weapon_pistol"
                                            GiveWeaponToPed(spawnPed, GetHashKey(randomWeapon), 250, false, true)
                                            SetPedArmour(spawnPed, 100)
                                        else
                                            local randomWeapon = "weapon_flashlight"
                                            GiveWeaponToPed(spawnPed, GetHashKey(randomWeapon), 250, false, true)
                                        end
        
                                        table.insert(CurrentPeds, spawnPed)
                                    end)
                                end
        
                                for i = 1, #CurrentPeds, 1 do
                                    if DoesEntityExist(CurrentPeds[i]) then
                                        TaskCombatPed(CurrentPeds[i], GetPlayerPed(-1), 0, 16)
                                    end
                                end
                            else
                                print("fejl, linje 793")
                            end
                        end)
                    end
                end
        
                if isCrateInTruck and distance >= 25 then
                    for i = 1, #CurrentPeds, 1 do
                        if DoesEntityExist(CurrentPeds[i]) then
                            ESX.Game.DeleteObject(CurrentPeds[i])
                        end
                    end
                    CurrentPeds = {}
                    HasMission = false
                    HasActiveDelivery = false
                end
            end
        end)
        
    end
    
    if sellPrice then
        crate = CreateObject(GetHashKey(crateModel), spawnLocation.crateSpawn.x, spawnLocation.crateSpawn.y, spawnLocation.crateSpawn.z-1, true, true, true)
        local crateCoords = vec3(spawnLocation.crateSpawn.x, spawnLocation.crateSpawn.y, spawnLocation.crateSpawn.z-1)
    
        id = exports.ox_target:addSphereZone({
            coords = crateCoords + vec3(0, 0, 0.7),
            radius = 1.5,
            options = {
                {
                    icon = "fa-solid fa-truck-ramp-box",
                    label = "Placer kassen i lastbilen",
                    distance = 2.5,
                    canInteract = function()
                        if spawnedMule and DoesEntityExist(spawnedMule) then
                            local truckCoords = GetEntityCoords(spawnedMule)
                            local distanceToTruckFromCrate = #(crateCoords - truckCoords)
    
                            return distanceToTruckFromCrate <= 10
                        else
                            return false
                        end
                    end,
                    onSelect = function(data)
                        LoadCrateIntoTruck(id)
                    end
                },
            }
        })
        
        CrateSpawn = AddBlipForCoord(spawnLocation.selectedSpawn)
        SetBlipSprite(CrateSpawn, 615)
        SetBlipColour(CrateSpawn, 5)
        SetBlipDisplay(CrateSpawn, 2)
        SetBlipScale(CrateSpawn, 1.0)
        SetBlipAsShortRange(CrateSpawn, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Leveringssted')
        EndTextCommandSetBlipName(CrateSpawn)

        lib.notify({
            title = 'Info',
            description = 'Kør til leveringstedet og aflevere pallen! Husk pallen!',
            type = 'inform'
        })

        Citizen.CreateThread(function()
            hasCrateDelivery = true
            notificationSent = false
        
            while hasCrateDelivery do
                Citizen.Wait(1000)
        
                if isCrateInTruck then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local crateDelivery = spawnLocation.selectedSpawn
                    local distance = #(playerCoords - crateDelivery)
        
                    if distance <= 100 then
                        if not notificationSent then
                            lib.notify({
                                title = 'Info',
                                description = 'Aflevere pallen i det afmærkede område!',
                                type = 'inform'
                            })
        
                            if DoesBlipExist(CrateSpawn) then
                                RemoveBlip(CrateSpawn)
                            end
        
                            if not LocationBlip then
                                LocationBlip = AddBlipForRadius(crateDelivery.x, crateDelivery.y, crateDelivery.z, 20.0)
                                SetBlipSprite(LocationBlip, 9)
                                SetBlipColour(LocationBlip, 70)
                                SetBlipAlpha(LocationBlip, 75)
                            end
        
                            notificationSent = true
                        end
        
                        if distance <= 20 then
                            crateData = {
                                canDeliver = true,
                                itemID = itemID,
                                sellPrice = sellPrice,
                                expreward = expreward,
                            }
                        else
                            crateData = {
                                canDeliver = false,
                                itemID = itemID,
                                sellPrice = sellPrice,
                                expreward = expreward,
                            }
                        end
                    else
                        crateData = {
                            canDeliver = false,
                            itemID = itemID,
                            sellPrice = sellPrice,
                            expreward = expreward,
                        }
                        notificationSent = false
                    end
                end
            end
        
            if DoesBlipExist(CrateSpawn) then
                RemoveBlip(CrateSpawn)
            end
        end)
    end
end)

function LoadCrateIntoTruck(data)
    if isCrateInTruck then
        lib.notify({
            description = 'Du har allerede en kasse i denne lastbil!',
            type = 'error'
        })
        return
    end

    if lib.progressBar({
        duration = 5000,
        label = 'Pakker Lastbil',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
        },
    }) then 
        isCrateInTruck = true
        exports.ox_target:removeZone(data)

        AttachEntityToEntity(crate, spawnedMule, GetEntityBoneIndexByName(spawnedMule, "extra_1"), 0, 0, 0.2, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        Wait(1000)
        FreezeEntityPosition(crate, true)
    end
end

function UnloadCrateFromTruck()
    if not isCrateInTruck then
        return
    end

    if lib.progressBar({
        duration = 5000,
        label = 'Aflæsser Lastbilen',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            combat = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
        },
    }) then
        local truckCoords = GetEntityCoords(spawnedMule)
        local truckForwardVector = GetEntityForwardVector(spawnedMule)
        local backwardOffset = 5.6
        local downwardOffset = -1.4
        local unloadX = truckCoords.x - truckForwardVector.x * backwardOffset
        local unloadY = truckCoords.y - truckForwardVector.y * backwardOffset
        local unloadZ = truckCoords.z + downwardOffset

        canDeliverCrate = true
        isCrateInTruck = nil
        DetachEntity(crate, true, true)
        SetEntityCoords(crate, unloadX, unloadY, unloadZ + 0.2)

        exports.ox_target:removeZone(truckid)

        crateid = exports.ox_target:addSphereZone({
            coords = vec3(unloadX, unloadY, unloadZ + 0.7),
            radius = 1.3,
            options = {
                {
                    icon = "fa-solid fa-truck-ramp-box",
                    label = "Placer kassen i lastbilen",
                    distance = 1.5,
                    onSelect = function(data)
                        LoadCrateIntoTruck(crateid)
                    end
                },
                {
                    icon = "fa-solid fa-truck-ramp-box",
                    label = "Aflevere kassen til lageret",
                    distance = 1.5,
                    canInteract = function()
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local nearestDistance = math.huge
        
                        for warehouseId, warehouse in pairs(Config.WarehouseInteractions) do
                            local warehouseEnter = warehouse.warehouseEnter
                            local dx = playerCoords.x - warehouseEnter.x
                            local dy = playerCoords.y - warehouseEnter.y
                            local dz = playerCoords.z - warehouseEnter.z
                            local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
        
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestWarehouseId = warehouseId
                            end
                        end
        
                        return nearestDistance < 10
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('elevate_warehouse:buyBox', function(cb)
                            if cb then
                                exports.ox_target:removeZone(crateid)
                                ESX.Game.DeleteObject(crate)
                                lib.notify({
                                    title = 'Kassen er leveret!',
                                    type = 'success'
                                })
                            else
                                lib.notify({
                                    title = 'Du har ikke plads i dette lagerhus!',
                                    type = 'error'
                                })
                            end
                        end, nearestWarehouseId, crateData.itemID)
                    end
                },
                {
                    icon = "fa-solid fa-truck-ramp-box",
                    label = "Aflevere kassen til smuglerne",
                    distance = 1.5,
                    canInteract = function()
                        return crateData.canDeliver and canDeliverCrate
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('elevate_warehouse:soldBox', function(cb)
                            if cb then
                                exports.ox_target:removeZone(crateid)
                                ESX.Game.DeleteObject(crate)
                                lib.notify({
                                    title = 'Du afleverede kassen til smuglerne!',
                                    type = 'success'
                                })
                                HasMission = false
                                hasCrateDelivery = false
                                RemoveDeliveryLocationBlip()
                                crateData = {
                                    canDeliver = nil,
                                    itemID = itemID,
                                    sellPrice = sellPrice,
                                    expreward = expreward,
                                }
                                canDeliverCrate = nil
                            end
                        end, crateData.canDeliver, crateData.sellPrice, crateData.expreward, crateData.itemID)
                    end
                }
            }
        })    
    end
end

function RemoveDeliveryLocationBlip()
    RemoveBlip(LocationBlip)
    LocationBlip = nil
end

function EnterWareHouse(WareHouseID)
    local warehouse = Config.WarehouseInteractions[WareHouseID]
    local enterCoords = warehouse.warehouseExit
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), enterCoords.x, enterCoords.y, enterCoords.z-1, enterCoords.w, false, false, true)
    SetEntityHeading(PlayerPedId(), 272.0)
    Wait(500)
    DoScreenFadeIn(1000)
end

function ExitWareHouse(WareHouseID)
    local warehouse = Config.WarehouseInteractions[WareHouseID]
    local exitCoords = warehouse.warehouseEnter
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), exitCoords.x, exitCoords.y, exitCoords.z-1, exitCoords.w, false, false, true)
    Wait(500)
    DoScreenFadeIn(1000)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if display then
            CloseUI()
        end
        
        for i = 1, #objects, 1 do
            if DoesEntityExist(objects[i]) then
                DeleteEntity(objects[i])
            end
        end
    end
end)

