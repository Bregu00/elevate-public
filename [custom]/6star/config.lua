Config = Config or {}

Config.garageTypes = {
    ['default'] = {
        ['Benefactor'] = {
            {model = "schwarzer2", label = "Benefactor Schwarzer 6STR", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Obey'] = {
            {model = "draftgpr", label = "Obey Drafter WB", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Ubermacht'] = {
            {model = "sentinelsg4", label = "Ubermacht Sentinel SG4", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['BF'] = {
            {model = "clubc", label = "BF Club C", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "clubp", label = "BF Club P", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Annis'] = {
            {model = "elegyrh6", label = "Annis Elegy RH6", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "elegyrh7", label = "Annis Elegy RH7", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "elegyxa19", label = "Annis Elegy WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "eurosx32wb", label = "Annis Euros X32 WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "remusx", label = "Annis Remus X", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "hyczr350", label = "Annis ZR350 WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "roxanne", label = "Annis Roxanne", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Declasse'] = {
            {model = "vigerozxwb", label = "Declasse Vigero ZX WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Dinka'] = {
            {model = "nexus", label = "Dinka Nexus", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Emperor'] = {
            {model = "sheavas", label = "Emperor Sheava S", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Karin'] = {
            {model = "kurxa19", label = "Karin Kuruma X", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "sultanrsv8", label = "Karin Sultan RS V8", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Bravado'] = {
            {model = "hycgaunt", label = "Bravado Gauntlet WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "hycbansh", label = "Bravado Banshee WB", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
    },
}
Config["6strGarage"] = {
    ["6str"] = {
        ["garageType"] = 'default',
        ["parkingSpots"] = {
            vec4(131.50, -3047.20, 5.46, 340.15),
            vec4(138.24, -3047.05, 5.46, 339.55),
            vec4(142.67, -3047.27, 5.46, 338.82),
            vec4(146.60, -3047.70, 5.46, 337.35),
            vec4(125.11, -3034.95, 5.59, 269.44),
            vec4(124.76, -3041.28, 5.46, 270.51)
        },
        ["parkVehicleZone"] = {
            vec4(154.33, -3051.57, 6.04, 46.65),
            vec4(120.82, -3051.44, 6.04, 83.11),
            vec4(120.68, -3007.86, 6.04, 23.08),
            vec4(153.40, -3007.09, 6.04, 284.92)
        },
        ["label"] = "6STR Udstilling",
        ["jobs"] = {["6str"] = 0},
    },
}
