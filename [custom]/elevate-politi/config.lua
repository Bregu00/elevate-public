Config = Config or {}

Config.Armory = {
    ["weapon_combatpistol"] = {
        slot = 1,
    },
    ["weapon_heavypistol"] = {
        slot = 2,
        price = 50000,
    },
    ["weapon_carbinerifle"] = {
        slot = 3,
        price = 100000,
    },
    ["weapon_smg"] = {
        slot = 4,
        price = 75000,
    },
    ["weapon_bzgas"] = {
        slot = 5,
        price = 25000,
    },
    ["weapon_nightstick"] = {
        slot = 6,
    },
    ["weapon_flashlight"] = {
        slot = 7,
    },
    ["ammo"] = {
        slot = 8,
        price = 50,
    },
    ["policearmor"] = {
        slot = 9,
        metadata = {
            health = 100,
            armor = "policearmor",
            label = "Politi Armor",
            durability = 100,
            plates = {
                {plate = "plate", health = 25},
                {plate = "plate", health = 25},
                {plate = "plate", health = 25},
                {plate = "plate", health = 25},
            }
        },
    },
    ["plate"] = {
        slot = 10,
    },
    ["bandage"] = {
        slot = 11,
    },
    ["cuffs"] = {
        slot = 12,
    },
    ["handcuffkey"] = {
        slot = 13,
    },
    ["spikestrip"] = {
        slot = 14,
    },
    ["weapon_fireextinguisher"] = {
        slot = 15,
    },
    ["radio"] = {
        slot = 16,
    },
    ["phone"] = {
        slot = 17,
    },
    ["medkit"] = {
        slot = 18,
        price = 10000,
    },
    ["camera"] = {
        slot = 19,
    },
    ["clip"] = {
        slot = 20,
    },
    ["silencer"] = {
        slot = 21,
    },
    ["police_stormram"] = {
        slot = 22,
        price = 150000,
    },
    ["police_stormram_lille"] = {
        slot = 23,
        price = 50000,
    },
    ["laptop"] = {
        slot = 24,
    },
}

Config.TrunkItems = {
    {
        item = "policecone",
        amount = 10,
    },
    {
        item = "policebarricade",
        amount = 10,
    },
    {
        item = "policeroadsign",
        amount = 10,
    },
    {
        item = "policetent",
        amount = 10,
    },
    {
        item = "policespotlight",
        amount = 10,
    },
    {
        item = "scuba_set",
        amount = 1,
        metadata = {
            oxy = 100,
            description = ("Ilt: %s%%"):format(ESX.Round(100, 2))
        }
    },
    {
        item = "scuba_fins",
        amount = 1,
    }
}

Config.CivilBiler = {
    {model = "polcargento", label = "Civil Argento" },
    {model = "polcrhinehart", label = "Civil Rhinehart" },
    {model = "polcxls", label = "Civil XLS" },
    {model = "polcimperial", label = "Civil Imperial" },
    {model = "polcschafter3", label = "Civil Schafter" },
    {model = "polcgresleyh", label = "Civil Gresley" },
    {model = "polckomoda", label = "Civil Komoda" },
    {model = "polcshinobi", label = "Civil Shinobi" },
    {model = "polcbuffaloh", label = "Civil Buffalo" },
}

Config.Locations = {
    {coords = vec4(455.13, -997.48, 30.65, 178.46), label = "Manage Loadouts", jobs = {["police"] = 0}},
    {coords = vec4(836.31, -1288.03, 28.24, 88.39), label = "Manage Loadouts", jobs = {["police"] = 0}},
    {coords = vec4(1836.559, 3686.138, 34.17676, 120.1832), label = "Manage Loadouts", jobs = {["police"] = 0}},
}

Config.EvidenceOptions = {
    ['Coords'] = {
        vec4(464.49, -973.11, 26.31, 182.64), -- MRPD
        vec4(848.17, -1313.07, 28.24, 181.35), -- LAMESA
        vec4(1819.93, 3670.92, 34.16, 209.98), -- SANDY
    },
    ['Jobs'] = {['police'] = 0},
    ['TargetLabel'] = 'Bevis Rum',
    ['InventoryPrefix'] = 'bevisrum-'
}

Config.trashBins = {
    vec4(464.65, -987.88, 30.68, 272.27),
    vec4(843.15, -1287.88, 27.24, 288.93)
}

Config.garageTypes = {
    ['default'] = {
        {model = "polargento", label = "Obey Argento", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polstreiter", label = "Benefactor Streiter", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polrhinehart", label = "Ubermacht Rhinehart", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polodyssey", label = "BF Odyssey", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polxls", label = "Benefactor XLS", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polimperial", label = "Benefactor Imperial", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "poliwagen", label = "Obey I-Wagen", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polrebla", label = "Ubermacht Rebla", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polshinobi", label = "Nagasaki Shinobi", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = 'polbf400', label = 'Nagasaki BF400', minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
    },
    ['helicopter'] = {
        {model = "polmav", label = "Maverick Helicopter", minGrade = 1, extras = {["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true}},
    },
    ['boat'] = {
        {model = "poldinghy", label = "Dinghy Båd", minGrade = 1, extras = {["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true}},
    },
    ['skiggesSandyPD'] = {
        {model = "polargento", label = "Obey Argento", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polstreiter", label = "Benefactor Streiter", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polrhinehart", label = "Ubermacht Rhinehart", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polodyssey", label = "BF Odyssey", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polxls", label = "Benefactor XLS", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polimperial", label = "Benefactor Imperial", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "poliwagen", label = "Obey I-Wagen", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polrebla", label = "Ubermacht Rebla", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polshinobi", label = "Nagasaki Shinobi", minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = 'polbf400', label = 'Nagasaki BF400', minGrade = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        {model = "polmav", label = "Maverick Helicopter", minGrade = 1, extras = {["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true}}
    }
}

Config.policeGarage = {
    ["MRPD"] = {
        ["garageType"] = 'default',
        ["parkingSpots"] = {
            vec4(456.43, -982.60, 24.13, 91.39),
            vec4(456.25, -979.31, 24.13, 90.63),
            vec4(456.33, -975.95, 24.13, 90.68),
            vec4(456.17, -972.57, 24.13, 90.70),
            vec4(442.15, -985.21, 24.13, 270.14),
            vec4(442.50, -988.49, 24.13, 270.27),
            vec4(442.45, -991.80, 24.13, 269.63),
            vec4(442.49, -995.27, 24.13, 270.47)
        },
        ["parkVehicleZone"] = {
            vec3(458.77, -1000.66, 24.71),
            vec3(458.71, -971.10, 24.71),
            vec3(423.75, -971.10, 24.71),
            vec3(423.75, -1000.65, 24.71),
        },
        ["label"] = "MRPD Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["LaMesaPD"] = {
        ["garageType"] = 'default',
        ["parkingSpots"] = {
            vec4(818.24, -1334.31, 24.52, 358.78),
            vec4(818.09, -1341.85, 24.54, 358.86),
            vec4(817.95, -1349.30, 24.54, 358.90),
            vec4(817.86, -1356.76, 24.54, 359.18),
            vec4(817.74, -1363.50, 24.54, 359.10),
            vec4(827.58, -1350.89, 24.52, 65.02),
            vec4(827.87, -1345.17, 24.52, 63.72),
            vec4(828.23, -1339.43, 24.52, 64.42),
            vec4(827.40, -1332.83, 24.53, 64.59),
            vec4(844.24, -1334.59, 24.52, 245.25),
            vec4(844.35, -1340.61, 24.49, 244.97),
            vec4(844.34, -1346.56, 24.50, 245.28),
            vec4(844.23, -1352.45, 24.50, 245.54)
        },
        ["parkVehicleZone"] = {
            vec3(817.22, -1310.88, 25.07),
            vec3(844.88, -1311.56, 25.07),
            vec3(844.61, -1320.94, 25.07),
            vec3(852.06, -1321.05, 25.07),
            vec3(852.14, -1325.13, 25.07),
            vec3(855.28, -1328.65, 25.07),
            vec3(858.71, -1330.74, 25.07),
            vec3(861.08, -1334.08, 25.07),
            vec3(864.63, -1335.90, 25.07),
            vec3(864.14, -1361.41, 25.07),
            vec3(851.81, -1375.22, 25.07),
            vec3(816.33, -1374.96, 25.07),
        },
        ["label"] = "LaMesaPD Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["SandyPD"] = {
        ["garageType"] = 'skiggesSandyPD',
        ["parkingSpots"] = {
            vec4(1844.74, 3689.50, 32.39, 300.34),
            vec4(1846.44, 3686.12, 32.39, 300.33),
            vec4(1848.46, 3682.84, 32.39, 299.98),
            vec4(1865.29, 3692.72, 32.39, 301.29),
            vec4(1863.30, 3696.06, 32.39, 300.59),
            vec4(1861.42, 3699.31, 32.39, 301.17),
            vec4(1834.92, 3691.21, 32.39, 30.18),
            vec4(1831.71, 3689.14, 32.39, 31.13),
            vec4(1828.30, 3687.61, 32.39, 30.99),
            vec4(1825.04, 3685.39, 32.39, 29.12),
            vec4(1818.30, 3681.66, 32.39, 30.52),
            vec4(1814.90, 3679.92, 32.39, 30.69),
            vec4(1853.85, 3705.12, 32.97, 207.06),
        },
        ["parkVehicleZone"] = {
            vec3(1814.70, 3676.36, 32.97),
            vec3(1807.62, 3687.86, 32.97),
            vec3(1855.52, 3715.52, 32.97),
            vec3(1869.22, 3691.84, 32.97),
            vec3(1845.25, 3677.98, 32.97),
            vec3(1838.65, 3690.11, 32.97),
        },
        ["label"] = "SandyPD Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["MRPDHELI"] = {
        ["garageType"] = 'helicopter',
        ["parkingSpots"] = {
            vec4(449.34, -981.12, 43.08, 269.05),
            vec4(472.11, -998.92, 43.08, 89.34),
        },
        ["parkVehicleZone"] = {
            vec3(466.96, -971.40, 42.69),
            vec3(467.39, -986.26, 42.69),
            vec3(476.41, -986.30, 42.69),
            vec3(476.46, -988.15, 42.69),
            vec3(480.29, -987.96, 42.69),
            vec3(480.52, -1005.53, 42.69),
            vec3(461.69, -1005.80, 42.69),
            vec3(461.83, -998.38, 42.69),
            vec3(426.25, -998.24, 42.69),
            vec3(426.18, -989.36, 42.69),
            vec3(436.21, -989.45, 42.69),
            vec3(436.54, -978.37, 42.69),
            vec3(440.72, -978.09, 42.69),
            vec3(440.76, -971.08, 42.69)
        },
        ["label"] = "MRPD Heli Garage",
        ["jobs"] = {["police"] = 0},
    },
    -- ["SANDYHELI"] = {
    --     ["garageType"] = 'helicopter',
    --     ["vehicleSpawnCoords"] = vector4(1853.448, 3706.222, 34.17623, 209.74),
    --     ["parkVehicleZone"] = {
    --         vec(1850.979, 3696.181, 33),
    --         vec(1861.135, 3704.414, 33),
    --         vec(1855.483, 3714.222, 33),
    --         vec(1844.073, 3708.623, 33),
    --     },
    --     ["label"] = "Sandy Heli Garage",
    --     ["jobs"] = {["police"] = 1},
    -- },
    ["LSBOAT"] = {
        ["garageType"] = 'boat',
        ["blip"] = {
            ["coords"] = vec3(-794.23, -1511.45, -0.88),
            ["sprite"] = 427,
            ["color"] = 3,
            ["scale"] = 0.7,
        },
        ["parkingSpots"] = {
            vec4(-799.02, -1509.07, -0.88, 110.04),
            vec4(-787.61, -1504.91, -0.87, 110.03),
            vec4(-783.54, -1510.24, -0.84, 110.23),
            vec4(-797.91, -1515.56, -0.87, 110.23)
        },
        ["parkVehicleZone"] = {
            vec3(-776.20, -1509.69, 0.48),
            vec3(-817.97, -1528.01, 0.48),
            vec3(-823.17, -1514.96, 0.48),
            vec3(-780.15, -1498.50, 0.48)
        },
        ["label"] = "LS Båd Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["SANDYBOAT"] = {
        ["garageType"] = 'boat',
        ["blip"] = {
            ["coords"] = vec3(1449.61, 3761.77, 30.73),
            ["sprite"] = 427,
            ["color"] = 3,
            ["scale"] = 0.7,
        },
        ["parkingSpots"] = {
            vec4(1435.36, 3761.78, 29.06, 294.95),
            vec4(1445.04, 3766.29, 29.06, 292.83),
            vec4(1461.12, 3773.82, 29.02, 292.84),
            vec4(1477.52, 3781.90, 29.02, 295.70)
        },
        ["parkVehicleZone"] = {
            vec3(1422.01, 3778.90, 31.00),
            vec3(1438.60, 3742.47, 31.00),
            vec3(1492.30, 3773.00, 31.00),
            vec3(1483.08, 3796.17, 31.00)
        },
        ["label"] = "Sandy Båd Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["PALETOBOAT"] = {
        ["garageType"] = 'boat',
        ["blip"] = {
            ["coords"] = vec3(-1608.48, 5254.00, 3.00),
            ["sprite"] = 427,
            ["color"] = 3,
            ["scale"] = 0.7,
        },
        ["parkingSpots"] = {
            vec4(-1602.89, 5259.41, -0.88, 23.59),
        },
        ["parkVehicleZone"] = {
            vec3(-1599.64, 5252.84, 1.47),
            vec3(-1614.61, 5245.41, 1.47),
            vec3(-1624.13, 5263.30, 1.47),
            vec3(-1603.02, 5276.75, 1.47),

        },
        ["label"] = "Paleto Båd Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["PACIFICBOAT"] = {
        ["garageType"] = 'boat',
        ["blip"] = {
            ["coords"] = vec3(3855.04, 4463.49, 1.73),
            ["sprite"] = 427,
            ["color"] = 3,
            ["scale"] = 0.7,
        },
        ["parkingSpots"] = {
            vec4(3854.86, 4455.63, -0.88, 269.71),
        },
        ["parkVehicleZone"] = {
            vec3(3853.36, 4443.68, 1.47),
            vec3(3880.24, 4440.12, 1.47),
            vec3(3883.69, 4471.01, 1.47),
            vec3(3854.62, 4476.36, 1.47)

        },
        ["label"] = "Pacific Båd Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["Military"] = {
        ["garageType"] = 'default',
        ["parkingSpots"] = {
            vec4(-1838.07, 2943.22, 31.23, 329.92)
        },
        ["parkVehicleZone"] = {
            vec3(-1844.46, 2952.79, 31.81),
            vec3(-1851.36, 2941.45, 31.81),
            vec3(-1833.64, 2931.16, 31.81),
            vec3(-1826.72, 2943.30, 31.93)
        },
        ["label"] = "Militær Garage",
        ["jobs"] = {["police"] = 0},
    },
    ["MilitaryHeli"] = {
        ["garageType"] = 'helicopter',
        ["parkingSpots"] = {
            vec4(-1928.80, 3018.73, 31.71, 329.29)
        },
        ["parkVehicleZone"] = {
            vec3(-1904.06, 3026.07, 31.87),
            vec3(-1919.00, 3000.42, 31.87),
            vec3(-1949.19, 3017.98, 31.87),
            vec3(-1934.48, 3043.51, 31.87)
        },
        ["label"] = "Militær Heli Garage",
        ["jobs"] = {["police"] = 0},
    },
}

Config.WhitelistedHelmets = {
    [217] = true,
    [216] = true,
    [215] = true,
    [214] = true,
}

Config.GunWeaponHashes = {
    [GetHashKey("WEAPON_PISTOL")] = true,
    [GetHashKey("WEAPON_COMBATPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOLXM3")] = true,
    [GetHashKey("WEAPON_APPISTOL")] = true,
    [GetHashKey("WEAPON_PISTOL50")] = true,
    [GetHashKey("WEAPON_SNSPISTOL")] = true,
    [GetHashKey("WEAPON_HEAVYPISTOL")] = true,
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = true,
    [GetHashKey("WEAPON_MARKSMANPISTOL")] = true,
    [GetHashKey("WEAPON_REVOLVER")] = true,
    [GetHashKey("WEAPON_DOUBLEACTION")] = true,
    [GetHashKey("WEAPON_CERAMICPISTOL")] = true,
    [GetHashKey("WEAPON_NAVYREVOLVER")] = true,
    [GetHashKey("WEAPON_MICROSMG")] = true,
    [GetHashKey("WEAPON_SMG")] = true,
    [GetHashKey("WEAPON_ASSAULTSMG")] = true,
    [GetHashKey("WEAPON_COMBATPDW")] = true,
    [GetHashKey("WEAPON_MACHINEPISTOL")] = true,
    [GetHashKey("WEAPON_MINISMG")] = true,
    [GetHashKey("WEAPON_RAYCARBINE")] = true,
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = true,
    [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = true,
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = true,
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = true,
    [GetHashKey("WEAPON_MUSKET")] = true,
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = true,
    [GetHashKey("WEAPON_DBSHOTGUN")] = true,
    [GetHashKey("WEAPON_AUTOSHOTGUN")] = true,
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = true,
    [GetHashKey("WEAPON_CARBINERIFLE")] = true,
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = true,
    [GetHashKey("WEAPON_SPECIALCARBINE")] = true,
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = true,
    [GetHashKey("WEAPON_COMPACTRIFLE")] = true,
    [GetHashKey("WEAPON_MG")] = true,
    [GetHashKey("WEAPON_COMBATMG")] = true,
    [GetHashKey("WEAPON_GUSENBERG")] = true,
    [GetHashKey("WEAPON_SNIPERRIFLE")] = true,
    [GetHashKey("WEAPON_HEAVYSNIPER")] = true,
    [GetHashKey("WEAPON_MARKSMANRIFLE")] = true,
}