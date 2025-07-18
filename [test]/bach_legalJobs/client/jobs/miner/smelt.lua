local minerConfig = lib.load("shared.jobs.miner")
local isSmelting = false

local smeltProps = {
    tongs = {
        model = "prop_weld_torch",
        bone = 57005, 
        pos = vec3(0.12, 0.0, 0.0),
        rot = vec3(270.0, 90.0, 0.0),
    },
    ingot = {
        model = "prop_ingot_01",
        bone = 18905, 
        pos = vec3(0.12, 0.05, 0.0),
        rot = vec3(0.0, 90.0, 90.0),
    },
}

local smeltingAnims = {
    prepare = {
        dict = "mini@repair",
        clip = "fixing_a_ped",
        flags = 1,
    },
    pour = {
        dict = "anim@heists@narcotics@funding@gang_idle",
        clip = "gang_chatting_idle01",
        flags = 1,
    },
    hammer = {
        dict = "amb@world_human_hammering@male@base",
        clip = "base",
        flags = 1,
    },
}

local function loadAnimDict(dict)
    exports.bach_legalJobs:debugPrint("Loading animation dictionary: " .. dict)
    if not DoesAnimDictExist(dict) then
        exports.bach_legalJobs:debugPrint("Animation dictionary doesn't exist: " .. dict)
        return false
    end

    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 500 do
        Wait(10)
        timeout = timeout + 1
    end

    if not HasAnimDictLoaded(dict) then
        exports.bach_legalJobs:debugPrint("Failed to load animation dictionary: " .. dict)
        return false
    end

    exports.bach_legalJobs:debugPrint("Successfully loaded animation dictionary: " .. dict)
    return true
end

function initSmeltingLocations()
    if not minerConfig["smeltLocations"] then
        return
    end

    for _, location in pairs(minerConfig["smeltLocations"]) do
        
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, location.blip.id)
        SetBlipColour(blip, location.blip.colour)
        SetBlipScale(blip, location.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.name)
        EndTextCommandSetBlipName(blip)

        if location.props then
            for _, prop in ipairs(location.props) do
                local propObj = CreateObject(GetHashKey(prop.model), prop.coords.x, prop.coords.y, prop.coords.z, false,
                    false, false)
                SetEntityHeading(propObj, prop.coords.w)
                FreezeEntityPosition(propObj, true)

                if prop.isInteraction then
                    exports.ox_target:addLocalEntity(propObj, {
                        {
                            name = "smelt_ore",
                            icon = "fas fa-fire",
                            label = "Smelt Materialer",
                            distance = 2.0,
                            groups = {
                                miner = 0,
                            },
                            onSelect = function()
                                openSmeltingMenu(location)
                            end,
                        },
                    })
                end
            end
        end

        if not location.props or not containsInteractionProp(location.props) then
            exports.ox_target:addBoxZone({
                coords = location.coords,
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = "smelt_ore_zone",
                        icon = "fas fa-fire",
                        label = "Smelt Materialer",
                        distance = 2.0,
                        groups = {
                            miner = 0,
                        },
                        onSelect = function()
                            openSmeltingMenu(location)
                        end,
                    },
                },
            })
        end
    end
end

function containsInteractionProp(props)
    for _, prop in ipairs(props) do
        if prop.isInteraction then
            return true
        end
    end
    return false
end

function openSmeltingMenu(location)
    if isSmelting then
        lib.notify({
            description = "Du er allerede ved at smelte materialer.",
            type = "error",
            icon = "fas fa-fire",
        })
        return
    end

    local smeltOptions = {}

    if not minerConfig["smeltRecipes"] or #minerConfig["smeltRecipes"] == 0 then
        lib.notify({
            description = "Der er ingen opskrifter tilgængelige for smeltning.",
            type = "error",
            icon = "fas fa-exclamation-triangle",
        })
        return
    end

    local hasAnyMaterial = false

    for _, recipe in pairs(minerConfig["smeltRecipes"]) do
        
        local hasRequiredAmount = exports.bach_legalJobs:hasItem(recipe.input.item, recipe.input.amount)

        table.insert(smeltOptions, {
            title = recipe.label,
            description = string.format("Kræver: %dx %s → Giver: %dx %s", recipe.input.amount, recipe.input.label,
                recipe.output.amount, recipe.output.label),
            icon = recipe.icon or "fas fa-fire",
            disabled = not hasRequiredAmount,
            onSelect = function()
                startSmelting(recipe, location)
            end,
        })

        if hasRequiredAmount then
            hasAnyMaterial = true
        end
    end

    if not hasAnyMaterial then
        lib.notify({
            description = "Du har ikke nok materialer til at smelte noget.",
            type = "error",
            icon = "fas fa-exclamation-triangle",
        })
        return
    end

    lib.registerContext({
        id = "smelt_menu",
        title = "Smeltning - " .. location.name,
        options = smeltOptions,
    })

    lib.showContext("smelt_menu")
end

function startSmelting(recipe, location)
    exports.bach_legalJobs:debugPrint(
        "Starting smelting process: " .. recipe.input.item .. " " .. recipe.input.amount .. " Location: " ..
            location.name)
    local playerPed = PlayerPedId()

    if not exports.bach_legalJobs:hasItem(recipe.input.item, recipe.input.amount) then
        lib.notify({
            description = "Du har ikke nok " .. recipe.input.label .. " til at smelte.",
            type = "error",
            icon = "fas fa-fire",
        })
        return
    end

    local playerCoords = GetEntityCoords(playerPed)
    if #(playerCoords - location.coords) > 5.0 then
        lib.notify({
            description = "Du er for langt væk fra smeltestedet.",
            type = "error",
            icon = "fas fa-map-marker-alt",
        })
        return
    end

    isSmelting = true
    exports.bach_legalJobs:debugPrint("Set isSmelting to true")

    local baseTime = recipe.time or minerConfig.defaultSmeltTime or 10000
    local smeltTime = baseTime
    exports.bach_legalJobs:debugPrint("Smelt time calculated: " .. smeltTime)

    local allAnimsLoaded = true
    if not loadAnimDict(smeltingAnims.prepare.dict) then
        allAnimsLoaded = false
        exports.bach_legalJobs:debugPrint("Failed to load prepare animation")
    end

    if not loadAnimDict(smeltingAnims.pour.dict) then
        allAnimsLoaded = false
        exports.bach_legalJobs:debugPrint("Failed to load pour animation")
    end

    if not loadAnimDict(smeltingAnims.hammer.dict) then
        allAnimsLoaded = false
        exports.bach_legalJobs:debugPrint("Failed to load hammer animation")
    end

    if not allAnimsLoaded then
        lib.notify({
            description = "Der var et problem med at indlæse animationerne.",
            type = "error",
            icon = "fas fa-exclamation-triangle",
        })
        isSmelting = false
        return
    end

    exports.bach_legalJobs:debugPrint("All animations loaded successfully")
    exports.bach_legalJobs:debugPrint("Starting step 1: Prepare")

    if lib.progressBar({
        duration = math.floor(smeltTime * 0.3),
        label = "Forbereder " .. recipe.input.label .. " til smeltning...",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = smeltingAnims.prepare.dict,
            clip = smeltingAnims.prepare.clip,
            flags = smeltingAnims.prepare.flags,
        },
    }) then
        exports.bach_legalJobs:debugPrint("Step 1 completed, starting step 2: Smelting")
        
        if lib.progressBar({
            duration = math.floor(smeltTime * 0.4),
            label = "Smelter " .. recipe.input.label .. "...",
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = smeltingAnims.pour.dict,
                clip = smeltingAnims.pour.clip,
                flags = smeltingAnims.pour.flags,
            },
            prop = smeltProps.tongs,
        }) then
            exports.bach_legalJobs:debugPrint("Step 2 completed, starting step 3: Forming")
            
            if lib.progressBar({
                duration = math.floor(smeltTime * 0.3),
                label = "Former " .. recipe.output.label .. "...",
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
                anim = {
                    dict = smeltingAnims.hammer.dict,
                    clip = smeltingAnims.hammer.clip,
                    flags = smeltingAnims.hammer.flags,
                },
                prop = smeltProps.ingot,
            }) then
                exports.bach_legalJobs:debugPrint("Step 3 completed, checking skill check requirement")
                
                local smeltingSuccess = true
                if recipe.requiresSkillCheck then
                    exports.bach_legalJobs:debugPrint("Skill check required, performing check")
                    smeltingSuccess = lib.skillCheck({
                        "easy",
                    }, {
                        "e",
                    })

                    if not smeltingSuccess then
                        exports.bach_legalJobs:debugPrint("Skill check failed")
                        lib.notify({
                            description = "Du mistede kontrollen over smelteprocessen og mistede nogle materialer.",
                            type = "error",
                            icon = "fas fa-fire",
                        })
                    else
                        exports.bach_legalJobs:debugPrint("Skill check passed")
                    end
                else
                    exports.bach_legalJobs:debugPrint("No skill check required")
                end

                if smeltingSuccess then
                    exports.bach_legalJobs:debugPrint("Processing successful smelt, preparing rewards")
                    
                    local outputAmount = recipe.output.amount

                    exports.bach_legalJobs:debugPrint("Calling server callback for items: " .. recipe.input.item ..
                                                          " -> " .. recipe.output.item)
                    
                    local success = lib.callback.await("bach_legalJobs:smeltItems", false, {
                        input = {
                            item = recipe.input.item,
                            amount = recipe.input.amount,
                        },
                        output = {
                            item = recipe.output.item,
                            amount = outputAmount,
                        },
                    })

                    exports.bach_legalJobs:debugPrint("Server callback returned: " .. tostring(success))
                    if success == true then 
                        exports.bach_legalJobs:debugPrint("Smelting completed successfully")
                        lib.notify({
                            title = "Smeltning Komplet!",
                            description = "Du har succesfuldt smeltet " .. recipe.input.amount .. "x " ..
                                recipe.input.label .. " til " .. outputAmount .. "x " .. recipe.output.label,
                            type = "success",
                            icon = "fas fa-check-circle",
                        })
                    else
                        exports.bach_legalJobs:debugPrint("Server reported problem with smelting items: " ..
                                                              tostring(success))
                        lib.notify({
                            description = "Der opstod et problem under smeltningen. Prøv igen senere.",
                            type = "error",
                            icon = "fas fa-exclamation-triangle",
                        })
                    end
                else
                    exports.bach_legalJobs:debugPrint("Processing failed smelt with partial loss")
                    
                    local lossAmount = math.ceil(recipe.input.amount * 0.5) 
                    exports.bach_legalJobs:debugPrint("Calculating loss: " .. lossAmount .. " of " ..
                                                          recipe.input.amount)

                    local success = lib.callback.await("bach_legalJobs:smeltItemsPartialLoss", false, {
                        input = {
                            item = recipe.input.item,
                            amount = recipe.input.amount,
                            lossAmount = lossAmount,
                        },
                    })

                    exports.bach_legalJobs:debugPrint("Partial loss process result: " .. tostring(success))
                    if success ~= true then
                        exports.bach_legalJobs:debugPrint("Failed to process partial item loss for smelting: " ..
                                                              tostring(success))
                    end
                end
            else
                exports.bach_legalJobs:debugPrint("Step 3 (forming) was cancelled")
            end
        else
            exports.bach_legalJobs:debugPrint("Step 2 (smelting) was cancelled")
        end
    else
        exports.bach_legalJobs:debugPrint("Step 1 (preparing) was cancelled")
    end

    exports.bach_legalJobs:debugPrint("Smelting process completed, setting isSmelting to false")
    isSmelting = false
end

CreateThread(function()
    Wait(1000) 
    initSmeltingLocations()
end)

exports("openSmeltingMenu", openSmeltingMenu)
