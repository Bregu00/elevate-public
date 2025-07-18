local minerConfig = lib.load("shared.jobs.miner")

for _, location in pairs(minerConfig["shopLocation"].locations) do
    local blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip, minerConfig["shopLocation"].blip.id)
    SetBlipColour(blip, minerConfig["shopLocation"].blip.colour)
    SetBlipScale(blip, minerConfig["shopLocation"].blip.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(minerConfig["shopLocation"].name)
    EndTextCommandSetBlipName(blip)
end

local startLoc = minerConfig["startLocation"].ped.loc
local startBlip = AddBlipForCoord(startLoc.x, startLoc.y, startLoc.z)
SetBlipSprite(startBlip, minerConfig["startLocation"].blip.id)
SetBlipColour(startBlip, minerConfig["startLocation"].blip.colour)
SetBlipScale(startBlip, minerConfig["startLocation"].blip.scale)
SetBlipAsShortRange(startBlip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString(minerConfig["startLocation"].blip.label)
EndTextCommandSetBlipName(startBlip)

CreateThread(function()
    for _, target in pairs(minerConfig["shopLocation"].targets) do
        local model = target.ped
        lib.requestModel(model, 10000)
        local ped = CreatePed(4, model, target.loc.x, target.loc.y, target.loc.z, target.heading, false, false)
        SetEntityHeading(ped, target.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, target.scenario, 0, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = "miner_shop",
                icon = "fas fa-shopping-basket",
                label = "Åbn " .. minerConfig["shopLocation"].name,
                distance = 2.0,
                groups = {
                    miner = 0,
                },
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", {
                        type = "miner_shop",
                        id = 1,
                    })
                end,
            },
        })
    end
end)

CreateThread(function()
    local startPed = minerConfig["startLocation"].ped
    lib.requestModel(startPed.model, 10000)

    local ped = CreatePed(4, GetHashKey(startPed.model), startPed.loc.x, startPed.loc.y, startPed.loc.z, startPed.loc.w,
        false, false)
    SetEntityHeading(ped, startPed.loc.w)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, startPed.scenario, 0, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "mining_info",
            icon = "fas fa-info-circle",
            label = "Få information om minedrift",
            distance = 2.0,
            onSelect = function()
                local playerJob = ESX.GetPlayerData().job

                if playerJob.name ~= "miner" then
                    lib.notify({
                        title = "Minearbejde",
                        description = "Du skal være ansat som minearbejder for at få mere information. Gå til Byrået for at ansøge om jobbet.",
                        type = "info",
                        icon = "fas fa-hard-hat",
                    })
                    return
                end

                lib.showContext("miner_info_menu")
            end,
        },
        {
            name = "mine_location",
            icon = "fas fa-hammer",
            label = "Begynd at mine",
            distance = 2.0,
            groups = {
                miner = 0,
            },
            onSelect = function()
                local playerPos = GetEntityCoords(PlayerPedId())
                local closestLocation = nil
                local minDist = 1000.0

                for _, location in pairs(minerConfig["mineLocations"]) do
                    local dist = #(playerPos - location.coords)
                    if dist < minDist then
                        minDist = dist
                        closestLocation = location
                    end
                end

                if closestLocation then
                    exports.bach_legalJobs:startMining(closestLocation)
                else
                    lib.notify({
                        title = "Minearbejde",
                        description = "Ingen minelokation fundet i nærheden.",
                        type = "error",
                        icon = "fas fa-hard-hat",
                    })
                end
            end,
            canInteract = function()
                return not _G.isMiningActive
            end,
        },
        {
            name = "stop_mining",
            icon = "fas fa-stop-circle",
            label = "Stop minearbejde",
            distance = 2.0,
            groups = {
                miner = 0,
            },
            canInteract = function()
                return _G.isMiningActive
            end,
            onSelect = function()
                exports.bach_legalJobs:stopMining(true)
            end,
        },
    })

    lib.registerContext({
        id = "miner_info_menu",
        title = "Minearbejder Information",
        options = {
            {
                title = "Mineområder",
                description = "Information om hvor du kan mine",
                icon = "fas fa-map-marker-alt",
                onSelect = function()
                    local mineLocationsOptions = {}

                    for i, location in pairs(minerConfig["mineLocations"]) do
                        table.insert(mineLocationsOptions, {
                            title = location.label,
                            description = "Sæt et waypoint til denne lokation",
                            icon = "fas fa-map-marker-alt",
                            iconColor = "#" .. location.blip.color,
                            onSelect = function()
                                SetNewWaypoint(location.coords.x, location.coords.y)
                                lib.notify({
                                    title = "Waypoint sat",
                                    description = "Waypoint sat til " .. location.label,
                                    type = "success",
                                    icon = "fas fa-map-marker-alt",
                                })
                                Wait(500)
                                lib.showContext("mine_locations_menu")
                            end,
                        })
                    end

                    lib.registerContext({
                        id = "mine_locations_menu",
                        title = "Mine Lokationer",
                        menu = "miner_info_menu",
                        options = mineLocationsOptions,
                        arrow = true,
                    })

                    lib.showContext("mine_locations_menu")
                end,
            },
            {
                title = "Sikkerhed",
                description = "Bær altid minerhjelm i farlige områder.\nHold afstand til andre minearbejdere.\nKontakt en mester hvis du oplever problemer.",
                icon = "fas fa-shield-alt",
            },
            {
                title = "Udstyr",
                description = "Du skal bruge en hakke for at mine.\nEn minerhjelm er påkrævet i nogle områder for din sikkerhed.\nDu kan købe alt udstyr i minebutikken.",
                icon = "fas fa-tools",
            },
        },
    })
end)

