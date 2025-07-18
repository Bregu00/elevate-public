CreateThread(function()
    for k, v in pairs(Config.Locations) do
        exports.ox_target:addBoxZone({
            name = string.lower(v.label),
            coords = vector3(v.coords.x, v.coords.y, v.coords.z),
            size = vector3(1, 1, 1),
            rotation = v.coords.w,
            options = {
                {
                    label = "Åben armory",
                    icon = "fa-solid fa-gun",
                    groups = v.jobs,
                    onSelect = function()
                        exports.ox_inventory:openInventory('shop', { type = 'policeShop'})
                    end
                },
                {
                    label = v.label,
                    icon = "fa-solid fa-warehouse",
                    groups = v.jobs,
                    onSelect = function()
                        generateMenu(k)
                    end
                },
            }
        })
    end
end)

function generateMenu(key)
    local Options = {}

    Options[#Options + 1] = {
        title = 'Loadouts',
        icon = 'fa-solid fa-warehouse',
        onSelect = function()
            ESX.TriggerServerCallback('jungurum_polLocker:server:getAllLoadouts', function(loadouts)
                local Options2 = {}

                if not loadouts then lib.notify({title = 'Du har ingen gemte loadouts!', type = 'error'}) return end
                for k, v in pairs(loadouts) do
                    Options2[#Options2 + 1] = {
                        title = "Name: " .. v.name .. " Price: " .. v.totalPrice,
                        icon = 'fa-solid fa-gun',
                        onSelect = function()
                            local Options3 = {}

                            Options3[#Options3 + 1] = {
                                title = "Hent loadout",
                                icon = "fa-solid fa-gun",
                                onSelect = function()
                                    ESX.TriggerServerCallback('jungurum_polLocker:server:giveLoadout', function(bool)
                                        if bool then
                                            lib.notify({title = "Du modtog " .. v.name, type = "success"})
                                        end
                                    end, v.data)
                                end
                            }

                            Options3[#Options3 + 1] = {
                                title = "Slet loadout",
                                icon = "fa-solid fa-gun",
                                onSelect = function()
                                    ESX.TriggerServerCallback('jungurum_polLocker:server:removeLoadout', function(bool)
                                        if bool then
                                            lib.notify({title = "Du slettede " .. v.name, type = "success"})
                                        end
                                    end, v.id)
                                end
                            }

                            lib.registerContext({
                                id = string.lower(v.name) .. "allLoadouts",
                                title = v.name,
                                options = Options3,
                                menu = string.lower(Config.Locations[key].label) .. "allLoadouts",
                            })
                            lib.showContext(string.lower(v.name) .. "allLoadouts")
                        end,
                    }
                end

                lib.registerContext({
                    id = string.lower(Config.Locations[key].label) .. "allLoadouts",
                    title = 'Alle Loadouts',
                    options = Options2,
                    menu = string.lower(Config.Locations[key].label),
                })
                lib.showContext(string.lower(Config.Locations[key].label) .. "allLoadouts")
            end)
        end,
    }

    Options[#Options + 1] = {
        title = '',
        disabled = true,
    }

    Options[#Options + 1] = {
        title = 'Opret nyt loadout',
        icon = 'fa-solid fa-warehouse',
        onSelect = function()
            local input = lib.inputDialog('Loadout Navn', {'Navn'})
            if not input then return end
            if not input[1] then return end
            ESX.TriggerServerCallback("jungurum_polLocker:server:createLoadout", function(loadoutCreation)
                if loadoutCreation then
                    lib.notify({title = "Du har lavet et nyt loadout", type = "success"})
                end 
            end, input[1])
        end,
    }

    lib.registerContext({
        id = string.lower(Config.Locations[key].label),
        title = 'Politi Loadout',
        options = Options
    })
    lib.showContext(string.lower(Config.Locations[key].label))
end
