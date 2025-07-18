return {
    ["pillbox"] = {
        paramedic = {
            model = "s_m_m_scientist_01",
            pos = vector4(308.2672, -595.5335, 42.28403, 70.93318),
        },
        zone = {
            pos = vec3(299.0, -585.28, 43.28),
            size = vec3(200.0, 200.0, 200.0),
        },
        blip = {
            enable = true,
            name = 'Pillbox Hospital',
            type = 61,
            scale = 1.0,
            color = 2,
            pos = vector3(308.96, -591.52, 43.28),
        },
        respawn = {
            {
                bedPoint = vector4(319.2205, -581.2819, 44.204, 164.1656),
                spawnPoint = vector4(319.2205, -581.2819, 44.204, 164.1656)
            },
            {
                bedPoint = vector4(317.8326, -585.1843, 44.204, 336.9854),
                spawnPoint = vector4(317.8326, -585.1843, 44.204, 336.9854)
            },

        },
        stash = {
            ['ems_stash_1'] = {
                slots = 50,
                weight = 5000, -- kg
                min_grade = 0,
                label = 'Ems stash',
                shared = true, -- false if you want to make everyone has a personal stash
                pos = vector3(310.4091, -603.0366, 43.28411)
            }
        },
        pharmacy = {
            ["ems_shop_1"] = {
                job = true,
                label = "Pharmacy",
                grade = 0, -- works only if job true
                pos = vector3(306.7934, -601.9003, 43.28415),
                blip = {
                    enable = false,
                    name = 'Pharmacy',
                    type = 61,
                    scale = 0.7,
                    color = 2,
                    pos = vector3(315.5516, -598.6013, 43.2918),
                },
                items = {
                    { name = 'medicalbag',    label = "Medicin Taske",   icon = "fas fa-briefcase-medical", price = 0 },
                    { name = 'bandage',       label = "Bandage",       icon = "fas fa-bandage",           price = 0 },
                    { name = 'defibrillator', label = "Defibrillator", icon = "fas fa-heartbeat",         price = 0 },
                    { name = 'tweezers',      label = "Pincet",      icon = "fas fa-tools",             price = 0 },
                    { name = 'burncream',     label = "Brandsalve",     icon = "fas fa-fire-extinguisher", price = 0 },
                    { name = 'suturekit',     label = "Sy Kit",     icon = "fas fa-scissors",          price = 0 },
                    { name = 'icepack',       label = "Ispose",      icon = "fas fa-snowflake",         price = 0 },
                    { name = 'water',       label = "Vand",      icon = "fa-solid fa-glass-water",         price = 0 },
                    { name = 'burger',       label = "Burger",      icon = "fa-solid fa-burger",         price = 0 },
                }

            },
            -- ["ems_shop_2"] = {
            --     job = false,
            --     label = "Pharmacy",
            --     grade = 0, -- works only if job true
            --     pos = vector3(303.84, -597.6, 43.28),
            --     blip = {
            --         enable = true,
            --         name = 'Pharmacy',
            --         type = 61,
            --         scale = 0.7,
            --         color = 2,
            --         pos = vector3(303.84, -597.6, 43.28),
            --     },
            --     items = {
            --         { name = 'bandage', label = "Bandage", icon = "fas fa-bandage", price = 10 },
            --     }
            -- },
        },
        garage = {
            ['ems_garage_1'] = {
                pedPos = vector4(328.4315, -577.6558, 27.79684, 337.6693),
                model = 'mp_m_weapexp_01',
                spawn = vector4(331.9589, -579.0128, 28.79684, 334.0457),
                deposit = vector3(331.9589, -579.0128, 28.79684),
                driverSpawnCoords = vector3(329.4279, -575.4985, 28.79684),

                vehicles = {
                    {
                        label = 'Vapid Speedo',
                        spawn_code = 'emsspeedo',
                        min_grade = 0,
                        modifications = {} -- es. {color1 = {255, 12, 25}}
                    },
                    {
                        label = 'Vapid Caracara',
                        spawn_code = 'emscara',
                        min_grade = 0,
                        modifications = {} -- es. {color1 = {255, 12, 25}}
                    },
                    {
                        label = 'Übermacht Rhinehart',
                        spawn_code = 'emsrhinehart',
                        min_grade = 0,
                        modifications = {} -- es. {color1 = {255, 12, 25}}
                    },
                }
            }
        },
        clothes = {
            enable = false,
            pos = vector4(300.7454, -597.4542, 42.2918, 298.0781),
            model = 'a_f_m_bevhills_01',
            male = {
                -- [1] = {
                --     ["Officier"] = {
                --         ['mask_1']    = 0,
                --         ['mask_2']    = 0,
                --         ['arms']      = 0,
                --         ['tshirt_1']  = 15,
                --         ['tshirt_2']  = 0,
                --         ['torso_1']   = 86,
                --         ['torso_2']   = 0,
                --         ['bproof_1']  = 0,
                --         ['bproof_2']  = 0,
                --         ['decals_1']  = 0,
                --         ['decals_2']  = 0,
                --         ['chain_1']   = 0,
                --         ['chain_2']   = 0,
                --         ['pants_1']   = 10,
                --         ['pants_2']   = 2,
                --         ['shoes_1']   = 56,
                --         ['shoes_2']   = 0,
                --         ['helmet_1']  = 34,
                --         ['helmet_2']  = 0,
                --         ['glasses_1'] = 34,
                --         ['glasses_2'] = 1,
                --     },
                --     ["Sargent"] = {
                --         ['mask_1']    = 0,
                --         ['mask_2']    = 0,
                --         ['arms']      = 0,
                --         ['tshirt_1']  = 15,
                --         ['tshirt_2']  = 0,
                --         ['torso_1']   = 21,
                --         ['torso_2']   = 0,
                --         ['bproof_1']  = 0,
                --         ['bproof_2']  = 0,
                --         ['decals_1']  = 0,
                --         ['decals_2']  = 0,
                --         ['chain_1']   = 0,
                --         ['chain_2']   = 0,
                --         ['pants_1']   = 10,
                --         ['pants_2']   = 2,
                --         ['shoes_1']   = 23,
                --         ['shoes_2']   = 0,
                --         ['helmet_1']  = 34,
                --         ['helmet_2']  = 0,
                --         ['glasses_1'] = 34,
                --         ['glasses_2'] = 1,
                --     }
                -- },
                -- [2] = {
                --     ["Sargent"] = {
                --         ['mask_1']    = 0,
                --         ['mask_2']    = 0,
                --         ['arms']      = 0,
                --         ['tshirt_1']  = 15,
                --         ['tshirt_2']  = 0,
                --         ['torso_1']   = 86,
                --         ['torso_2']   = 0,
                --         ['bproof_1']  = 0,
                --         ['bproof_2']  = 0,
                --         ['decals_1']  = 0,
                --         ['decals_2']  = 0,
                --         ['chain_1']   = 0,
                --         ['chain_2']   = 0,
                --         ['pants_1']   = 10,
                --         ['pants_2']   = 2,
                --         ['shoes_1']   = 56,
                --         ['shoes_2']   = 0,
                --         ['helmet_1']  = 34,
                --         ['helmet_2']  = 0,
                --         ['glasses_1'] = 34,
                --         ['glasses_2'] = 1,
                --     }
                -- },
            },
            female = {
                -- [1] = {
                --     ["Officier"] = {
                --         ['mask_1']    = 0,
                --         ['mask_2']    = 0,
                --         ['arms']      = 0,
                --         ['tshirt_1']  = 15,
                --         ['tshirt_2']  = 0,
                --         ['torso_1']   = 86,
                --         ['torso_2']   = 0,
                --         ['bproof_1']  = 0,
                --         ['bproof_2']  = 0,
                --         ['decals_1']  = 0,
                --         ['decals_2']  = 0,
                --         ['chain_1']   = 0,
                --         ['chain_2']   = 0,
                --         ['pants_1']   = 10,
                --         ['pants_2']   = 2,
                --         ['shoes_1']   = 56,
                --         ['shoes_2']   = 0,
                --         ['helmet_1']  = 34,
                --         ['helmet_2']  = 0,
                --         ['glasses_1'] = 34,
                --         ['glasses_2'] = 1,
                --     }
                -- },
            },
        },
    },
}
