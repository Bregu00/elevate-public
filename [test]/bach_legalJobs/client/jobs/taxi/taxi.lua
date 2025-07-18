local taxiConfig = lib.load("shared.jobs.taxi")
local currentJob = nil
local taxiVehicle = nil
local hasTaxiJob = false
local isOnDuty = false
local meterActive = false
local currentFare = 0
local startTime = 0
local startCoords = nil
local currentDistance = 0
local taxiZones = {}

local function initTaxiJob()
    for _, depotLoc in pairs(taxiConfig["depots"]) do
        local depotBlip = AddBlipForCoord(depotLoc.coords.x, depotLoc.coords.y, depotLoc.coords.z)
        SetBlipSprite(depotBlip, depotLoc.blip.sprite)
        SetBlipDisplay(depotBlip, 4)
        SetBlipScale(depotBlip, depotLoc.blip.scale)
        SetBlipColour(depotBlip, depotLoc.blip.color)
        SetBlipAsShortRange(depotBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(depotLoc.blip.label)
        EndTextCommandSetBlipName(depotBlip)

        local depotZone = lib.zones.box({
            coords = vector3(depotLoc.coords.x, depotLoc.coords.y, depotLoc.coords.z),
            size = vector3(5, 5, 3),
            rotation = depotLoc.coords.w,
            debug = false,
            onEnter = function()
                lib.showTextUI("[E] Brug Taxacentral", {
                    position = "top-center",
                    icon = "fas fa-taxi",
                })
                taxiInteract = lib.addKeybind({
                    name = "taxiInteract",
                    description = "Interagere med Taxaservice",
                    defaultKey = "E",
                    onPressed = function(self)
                        openTaxiMenu()
                    end,
                })
            end,
            onExit = function()
                lib.hideTextUI()
                taxiInteract:disable(true)
                Wait(100)
                taxiInteract = nil
            end,
        })

        table.insert(taxiZones, depotZone)

        if depotLoc.pedModel then
            local additionalPedModel = depotLoc.pedModel
            if type(additionalPedModel) == "string" then
                additionalPedModel = GetHashKey(additionalPedModel)
            end

            lib.requestModel(additionalPedModel, 10000)

            if HasModelLoaded(additionalPedModel) then
                local additionalPed = CreatePed(4, additionalPedModel, depotLoc.coords.x, depotLoc.coords.y,
                    depotLoc.coords.z - 1.0, depotLoc.coords.w, false, true)
                SetEntityHeading(additionalPed, depotLoc.coords.w)
                FreezeEntityPosition(additionalPed, true)
                SetEntityInvincible(additionalPed, true)
                SetBlockingOfNonTemporaryEvents(additionalPed, true)

                if depotLoc.scenario then
                    TaskStartScenarioInPlace(additionalPed, depotLoc.scenario, 0, true)
                end
            end
        end
    end

    RegisterCommand("taximeter", function()
        local playerPed = PlayerPedId()
        local inTaxi = IsPedInAnyTaxi(playerPed)
        local inTaxiVehicle = taxiVehicle and IsPedInVehicle(playerPed, taxiVehicle, false)

        if hasTaxiJob and isOnDuty and (inTaxi or inTaxiVehicle) then
            toggleTaxiMeter()
        else
            if not hasTaxiJob then
                lib.notify({
                    title = "Taxaservice",
                    description = "Du er ikke ansat som taxachauffør",
                    type = "error",
                    icon = "fas fa-taxi",
                })
            elseif not isOnDuty then
                lib.notify({
                    title = "Taxaservice",
                    description = "Du skal være på vagt for at bruge taxameteret",
                    type = "error",
                    icon = "fas fa-taxi",
                })
            elseif not (inTaxi or inTaxiVehicle) then
                lib.notify({
                    title = "Taxaservice",
                    description = "Du skal være i en taxa for at bruge taxameteret",
                    type = "error",
                    icon = "fas fa-taxi",
                })
            end
        end
    end, false)

    RegisterKeyMapping("taximeter", "Slå taxameter til/fra", "keyboard", taxiConfig["meterToggleKey"])
end

lib.addRadialItem({
    {
        id = "taxi",
        label = "Taxa",
        icon = "taxi",
        menu = "taxi_menu",
        onSelect = function()
            radialMenu()
        end,
    },
})

lib.registerRadial({
    id = "taxi_menu",
})

function radialMenu()
    local hasActivePickup = false
    if hasTaxiJob and isOnDuty then
        local jobData = exports.bach_legalJobs:getCurrentJobData()
        if jobData and jobData.type == "pickup" then
            hasActivePickup = true
        end
    end

    local menuItems = {
        {
            label = isOnDuty and "Gå af vagt" or "Gå på vagt",
            icon = isOnDuty and "fas fa-toggle-off" or "fas fa-toggle-on",
            onSelect = function()
                toggleDuty()
            end,
        },
        {
            label = "Find passager",
            icon = "fas fa-search",
            onSelect = function()
                if isOnDuty then
                    TriggerEvent("bach_taxijob:findPassenger")
                else
                    lib.notify({
                        title = "Taxaservice",
                        description = "Du skal være på vagt for at finde passager",
                        type = "error",
                        icon = "fas fa-taxi",
                    })
                end
            end,
        },
        {
            label = "Taxameter",
            icon = "fas fa-money-bill",
            onSelect = function()
                if hasTaxiJob and isOnDuty and
                    (IsPedInAnyTaxi(PlayerPedId()) or
                        (taxiVehicle and IsPedInVehicle(PlayerPedId(), taxiVehicle, false))) then
                    toggleTaxiMeter()
                else
                    lib.notify({
                        title = "Taxaservice",
                        description = "Du skal være i en taxa for at bruge taxameteret",
                        type = "error",
                        icon = "fas fa-taxi",
                    })
                end
            end,
        },
    }

    if hasActivePickup then
        table.insert(menuItems, {
            label = "Afvis passager",
            icon = "fas fa-user-times",
            onSelect = function()
                TriggerEvent("bach_taxijob:cancelPassenger", "Du afviste passageren")
            end,
        })
    end

    lib.registerRadial({
        id = "taxi_menu",
        items = menuItems,
    })
end

function openTaxiMenu()
    local playerJob = ESX.GetPlayerData().job
    hasTaxiJob = playerJob.name == "taxi"

    local options = {}

    table.insert(options, {
        title = "Taxacentral",
        description = "Velkommen til taxacentralen",
        icon = "fas fa-taxi",
        iconColor = "#f7b731",
    })

    if hasTaxiJob then

        table.insert(options, {
            title = isOnDuty and "Gå af vagt" or "Gå på vagt",
            description = isOnDuty and "Afslut din vagt som taxachauffør" or "Start din vagt som taxachauffør",
            icon = isOnDuty and "fas fa-toggle-off" or "fas fa-toggle-on",
            onSelect = function()
                toggleDuty()
                Wait(100)
                openTaxiMenu()
            end,
        })

        if isOnDuty then
            if taxiVehicle and DoesEntityExist(taxiVehicle) then
                table.insert(options, {
                    title = "Returner køretøj",
                    description = "Parkér dit taxakøretøj og få dit depositum tilbage",
                    icon = "fas fa-times-circle",
                    onSelect = function()
                        returnTaxiVehicle()
                    end,
                })

                if IsPedInVehicle(PlayerPedId(), taxiVehicle, false) then
                    table.insert(options, {
                        title = meterActive and "Deaktiver taxameter" or "Aktiver taxameter",
                        description = meterActive and "Stop taxameteret og få betaling" or
                            "Start taxameteret til en ny kunde",
                        icon = "fas fa-calculator",
                        onSelect = function()
                            toggleTaxiMeter()
                            Wait(100)
                            if meterActive then
                                openTaxiMenu()
                            end
                        end,
                    })
                end
            else
                table.insert(options, {
                    title = "Lån taxakøretøj",
                    description = "Vælg et taxakøretøj at bruge",
                    icon = "fas fa-car",
                    onSelect = function()
                        openVehicleMenu()
                    end,
                })
            end
        end

        if isOnDuty and taxiVehicle and DoesEntityExist(taxiVehicle) and not currentJob then
            table.insert(options, {
                title = "Find passager",
                description = "Søg efter kunder der har brug for en taxi",
                icon = "fas fa-search",
                onSelect = function()
                    TriggerEvent("bach_taxijob:findPassenger")
                end,
            })
        end
    else
        table.insert(options, {
            title = "Bliv taxachauffør",
            description = "Du skal ansættes på Byrået først",
            icon = "fas fa-info-circle",
            disabled = true,
        })
    end

    lib.registerContext({
        id = "taxi_menu",
        title = "Taxacentral",
        options = options,
    })

    lib.showContext("taxi_menu")
end

function toggleDuty()
    isOnDuty = not isOnDuty

    if isOnDuty then
        lib.notify({
            title = "Taxaservice",
            description = "Du er nu på vagt som taxachauffør",
            type = "success",
            icon = "fas fa-taxi",
        })
    else

        if taxiVehicle and DoesEntityExist(taxiVehicle) then
            returnTaxiVehicle()
        end

        if currentJob then
            cancelCurrentJob("Du afsluttede din vagt")
        end

        lib.notify({
            title = "Taxaservice",
            description = "Du er ikke længere på vagt",
            type = "error",
            icon = "fas fa-taxi",
        })
    end
end

function openVehicleMenu()
    local options = {}

    for _, vehicle in pairs(taxiConfig["vehicles"]) do
        table.insert(options, {
            title = vehicle.label,
            description = vehicle.description,
            icon = "fas fa-car",
            image = "https://bachdevpage.vercel.app/vehicles/" .. vehicle.model .. ".webp",
            metadata = {
                {
                    label = "Depositum",
                    value = vehicle.deposit .. ",-",
                },
            },
            onSelect = function()
                spawnTaxiVehicle(vehicle)
            end,
        })
    end

    lib.registerContext({
        id = "taxi_vehicle_menu",
        title = "Vælg taxakøretøj",
        menu = "taxi_menu",
        options = options,
    })

    lib.showContext("taxi_vehicle_menu")
end

function spawnTaxiVehicle(vehicleData)

    local canPay = lib.callback.await("bach_taxijob:checkDeposit", false, vehicleData.deposit)

    if not canPay then
        lib.notify({
            title = "Taxaservice",
            description = "Du har ikke råd til depositummet på " .. vehicleData.deposit .. ",-",
            type = "error",
            icon = "fas fa-taxi",
        })
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearestDepot = taxiConfig["depots"][1]
    local nearestDistance = #(playerCoords -
                                vector3(nearestDepot.coords.x, nearestDepot.coords.y, nearestDepot.coords.z))

    for _, depot in pairs(taxiConfig["depots"]) do
        local distance = #(playerCoords - vector3(depot.coords.x, depot.coords.y, depot.coords.z))
        if distance < nearestDistance then
            nearestDepot = depot
            nearestDistance = distance
        end
    end

    local model = GetHashKey(vehicleData.model)
    lib.requestModel(model, 10000)

    if HasModelLoaded(model) then

        local spawnCoords = vector4(nearestDepot.vehicleSpawn.x, nearestDepot.vehicleSpawn.y,
            nearestDepot.vehicleSpawn.z, nearestDepot.vehicleSpawn.w)

        taxiVehicle = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, false)

        SetVehicleNumberPlateText(taxiVehicle, "TX" .. vehicleData.deposit)
        SetVehicleDirtLevel(taxiVehicle, 0.0)
        SetVehicleEngineOn(taxiVehicle, true, true, false)

        local vehicleBlip = AddBlipForEntity(taxiVehicle)
        SetBlipSprite(vehicleBlip, 198)
        SetBlipScale(vehicleBlip, 0.8)
        SetBlipColour(vehicleBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Dit taxakøretøj")
        EndTextCommandSetBlipName(vehicleBlip)

        local success = lib.callback.await("bach_taxijob:payDeposit", false, vehicleData.deposit)

        if success then

            Entity(taxiVehicle).state.deposit = vehicleData.deposit

            lib.notify({
                title = "Taxaservice",
                description = "Du lånte en " .. vehicleData.label .. " og betalte " .. vehicleData.deposit ..
                    ",- i depositum",
                type = "success",
                icon = "fas fa-taxi",
            })

            SetEntityAsMissionEntity(taxiVehicle, true, true)

            TaskWarpPedIntoVehicle(PlayerPedId(), taxiVehicle, -1)
        else

            DeleteVehicle(taxiVehicle)
            taxiVehicle = nil

            lib.notify({
                title = "Taxaservice",
                description = "Der opstod en fejl ved betaling af depositum",
                type = "error",
                icon = "fas fa-taxi",
            })
        end
    else
        lib.notify({
            title = "Taxaservice",
            description = "Der opstod en fejl ved fremskaffelse af køretøjet",
            type = "error",
            icon = "fas fa-taxi",
        })
    end
end

function returnTaxiVehicle()
    if not taxiVehicle or not DoesEntityExist(taxiVehicle) then
        lib.notify({
            title = "Taxaservice",
            description = "Du har ikke et taxakøretøj ude",
            type = "error",
            icon = "fas fa-taxi",
        })
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearDepot = false
    local mainDepotCoords = vector3(taxiConfig["depots"][1].coords.x, taxiConfig["depots"][1].coords.y,
        taxiConfig["depots"][1].coords.z)

    if #(playerCoords - mainDepotCoords) < 30.0 then
        nearDepot = true
    else
        for _, depot in pairs(taxiConfig["depots"]) do
            local depotCoords = vector3(depot.coords.x, depot.coords.y, depot.coords.z)
            if #(playerCoords - depotCoords) < 30.0 then
                nearDepot = true
                break
            end
        end
    end

    if not nearDepot then
        lib.notify({
            title = "Taxaservice",
            description = "Du skal være ved en taxacentral for at returnere køretøjet",
            type = "error",
            icon = "fas fa-taxi",
        })
        return
    end

    local deposit = Entity(taxiVehicle).state.deposit

    if not deposit then

        local plate = GetVehicleNumberPlateText(taxiVehicle)
        if plate and string.sub(plate, 1, 2) == "TX" then
            deposit = tonumber(string.sub(plate, 3))
        end
    end

    if not deposit then
        deposit = 0

    end

    DeleteVehicle(taxiVehicle)
    taxiVehicle = nil

    local success = lib.callback.await("bach_taxijob:returnDeposit", false, deposit)

    if success then

        lib.notify({
            title = "Taxaservice",
            description = "Du returnerede køretøjet og fik " .. lib.math.groupdigits(deposit, ",") ..
                ",- tilbage i depositum",
            type = "success",
            icon = "fas fa-taxi",
        })
    else
        lib.notify({
            title = "Taxaservice",
            description = "Der opstod en fejl ved returnering af depositum",
            type = "error",
            icon = "fas fa-taxi",
        })
    end

    if currentJob then
        cancelCurrentJob("Du returnerede taxaen")
    end
end

function toggleTaxiMeter()
    meterActive = not meterActive

    if meterActive then

        startTime = GetGameTimer()
        startCoords = GetEntityCoords(PlayerPedId())
        currentDistance = 0
        currentFare = taxiConfig["fares"].baseFare

        lib.notify({
            title = "Taxameter",
            description = "Taxameter startet: " .. currentFare .. ",-",
            type = "success",
            icon = "fas fa-taxi",
        })
    else

        lib.hideTextUI()

        local endTime = GetGameTimer()
        local timeElapsed = (endTime - startTime) / 1000
        local waitingCharge = timeElapsed * taxiConfig["fares"].perSecondWaiting
        currentFare = math.floor(currentFare + waitingCharge)

        lib.notify({
            title = "Taxameter",
            description = "Taxameter stoppet. Pris: " .. currentFare .. ",-",
            type = "info",
            icon = "fas fa-taxi",
        })

        startTime = 0
        startCoords = nil
        currentDistance = 0

    end
end

function openPaymentOptions(fare)
    lib.registerContext({
        id = "taxi_payment_menu",
        title = "Betaling - " .. fare .. ",-",
        options = {
            {
                title = "Kontant betaling",
                description = "Kunden betaler kontant",
                icon = "fas fa-money-bill",
                onSelect = function()
                    processPayment(fare, "cash")
                end,
            },
            {
                title = "Kortbetaling",
                description = "Kunden betaler med kort",
                icon = "fas fa-credit-card",
                onSelect = function()
                    processPayment(fare, "card")
                end,
            },
            {
                title = "Gratis tur",
                description = "Giv kunden en gratis tur",
                icon = "fas fa-gift",
                onSelect = function()
                    lib.notify({
                        title = "Taxaservice",
                        description = "Du gav en gratis tur",
                        type = "info",
                        icon = "fas fa-taxi",
                    })
                end,
            },
        },
    })

    lib.showContext("taxi_payment_menu")
end

function processPayment(fare, method)

    local tipAmount = 0
    local tipChance = math.random(1, 100)

    if tipChance <= taxiConfig["fares"].tipChance then

        local tipOptions = taxiConfig["fares"].tipAmount
        tipAmount = tipOptions[math.random(1, #tipOptions)]
    end

    local totalPayment = fare + tipAmount

    local success = lib.callback.await("bach_taxijob:processPayment", false, totalPayment)

    if success then

        if tipAmount > 0 then
            lib.notify({
                title = "Taxaservice",
                description = "Kunden betalte " .. lib.math.groupdigits(fare, ",") .. ",- " ..
                    (method == "cash" and "kontant" or "med kort") .. " og gav " .. lib.math.groupdigits(tipAmount, ",") ..
                    ",- i drikkepenge!",
                type = "success",
                icon = "fas fa-taxi",
            })
        else
            lib.notify({
                title = "Taxaservice",
                description = "Kunden betalte " .. lib.math.groupdigits(fare, ",") .. ",- " ..
                    (method == "cash" and "kontant" or "med kort"),
                type = "success",
                icon = "fas fa-taxi",
            })
        end
    else
        lib.notify({
            title = "Taxaservice",
            description = "Der opstod en fejl ved behandling af betalingen",
            type = "error",
            icon = "fas fa-taxi",
        })
    end
    lib.hideTextUI()
end

function cancelCurrentJob(reason)
    local currentJob = exports.bach_legalJobs:getCurrentJobData()
    if currentJob then

        if currentJob.blip then
            RemoveBlip(currentJob.blip)
        end

        if currentJob.passenger and DoesEntityExist(currentJob.passenger) then
            DeletePed(currentJob.passenger)
        end

        lib.notify({
            title = "Taxaservice",
            description = reason or "Turen blev annulleret",
            type = "error",
            icon = "fas fa-taxi",
        })

        lib.hideTextUI()

        currentJob = nil
        exports.bach_legalJobs:setCurrentJobData(nil)
    end
end

CreateThread(function()
    while not ESX do
        Wait(0)
    end

    Wait(2000)
    initTaxiJob()

    while true do
        local sleep = meterActive and 1000 or 5000
        Wait(sleep)

        if meterActive and taxiVehicle and DoesEntityExist(taxiVehicle) then
            local playerPed = PlayerPedId()

            if IsPedInAnyTaxi(playerPed) or IsPedInVehicle(playerPed, taxiVehicle, false) then
                local currentCoords = GetEntityCoords(playerPed)

                local distanceTraveled = #(currentCoords - startCoords)
                currentDistance = currentDistance + distanceTraveled

                local distanceCharge = (distanceTraveled / 1000) * taxiConfig["fares"].perMeter * 1000
                currentFare = currentFare + distanceCharge

                startCoords = currentCoords

                lib.showTextUI("Taxameter: " .. math.floor(currentFare) .. ",- | Distance: " ..
                                   math.floor(currentDistance) .. "m", {
                    position = "top-center",
                    icon = "fas fa-taxi",
                })
            else

                meterActive = false
                lib.hideTextUI()
                lib.notify({
                    title = "Taxameter",
                    description = "Taxameter stoppet fordi du forlod køretøjet",
                    type = "error",
                    icon = "fas fa-taxi",
                })
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for _, zone in pairs(taxiZones) do
        zone:remove()
    end

    lib.hideTextUI()
end)

exports("openTaxiMenu", openTaxiMenu)
exports("toggleTaxiMeter", toggleTaxiMeter)
exports("openPaymentOptions", function(fare)

    if not exports.bach_legalJobs:getCurrentJobData() then
        lib.notify({
            title = "Taxaservice",
            description = "Der er ingen kunde til at betale",
            type = "error",
            icon = "fas fa-taxi",
        })
        return false
    end

    openPaymentOptions(fare)
    return true
end)
exports("getDutyStatus", function()
    return isOnDuty
end)
exports("hasTaxiJob", function()
    return hasTaxiJob
end)
exports("toggleDuty", toggleDuty)

RegisterNetEvent("bach_taxijob:toggleTaxiMeter")
AddEventHandler("bach_taxijob:toggleTaxiMeter", function()
    if hasTaxiJob and isOnDuty and
        (IsPedInAnyTaxi(PlayerPedId()) or (taxiVehicle and IsPedInVehicle(PlayerPedId(), taxiVehicle, false))) then
        toggleTaxiMeter()
    else
        lib.notify({
            title = "Taxaservice",
            description = "Du skal være i en taxa for at bruge taxameteret",
            type = "error",
            icon = "fas fa-taxi",
        })
    end
end)
