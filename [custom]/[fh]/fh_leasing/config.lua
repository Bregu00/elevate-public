Config = {}

Config.Minutes = function(minutes) return minutes * 60 end
Config.Hours = function(hours) return hours * (60 * 60) end
Config.Days = function(days) return days * (24 * (60 * 60)) end

Config.RequiredJobs = {
    policedatabase = {"demo"},
    kriminal = {"demo"}, 
    leasingsystem = {"carver"},
    leasingdatabase = {"carver", "demo"},
    ownedvehicles = {"carver"},
}

Config.JobGradeRequirements = {
    extendLeasing = {
        carver = 1, 
        -- police = 15,
    },
    withdrawLeasing = {
        carver = 2, 
        -- police = 15,
    },
    settingsLeasing = {
        carver = 3, 
        -- police = 15,
    },
}

Config.Company = {
    DemoSpawners = {
        {spawnPoint = vector4(-1192.0664, -1303.6860, 4.9729, 114.4094)},
        {spawnPoint = vector4(-1198.4736, -1307.0317, 4.9729, 321.3311)},
        {spawnPoint = vector4(-1211.6722, -1321.3855, 4.9724, 145.5416)},
        {spawnPoint = vector4(-1205.1113, -1318.8357, 4.9719, 109.3318)},
        {spawnPoint = vector4(-1191.7072, -1321.0231, 5.0517, 208.4705)},
        {spawnPoint = vector4(-1181.2106, -1328.9666, 4.9729, 124.9541)},
        {spawnPoint = vector4(-1189.4589, -1332.6981, 4.9729, 142.3183)},

    },

    Catalogs = {
        {distance = 1.5, pos = vector3(-772.5445, -1035.1877, 10.6068), type = 25, spawnPoint = vector4(-763.1927, -1011.8715, 13.2476, 29.6335)},
    },

    PolyZone = {
        vector3(-1175.1523, -1332.5712, 4.6317),
        vector3(-1205.6855, -1346.4606, 4.6317),
        vector3(-1222.3499, -1311.0317, 4.6317),
        vector3(-1190.6492, -1297.7717, 4.6317),
    },

    SoldVehicleSpawn = {
        vec4(-1206.30, -1324.78, 3.33, 293.55),
    },
}

Config.ClassOrder = {
    "Super",
    "Sports",
    "Sports Classic",
    "Sedan",
    "SUV",
    "Motorcycle",
    "Muscle"
}

Config.LeasingSystemEntries = {
}
