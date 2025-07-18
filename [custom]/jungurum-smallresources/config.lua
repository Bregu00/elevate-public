Config = Config or {}

Config.starterItems = {
    {name = 'phone', amount = 1},
    {name = 'radio', amount = 1}
}

Config.Blackmarket = {
    locations = {
        vec4(660.80, 1282.43, 359.29, 270.57),
        vec4(474.30, -635.61, 24.64, 356.63),
        vec4(1500.90, -2124.36, 75.03, 210.29),
        vec4(-436.72, 1058.16, 318.98, 197.42),
    },
    items = {
        { name = 'ammo', price = math.random(800, 1300), currency = "autoall" },
        { name = 'ammo2', price = math.random(900, 1450), currency = "autoall" },
        { name = 'silencer', price = 50000, currency = "autoall" },
        { name = 'clip', price = 175000, currency = "autoall" },
        { name = 'armor', price = 25000, currency = "autoall" },
        { name = 'plate', price = math.random(50000, 70000), currency = "autoall" },
        { name = 'lockpick', price = math.random(20000, 25000), currency = "autoall" },
        { name = 'angle_grinder', price = math.random(100000, 150000), currency = "autoall" },
        { name = 'transponder', price = math.random(50000, 100000), currency = "autoall" },
        { name = 'parachute', price = math.random(25000, 50000), currency = "autoall" },
        { name = 'medkit', price = math.random(10000, 20000), currency = "autoall" },
        { name = 'bandage', price = math.random(1000, 3500), currency = "autoall" },
        { name = 'weapon_colbaton', price = 200000, currency = "autoall" },
        { name = 'weapon_snspistol', price = 720000, currency = "autoall" },
        { name = 'weapon_pistol', price = 1500000, currency = "autoall" },
        { name = 'contracts_tablet', price = 500000, currency = "autoall" },
        { name = 'evidence_tweezers', price = 15000, currency = "autoall" },
    },
    blacklistedJobs = {
        ['police'] = true,
    }
}

Config.PauseMapText = 'Elevate'                                     -- Text shown above the map when ESC is pressed. If left empty 'FiveM' will appear

Config.AIResponse = {
    wantedLevels = false, -- if true, you will recieve wanted levels
    dispatchServices = {  -- AI dispatch services
        [1] = false,      -- Police Vehicles
        [2] = false,      -- Police Helicopters
        [3] = false,      -- Fire Department Vehicles
        [4] = false,      -- Swat Vehicles
        [5] = false,      -- Ambulance Vehicles
        [6] = false,      -- Police Motorcycles
        [7] = false,      -- Police Backup
        [8] = false,      -- Police Roadblocks
        [9] = false,      -- PoliceAutomobileWaitPulledOver
        [10] = false,     -- PoliceAutomobileWaitCruising
        [11] = false,     -- Gang Members
        [12] = false,     -- Swat Helicopters
        [13] = false,     -- Police Boats
        [14] = false,     -- Army Vehicles
        [15] = false      -- Biker Backup
    }
}

Config.Discord = {
    isEnabled = false,                                     -- If set to true, then discord rich presence will be enabled
    applicationId = '00000000000000000',                   -- The discord application id
    iconLarge = 'logo_name',                               -- The name of the large icon
    iconLargeHoverText = 'This is a Large icon with text', -- The hover text of the large icon
    iconSmall = 'small_logo_name',                         -- The name of the small icon
    iconSmallHoverText = 'This is a Small icon with text', -- The hover text of the small icon
    updateRate = 60000,                                    -- How often the player count should be updated
    showPlayerCount = true,                                -- If set to true the player count will be displayed in the rich presence
    maxPlayers = 48,                                       -- Maximum amount of players
    buttons = {
        {
            text = 'Tilslut Server',
            url = 'fivem://connect/localhost:30120'
        },
    }
}

Config.slashTireOptions = {
    distance = 1.5,
    weapons = {
        { 'WEAPON_KNIFE' },
        { 'WEAPON_DAGGER' },
        { 'WEAPON_SWITCHBLADE' },
    }
}

Config.Density = {
    parked = 0.4,
    vehicle = 0.4,
    multiplier = 1.0,
    peds = 1.0,
    scenario = 1.0
}

Config.Disable = {
    hudComponents = { 1, 2, 3, 4, 7, 8, 9, 13, 14, 19, 20, 21, 22 , 23}, -- Hud Components: https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
    controls = { 37 },                                            -- Controls: https://docs.fivem.net/docs/game-references/controls/
    displayAmmo = false,                                           -- false disables ammo display
    ambience = true,                                              -- disables distance sirens, distance car alarms, flight music, etc
    idleCamera = true,                                            -- disables the idle cinematic camera
    pistolWhipping = true,                                        -- disables pistol whipping
    driveby = false,                                              -- disables driveby
    healthRegen = true
}

Config.HandsUp = {
    command = 'hu',
    keybind = 'X',
    controls = { 24, 25, 47, 58, 59, 63, 64, 71, 72, 75, 140, 141, 142, 143, 257, 263, 264 }
}

Config.BlacklistedScenarios = {
    types = {
        'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        'WORLD_VEHICLE_MILITARY_PLANES_BIG',
        'WORLD_VEHICLE_AMBULANCE',
        'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
        'WORLD_VEHICLE_POLICE_CAR',
        'WORLD_VEHICLE_POLICE_BIKE'
    },
    groups = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`
    }
}

Config.DamageNeeded = 50.0

Config.BlacklistedWeapons = {
    [`WEAPON_RAILGUN`] = true,
}

Config.vehicleDamage = {
    deformationMultiplier = 1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.5,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.5,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 20,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 2,						-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 1.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.3,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.5,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 2,				-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 4.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 250.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 250.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 50.0,						-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.
	limpMode = false,
    randomTireBurstInterval = 0,				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled


	-- Class Damagefactor Multiplier
	-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
	-- Use it to increase or decrease damage for each class

	classDamageMultiplier = {
		[0] = 	0.44,		--	0: Compacts
				0.44,		--	1: Sedans
				0.44,		--	2: SUVs
				0.44,		--	3: Coupes
				0.44,		--	4: Muscle
				0.44,		--	5: Sports Classics
				0.44,		--	6: Sports
				0.44,		--	7: Super
				0.50,		--	8: Motorcycles
				0.44,		--	9: Off-road
				0.25,		--	10: Industrial
				0.44,		--	11: Utility
				0.44,		--	12: Vans
				0.44,		--	13: Cycles
				0.5,		--	14: Boats
				0.44,		--	15: Helicopters
				0.44,		--	16: Planes
				0.44,		--	17: Service
				0.10,		--	18: Emergency
				0.75,		--	19: Military
				0.44,		--	20: Commercial
				0.44		--	21: Trains
	}
}

Config.driveBy = {
    DisableOnlyWhenSpeeding = true,
    VehicleSpeedToDisable = 20, -- MPH
}

Config.Holsters = {
    StashWeapons = {
        [`WEAPON_BAT`] = true,
        [`WEAPON_GOLFCLUB`] = true,
        [`WEAPON_CROWBAR`] = true,
        [`WEAPON_WRENCH`] = true,
        [`WEAPON_HATCHET`] = true,
        [`WEAPON_BATTLEAXE`] = true,
        [`WEAPON_MACHETE`] = true,
        [`WEAPON_POOLCUE`] = true,
        [`WEAPON_MICROSMG`] = true,
        [`WEAPON_MINISMG`] = true,
        [`WEAPON_SMG`] = true,
        [`WEAPON_DBSHOTGUN`] = true,
        [`WEAPON_MACHINEPISTOL`] = true,
        [`WEAPON_GUSENBERG`] = true,
        [`WEAPON_COMPACTRIFLE`] = true,
        [`WEAPON_ASSAULTRIFLE`] = true,
        [`WEAPON_CARBINERIFLE`] = true,
        [`WEAPON_CARBINERIFLE_MK2`] = true,
        [`WEAPON_COMBATPDW`] = true,
        [`WEAPON_PUMPSHOTGUN`] = true,
        [`WEAPON_COMBATSHOTGUN`] = true,
        [`WEAPON_BATS`] = true,
        [`WEAPON_COLBATON`] = true,
    },
    HolsterWeapons = {
        [`WEAPON_UNARMED`] = true,
        [`WEAPON_PISTOL`] = true,
        [`WEAPON_PISTOL_MK2`] = true,
        [`WEAPON_COMBATPISTOL`] = true,
        [`WEAPON_APPISTOL`] = true,
        [`WEAPON_PISTOL50`] = true,
        [`WEAPON_HEAVYPISTOL`] = true,
        [`WEAPON_VINTAGEPISTOL`] = true,
        [`WEAPON_STUNGUN`] = true,
        [`WEAPON_SNSPISTOL`] = true,
        [`WEAPON_PISTOLXM3`] = true,
        [`WEAPON_SNSPISTOL_MK2`] = true,
        [`WEAPON_CERAMICPISTOL`] = true,
        [`WEAPON_REVOLVER`] = true,
        [`WEAPON_NAVYREVOLVER`] = true,
        [`WEAPON_GADGETPISTOL`] = true,
    },
    ValidPedHolsters = {
        [`mp_m_freemode_01`] = {
            [8] = {
                holsterAddWeapon = {
                    [208] = {
                        newVariation = 8,
                        newComponent = 207,
                        holster = 'holster',
                    },
                    [210] = {
                        newVariation = 8,
                        newComponent = 209,
                        holster = 'holster',
                    },
                    [212] = {
                        newVariation = 8,
                        newComponent = 211,
                        holster = 'holster',
                    },
                    [214] = {
                        newVariation = 8,
                        newComponent = 213,
                        holster = 'holster',
                    },
                    [216] = {
                        newVariation = 8,
                        newComponent = 215,
                        holster = 'holster',
                    },
                    [218] = {
                        newVariation = 8,
                        newComponent = 217,
                        holster = 'holster',
                    },
                    [220] = {
                        newVariation = 8,
                        newComponent = 219,
                        holster = 'holster',
                    },
                    [222] = {
                        newVariation = 8,
                        newComponent = 221,
                        holster = 'holster',
                    },
                    [225] = {
                        newVariation = 8,
                        newComponent = 224,
                        holster = 'holster',
                    },
                    [227] = {
                        newVariation = 8,
                        newComponent = 226,
                        holster = 'holster',
                    },
                    [232] = {
                        newVariation = 8,
                        newComponent = 232,
                        holster = 'holster_front',
                    },
                    [236] = {
                        newVariation = 8,
                        newComponent = 235,
                        holster = 'holster',
                    },
                },
                holsterRemoveWeapon = {
                    [207] = {
                        newVariation = 8,
                        newComponent = 208,
                        holster = 'holster',
                    },
                    [209] = {
                        newVariation = 8,
                        newComponent = 210,
                        holster = 'holster',
                    },
                    [211] = {
                        newVariation = 8,
                        newComponent = 212,
                        holster = 'holster',
                    },
                    [213] = {
                        newVariation = 8,
                        newComponent = 214,
                        holster = 'holster',
                    },
                    [215] = {
                        newVariation = 8,
                        newComponent = 216,
                        holster = 'holster',
                    },
                    [217] = {
                        newVariation = 8,
                        newComponent = 218,
                        holster = 'holster',
                    },
                    [219] = {
                        newVariation = 8,
                        newComponent = 220,
                        holster = 'holster',
                    },
                    [221] = {
                        newVariation = 8,
                        newComponent = 222,
                        holster = 'holster',
                    },
                    [224] = {
                        newVariation = 8,
                        newComponent = 225,
                        holster = 'holster',
                    },
                    [226] = {
                        newVariation = 8,
                        newComponent = 227,
                        holster = 'holster',
                    },
                    [227] = {
                        newVariation = 8,
                        newComponent = 227,
                        holster = 'holster',
                    },
                    [232] = {
                        newVariation = 8,
                        newComponent = 232,
                        holster = 'holster_front',
                    },
                    [235] = {
                        newVariation = 8,
                        newComponent = 236,
                        holster = 'holster',
                    },
                },
            },

            -- [10] = {
            --     holsterAddWeapon = {
            --     },
            --     holsterRemoveWeapon = {
            -- },
        
        },
        [`mp_f_freemode_01`] = {
            [8] = {
                holsterAddWeapon = {
                    [152] = {
                        newVariation = 8,
                        newComponent = 160,
                        holster = 'holster',
                    },
                    [160] = {
                        newVariation = 8,
                        newComponent = 160,
                        holster = 'holster',
                    },
                    [254] = {
                        newVariation = 8,
                        newComponent = 253,
                        holster = 'holster',
                    },
                    [255] = {
                        newVariation = 8,
                        newComponent = 256,
                        holster = 'holster',
                    },
                    [295] = {
                        newVariation = 8,
                        newComponent = 296,
                        holster = 'holster',
                    },
                },
                holsterRemoveWeapon = {
                    [152] = {
                        newVariation = 8,
                        newComponent = 160,
                        holster = 'holster',
                    },
                    [160] = {
                        newVariation = 8,
                        newComponent = 160,
                        holster = 'holster',
                    },
                    [253] = {
                        newVariation = 8,
                        newComponent = 254,
                        holster = 'holster',
                    },
                    [256] = {
                        newVariation = 8,
                        newComponent = 255,
                        holster = 'holster',
                    },
                    [296] = {
                        newVariation = 8,
                        newComponent = 295,
                        holster = 'holster',
                    },
                },
            },
        },
        [`mani_wei`] = {
            [5] = {
                holsterAddWeapon = {
                    [1] = true
                },
                holsterRemoveWeapon = {
                    [1] = true
                },
            },
        },
    },
    ValidPedBags = {
        [`mp_m_freemode_01`] = {
            variation = 5,
            bags = {
                [40] = 20000,
                [41] = 20000,
                [44] = 20000,
                [45] = 20000,
                [81] = 20000,
                [82] = 20000,
                [85] = 20000,
                [86] = 20000,
                [111] = 20000,
                [112] = 20000,
                [117] = 20000,
                [118] = 20000,
                [119] = 20000,
                [120] = 20000,
                [120] = 20000,
            }
        },
        [`mp_f_freemode_01`] = {
            variation = 5,
            bags = {
                [40] = 20000,
                [41] = 20000,
                [44] = 20000,
                [45] = 20000,
                [81] = 20000,
                [82] = 20000,
                [85] = 20000,
                [86] = 20000,
                [111] = 20000,
                [112] = 20000,
                [117] = 20000,
                [118] = 20000,
                [119] = 20000,
                [120] = 20000,
                [121] = 20000,
                [122] = 20000,
            }
        },
        [`mani_wei`] = {
            variation = 5,
            bags = {
                [1] = 20000,
            }
        },
    }
}

Config.Recoil = {
    [`WEAPON_SNSPISTOL`] = 0.01,
    [`WEAPON_PISTOL`] = 0.02,
    [`WEAPON_COMBATPISTOL`] = 0.02,
    [`WEAPON_PISTOLXM3`] = 0.02,
    [`WEAPON_PISTOL50`] = 0.025,
    [`WEAPON_HEAVYPISTOL`] = 0.02,
    [`WEAPON_VINTAGEPISTOL`] = 0.02,
    [`WEAPON_REVOLVER`] = 0.05,
    [`WEAPON_NAVYREVOLVER`] = 0.05,
    [`WEAPON_CARBINERIFLE`] = 0.02,
    [`WEAPON_PUMPSHOTGUN`] = 0.08,
    [`WEAPON_SAWNOFFSHOTGUN`] = 0.08,
    [`WEAPON_DBSHOTGUN`] = 0.08,
    [`WEAPON_SMG`] = 0.02,
}

Config.AFK = {
    timeAFK = 1800, -- 30 minutes in nseconds
    kickWarning = true,
    msgKickAss = 'Du blev smidt af serveren for at være inaktiv.',
    description = 'Du vil blive smidt af serveren om',
    seconds = 'sekunder',
}

Config.ResetTimes = { -- Kicker folk 2 minutter før genstart for at undgå fejl.
    {
        hour = "17",
        minute = "58"
    },
    {
        hour = "02",
        minute = "58"
    },
    {
        hour = "11",
        minute = "58"
    },
}

Config.adminGroups = {
    ['mod'] = true,
    ['admin'] = true,
    ['god'] = true
}