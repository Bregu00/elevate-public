local ESX = exports["es_extended"]:getSharedObject()
local Blips = {}
local runStarted = false
local pickups = 0
local activePickupZones = {}

RegisterNetEvent("pawnshop:client:openmachine", function(data)
    local playerData = ESX.GetPlayerData()
    Wait(250)

    local stash = {
        id = playerData.job.name .. "_" .. data.param,
        label = data.label,
        slots = 25,
        maxWeight = 5000000,
    }

    if not exports["ox_inventory"]:openInventory("stash", stash) then
        TriggerServerEvent("pawnshop:server:registerStash", stash)
        exports["ox_inventory"]:openInventory("stash", stash)
    end
end)

CreateThread(function()
    for key, value in pairs(Config.Locations) do
        exports["ox_target"]:addBoxZone({
            coords = vector3(value.coords.x, value.coords.y, value.coords.z),
            size = vector3(value.width, value.length, value.maxZ - value.minZ),
            rotation = value.coords.w,
            debug = Config.PolyDebug,
            options = {
                {
                    event = "pawnshop:client:openmachine",
                    icon = "fas fa-sign-in-alt",
                    label = Config.Lang.openMachine,
                    param = value.name,
                    groups = {
                        [value.job] = 2,
                    },
                },
                {
                    event = "pawnshop:client:smeltItems",
                    icon = "fas fa-sign-in-alt",
                    label = Config.Lang.startMachine,
                    param = value.name,
                    groups = {
                        [value.job] = 2,
                    },
                },
            },
            distance = 2.5,
        })
    end
end)

CreateThread(function()
    for key, value in pairs(Config.Stashes) do
        exports["ox_target"]:addBoxZone({
            coords = vector3(value.coords.x, value.coords.y, value.coords.z),
            size = vector3(value.width, value.length, value.maxZ - value.minZ),
            rotation = value.coords.w,
            debug = Config.PolyDebug,
            options = {
                {
                    event = "pawnshop:client:openStash",
                    icon = "fas fa-sign-in-alt",
                    label = Config.Lang.openStash,
                    param = value,
                    groups = {
                        [value.job] = value.requiredRank,
                    },
                },
            },
            distance = 2.5,
        })
    end
end)

RegisterNetEvent("pawnshop:client:openStash", function(data)
    local stash = {
        id = data.param.name,
        label = data.label,
        slots = data.param.slots,
        maxWeight = data.param.maxweight,
    }

    if not exports["ox_inventory"]:openInventory("stash", stash) then
        TriggerServerEvent("pawnshop:server:registerStash", stash)
        exports["ox_inventory"]:openInventory("stash", stash)
    end
end)

local function AddRunPoly()
    local newLabel = runStarted and Config.Lang.stopRun or Config.Lang.startRun
    for _, value in pairs(Config.StartRun) do
        exports["ox_target"]:addBoxZone({
            coords = vector3(value.coords.x, value.coords.y, value.coords.z),
            size = vector3(value.width, value.length, value.maxZ - value.minZ),
            rotation = value.coords.w,
            debug = Config.PolyDebug,
            options = {
                {
                    event = "pawnshop:client:startrun",
                    icon = "fas fa-sign-in-alt",
                    label = newLabel,
                    zone = value.name,
                    groups = {
                        [value.job] = 0,
                    },
                },
            },
            distance = 2.5,
        })
    end
end

CreateThread(function()
    for _, value in pairs(Config.Trays) do
        exports["ox_target"]:addBoxZone({
            coords = vector3(value.coords.x, value.coords.y, value.coords.z),
            size = vector3(value.width, value.length, value.maxZ - value.minZ),
            rotation = value.coords.w,
            debug = Config.PolyDebug,
            options = {
                {
                    icon = "fas fa-sign-in-alt",
                    label = Config.Lang.openTray,
                    onSelect = function()
                        local stash = {
                            id = value.name,
                            label = value.name,
                            slots = 25,
                            maxWeight = 5000000,
                        }
                        if not exports["ox_inventory"]:openInventory("stash", stash) then
                            TriggerServerEvent("pawnshop:server:registerStash", stash)
                            exports["ox_inventory"]:openInventory("stash", stash)
                        end
                    end,
                },
                {
                    icon = "fas fa-calculator",
                    label = Config.Lang.checkTrayValue,
                    onSelect = function()
                        local value = lib.callback.await("pawnshop:server:calculateTrayValue", false, value.name)
                        local input = lib.inputDialog("Pawn Udregner", {
                            {
                                type = "slider",
                                label = "Profit %",
                                description = "Vælg procentdel virksomheden tjener",
                                required = true,
                                min = 0,
                                max = 20,
                                step = 0.5,
                            },
                        })

                        if not input then
                            return
                        end
                        local profit = value * (input[1] / 100)
                        local total = value - profit
                        local profitText = string.format("%.2f", total)
                        lib.notify({
                            description = string.format(Config.Lang.trayValueDescription, profitText),
                            type = "inform",
                            duration = 10000,
                        })

                        local alert = lib.alertDialog({
                            header = "Kopier til udklipsholder",
                            content = "Ville du gerne kopiere til udklipsholder?  \n  \nIndkøbsprisen på varen(ene) er: " ..
                                profitText .. " DKK",
                            centered = true,
                            cancel = true,
                        })

                        if alert == "confirm" then
                            lib.setClipboard(total)
                        end

                    end,
                    groups = {
                        [value.job] = 0,
                    },
                },
                {
                    icon = "fas fa-sign-in-alt",
                    label = Config.Lang.registerTray,
                    onSelect = function()

                        local nearbyPlayers = lib.callback.await("pawnshop:server:getNearbyPlayers", false)

                        local value = lib.callback.await("pawnshop:server:calculateTrayValue", false, value.name)
                        local input = lib.inputDialog("Pawn Register Indkøb", {
                            {
                                type = "slider",
                                label = "Profit %",
                                description = "Vælg procentdel virksomheden tjener",
                                required = true,
                                min = 0,
                                max = 20,
                                step = 0.5,
                            },
                            {
                                type = "select",
                                label = "Kunde",
                                description = "Vælg kunden som sælger varen",
                                required = true,
                                options = nearbyPlayers,
                            },
                        })

                        if not input then
                            return
                        end
                        local profit = value * (input[1] / 100)
                        local total = value - profit
                        local profitText = string.format("%.2f", total)
                        lib.notify({
                            description = string.format(Config.Lang.trayValueDescription, profitText),
                            type = "inform",
                            duration = 10000,
                        })

                        TriggerServerEvent("pawnshop:server:registerTray", input[1], value, input[2])
                    end,
                    groups = {
                        [value.job] = 0,
                    },
                },
            },
            distance = 2.5,
        })
    end
    AddRunPoly()
end)

local poly = lib.zones.poly({
    points = {
        vec(447.4908, -1490.8718, 29),
        vec(439.2313, -1468.1970, 29),
        vec(439.8640, -1465.1705, 29),
        vec(454.4627, -1460.0061, 29),
        vec(463.5774, -1485.0476, 29),
    },
    thickness = 2,
    debug = false,
    onEnter = function()
        isInsidePoly = true
    end,
    onExit = function()
        isInsidePoly = nil
    end,
})

exports.ox_target:addGlobalPlayer({
    {
        icon = "fa-solid fa-user",
        label = "Spiller Information",
        groups = {
            "pop",
        },
        onSelect = function(data)
            local playerData = lib.callback.await("pawnshop:server:getdata", false,
                GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            print(json.encode(playerData))
            lib.showTextUI("[E] - Spiller Information  \n" ..
                               string.format("Navn: %s  \nTotal: %s DKK,-  \nProcent: %s", playerData.name,
                    lib.math.groupdigits(playerData.total), playerData.procent), {
                icon = "fa-solid fa-user",
            })

            CreateThread(function()
                while lib.isTextUIOpen() do
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        break
                    end
                    Wait(0)
                end
            end)
        end,
        distance = 1.5,
        canInteract = function(entity)
            if isInsidePoly then
                return true
            end
            return false
        end,
    },
})

RegisterNetEvent("pawnshop:client:smeltItems", function(data)
    if lib.progressBar({
        duration = 2500,
        label = Config.Lang.progressbarUsingMachine,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = "anim@mp_player_intmenu@key_fob@",
            clip = "fob_click",
        },
    }) then
        TriggerServerEvent("pawnshop:server:smelt", data)
    else
        lib.notify({
            title = Config.Lang.youCancelled,
            type = "error",
            duration = 3000,
        })
    end
end)

local function RemoveBlips()
    for key, value in pairs(Blips) do
        if type(value) == "number" then
            RemoveBlip(value)
        end
    end
    Blips = {}

    CleanupAllPickupZones()
end

local function DestroyPolys()
    for key, value in pairs(Config) do
        if type(value) == "table" then
            for i = 1, #value do
                exports["ox_target"]:removeZone(value[i].name)
            end
        end
    end
end

RegisterNetEvent("pawnshop:client:startrun", function(data)
    local i = math.random(1, #Config.PickupPlaces)
    ESX.TriggerServerCallback("pawnshop:server:checkpickamount", function(canPickup)
        if canPickup then
            exports["ox_target"]:removeZone(data.zone)
            if not runStarted then
                ESX.TriggerServerCallback("pawnshop:server:checkmoney", function(result)
                    if result then
                        runStarted = true
                        Blipstuff(i)
                        AddRunPoly()
                    else
                        lib.notify({
                            title = Config.Lang.notEnoughMoney,
                            type = "error",
                            duration = 3500,
                        })
                        AddRunPoly()
                    end
                end)
            else
                runStarted = false
                RemoveBlips()
                AddRunPoly()
            end
        else
            lib.notify({
                title = Config.Lang.cantDoMoreRuns,
                type = "error",
                duration = 7500,
            })
            runStarted = false
            AddRunPoly()
        end
    end)
end)

RegisterNetEvent("pawnshop:client:pickup", function(data)
    ESX.TriggerServerCallback("pawnshop:server:pickup", function(result)
        if result then
            local i = math.random(1, #Config.PickupPlaces)

            if data.zoneName then
                exports["ox_target"]:removeZone(data.zoneName)
                activePickupZones[data.index] = nil
            end

            RemoveBlip(data.blipName)
            Wait(250)
            Blipstuff(i)
            pickups = pickups + 1
            lib.notify({
                title = Config.Lang.tookItem,
                type = "success",
                duration = 3500,
            })
        else
            lib.notify({
                title = Config.Lang.tookNothing,
                type = "success",
                duration = 3500,
            })
        end
    end)
end)

function CreateTarget(index)
    if activePickupZones[index] then
        exports["ox_target"]:removeZone(activePickupZones[index])
        activePickupZones[index] = nil
    end

    local zoneName = "pickup_" .. GetGameTimer() .. "_" .. index
    activePickupZones[index] = zoneName

    exports["ox_target"]:addBoxZone({
        name = zoneName,
        coords = vector3(Config.PickupPlaces[index].coords.x, Config.PickupPlaces[index].coords.y,
            Config.PickupPlaces[index].coords.z),
        size = vector3(2, 1.3, 4),
        rotation = Config.PickupPlaces[index].coords.w,
        debug = Config.PolyDebug,
        options = {
            {
                event = "pawnshop:client:pickup",
                icon = "fas fa-sign-in-alt",
                label = Config.Lang.pickup,
                index = index,
                blipName = Blips[index],
                zoneName = zoneName,
            },
        },
        distance = 2.5,
    })
end

function CleanupAllPickupZones()
    for index, zoneName in pairs(activePickupZones) do
        exports["ox_target"]:removeZone(zoneName)
    end
    activePickupZones = {}
end

function Blipstuff(blipI)
    ESX.TriggerServerCallback("pawnshop:server:checkpickamount", function(result)
        if result then
            Blips[blipI] = AddBlipForCoord(vector3(Config.PickupPlaces[blipI].coords.x,
                Config.PickupPlaces[blipI].coords.y, Config.PickupPlaces[blipI].coords.z))
            SetBlipSprite(Blips[blipI], Config.PickupPlaces[blipI].blip)
            SetBlipDisplay(Blips[blipI], 4)
            SetBlipScale(Blips[blipI], 1.0)
            SetBlipColour(Blips[blipI], Config.PickupPlaces[blipI].color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.PickupPlaces[blipI].label)
            EndTextCommandSetBlipName(Blips[blipI])
            SetBlipRoute(Blips[blipI], true)
            SetBlipRouteColour(Blips[blipI], Config.PickupPlaces[blipI].color)
            CreateTarget(blipI)
        else
            lib.notify({
                title = Config.Lang.cantDoMoreRuns,
                type = "error",
                duration = 7500,
            })
        end
    end)
end

local function loadModel(model)
    if HasModelLoaded(model) then
        return
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

local function GradeCheck(grade, table)
    for i = 1, #table do
        if table[i] == grade then
            return true
        end
    end
    return false
end

local function ParkCar()
    local car = GetVehiclePedIsIn(PlayerPedId(), true)
    if car ~= 0 then
        lib.notify({
            title = "Vehicle Stored!",
            type = "success",
        })
        NetworkFadeOutEntity(car, true, false)
        Wait(2000)
        ESX.Game.DeleteVehicle(car)
    else
        lib.notify({
            title = "No car",
            type = "error",
            duration = 3500,
        })
    end
end

local function OpenMenu(v)
    local playerData = ESX.GetPlayerData()
    local menu = {}
    table.insert(menu, {
        title = "This is the vehicles you can spawn",
        icon = "fas fa-code",
        disabled = true,
    })
    for i = 1, #Config.PawnCars do
        if GradeCheck(playerData.job.grade, Config.PawnCars[i].AuthorizedRanks) then
            table.insert(menu, {
                title = Config.PawnCars[i].Label,
                description = Config.PawnCars[i].Label,
                icon = "fas fa-star",
                onSelect = function()
                    TriggerEvent("qb-pawnsystem:client:SpawnCar", {
                        model = Config.PawnCars[i].spawnName,
                        object = v,
                    })
                end,
            })
        end
    end
    lib.registerContext({
        id = "pawn_car_menu",
        title = "Pawn Vehicles",
        options = menu,
    })
    lib.showContext("pawn_car_menu")
end

RegisterNetEvent("qb-pawnsystem:client:SpawnCar", function(data)
    ESX.Game.SpawnVehicle(data.model, data.object.spawnLocation, data.object.spawnLocation.w, function(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        exports["vehiclekeys"]:SetOwner(GetVehicleNumberPlateText(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
    end)
end)

CreateThread(function()
    for _, value in pairs(Config.Locations) do
        value.blipid = AddBlipForCoord(vector3(value.coords.x, value.coords.y, value.coords.z))
        SetBlipSprite(value.blipid, value.blip)
        SetBlipDisplay(value.blipid, 4)
        SetBlipScale(value.blipid, 0.8)
        SetBlipColour(value.blipid, value.color)
        SetBlipAsShortRange(value.blipid, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(value.label)
        EndTextCommandSetBlipName(value.blipid)
    end
end)

CreateThread(function()
    if Config.CarSpawner[1] then
        for k, v in pairs(Config.CarSpawner) do
            loadModel(v.ped)
            local jobped = CreatePed(0, v.ped, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, false)
            TaskStartScenarioInPlace(jobped, "WORLD_HUMAN_CLIPBOARD", 0, true)
            FreezeEntityPosition(jobped, true)
            SetEntityInvincible(jobped, true)
            SetBlockingOfNonTemporaryEvents(jobped, true)
            exports["ox_target"]:addLocalEntity(jobped, {
                {
                    icon = "fas fa-warehouse",
                    label = v.targetTakeOutLabel,
                    groups = v.job,
                    onSelect = function()
                        OpenMenu(v)
                    end,
                },
                {
                    icon = "fas fa-warehouse",
                    label = v.targetParkLabel,
                    groups = v.job,
                    onSelect = function()
                        ParkCar()
                    end,
                },
            }, 2.0)
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DestroyPolys()
    end
end)

local deliveryActive = false
local deliveryBlips = {}
local currentDeliveryPoint = nil
local deliveryItems = {}

local function addPolyDelivery()
    local newLabel = deliveryActive and Config.Lang.stopDelivery or Config.Lang.startDelivery
    for _, value in pairs(Config.StartRun) do
        exports["ox_target"]:addBoxZone({
            coords = vector3(value.coords.x, value.coords.y, value.coords.z),
            size = vector3(value.width, value.length, value.maxZ - value.minZ),
            rotation = value.coords.w,
            debug = Config.PolyDebug,
            options = {
                {
                    event = "pawnshop:client:startDelivery",
                    icon = "fas fa-truck-loading",
                    label = newLabel,
                    zone = value.name,
                    groups = {
                        [value.job] = 0,
                    },
                },
            },
            distance = 2.5,
        })
    end
end

CreateThread(function()
    addPolyDelivery()
end)

RegisterNetEvent("pawnshop:client:startDelivery", function(data)
    exports["ox_target"]:removeZone(data.zone)
    if deliveryActive then
        lib.notify({
            title = Config.Lang.deliveryCancelled,
            type = "inform",
            duration = 3500,
        })
        ClearDeliveryMission()
        addPolyDelivery()
        return
    end

    ESX.TriggerServerCallback("pawnshop:server:checkDepositFee", function(canAfford)
        if canAfford then
            StartDeliveryMission()
            addPolyDelivery()
        else
            lib.notify({
                title = Config.Lang.notEnoughMoneyDeposit,
                type = "error",
                duration = 3500,
            })
            addPolyDelivery()
        end
    end)
end)

function StartDeliveryMission()
    deliveryActive = true

    deliveryItems = {}
    for itemName, _ in pairs(Config.Items) do
        local itemData = exports.ox_inventory:Items(itemName)
        if itemData then
            table.insert(deliveryItems, {
                name = itemData.name,
                label = itemData.label or itemName,
            })
        end
    end

    lib.notify({
        title = Config.Lang.deliveryStarted,
        description = Config.Lang.deliveryDescription,
        type = "success",
        duration = 5000,
    })

    SetupNextDeliveryPoint()
end

function SetupNextDeliveryPoint()
    local locations = Config.PickupPlaces
    currentDeliveryPoint = locations[math.random(#locations)]

    local blip = AddBlipForCoord(currentDeliveryPoint.coords.x, currentDeliveryPoint.coords.y,
        currentDeliveryPoint.coords.z)
    SetBlipSprite(blip, 501)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.8)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Lang.deliveryLocation)
    EndTextCommandSetBlipName(blip)

    table.insert(deliveryBlips, blip)

    exports["ox_target"]:addBoxZone({
        name = "delivery_" .. currentDeliveryPoint.name,
        coords = vector3(currentDeliveryPoint.coords.x, currentDeliveryPoint.coords.y, currentDeliveryPoint.coords.z),
        size = vector3(2, 1.3, 4),
        rotation = currentDeliveryPoint.coords.w,
        debug = Config.PolyDebug,
        options = {
            {
                event = "pawnshop:client:openDeliveryMenu",
                icon = "fas fa-box",
                label = Config.Lang.deliverItems,
            },
        },
        distance = 2.5,
    })

    lib.notify({
        title = Config.Lang.newDelivery,
        description = Config.Lang.deliveryLocationDesc,
        type = "inform",
        duration = 5000,
    })
end

RegisterNetEvent("pawnshop:client:openDeliveryMenu", function()
    if not deliveryActive then
        return
    end
    ESX.TriggerServerCallback("pawnshop:server:getPlayerDeliveryItems", function(playerItems)
        if #playerItems == 0 then
            lib.notify({
                title = Config.Lang.noItemsToDeliver,
                description = Config.Lang.findItemsFirst,
                type = "error",
                duration = 3500,
            })
            return
        end

        local options = {}
        for _, item in pairs(playerItems) do
            table.insert(options, {
                title = item.label .. " (" .. item.count .. ")",
                description = Config.Lang.deliverThisItem,
                icon = "fas fa-box",
                onSelect = function()
                    DeliverItem(item)
                end,
                metadata = {
                    {
                        label = Config.Lang.reward,
                        value = (Config.Items[item.name].money or Config.DeliveryBaseReward) .. " " ..
                            Config.Lang.currency,
                    },
                },
            })
        end

        table.insert(options, {
            title = Config.Lang.cancelDelivery,
            description = Config.Lang.stopDeliveryDesc,
            icon = "fas fa-times",
            onSelect = function()
                ClearDeliveryMission()
                lib.notify({
                    title = Config.Lang.deliveryCancelled,
                    description = Config.Lang.deliveryCancelledDesc,
                    type = "inform",
                    duration = 3500,
                })
            end,
        })

        lib.registerContext({
            id = "delivery_menu",
            title = Config.Lang.deliveryMenuTitle,
            options = options,
        })

        lib.showContext("delivery_menu")
    end)
end)

function DeliverItem(item)
    if lib.progressBar({
        duration = 3000,
        label = Config.Lang.deliveringItem,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = "mp_common",
            clip = "givetake1_a",
        },
    }) then
        TriggerServerEvent("pawnshop:server:deliverItem", item.name)
        exports["ox_target"]:removeZone("delivery_" .. currentDeliveryPoint.name)
        ClearCurrentDeliveryBlip()
        SetupNextDeliveryPoint()
    else
        lib.notify({
            title = Config.Lang.deliveryCancelled,
            type = "error",
            duration = 3500,
        })
    end
end

function ClearDeliveryMission()
    deliveryActive = false
    ClearAllDeliveryBlips()

    if currentDeliveryPoint then
        exports["ox_target"]:removeZone("delivery_" .. currentDeliveryPoint.name)
        currentDeliveryPoint = nil
    end

    TriggerServerEvent("pawnshop:server:returnDeposit")
end

function ClearCurrentDeliveryBlip()
    if #deliveryBlips > 0 then
        local blip = table.remove(deliveryBlips, 1)
        RemoveBlip(blip)
    end
end

function ClearAllDeliveryBlips()
    for _, blip in pairs(deliveryBlips) do
        RemoveBlip(blip)
    end
    deliveryBlips = {}
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() and deliveryActive then
        ClearDeliveryMission()
    end
end)
