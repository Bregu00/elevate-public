local minerConfig = lib.load("shared.jobs.miner")
_G.isMiningActive = false
local currentMiningData = {
    totalReward = {},
    markers = {},
    blips = {},
    spotsToMine = 0,
    completedSpots = 0,
}

local pickaxeProp = {
    model = "prop_tool_pickaxe",
    bone = 57005,
    pos = vec3(0.09, -0.02, -0.03),
    rot = vec3(300.0, 180.0, 40.0),
}

local hammerProp = {
    model = "prop_tool_hammer",
    bone = 57005,
    pos = vec3(0.13, 0.0, 0.02),
    rot = vec3(90.0, 270.0, 80.0),
}

local miningAnims = {
    {
        dict = "melee@large_wpn@streamed_core",
        clip = "ground_attack_0",
    },
    {
        dict = "melee@large_wpn@streamed_core",
        clip = "ground_attack_1",
    },
    {
        dict = "amb@world_human_hammering@male@base",
        clip = "base",
    },
    {
        dict = "amb@world_human_const_drill@male@drill@base",
        clip = "base",
    },
}

local function getRandomMiningSpots(centerCoords, count, radius)
    local spots = {}
    for i = 1, count do
        local angle = math.rad((i - 1) * (360 / count))
        local offsetX = math.cos(angle) * (radius * (0.5 + math.random() * 0.5))
        local offsetY = math.sin(angle) * (radius * (0.5 + math.random() * 0.5))

        local spotType = (math.random() > 0.5) and "wall" or "ground"

        table.insert(spots, {
            coords = vector3(centerCoords.x + offsetX, centerCoords.y + offsetY, centerCoords.z),
            type = spotType,
            mined = false,
        })
    end
    return spots
end

local function cleanupMining(markers, blips)
    if markers then
        for _, marker in ipairs(markers) do
            if DoesEntityExist(marker) then
                DeleteObject(marker)
            end
        end
    end

    if blips then
        for _, blip in ipairs(blips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end

    lib.hideTextUI()

    _G.isMiningActive = false

    currentMiningData = {
        totalReward = {},
        markers = {},
        blips = {},
        spotsToMine = 0,
        completedSpots = 0,
    }
end

function stopMining(collectRewards)
    if not _G.isMiningActive then
        lib.notify({
            description = "Du er ikke i gang med at mine.",
            type = "error",
            icon = "fas fa-exclamation-circle",
        })
        return
    end

    lib.notify({
        description = "Du afbrød mineprocessen.",
        type = "info",
        icon = "fas fa-info-circle",
    })

    if collectRewards and next(currentMiningData.totalReward) ~= nil then
        lib.notify({
            title = "Mining Afbrudt",
            description = "Du afbrød mineprocessen, men beholdt ressourcerne du havde indsamlet (" ..
                currentMiningData.completedSpots .. "/" .. currentMiningData.spotsToMine .. " punkter).",
            type = "error",
            icon = "fas fa-check-circle",
        })

        exports.bach_legalJobs:debugPrint("Sending partial rewards to server: " ..
                                              json.encode(currentMiningData.totalReward))

        lib.callback.await("bach_legalJobs:giveMinedItems", false, currentMiningData.totalReward)
    end

    cleanupMining(currentMiningData.markers, currentMiningData.blips)
    return true
end

local function startMining(location)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local usingPickaxe = false
    local usingHammer = false

    if _G.isMiningActive then
        lib.notify({
            description = "Du er allerede i gang med at mine.",
            type = "error",
            icon = "fas fa-exclamation-circle",
        })
        return
    end

    if not exports.bach_legalJobs:hasItem("pickaxe") or not exports.bach_legalJobs:hasItem("hammer") then
        lib.notify({
            description = "Du har ikke en hakke eller en hammer.",
            type = "error",
            icon = "fas fa-hammer",
        })
        return
    end

    if exports.bach_legalJobs:hasItem("pickaxe") then
        usingPickaxe = true
    end

    if exports.bach_legalJobs:hasItem("hammer") then
        usingHammer = true
    end

    if not usingPickaxe and not usingHammer then
        lib.notify({
            description = "Du har ikke en hakke eller en hammer.",
            type = "error",
            icon = "fas fa-hammer",
        })
        return
    end

    if location.allowOnlyWhenWearingHelmet and not exports.bach_legalJobs:isPlayerWearingHelmet() then
        lib.notify({
            description = "Du skal have en minerhat på for at kunne mine her.",
            type = "error",
            icon = "fas fa-hat-hard",
        })
        return
    end

    _G.isMiningActive = true

    local miningSpots = {}
    local spotsToMine = 0

    if location.locations and #location.locations > 0 then
        for i, spot in ipairs(location.locations) do
            table.insert(miningSpots, {
                coords = vector3(spot.coords.x, spot.coords.y, spot.coords.z),
                heading = spot.coords.w,
                type = spot.type,
                mined = false,
            })
            spotsToMine = spotsToMine + 1
        end
    else
        spotsToMine = math.random(3, 5)
        miningSpots = getRandomMiningSpots(location.coords, spotsToMine, 2.0)
    end

    local completedSpots = 0
    local totalReward = {}
    local markers = {}
    local blips = {}

    currentMiningData = {
        totalReward = totalReward,
        markers = markers,
        blips = blips,
        spotsToMine = spotsToMine,
        completedSpots = completedSpots,
    }

    if #miningSpots == 0 or spotsToMine == 0 then
        lib.notify({
            description = "Der er ingen minepunkter at finde i dette område.",
            type = "error",
            icon = "fas fa-exclamation-circle",
        })
        cleanupMining(markers, blips)
        return
    end

    lib.notify({
        description = "Du begynder at mine. Find " .. spotsToMine .. " steder at hakke.",
        type = "info",
        icon = "fas fa-info-circle",
    })

    for i, spot in ipairs(miningSpots) do

        local propModel = "prop_rock_5_smash1"
        if spot.type == "wall" then
            propModel = "prop_rock_5_smash1"
        elseif spot.type == "ground" then
            propModel = "prop_rock_5_smash2"
        end

        local marker = CreateObject(GetHashKey(propModel), spot.coords.x, spot.coords.y, spot.coords.z - 0.9, false,
            true, false)
        if spot.heading then
            SetEntityHeading(marker, spot.heading)
        end
        SetEntityAlpha(marker, 200, false)
        FreezeEntityPosition(marker, true)
        table.insert(markers, marker)

        local blip = AddBlipForCoord(spot.coords.x, spot.coords.y, spot.coords.z)
        SetBlipSprite(blip, 618)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Minepunkt")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

    local lastActivityTime = GetGameTimer()
    local maxIdleTime = 60000

    while completedSpots < spotsToMine do

        if GetGameTimer() - lastActivityTime > maxIdleTime then
            lib.notify({
                description = "Du har været inaktiv for længe. Mineprocessen er afsluttet.",
                type = "error",
                icon = "fas fa-clock",
            })
            cleanupMining(markers, blips)
            return
        end

        local nearestSpot = nil
        local nearestDist = 999.0

        playerCoords = GetEntityCoords(playerPed)
        for i, spot in ipairs(miningSpots) do
            if not spot.mined then
                local dist = #(playerCoords - spot.coords)
                if dist < nearestDist and dist < 1.5 then
                    nearestDist = dist
                    nearestSpot = i
                    lastActivityTime = GetGameTimer()
                end
            end
        end

        if nearestSpot then

            lib.showTextUI("Tryk [E] for at mine på dette punkt")

            if IsControlJustPressed(0, 38) then
                lastActivityTime = GetGameTimer()
                lib.hideTextUI()

                local anim
                local spotType = miningSpots[nearestSpot].type

                if spotType == "wall" then
                    exports.bach_legalJobs:debugPrint("Using wall mining animation for spot " .. nearestSpot)
                    anim = {
                        dict = "amb@world_human_hammering@male@base",
                        clip = "base",
                        flags = 1,
                    }
                elseif spotType == "ground" then
                    exports.bach_legalJobs:debugPrint("Using ground mining animation for spot " .. nearestSpot)
                    anim = {
                        dict = "melee@large_wpn@streamed_core",
                        clip = "ground_attack_0",
                        flags = 1,
                    }
                else
                    exports.bach_legalJobs:debugPrint("No valid spot type found for mining spot " .. nearestSpot)
                    local randomAnim = miningAnims[math.random(1, #miningAnims)]
                    anim = {
                        dict = randomAnim.dict,
                        clip = randomAnim.clip,
                        flags = 1,
                    }
                end

                local duration = math.random(5000, 8000)
                if usingHammer and usingPickaxe then
                    duration = math.random(4000, 6000)
                end

                if lib.progressBar({
                    duration = duration,
                    label = "Miner punkt " .. completedSpots + 1 .. "/" .. spotsToMine,
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = anim.dict,
                        clip = anim.clip,
                        flags = anim.flags,
                    },
                    prop = usingPickaxe and pickaxeProp or hammerProp,
                }) then

                    miningSpots[nearestSpot].mined = true
                    completedSpots = completedSpots + 1
                    currentMiningData.completedSpots = completedSpots
                    lastActivityTime = GetGameTimer()

                    local coords = miningSpots[nearestSpot].coords

                    DeleteObject(markers[nearestSpot])
                    markers[nearestSpot] = CreateObject(GetHashKey("prop_rock_5_smash3"), coords.x, coords.y,
                        coords.z - 0.9, false, true, false)
                    SetEntityAlpha(markers[nearestSpot], 150, false)

                    SetBlipColour(blips[nearestSpot], 3)
                    SetBlipScale(blips[nearestSpot], 0.5)

                    local spotReward = processMiningReward(usingPickaxe, usingHammer)

                    for item, count in pairs(spotReward) do
                        totalReward[item] = (totalReward[item] or 0) + count
                        currentMiningData.totalReward[item] = totalReward[item]
                    end

                    if math.random(1, 100) <= 8 then
                        triggerRandomMiningEvent(usingPickaxe, usingHammer)
                    end

                    if completedSpots < spotsToMine then
                        lib.notify({
                            description = "Du har minet " .. completedSpots .. " ud af " .. spotsToMine .. " punkter.",
                            type = "info",
                            icon = "fas fa-info-circle",
                        })
                    end
                else
                    lib.hideTextUI()
                    lib.notify({
                        description = "Du afbrød mineprocessen.",
                        type = "error",
                        icon = "fas fa-ban",
                    })
                    cleanupMining(markers, blips)
                    break
                end
            end
        else
            lib.hideTextUI()
        end

        Wait(0)
    end

    for _, marker in ipairs(markers) do
        DeleteObject(marker)
    end

    for _, blip in ipairs(blips) do
        RemoveBlip(blip)
    end

    if completedSpots == spotsToMine then
        lib.notify({
            title = "Mining Komplet!",
            description = "Du har minet alle punkter og fundet ressourcer!",
            type = "success",
            icon = "fas fa-check-circle",
        })

        exports.bach_legalJobs:debugPrint("Sending total rewards to server: " .. json.encode(totalReward))

        lib.callback.await("bach_legalJobs:giveMinedItems", false, totalReward)
    end

    cleanupMining(markers, blips)
end

function processMiningReward(usingPickaxe, usingHammer)
    local luckRoll = math.random(1, 100)
    local reward = {}

    reward.stone = math.random(1, 3)

    if minerConfig["miningRewards"] then

        if luckRoll <= 10 then
            if minerConfig["miningRewards"]["rareRewards"] and #minerConfig["miningRewards"]["rareRewards"] > 0 then

                local rewardConfig = minerConfig["miningRewards"]["rareRewards"][math.random(1,
                    #minerConfig["miningRewards"]["rareRewards"])]

                if rewardConfig and rewardConfig.item then
                    local amount = math.random(rewardConfig.min or 1, rewardConfig.max or 3)

                    if usingPickaxe and usingHammer then
                        amount = amount + math.random(1, 2)
                    end

                    reward[rewardConfig.item] = amount

                    lib.notify({
                        description = rewardConfig.label or "Jackpot! Du fandt sjældne ressourcer!",
                        type = "success",
                        icon = "fas fa-coins",
                    })
                end

                exports.bach_legalJobs:debugPrint("Jackpot reward generated: " .. json.encode(reward))
            else

                reward.stone = (reward.stone or 0) + math.random(2, 4)

                lib.notify({
                    description = "Du fandt ekstra ressourcer!",
                    type = "success",
                    icon = "fas fa-coins",
                })

                exports.bach_legalJobs:debugPrint(
                    "Warning: Using fallback for rare rewards because rareRewards config is missing")
            end
        else

            if minerConfig["miningRewards"]["normalRewards"] and #minerConfig["miningRewards"]["normalRewards"] > 0 then

                local rewardConfig = minerConfig["miningRewards"]["normalRewards"][math.random(1,
                    #minerConfig["miningRewards"]["normalRewards"])]

                if rewardConfig and rewardConfig.item then
                    local amount = math.random(rewardConfig.min or 1, rewardConfig.max or 3)

                    if usingPickaxe and usingHammer then
                        amount = amount + 1
                    end

                    reward[rewardConfig.item] = amount

                    if rewardConfig.item ~= "stone" then
                        lib.notify({
                            description = rewardConfig.label or "Du fandt " .. rewardConfig.item .. "!",
                            type = "success",
                            icon = "fas fa-cubes",
                        })
                    end
                end
            else

                reward.stone = (reward.stone or 0) + math.random(1, 2)
                exports.bach_legalJobs:debugPrint(
                    "Warning: Using fallback for normal rewards because normalRewards config is missing")
            end
        end
    else

        reward.stone = (reward.stone or 0) + math.random(1, 3)
        exports.bach_legalJobs:debugPrint("Warning: No miningRewards section found in config, using minimal fallback")
    end

    if math.random(1, 100) <= 3 then
        if minerConfig["miningRewards"] and minerConfig["miningRewards"]["surpriseItems"] and
            #minerConfig["miningRewards"]["surpriseItems"] > 0 then

            local surpriseConfig = minerConfig["miningRewards"]["surpriseItems"][math.random(1,
                #minerConfig["miningRewards"]["surpriseItems"])]

            if surpriseConfig and surpriseConfig.item then
                reward[surpriseConfig.item] = surpriseConfig.amount or 1

                lib.notify({
                    description = surpriseConfig.label or "Du fandt noget specielt!",
                    type = "success",
                    icon = "fas fa-exclamation-circle",
                })
            end
        else

            local defaultItemName = "stone"
            reward[defaultItemName] = (reward[defaultItemName] or 0) + 1

            lib.notify({
                description = "Du fandt noget specielt!",
                type = "success",
                icon = "fas fa-exclamation-circle",
            })

            exports.bach_legalJobs:debugPrint(
                "Warning: Using fallback for surprise items because surpriseItems config is missing")
        end
    end

    exports.bach_legalJobs:debugPrint("Mining reward generated: " .. json.encode(reward))
    return reward
end

function triggerRandomMiningEvent(usingPickaxe, usingHammer)
    local events = {
        {
            name = "tool_damage",
            chance = 40,
            handler = function()
                local saveToolSuccess = lib.skillCheck({
                    "hard",
                }, {
                    "e",
                })

                if not saveToolSuccess then
                    if usingPickaxe then
                        lib.callback.await("bach_legalJobs:damageTool", false, "pickaxe")
                        lib.notify({
                            description = "Din hakke ramte en hård klippe og blev beskadiget!",
                            type = "error",
                            icon = "fas fa-hammer",
                        })
                    end
                else
                    lib.notify({
                        description = "Du reddede dit værktøj fra at blive beskadiget!",
                        type = "success",
                        icon = "fas fa-check-circle",
                    })
                end
            end,
        },
        {
            name = "rock_slide",
            chance = 30,
            handler = function()
                lib.notify({
                    description = "Der er et lille stenskred! Spring til side!",
                    type = "warning",
                    icon = "fas fa-exclamation-triangle",
                })

                local startTime = GetGameTimer()
                local moved = false

                lib.showTextUI("Bevæg dig hurtigt væk fra dette sted!")

                local initialPos = GetEntityCoords(PlayerPedId())

                while GetGameTimer() - startTime < 2000 do
                    local currentPos = GetEntityCoords(PlayerPedId())
                    if #(initialPos - currentPos) > 1.0 then
                        moved = true
                        break
                    end
                    Wait(100)
                end

                lib.hideTextUI()

                if moved then
                    lib.notify({
                        description = "Du undgik stenfaldet!",
                        type = "success",
                        icon = "fas fa-running",
                    })
                else

                    lib.notify({
                        description = "Du blev ramt af faldende sten!",
                        type = "error",
                        icon = "fas fa-heart",
                    })

                    local health = GetEntityHealth(PlayerPedId())
                    SetEntityHealth(PlayerPedId(), health - 10)
                end
            end,
        },
        {
            name = "bonus_find",
            chance = 30,
            handler = function()
                local reward = {}
                if minerConfig["miningRewards"] and minerConfig["miningRewards"]["bonusItems"] and
                    #minerConfig["miningRewards"]["bonusItems"] > 0 then

                    local bonusConfig = minerConfig["miningRewards"]["bonusItems"][math.random(1,
                        #minerConfig["miningRewards"]["bonusItems"])]

                    if bonusConfig and bonusConfig.item then
                        reward[bonusConfig.item] = bonusConfig.amount or 1

                        lib.notify({
                            description = bonusConfig.label or "Du fandt en åre med ekstra ressourcer!",
                            type = "success",
                            icon = "fas fa-gem",
                        })
                    end
                else

                    reward.stone = math.random(2, 5)

                    lib.notify({
                        description = "Du fandt en åre med ekstra ressourcer!",
                        type = "success",
                        icon = "fas fa-gem",
                    })

                    exports.bach_legalJobs:debugPrint(
                        "Warning: Using fallback for bonus items because bonusItems config is missing")
                end

                lib.callback.await("bach_legalJobs:giveMinedItems", false, reward)
            end,
        },
    }

    local eventChances = {}
    for i, event in ipairs(events) do
        for j = 1, event.chance do
            table.insert(eventChances, i)
        end
    end

    local selected = events[eventChances[math.random(1, #eventChances)]]
    selected.handler()
end

exports("startMining", startMining)
exports("stopMining", stopMining)
