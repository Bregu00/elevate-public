Config = {}

Config.Framework = 'esx' -- standalone/esx/qb
Config.NotificationType = 'esx' -- esx/qb/mythic
Config.Locale = 'en' -- en/fi
Config.DebugMode = false -- false/true

Config.Phone = 'lb' -- default/lb/gks -- you can add your own in server/main_editable.lua
Config.Inventory = 'ox' -- default/ox

Config.Controls = { -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard
    callManager = 'U',
    toggleMoveMode = 'I',
    map = 'COMMA',
    sidebar = 'PERIOD',
    toggleFocus = 'LMENU',
    calls = {
        next = 'LEFT',
        previous = 'RIGHT',
        accept = 'UP',
    },
    panicButton = '-',
}

Config.RemoveCallFromEveryone = false -- false/true, should a call be removed from everyone if it is deleted manually by someone
Config.AttachAllUnitsInGroupToCall = false -- false/true, should all units of a group be attached to a call when it is accepted
Config.AttachAllUnitsInVehicleToCall = false -- false/true, should all units in a vehicle be attached to a call when it is accepted

Config.NotificationPosition = 'top-right' -- 'top-right' | 'top-left' | 'top-center' | 'bottom-left' | 'bottom-right' | 'bottom-center' | undefined
Config.CallManagerPosition = {
    x = 15,
    y = 500,
}

Config.Dispatch = {
    police = {
        jobs = { -- jobs to be included in the dispatch group
            police = true,
            sheriff = true,
            leo = true,
            --if using standalone (and badger discord api), replace the "police" for example with discord role id like this (has to be done in other job parts too):
            --['820394321600708608'] = true
        },
        permissions = {
            manageLayers = {
                police = 4, -- job name, minimum grade
                sheriff = 4,
            },
            dispatcher = { -- dispatchers can manage all units
                police = 4,
                sheriff = 4,
            },
        },
        panicButton = true, -- enable panic button
        pages = { -- pages to enable
            map = true,
            sidebar = true,
            callManager = true,
            notification = true,
        },
        iconName = 'police.png', -- unit icon for map, if not set, will use marker.png
        --neededItem = 'radio', -- item needed to use map, sidebar, callmanager, see notifications
    },
    ems = {
        jobs = {
            ambulance = true,
        },
        panicButton = true,
        pages = {
            map = true,
            sidebar = true,
            callManager = true,
            notification = true,
        },
    }
}

Config.Alerts = {
    shooting = {
        enable = true,
        jobs = {'police'}, -- jobs to alert, will select dispatch group based on this
        ignoredJobs = { -- jobs to ignore for this alert
            police = true,
        },
        cooldown = 15000, -- cooldown for alert in ms
        --removeTime = 1000 * 60 * 5, -- time in ms to remove alert from map (5 minutes)
        checkForSuppressor = true,
        nearbyPed = {
            enable = true, -- enable nearby ped check
            needLos = true, -- should ped have line of sight to player
            dist = 150, -- distance to check for nearby peds
            anim = { -- animation to play on nearby ped on alert
                dict = 'cellphone@',
                name = 'cellphone_text_read_base',
                prop = {
                    model = `prop_npc_phone_02`,
                    bone = 28422,
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0),
                },
                duration = 5000,
            }
        },
        platePercentage = {min = 25, max = 40}, -- percentage of plate to be visible to alert, unknown characters are set as ?
        coordsOffset = 10, -- offset for alert coords
    },
    gunSeen = {
        enable = false,
        jobs = {'police'},
        ignoredJobs = {
            police = true,
        },
        cooldown = 15000,
        checkForSuppressor = false,
        nearbyPed = {
            enable = true,
            needLos = true,
            dist = 50,
            anim = {
                dict = 'cellphone@',
                name = 'cellphone_text_read_base',
                prop = {
                    model = `prop_npc_phone_02`,
                    bone = 28422,
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0),
                },
                duration = 5000,
            }
        },
        platePercentage = {min = 25, max = 100},
        coordsOffset = 20,
    },
    speeding = {
        enable = false,
        jobs = {'police'},
        ignoredJobs = {
            police = true,
            ambulance = true,
        },
        cooldown = 15000,
        locations = {
            {coords = vec3(100.78, -1016.51, 29.41), radius = 20.0, minSpeed = 25},
        },
        platePercentage = {min = 25, max = 100},
    },
    vehStealing = {
        enable = false,
        jobs = {'police'},
        ignoredJobs = {
            police = true,
        },
        cooldown = 15000,
        platePercentage = {min = 25, max = 100},
    },
    fighting = {
        enable = false,
        jobs = {'police'},
        ignoredJobs = {
            police = true,
        },
        cooldown = 15000,
        nearbyPed = {
            enable = true,
            needLos = true,
            dist = 100,
            anim = {
                dict = 'cellphone@',
                name = 'cellphone_text_read_base',
                prop = {
                    model = `prop_npc_phone_02`,
                    bone = 28422,
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0),
                },
                duration = 5000,
            }
        },
        coordsOffset = 20,
    },
    injuredPerson = {
        enable = true,
        jobs = {'ambulance'},
        cooldown = 60000,
        nearbyPed = {
            enable = true,
            needLos = true,
            dist = 50,
            anim = {
                dict = 'cellphone@',
                name = 'cellphone_text_read_base',
                prop = {
                    model = `prop_npc_phone_02`,
                    bone = 28422,
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0),
                },
                duration = 5000,
            }
        }
    },
    panicButton = {
        enable = true,
        cooldown = 15000,
        anim = {
            dict = 'random@arrests',
            name = 'generic_radio_chatter',
        },
        playSound = true,
        playSoundAll = true,
    },
    call = {
        enable = false,
        cooldown = 15000,
        jobs = {'police'},
    },
}

Config.BlacklistedWeapons = {
    [`WEAPON_STUNGUN`] = true,
    [`WEAPON_BALL`] = true,
    [`WEAPON_SNOWBALL`] = true,
    [`WEAPON_FLARE`] = true,
    [`WEAPON_SMOKEGRENADE`] = true,
    [`WEAPON_BZGAS`] = true,
    [`WEAPON_FIREEXTINGUISHER`] = true,
    [`WEAPON_JERRYCAN`] = true,
    [`WEAPON_HAZARDCAN`] = true,
    [`WEAPON_FERTILIZERCAN`] = true,
}

Config.Colors = {
    [0] = "Sort",
    [1] = "Sort",
    [2] = "Sort",
    [3] = "Sølv",
    [4] = "Sølv",
    [5] = "Blå",
    [6] = "Grå",
    [7] = "Sølv",
    [8] = "Sølv",
    [9] = "Sølv",
    [10] = "Mørk",
    [11] = "Grå",
    [12] = "Sort",
    [13] = "Grå",
    [14] = "Grå",
    [15] = "Sort",
    [16] = "Sort",
    [17] = "Sølv",
    [18] = "Sølv",
    [19] = "Mørk",
    [20] = "Sølv",
    [21] = "Sort",
    [22] = "Sort",
    [23] = "Sølvgrå",
    [24] = "Sølv",
    [25] = "Blå & Sølv",
    [26] = "Sølv",
    [27] = "Rød",
    [28] = "Rød",
    [29] = "Rød",
    [30] = "Rød",
    [31] = "Rød",
    [32] = "Rød",
    [33] = "Rød",
    [34] = "Rød",
    [35] = "Rød",
    [36] = "Orange",
    [37] = "Guld",
    [38] = "Orange",
    [39] = "Rød",
    [40] = "Rød",
    [41] = "Orange",
    [42] = "Gul",
    [43] = "Rød",
    [44] = "Rød",
    [45] = "Rød",
    [46] = "Rød",
    [47] = "Rød",
    [48] = "Rød",
    [49] = "Grøn",
    [50] = "Grøn",
    [51] = "Grøn",
    [52] = "Grøn",
    [53] = "Grøn",
    [54] = "Grøn",
    [55] = "Grøn",
    [56] = "Grøn",
    [57] = "Grøn",
    [58] = "Grøn",
    [59] = "Grøn",
    [60] = "Blå",
    [61] = "Blå",
    [62] = "Blå",
    [63] = "Blå",
    [64] = "Blå",
    [65] = "Blå",
    [66] = "Blå",
    [67] = "Blå",
    [68] = "Blå",
    [69] = "Blå",
    [70] = "Blå",
    [71] = "Lilla & Blå",
    [72] = "Blå",
    [73] = "Blå",
    [74] = "Blå",
    [75] = "Blå",
    [76] = "Blå",
    [77] = "Blå",
    [78] = "Blå",
    [79] = "Blå",
    [80] = "Blå",
    [81] = "Blå",
    [82] = "Blå",
    [83] = "Blå",
    [84] = "Blå",
    [85] = "Blå",
    [86] = "Blå",
    [87] = "Blå",
    [88] = "Gult",
    [89] = "Gult",
    [90] = "Bronze",
    [91] = "Gul",
    [92] = "Lime",
    [93] = "Champagne",
    [94] = "Beige",
    [95] = "Ivory",
    [96] = "Brun",
    [97] = "Brun",
    [98] = "Brun",
    [99] = "Beige",
    [100] = "Brun",
    [101] = "Brun",
    [102] = "Bøg",
    [103] = "Bøg",
    [104] = "Orange",
    [105] = "Sand",
    [106] = "Sand",
    [107] = "Cream",
    [108] = "Brun",
    [109] = "Brun",
    [110] = "Brun",
    [111] = "Hvid",
    [112] = "Hvid",
    [113] = "Beige",
    [114] = "Brun",
    [115] = "Brun",
    [116] = "Beige",
    [117] = "Mørk",
    [118] = "Mørk",
    [119] = "Sølv",
    [120] = "Krom",
    [121] = "Hvid",
    [122] = "Hvid",
    [123] = "Orange",
    [124] = "Orange",
    [125] = "Grøn",
    [126] = "Gult",
    [127] = "Blå",
    [128] = "Grøn",
    [129] = "Brun",
    [130] = "Orange",
    [131] = "Hvid",
    [132] = "Hvid",
    [133] = "Grøn",
    [134] = "Hvid",
    [135] = "Pink",
    [136] = "Pink",
    [137] = "Pink",
    [138] = "Orange",
    [139] = "Grøn",
    [140] = "Blå",
    [141] = "Sort & Blå",
    [142] = "Sort & Lilla",
    [143] = "Sort & Rød",
    [144] = "Grøn",
    [145] = "Lilla",
    [146] = "Blå",
    [147] = "Sort",
    [148] = "Lilla",
    [149] = "Lilla",
    [150] = "Rød",
    [151] = "Grøn",
    [152] = "Grøn",
    [153] = "Brun",
    [154] = "Sand",
    [155] = "Grøn",
    [156] = "Alloy",
    [157] = "Blå",
    [158] = "Guld",
    [159] = "Guld",
}

Config.Weapons = {
    [`WEAPON_STUNGUN`] = 'WEAPON_STUNGUN',
    [`WEAPON_VINTAGEPISTOL`] = 'WEAPON_VINTAGEPISTOL',
    [`WEAPON_SNSPISTOL`] = 'WEAPON_SNSPISTOL',
    [`WEAPON_SNSPISTOL_MK2`] = 'WEAPON_SNSPISTOL_MK2',
    [`WEAPON_PISTOL`] = 'WEAPON_PISTOL',
    ['WEAPON_PISTOLXM3'] = 'WEAPON_PISTOLXM3',
    [`WEAPON_PISTOL_MK2`] = 'WEAPON_PISTOL_MK2',
    [`WEAPON_COMBATPISTOL`] = 'WEAPON_COMBATPISTOL',
    [`WEAPON_APPISTOL`] = 'WEAPON_APPISTOL',
    [`WEAPON_HEAVYPISTOL`] = 'WEAPON_HEAVYPISTOL',
    [`WEAPON_PISTOL50`] = 'WEAPON_PISTOL50',
    [`WEAPON_REVOLVER`] = 'WEAPON_REVOLVER',
    [`WEAPON_REVOLVER_MK2`] = 'WEAPON_REVOLVER_MK2',
    [`WEAPON_MARKSMANPISTOL`] = 'WEAPON_MARKSMANPISTOL',
    [`WEAPON_DOUBLEACTION`] = 'WEAPON_DOUBLEACTION',
    [`WEAPON_MICROSMG`] = 'WEAPON_MICROSMG',
    [`WEAPON_SMG`] = 'WEAPON_SMG',
    [`WEAPON_SMG_MK2`] = 'WEAPON_SMG_MK2',
    [`WEAPON_ASSAULTSMG`] = 'WEAPON_ASSAULTSMG',
    [`WEAPON_COMBATPDW`] = 'WEAPON_COMBATPDW',
    [`WEAPON_MACHINEPISTOL`] = 'WEAPON_MACHINEPISTOL',
    [`WEAPON_MINISMG`] = 'WEAPON_MINISMG',
    [`WEAPON_PUMPSHOTGUN`] = 'WEAPON_PUMPSHOTGUN',
    [`WEAPON_PUMPSHOTGUN_MK2`] = 'WEAPON_PUMPSHOTGUN_MK2',
    [`WEAPON_ASSAULTSHOTGUN`] = 'WEAPON_ASSAULTSHOTGUN',
    [`WEAPON_BULLPUPSHOTGUN`] = 'WEAPON_BULLPUPSHOTGUN',
    [`WEAPON_SAWNOFFSHOTGUN`] = 'WEAPON_SAWNOFFSHOTGUN',
    [`WEAPON_DBSHOTGUN`] = 'WEAPON_DBSHOTGUN',
    [`WEAPON_HEAVYSHOTGUN`] = 'WEAPON_HEAVYSHOTGUN',
    [`WEAPON_MUSKET`] = 'WEAPON_MUSKET',
    [`WEAPON_AUTOSHOTGUN`] = 'WEAPON_AUTOSHOTGUN',
    [`WEAPON_COMBATSHOTGUN`] = 'WEAPON_COMBATSHOTGUN',
    [`WEAPON_ASSAULTRIFLE`] = 'WEAPON_ASSAULTRIFLE',
    [`WEAPON_ASSAULTRIFLE_MK2`] = 'WEAPON_ASSAULTRIFLE_MK2',
    [`WEAPON_CARBINERIFLE`] = 'WEAPON_CARBINERIFLE',
    [`WEAPON_CARBINERIFLE_MK2`] = 'WEAPON_CARBINERIFLE_MK2',
    [`WEAPON_ADVANCEDRIFLE`] = 'WEAPON_ADVANCEDRIFLE',
    [`WEAPON_SPECIALCARBINE`] = 'WEAPON_SPECIALCARBINE',
    [`WEAPON_SPECIALCARBINE_MK2`] = 'WEAPON_SPECIALCARBINE_MK2',
    [`WEAPON_BULLPUPRIFLE`] = 'WEAPON_BULLPUPRIFLE',
    [`WEAPON_BULLPUPRIFLE_MK2`] = 'WEAPON_BULLPUPRIFLE_MK2',
    [`WEAPON_COMPACTRIFLE`] = 'WEAPON_COMPACTRIFLE',
    [`WEAPON_MILITARYRIFLE`] = 'WEAPON_MILITARYRIFLE',
    [`WEAPON_MG`] = 'WEAPON_MG',
    [`WEAPON_COMBATMG`] = 'WEAPON_COMBATMG',
    [`WEAPON_COMBATMG_MK2`] = 'WEAPON_COMBATMG_MK2',
    [`WEAPON_GUSENBERG`] = 'WEAPON_GUSENBERG',
    [`WEAPON_SNIPERRIFLE`] = 'WEAPON_SNIPERRIFLE',
    [`WEAPON_HEAVYSNIPER`] = 'WEAPON_HEAVYSNIPER',
    [`WEAPON_HEAVYSNIPER_MK2`] = 'WEAPON_HEAVYSNIPER_MK2',
    [`WEAPON_MARKSMANRIFLE`] = 'WEAPON_MARKSMANRIFLE',
    [`WEAPON_MARKSMANRIFLE_MK2`] = 'WEAPON_MARKSMANRIFLE_MK2'
}