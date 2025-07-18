Config = {}

Config.Webhook = ''

Config.Minutes = function(minutes) return minutes * 60 end
Config.Hours = function(hours) return hours * (60 * 60) end
Config.Days = function(days) return days * (24 * (60 * 60)) end

Config.MaxVehicleLists = 80
Config.MaxVehiclesPerUser = 3

Config.VehicleGPSDisableCount = 3
Config.VehiclesRefresh = Config.Hours(2)
Config.VehicleCooldown = Config.Hours(2)

Config.VehicleStorageInteractions = {
    [1] = {
        interaction = vec3(-1581.31, -594.59, -89.82),
        storageEnter = vec4(-1554.37, -579.98, 33.92, 220.5),
        storageExit = vec4(-1582.06, -614.99, -90.20, 2.5),
        storageLocation = vec3(-1585.0, -596.0, -100.0),
        deliveryLocation = vec4(-1537.62, -577.68, 25.13, 35.5),
    },
    [2] = {
        interaction = vec3(-156.23, -618.65, -89.82),
        storageEnter = vec4(-129.09, -648.96, 40.68, 340.5),
        storageExit = vec4(-157.03, -639.08, -90.20, 2.5),
        storageLocation = vec3(-160.0, -620.0, -100),
        deliveryLocation = vec4(-144.08, -576.95, 31.85, 160.5),
    },
    [3] = {
        interaction = vec3(-816.39, -2128.59, -119.82),
        storageEnter = vec4(-823.75, -2103.58, 8.95, 316.5),
        storageExit = vec4(-817.18, -2149.19, -120.20, 2.5),
        storageLocation = vec3(-820.0, -2130.0, -130.0),
        deliveryLocation = vec4(-803.58, -2119.26, 8.23, 45.5),
    },
    [4] = {
        interaction = vec3(-81.48, -818.64, -119.92),
        storageEnter = vec4(-83.69, -835.37, 40.55, 160.5),
        storageExit = vec4(-82.13, -838.95, -120.20, 2.5),
        storageLocation = vec3(-85.0, -820.0, -130.0),
        deliveryLocation = vec4(-84.02, -820.82, 34.45, 350.5),
    },
    [5] = {
        interaction = vec3(-1066.34, -2848.59, -69.95),
        storageEnter = vec4(-1070.12, -2867.25, 14.30, 150.5),
        storageExit = vec4(-1067.11, -2868.98, -70.20, 2.5),
        storageLocation = vec3(-1070.0, -2850.0, -80.0),
        deliveryLocation = vec4(-1078.40, -2865.15, 13.37, 60.5),
    },
}

Config.LevelManagement = {
    [1] = {
        label = "Nybegynder",
        requiredEXPAmount = 0,
        maxEXPToRequire = 10,
    },
    [2] = {
        label = "Dygtig",
        requiredEXPAmount = 100,
        maxEXPToRequire = 20,
    },
    [3] = {
        label = "Ekspert",
        requiredEXPAmount = 500,
        maxEXPToRequire = 50,
    },
    [4] = {
        label = "Veteran",
        requiredEXPAmount = 750,
        maxEXPToRequire = 75,
    },
    [5] = {
        label = "Mester",
        requiredEXPAmount = 1400,
        maxEXPToRequire = 100,
    },
    [6] = {
        label = "Øvet Mester",
        requiredEXPAmount = 2000,
        maxEXPToRequire = 105,
    },
    [7] = {
        label = "Avanceret Mester",
        requiredEXPAmount = 2600,
        maxEXPToRequire = 110,
    },
    [8] = {
        label = "Ekspert Mester",
        requiredEXPAmount = 3200,
        maxEXPToRequire = 115,
    },
    [9] = {
        label = "Professionel Mester",
        requiredEXPAmount = 3800,
        maxEXPToRequire = 120,
    },
    [10] = {
        label = "Super Duper Mega Mester",
        requiredEXPAmount = 4500,
        maxEXPToRequire = 125,
    },
}

Config.StorageVehicles = {
    ["kanjo"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["issi2"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["club"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["asea"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["ingot"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["stratum"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["gauntlet"] = {
        model = "imp_prop_covered_vehicle_03a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["ruiner"] = {
        model = "imp_prop_covered_vehicle_03a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["blade"] = {
        model = "imp_prop_covered_vehicle_04a",
        requiredexp = 0,
        expreward = 5,
        buyPrice = 30000,      -- Originalt 20000
        sellPrice = 75000,     -- Originalt 50000
    },
    ["seminole"] = {
        model = "imp_prop_covered_vehicle_07a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 45,
    },
    ["seminole2"] = {
        model = "imp_prop_covered_vehicle_07a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 45,
    },
    ["baller"] = {
        model = "xm3_prop_xm3_cover_veh_01a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 45,
    },
    ["futo"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 45,
    },
    ["sultan"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 45,
    },
    ["remus"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 100,
        expreward = 10,
        buyPrice = 60000,      -- Originalt 40000
        sellPrice = 120000,    -- Originalt 80000
        chance = 35,
    },
    ["komoda"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 500,
        expreward = 15,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 40,
    },
    ["jugular"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 500,
        expreward = 25,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 35,
    },
    ["drafter"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 500,
        expreward = 15,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 35,
    },
    ["cinquemila"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 500,
        expreward = 15,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 35,
    },
    ["rhinehart"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 500,
        expreward = 15,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 35,
    },
    ["schafter4"] = {
        model = "imp_prop_covered_vehicle_02a",
        requiredexp = 500,
        expreward = 15,
        buyPrice = 75000,      -- Originalt 50000
        sellPrice = 150000,    -- Originalt 100000
        chance = 35,
    },
    ["italigtb"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 750,
        expreward = 35,
        buyPrice = 85500,     -- Originalt 75000
        sellPrice = 170250,    -- Originalt 150000
        chance = 35,
        hasPoliceGPS = true,
    },
    ["vacca"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 1400,
        expreward = 50,
        buyPrice = 150000,     -- Originalt 100000
        sellPrice = 350000,    -- Originalt 200000
        chance = 30,
        hasPoliceGPS = true,
    },
    ["xa21"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 2000,
        expreward = 50,
        buyPrice = 202500,     -- Originalt 135000
        sellPrice = 487500,    -- Originalt 270000
        chance = 25,
        hasPoliceGPS = true,
    },
    ["entity2"] = {
        model = "prop_entityxf_covered",
        requiredexp = 2600,
        expreward = 55,
        buyPrice = 255000,     -- Originalt 170000
        sellPrice = 565000,    -- Originalt 340000
        chance = 20,
        hasPoliceGPS = true,
    },
    ["t20"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 3200,
        expreward = 55,
        buyPrice = 307500,     -- Originalt 205000
        sellPrice = 722500,    -- Originalt 410000
        chance = 15,
        hasPoliceGPS = true,
    },
    ["nero"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 3800,
        expreward = 60,
        buyPrice = 360000,     -- Originalt 240000
        sellPrice = 780000,    -- Originalt 480000
        chance = 10,
        hasPoliceGPS = true,
    },
    ["turismor"] = {
        model = "imp_prop_covered_vehicle_01a",
        requiredexp = 4500,
        expreward = 75,
        buyPrice = 500000,
        sellPrice = 1000000,
        chance = 5,
        hasPoliceGPS = true,
    },
}

Config.StorageOffsets = json.decode('[{"x":-9.5599365234375,"y":-6.71359252929687,"z":8.7939224243164,"w":270.0},{"x":-9.595947265625,"y":-2.96368408203125,"z":8.79000854492187,"w":270.0},{"x":-9.595947265625,"y":1.82527160644531,"z":8.79000854492187,"w":270.0},{"x":-9.5599365234375,"y":-11.15383911132812,"z":8.7939224243164,"w":270.0},{"x":-9.5599365234375,"y":-14.91475677490234,"z":8.7939224243164,"w":270.0},{"x":-9.5599365234375,"y":-6.71359252929687,"z":4.38835906982421,"w":270.0},{"x":-9.595947265625,"y":-2.96368408203125,"z":4.38444519042968,"w":270.0},{"x":-9.595947265625,"y":1.82527160644531,"z":4.38444519042968,"w":270.0},{"x":-9.5599365234375,"y":-11.15383911132812,"z":4.38835906982421,"w":270.0},{"x":-9.5599365234375,"y":-14.91475677490234,"z":4.38835906982421,"w":270.0},{"x":-9.5599365234375,"y":-6.71359252929687,"z":-0.0286865234375,"w":270.0},{"x":-9.595947265625,"y":-2.96368408203125,"z":-0.03260040283203,"w":270.0},{"x":-9.595947265625,"y":1.82527160644531,"z":-0.03260040283203,"w":270.0},{"x":-9.5599365234375,"y":-11.15383911132812,"z":-0.0286865234375,"w":270.0},{"x":-9.5599365234375,"y":-14.91475677490234,"z":-0.0286865234375,"w":270.0},{"x":4.2506103515625,"y":-3.05670928955078,"z":-0.02869415283203,"w":90.0},{"x":4.2867431640625,"y":-6.80672454833984,"z":-0.03260803222656,"w":90.0},{"x":4.2864990234375,"y":-11.59600067138671,"z":-0.03260803222656,"w":90.0},{"x":4.2503662109375,"y":1.38323974609375,"z":-0.02869415283203,"w":90.0},{"x":4.2506103515625,"y":5.14431762695312,"z":-0.02869415283203,"w":90.0},{"x":4.250732421875,"y":-3.05670166015625,"z":4.37311553955078,"w":90.0},{"x":4.286865234375,"y":-6.80671691894531,"z":4.36920166015625,"w":90.0},{"x":4.28662109375,"y":-11.59599304199218,"z":4.36920166015625,"w":90.0},{"x":4.25048828125,"y":1.38324737548828,"z":4.37311553955078,"w":90.0},{"x":4.250732421875,"y":5.14432525634765,"z":4.37311553955078,"w":90.0}]')

Config.CarSpawns = {
    vector4(-144.9210, 6330.7358, 31.6390, 47.3744),
    vector4(1772.7112, 3702.6738, 34.2460, 209.8562),
    vector4(2201.3210, 4832.8438, 44.8713, 352.2229),
    vector4(2238.9316, 5142.6201, 55.5859, 226.2356),
    vector4(2585.9700, 2580.1448, 34.2481, 197.6473),
    vector4(1314.8097, -1635.4552, 52.1301, 306.0729),
    vector4(1053.5216, -2240.9497, 30.4847, 352.3929),
    vector4(459.2600, -1929.5493, 24.8741, 295.1779),
    vector4(-1281.0027, -1221.9221, 4.5753, 20.7037),
    vector4(-1610.8682, -401.5499, 41.9784, 142.2899),
    vector4(-1037.4736, 467.3300, 77.6051, 315.0707),
    vector4(-555.3716, 665.0715, 145.0839, 336.9124),
}

Config.SellLocation = {
    vector4(235.0073, -3316.1289, 5.7903, 272.3795),
    vector4(1189.46, -3105.62, 5.66, 182.88),
    vector4(-1154.2662, -2173.9592, 13.2381, 135.4676),
}
