local taxiConfig = lib.load("shared.jobs.taxi")
local activeNPCs = {}
local blips = {}

RegisterNetEvent("bach_taxijob:findPassenger", function()
    findPassenger()
end)

function findPassenger()
    local playerPed = PlayerPedId()

    if not IsPedInAnyTaxi(playerPed) then
        lib.notify({
            title = "Taxaservice",
            description = "Du skal være i et taxakøretøj for at finde passagerer",
            type = "error",
            icon = "fas fa-taxi",
        })
        return
    end

    if currentJob then
        lib.notify({
            title = "Taxaservice",
            description = "Du har allerede en aktiv tur",
            type = "error",
            icon = "fas fa-taxi",
        })
        return
    end

    lib.notify({
        title = "Taxaservice",
        description = "Søger efter passagerer i nærheden...",
        type = "info",
        icon = "fas fa-search",
    })

    local onlinePlayers = lib.callback.await("bach_taxijob:getOnlinePlayers", false)

    local passengerChance = 80
    if onlinePlayers then

        passengerChance = math.max(60, 80 - (onlinePlayers * 2))
    end

    Wait(math.random(2000, 5000))

    if math.random(1, 100) > passengerChance then
        lib.notify({
            title = "Taxaservice",
            description = "Ingen passagerer fundet i nærheden. Prøv et andet sted.",
            type = "error",
            icon = "fas fa-times",
        })
        return
    end

    local playerCoords = GetEntityCoords(playerPed)
    spawnPassenger(playerCoords)
end

function spawnPassenger(playerCoords)

    local spawnDistance = taxiConfig["passengers"].spawnDistance
    local spawnPos = findSafeSpawnPoint(playerCoords, spawnDistance)

    if not spawnPos then
        lib.notify({
            title = "Taxaservice",
            description = "Kunne ikke finde et sted at placere passageren",
            type = "error",
            icon = "fas fa-times",
        })
        return
    end

    local finalCheck, finalGroundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z, true)
    if finalCheck and math.abs(finalGroundZ - spawnPos.z) > 0.5 then
        spawnPos = vector3(spawnPos.x, spawnPos.y, finalGroundZ)
    end

    local skyCheck = StartShapeTestRay(spawnPos.x, spawnPos.y, spawnPos.z + 50.0, spawnPos.x, spawnPos.y, spawnPos.z, 1,
        0, 0)
    local _, skyHit, _, _, _ = GetShapeTestResult(skyCheck)

    local pedModels = taxiConfig["pedModels"]
    local pedModel = pedModels[math.random(1, #pedModels)]
    local modelHash = GetHashKey(pedModel)

    RequestModel(modelHash)

    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 30 do
        Wait(100)
        timeout = timeout + 1
    end

    if not HasModelLoaded(modelHash) then
        lib.notify({
            title = "Taxaservice",
            description = "Kunne ikke indlæse passager model",
            type = "error",
            icon = "fas fa-times",
        })
        return
    end

    local clearArea = false

    local areaCheck = StartShapeTestBox(spawnPos.x, spawnPos.y, spawnPos.z, 1.0, 1.0, 2.0, 0.0, 0.0, 0.0, true, 2, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(areaCheck)

    if hit == 1 and entityHit ~= 0 then
        clearArea = true
    end

    ClearAreaOfObjects(spawnPos.x, spawnPos.y, spawnPos.z, 2.0, 0)
    Wait(100)

    local ped = CreatePed(4, modelHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)

    SetModelAsNoLongerNeeded(modelHash)

    if not DoesEntityExist(ped) then
        lib.notify({
            title = "Taxaservice",
            description = "Kunne ikke oprette passageren",
            type = "error",
            icon = "fas fa-times",
        })
        return
    end

    local pedCoords = GetEntityCoords(ped)

    local success, groundZ = GetGroundZFor_3dCoord(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, true)
    if success then
        SetEntityCoords(ped, pedCoords.x, pedCoords.y, groundZ, false, false, false, false)
    end

    PlaceObjectOnGroundProperly(ped)

    local height = GetEntityHeightAboveGround(ped)

    if height > 1.0 or height < 0.0 then
        local newPos = GetEntityCoords(ped)
        local finalZ = newPos.z - height + 0.1
        SetEntityCoords(ped, newPos.x, newPos.y, finalZ, false, false, false, false)
    end

    Wait(100)

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)

    SetEntityVisible(ped, true, false)
    SetEntityAlpha(ped, 255, false)
    SetPedRandomComponentVariation(ped, 0)

    PlaceObjectOnGroundProperly(ped)

    local finalPedCoords = GetEntityCoords(ped)
    local finalHeight = GetEntityHeightAboveGround(ped)

    local finalGroundCheck = StartShapeTestRay(finalPedCoords.x, finalPedCoords.y, finalPedCoords.z + 0.1,
        finalPedCoords.x, finalPedCoords.y, finalPedCoords.z - 10.0, 1, ped, 0)
    local _, finalHit, finalHitCoords, _, _ = GetShapeTestResult(finalGroundCheck)

    if finalHit == 1 then
        local groundDist = math.abs(finalPedCoords.z - finalHitCoords.z)

        if groundDist > 1.0 then

            SetEntityCoords(ped, finalPedCoords.x, finalPedCoords.y, finalHitCoords.z + 0.1, false, false, false, false)
            Wait(100)
            PlaceObjectOnGroundProperly(ped)
        end
    end

    local scenarios = taxiConfig["passengers"].scenarios
    local scenario = scenarios[math.random(1, #scenarios)]
    TaskStartScenarioInPlace(ped, scenario, 0, true)

    local destinationCoords = generateDestination(playerCoords)
    if not destinationCoords then
        DeletePed(ped)
        lib.notify({
            title = "Taxaservice",
            description = "Kunne ikke finde en destination",
            type = "error",
            icon = "fas fa-times",
        })
        return
    end

    local passengerBlip = AddBlipForEntity(ped)
    SetBlipSprite(passengerBlip, 280)
    SetBlipDisplay(passengerBlip, 4)
    SetBlipScale(passengerBlip, 0.8)
    SetBlipColour(passengerBlip, 2)
    SetBlipAsShortRange(passengerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Passager")
    EndTextCommandSetBlipName(passengerBlip)

    currentJob = {
        type = "pickup",
        passenger = ped,
        passengerCoords = vector3(spawnPos.x, spawnPos.y, spawnPos.z),
        destinationCoords = destinationCoords,
        blip = passengerBlip,
        startTime = GetGameTimer(),
        estimatedFare = calculateEstimatedFare(vector3(spawnPos.x, spawnPos.y, spawnPos.z), destinationCoords),
    }

    lib.notify({
        title = "Taxaservice",
        description = "En ny passager venter på dig. Estimeret pris: " .. currentJob.estimatedFare .. ",-",
        type = "success",
        icon = "fas fa-user",
    })

    CreateThread(function()
        monitorTaxiJob()
    end)
end

function findSafeSpawnPoint(centerPoint, distance)
    local goodAreas = {
        {
            x = -100,
            y = -500,
            width = 1500,
            height = 1500,
        },
        {
            x = -1200,
            y = -2700,
            width = 600,
            height = 600,
        },
        {
            x = 1800,
            y = 3600,
            width = 800,
            height = 800,
        },
        {
            x = -100,
            y = 6300,
            width = 600,
            height = 600,
        },
    }

    local inGoodArea = false
    for _, area in ipairs(goodAreas) do
        if centerPoint.x > area.x and centerPoint.x < area.x + area.width and centerPoint.y > area.y and centerPoint.y <
            area.y + area.height then
            inGoodArea = true
            break
        end
    end

    local maxAttempts = 30
    local bestPoint = nil
    local bestScore = -1

    for i = 1, maxAttempts do
        local angle = (i - 1) * (360 / maxAttempts) + math.random(-10, 10)
        local spawnDistance = distance * (0.8 + math.random() * 0.4)
        local radian = math.rad(angle)

        local x = centerPoint.x + spawnDistance * math.cos(radian)
        local y = centerPoint.y + spawnDistance * math.sin(radian)

        local streetZ = 0
        local streetFound = false
        local dummy, streetPosition = GetNthClosestVehicleNodeWithHeading(x, y, 0.0, 1, 0, 0, 0)

        if dummy then
            streetZ = streetPosition.z
            streetFound = true
        end

        local success = false
        local groundZ = 0.0

        if streetFound then

            success, groundZ = GetGroundZFor_3dCoord(x, y, streetZ + 2.0, true)
            if success and math.abs(groundZ - streetZ) < 7.0 then
            else

                local heightsToTry = {
                    streetZ - 1.0,
                    streetZ + 0.5,
                    streetZ + 5.0,
                    0.0,
                    5.0,
                    30.0,
                    100.0,
                }

                for _, testZ in ipairs(heightsToTry) do
                    success, groundZ = GetGroundZFor_3dCoord(x, y, testZ, true)
                    if success then

                        if math.abs(groundZ - streetZ) < 5.0 then

                            break
                        else

                            success = false
                        end
                    end
                end
            end
        else

            local heightsToTry = {
                0.0,
                1.0,
                5.0,
                30.0,
                100.0,
            }
            for _, testZ in ipairs(heightsToTry) do
                success, groundZ = GetGroundZFor_3dCoord(x, y, testZ, true)
                if success then

                    break
                end
            end
        end

        if success then

            local testPoint = vector3(x, y, groundZ)

            if groundZ < -50.0 or groundZ > 200.0 then

                goto continue
            end

            local cast1 = StartShapeTestRay(x, y, groundZ + 100.0, x, y, groundZ - 5.0, 1, 0, 0)
            local _, hit1, hitCoords1, _, hitEntity1 = GetShapeTestResult(cast1)

            if hit1 == 1 and math.abs(hitCoords1.z - groundZ) > 1.0 then

                goto continue
            end

            local waterTest, waterHeight = GetWaterHeight(x, y, groundZ)
            if waterTest and waterHeight + 0.5 > groundZ then

                goto continue
            end

            local isOnRoad = IsPointOnRoad(x, y, groundZ, 0)
            local roadPosition = testPoint
            local roadDistance = 0

            if isOnRoad then
                for offset = 1, 8 do
                    local angleOffset = offset * 45
                    local offsetRadian = math.rad(angleOffset)
                    local offsetX = x + 5.0 * math.cos(offsetRadian)
                    local offsetY = y + 5.0 * math.sin(offsetRadian)
                    local offsetSuccess, offsetZ = GetGroundZFor_3dCoord(offsetX, offsetY, groundZ, true)

                    if offsetSuccess and not IsPointOnRoad(offsetX, offsetY, offsetZ, 0) then

                        if math.abs(offsetZ - groundZ) < 3.0 then
                            x = offsetX
                            y = offsetY
                            groundZ = offsetZ
                            isOnRoad = false

                            break
                        end
                    end
                end
            end

            local closestRoad = vector3(0, 0, 0)
            local roadFound, roadPosition = GetClosestVehicleNode(x, y, groundZ, closestRoad, 1, 3.0, 0)

            if roadFound then
                roadDistance = #(vector2(x, y) - vector2(roadPosition.x, roadPosition.y))

                local heightDiff = math.abs(groundZ - roadPosition.z)
                if heightDiff > 7.0 then

                    goto continue
                end
            end

            local score = 0

            if not isOnRoad and roadDistance < 20.0 and roadDistance > 2.0 then
                score = score + (20.0 - roadDistance)
            end

            if inGoodArea then
                score = score + 20
            end

            if waterTest then
                score = score - 50
            end

            local cast = StartShapeTestRay(x, y, groundZ + 0.5, x, y, groundZ + 15.0, 1, 0, 0)
            local _, hit, hitCoords, _, _ = GetShapeTestResult(cast)

            if hit == 0 then

                score = score + 30
            else

                local clearanceHeight = hitCoords.z - groundZ
                if clearanceHeight < 2.0 then

                    score = score - 100

                    goto continue
                end
            end

            local buildingCheck = StartShapeTestRay(x, y, groundZ - 0.5, x, y, groundZ - 10.0, 1, 0, 0)
            local _, buildingHit, buildingHitCoords, _, _ = GetShapeTestResult(buildingCheck)

            if buildingHit == 1 and math.abs(buildingHitCoords.z - (groundZ - 0.5)) < 0.1 then

                score = score - 1000

                goto continue
            end

            if streetFound then
                local heightAboveStreet = groundZ - streetZ
                if heightAboveStreet > 5.0 then

                    local heightPenalty = heightAboveStreet * 10
                    score = score - heightPenalty

                    if heightAboveStreet > 10.0 then

                        goto continue
                    end
                end
            end

            if score > bestScore then
                bestScore = score
                bestPoint = vector3(x, y, groundZ)

            end
        end

        ::continue::
    end

    if bestPoint and bestScore > 0 then
        return bestPoint
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local headingRad = math.rad(playerHeading)
    local forwardX = playerCoords.x + 5.0 * math.sin(-headingRad)
    local forwardY = playerCoords.y + 5.0 * math.cos(-headingRad)

    local success, groundZ = GetGroundZFor_3dCoord(forwardX, forwardY, playerCoords.z, true)

    if success then
        return vector3(forwardX, forwardY, groundZ)
    end

    return vector3(playerCoords.x, playerCoords.y, playerCoords.z)
end

function generateDestination(startCoords)

    local popularDestinations = {

        {
            x = 311.9,
            y = -278.5,
            z = 54.1,
        },
        {
            x = -55.0,
            y = -1096.5,
            z = 26.4,
        },
        {
            x = 230.0,
            y = -870.0,
            z = 30.5,
        },
        {
            x = -823.0,
            y = -122.0,
            z = 28.0,
        },
        {
            x = -1370.0,
            y = -503.0,
            z = 33.0,
        },
        {
            x = 313.0,
            y = -1090.0,
            z = 29.0,
        },
        {
            x = 380.0,
            y = -355.0,
            z = 48.0,
        },

        {
            x = 46.0,
            y = -1754.0,
            z = 29.0,
        },
        {
            x = -707.0,
            y = -914.0,
            z = 19.0,
        },
        {
            x = -148.0,
            y = -1040.0,
            z = 27.0,
        },

        {
            x = -1022.0,
            y = -2729.0,
            z = 13.7,
        },
        {
            x = -1615.0,
            y = -1041.0,
            z = 13.0,
        },
        {
            x = -1893.0,
            y = -560.0,
            z = 11.8,
        },
        {
            x = -1658.3,
            y = -984.2,
            z = 13.1,
        },

        {
            x = 1992.0,
            y = 3741.0,
            z = 32.0,
        },
        {
            x = 1851.0,
            y = 3683.0,
            z = 34.0,
        },

        {
            x = -5.0,
            y = 6520.0,
            z = 31.0,
        },
        {
            x = -449.0,
            y = 6007.0,
            z = 31.0,
        },
    }

    local usePopularDestination = (math.random(1, 100) <= 70)

    if usePopularDestination then

        local destination = popularDestinations[math.random(1, #popularDestinations)]

        local posX = destination.x + math.random(-20, 20)
        local posY = destination.y + math.random(-20, 20)

        local success, groundZ = GetGroundZFor_3dCoord(posX, posY, destination.z, false)

        if success then

            local waterTest, waterHeight = GetWaterHeight(posX, posY, groundZ)
            if not waterTest then
                return vector3(posX, posY, groundZ)
            end
        end
    end

    local minDistance = taxiConfig["passengers"].minDistance
    local maxDistance = taxiConfig["passengers"].maxDistance

    for attempt = 1, 15 do

        local angle = math.random() * 2 * math.pi
        local distance = math.random(minDistance, maxDistance)

        local x = startCoords.x + distance * math.cos(angle)
        local y = startCoords.y + distance * math.sin(angle)

        local success, groundZ = GetGroundZFor_3dCoord(x, y, 800.0, false)

        if success then

            local waterTest, waterHeight = GetWaterHeight(x, y, groundZ)

            local isOnRoad = IsPointOnRoad(x, y, groundZ, 0)
            local roadFound, roadPosition = GetClosestVehicleNode(x, y, groundZ, vector3(0, 0, 0), 1, 3.0, 0)

            local notInWater = not waterTest
            if waterTest and type(groundZ) == "number" and type(waterHeight) == "number" then
                notInWater = groundZ > waterHeight + 1.0
            end

            if notInWater and roadFound then
                local roadDistance = #(vector3(x, y, groundZ) - roadPosition)

                if isOnRoad then
                    x = x + math.random(-5, 5)
                    y = y + math.random(-5, 5)
                    success, groundZ = GetGroundZFor_3dCoord(x, y, 100.0, false)
                    if not success then
                        goto continue
                    end
                end

                local cast = StartShapeTestRay(x, y, groundZ + 0.5, x, y, groundZ + 15.0, 1, 0, 0)
                local _, hit, _, _, _ = GetShapeTestResult(cast)

                if hit == 0 then
                    return vector3(x, y, groundZ)
                end
            end
        end

        ::continue::
    end

    return vector3(215.0, -810.0, 30.0)
end

function calculateEstimatedFare(startPoint, endPoint)
    local distance = #(startPoint - endPoint)
    local baseFare = taxiConfig["fares"].baseFare
    local perMeter = taxiConfig["fares"].perMeter
    local estimatedFare = baseFare + (distance * perMeter)

    return math.floor(estimatedFare / 10) * 10
end

function monitorTaxiJob()
    local waypointBlip = nil
    local destinationBlip = nil

    SetNewWaypoint(currentJob.passengerCoords.x, currentJob.passengerCoords.y)

    destinationBlip = AddBlipForCoord(currentJob.destinationCoords.x, currentJob.destinationCoords.y,
        currentJob.destinationCoords.z)
    SetBlipSprite(destinationBlip, 162)
    SetBlipColour(destinationBlip, 5)
    SetBlipScale(destinationBlip, 0.8)
    SetBlipRoute(destinationBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destination")
    EndTextCommandSetBlipName(destinationBlip)

    function removeBlip()
        RemoveBlip(destinationBlip)
    end

    while currentJob and currentJob.type == "pickup" do
        Wait(1000)

        local playerPed = PlayerPedId()
        if not IsPedInAnyTaxi(playerPed) or not exports.bach_legalJobs:getDutyStatus() then
            cancelCurrentJob("Du forlod taxaen eller gik af vagt")
            if destinationBlip then
                RemoveBlip(destinationBlip)
            end
            return
        end

        local timeElapsed = (GetGameTimer() - currentJob.startTime) / 1000
        local cancelChance = timeElapsed / 60 * taxiConfig["customers"].cancelChance

        if math.random(1, 100) < cancelChance then
            cancelCurrentJob("Passageren blev træt af at vente")
            if destinationBlip then
                RemoveBlip(destinationBlip)
            end
            return
        end

        if timeElapsed > taxiConfig["customers"].maxWaitTime then
            cancelCurrentJob("Passageren blev træt af at vente")
            if destinationBlip then
                RemoveBlip(destinationBlip)
            end
            return
        end

        local playerCoords = GetEntityCoords(playerPed)
        local passengerCoords = GetEntityCoords(currentJob.passenger)
        local distance = #(vector2(playerCoords.x, playerCoords.y) - vector2(passengerCoords.x, passengerCoords.y))

        lib.showTextUI("Kør til passageren (" .. math.floor(distance) .. "m)", {
            position = "top-center",
            icon = "fas fa-user",
        })

        if distance <= taxiConfig["customers"].pickupRadius then

            lib.hideTextUI()

            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if not vehicle or vehicle == 0 then
                cancelCurrentJob("Du forlod taxaen")
                if destinationBlip then
                    RemoveBlip(destinationBlip)
                end
                return
            end

            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local hasEmptySeat = false
            local emptySeatIndex = -1

            for i = 0, maxSeats - 1 do
                if IsVehicleSeatFree(vehicle, i) then
                    hasEmptySeat = true
                    emptySeatIndex = i
                    break
                end
            end

            if not hasEmptySeat then
                cancelCurrentJob("Der er ikke plads til passageren i taxaen")
                if destinationBlip then
                    RemoveBlip(destinationBlip)
                end
                return
            end

            currentJob.type = "driving"
            currentJob.startTime = GetGameTimer()

            RemoveBlip(currentJob.blip)

            ClearPedTasksImmediately(currentJob.passenger)
            TaskEnterVehicle(currentJob.passenger, vehicle, -1, emptySeatIndex, 1.0, 1, 0)

            local enterTimeout = 0
            local passengerEntered = false

            lib.notify({
                title = "Taxaservice",
                description = "Passageren stiger ind i taxaen...",
                type = "info",
                icon = "fas fa-taxi",
            })

            while not passengerEntered and enterTimeout < 150 do
                Wait(100)
                enterTimeout = enterTimeout + 1

                if not DoesEntityExist(currentJob.passenger) then
                    break
                elseif IsPedInVehicle(currentJob.passenger, vehicle, false) then
                    passengerEntered = true
                    break
                end

            end

            if not DoesEntityExist(currentJob.passenger) then
                cancelCurrentJob("Passageren forsvandt")
                if destinationBlip then
                    RemoveBlip(destinationBlip)
                end
                return
            end

            if not passengerEntered then

                if DoesEntityExist(currentJob.passenger) then
                    ClearPedTasksImmediately(currentJob.passenger)
                    Wait(100)
                    TaskWarpPedIntoVehicle(currentJob.passenger, vehicle, emptySeatIndex)
                    Wait(500)

                    if not IsPedInVehicle(currentJob.passenger, vehicle, false) then
                        cancelCurrentJob("Passageren kunne ikke stige ind i taxaen")
                        if destinationBlip then
                            RemoveBlip(destinationBlip)
                        end
                        return
                    end
                end
            end

            SetBlipRoute(destinationBlip, true)
            currentJob.blip = destinationBlip

            lib.notify({
                title = "Taxaservice",
                description = "Passageren er inde i taxaen. Kør til destinationen.",
                type = "success",
                icon = "fas fa-route",
            })

            if not meterActive then
                lib.notify({
                    title = "Taxameter",
                    description = "Husk at starte taxameteret (tryk " .. taxiConfig["meterToggleKey"] .. ")",
                    type = "info",
                    icon = "fas fa-money-bill-wave",
                })
            end
        end
    end

    local loopCount = 0

    while currentJob and currentJob.type == "driving" do

        loopCount = loopCount + 1

        Wait(1000)

        local playerPed = PlayerPedId()
        if not IsPedInAnyTaxi(playerPed) or not exports.bach_legalJobs:getDutyStatus() then
            cancelCurrentJob("Du forlod taxaen eller gik af vagt")
            return
        end

        if not DoesEntityExist(currentJob.passenger) or not IsPedInAnyVehicle(currentJob.passenger, false) then
            cancelCurrentJob("Passageren forlod taxaen")
            return
        end

        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(vector2(playerCoords.x, playerCoords.y) -
                             vector2(currentJob.destinationCoords.x, currentJob.destinationCoords.y))

        lib.showTextUI("Kør til destinationen (" .. math.floor(distance) .. "m)", {
            position = "top-center",
            icon = "fas fa-map-marker-alt",
        })

        local shouldDropOff = distance <= taxiConfig["customers"].dropoffRadius

        if distance <= (taxiConfig["customers"].dropoffRadius - 5.0) then

            shouldDropOff = true
        end

        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and distance <= (taxiConfig["customers"].dropoffRadius + 5.0) and GetEntitySpeed(vehicle) < 1.0 then

            shouldDropOff = true
        end

        if currentJob and currentJob.forceDropOff then

            shouldDropOff = true
            currentJob.forceDropOff = nil
        end

        if shouldDropOff then

            lib.hideTextUI()

            lib.notify({
                title = "Taxaservice",
                description = "Du har nået destinationen!",
                type = "success",
                icon = "fas fa-map-marker-alt",
            })

            local vehicle = GetVehiclePedIsIn(playerPed, false)

            local speed = GetEntitySpeed(vehicle)
            if speed > 0.5 then
                lib.notify({
                    title = "Taxaservice",
                    description = "Stop køretøjet for at afsætte passageren",
                    type = "info",
                    icon = "fas fa-taxi",
                })

                while GetEntitySpeed(vehicle) > 0.5 do
                    Wait(100)
                    if not DoesEntityExist(currentJob.passenger) then
                        break
                    end
                end
            end

            if DoesEntityExist(currentJob.passenger) and IsPedInVehicle(currentJob.passenger, vehicle, false) then

                TaskLeaveVehicle(currentJob.passenger, vehicle, 1)
                Wait(500)

                local timeout = 0
                while IsPedInVehicle(currentJob.passenger, vehicle, false) and timeout < 50 do
                    Wait(100)
                    timeout = timeout + 1

                end

                if IsPedInVehicle(currentJob.passenger, vehicle, false) then

                    ClearPedTasksImmediately(currentJob.passenger)
                    TaskLeaveVehicle(currentJob.passenger, vehicle, 16)
                    Wait(500)

                    timeout = 0
                    while IsPedInVehicle(currentJob.passenger, vehicle, false) and timeout < 20 do
                        Wait(100)
                        timeout = timeout + 1
                    end

                    if IsPedInVehicle(currentJob.passenger, vehicle, false) then

                        ClearPedTasks(currentJob.passenger)
                        ClearPedTasksImmediately(currentJob.passenger)

                        local exitPos = GetOffsetFromEntityInWorldCoords(vehicle, 1.0, 0.0, 0.0)
                        SetEntityCoords(currentJob.passenger, exitPos.x, exitPos.y, exitPos.z, false, false, false,
                            false)

                        Wait(100)

                        SetPedToRagdoll(currentJob.passenger, 1000, 1000, 0, 0, 0, 0)
                        Wait(1000)
                        ClearPedTasks(currentJob.passenger)
                    end
                end

                if not IsPedInVehicle(currentJob.passenger, vehicle, false) then

                else

                    lib.notify({
                        title = "Taxaservice",
                        description = "Passageren kunne ikke forlade køretøjet, men turen afsluttes alligevel",
                        type = "error",
                        icon = "fas fa-exclamation-triangle",
                    })
                end
            end

            if DoesEntityExist(currentJob.passenger) and not IsPedInVehicle(currentJob.passenger, vehicle, false) then
                Wait(500)

                local forward = GetEntityForwardVector(currentJob.passenger)
                forward = vector3(forward.x + math.random(-30, 30) / 100, forward.y + math.random(-30, 30) / 100, 0.0)

                local passengerPos = GetEntityCoords(currentJob.passenger)
                local walkCoords = passengerPos + forward * 100.0

                ClearPedTasks(currentJob.passenger)
                TaskGoStraightToCoord(currentJob.passenger, walkCoords.x, walkCoords.y, passengerPos.z, 1.0, -1, 0.0,
                    0.0)

            end

            if currentJob.blip then
                RemoveBlip(currentJob.blip)
                currentJob.blip = nil
            end

            if meterActive then
                toggleTaxiMeter()
            else
                local randomMultiplier = math.random(90, 110) / 100
                currentFare = math.floor(currentJob.estimatedFare * randomMultiplier)

                exports.bach_legalJobs:openPaymentOptions(currentFare)
            end

            CreateThread(function()

                Wait(5000)
                if currentJob and currentJob.passenger and DoesEntityExist(currentJob.passenger) then
                    DeletePed(currentJob.passenger)
                end
                currentJob = nil
                lib.notify({
                    title = "Taxaservice",
                    description = "Turen er afsluttet. Klar til næste passager!",
                    type = "success",
                    icon = "fas fa-taxi",
                })
            end)

            lib.callback.await("bach_taxijob:updateStats", false, {
                distance = #(currentJob.passengerCoords - currentJob.destinationCoords),
                fare = currentFare,
            })

            CreateThread(function()
                Wait(7000)
                if currentJob and currentJob.type == "complete" then

                    if currentJob.passenger and DoesEntityExist(currentJob.passenger) then
                        DeletePed(currentJob.passenger)
                    end
                    if currentJob.blip then
                        RemoveBlip(currentJob.blip)
                    end
                    currentJob = nil
                    lib.hideTextUI()
                end
            end)

            break
        end
    end
end

RegisterCommand("canceltaxi", function()
    if currentJob then
        cancelCurrentJob("Du annullerede turen")
    end
end, false)

RegisterKeyMapping("canceltaxi", "Annuller taxatur", "keyboard", "F7")

RegisterCommand("afsluttur", function()
    if currentJob and currentJob.type == "driving" then
        currentJob.forceDropOff = true
        lib.notify({
            title = "Taxi",
            description = "Tur afsluttes ved næste stop",
            type = "success",
        })
    else
        lib.notify({
            title = "Taxi",
            description = "Du har ingen aktiv taxatur",
            type = "error",
        })
    end
end, false)

exports("getCurrentJobData", function()
    return currentJob
end)

exports("setCurrentJobData", function(data)
    if data == nil then
        removeBlip()
    end

    currentJob = data
end)

RegisterNetEvent("bach_taxijob:cancelPassenger")
AddEventHandler("bach_taxijob:cancelPassenger", function(reason)
    if currentJob then
        cancelCurrentJob(reason or "Du annullerede turen")
    else
        lib.notify({
            title = "Taxaservice",
            description = "Du har ingen aktiv tur at annullere",
            type = "error",
            icon = "fas fa-times",
        })
    end
end)

