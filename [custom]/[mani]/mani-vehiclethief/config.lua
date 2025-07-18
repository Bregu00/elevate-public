local Config = {}

Config.Debug = false

Config.Migrate = true

Config.ContractInterval = 2 * 60 * 60 * 1000

Config.Cooldown = 2 * 60 * 60 -- Seconds

Config.HackingCooldown = 1 * 1000 * 60

Config.GpsInterval = 2500

Config.GarageLocations = {
    {
        ['Entrance'] = vec4(-1554.29, -580.06, 33.92, 35.0),
        ['VehicleExit'] = vec4(-1538.11, -576.85, 25.43, 35.0)
    },
    {
        ['Entrance'] = vec4(-83.39, -835.38, 40.56, 340.0),
        ['VehicleExit'] = vec4(-84.14, -821.49, 35.35, 350.0)
    },
    {
        ['Entrance'] = vec4(-129.11, -649.14, 40.5, 160.0),
        ['VehicleExit'] = vec4(-144.26, -577.31, 32.15, 160.0)
    },
    {
        ['Entrance'] = vec4(-823.89, -2103.81, 8.96, 137.00),
        ['VehicleExit'] = vec4(-805.05, -2118.45, 8.52, 225.0)
    },
    {
        ['Entrance'] = vec4(-1070.00, -2867.09, 14.29, 332.50),
        ['VehicleExit'] = vec4(-1078.75, -2865.52, 13.66, 240.0)
    },
}

Config.Classes = {
    ['D'] = {
        ['XPRequired'] = 0,
        ['XPReward'] = 5,
        ['Price'] = 30000,
        ['PriceReward'] = 162000, -- Increased by 20% from original
        ['Stock'] = { min = 10, max = 15 },
        ['Vehicles'] = {
            { model = 'gbvivant', label = 'Bordeaux Vivant' },
            { model = 'gbbriosof', label = 'Grotti Brioso Fulmin' },
            { model = 'gbkomodagt', label = 'Lampadati Komoda GT' },
            { model = 'gbstanierle', label = 'Vapid Stanier LE' },
        }
    },
    ['C'] = {
        ['XPRequired'] = 125,
        ['XPReward'] = 10,
        ['Price'] = 60000,
        ['PriceReward'] = 259200, -- Increased by 20% from original
        ['Stock'] = { min = 10, max = 15 },
        ['Vehicles'] = {
            { model = 'gbclubxr', label = 'BF Club XR' },
            { model = 'gbturismogt', label = 'Grotti Turismo GT' },
            { model = 'gbcometcl', label = 'Pfister Comet Classic' },
            { model = 'gbschrauber', label = 'Benefactor Schrauber' },
        }
    },
    ['B'] = {
        ['XPRequired'] = 500,
        ['XPReward'] = 15,
        ['Price'] = 75000,
        ['PriceReward'] = 364500, -- Increased by 20% from original
        ['Stock'] = { min = 10, max = 15 },
        ['Vehicles'] = {
            { model = 'gbsolacev', label = 'Dewbauchee Solace Vi' },
            { model = 'gbsapphire', label = 'Enus Sapphire' },
            { model = 'gbbisonhf', label = 'Bravado Bison HF' },
            { model = 'gbeon', label = 'Coil Eon' },
        }
    },
    ['A'] = {
        ['XPRequired'] = 750,
        ['XPReward'] = 35,
        ['Price'] = 100000,
        ['PriceReward'] = 600000, -- Increased by 20% from original
        ['Stock'] = { min = 10, max = 15 },
        ['Hack'] = { min = 1, max = 2 },
        ['MinCops'] = 1,
        ['Vehicles'] = {
            { model = 'gbmogulrs', label = 'Karin Mogul RS' },
            { model = 'gbsultanrsx', label = 'Karin Sultan RSx' },
            { model = 'gbsentinelgts', label = 'Ubermacht Sentinel G' },
            { model = 'gbdominatorgsx', label = 'Vapid Dominator GSX' },
            { model = 'gbargento7f', label = 'Obey Argento 7F' },
        }
    },
    ['S'] = {
        ['XPRequired'] = 1750,
        ['XPReward'] = 50,
        ['Price'] = 200000,
        ['PriceReward'] = 803250, -- Decreased by 15%
        ['Stock'] = { min = 4, max = 6 },
        ['Hack'] = { min = 4, max = 6 },
        ['MinCops'] = 2,
        ['Vehicles'] = {
            { model = 'gbbanshees', label = 'Bravado Banshee S' },
            { model = 'gbcomets2rc', label = 'Pfister Comet S2R Cabrio' },
            { model = 'gbmilano', label = 'Grotti Milano' },
            { model = 'gbronin', label = 'Emperor Ronin' },
        }
    },
    ['S+'] = {
        ['XPRequired'] = 4000,
        ['XPReward'] = 60,
        ['Price'] = 250000,
        ['PriceReward'] = 1032750, -- Decreased by 15%
        ['Stock'] = { min = 3, max = 4 },
        ['Hack'] = { min = 4, max = 8 },
        ['MinCops'] = 3,
        ['Vehicles'] = {
            { model = 'gbcomets2r', label = 'Pfister Comet S2R' },
            { model = 'gbtr3s', label = 'Progen TR3-S' },
            { model = 'gbprospero', label = 'Pegassi Prospero' },
        }
    },
}

Config.SpawnLocations = {
    vec4(-701.87, -1379.42, 4.65, 319.97),
    vec4(107.55, -1071.45, 28.85, 66.66),
    vec4(-281.47, -1226.05, 26.02, 179.86),
    vec4(-281.40, -1226.03, 40.08, 269.95),
    vec4(306.04, -2519.47, 5.64, 288.58),
    vec4(1309.30, -2037.72, 45.23, 291.97),
    vec4(1216.42, -1289.05, 34.56, 265.79),
    vec4(1295.35, -546.81, 69.97, 78.78),
    vec4(1146.90, -373.82, 66.67, 351.25),
    vec4(914.52, -180.02, 73.77, 238.43),
    vec4(879.61, -83.70, 78.38, 150.50),
    vec4(605.15, 74.83, 91.72, 164.41),
    vec4(612.51, 248.33, 102.46, 152.25),
    vec4(1194.14, 633.65, 98.82, 324.02),
    vec4(1172.04, 1815.21, 74.09, 127.03),
    vec4(782.86, 2276.37, 48.07, 166.65),
    vec4(-690.23, 2992.68, 24.13, 298.19),
    vec4(-2628.34, 2307.72, 24.95, 113.82),
    vec4(-3093.51, 1351.82, 19.59, 178.81),
    vec4(-2204.74, -363.18, 12.47, 6.96),
    vec4(-2019.14, -461.00, 10.88, 320.01),
    vec4(-1721.37, -722.20, 9.39, 324.83),
    vec4(-1451.11, -931.19, 9.22, 229.81),
    vec4(-1082.84, -1706.82, 3.73, 316.33),
    vec4(2605.45, 2464.74, 25.90, 178.69),
    vec4(1055.61, -2222.46, 30.01, 354.22),
    vec4(468.45, -1925.02, 24.75, 295.58),
    vec4(-1265.49, -1228.27, 4.41, 105.86),
    vec4(-1591.63, -403.24, 42.56, 50.86),
    vec4(-1033.27, 493.72, 80.23, 269.90),
    vec4(-555.05, 665.54, 144.68, 341.70)
}

Config.DeliveryLocations = {
    vec4(1130.21, -795.22, 57.63, 90.0),
    vec4(234.31, -3316.16, 4.50, 90.0),
    vec4(1189.47, -3105.81, 4.36, 180.08),
    vec4(-1283.28, -3417.93, 12.65, 150.0),
    -- vec4(760.50, -1865.86, 28.01, 90.0),
    vec4(1357.82, -2095.39, 50.71, 40.0),
    vec4(693.01, -1012.04, 21.44, 360.0),
    vec4(585.60, 2789.55, 40.90, 275.0),
}

Config.Settings = {
    ['RadiusBlip'] = {
        ['Offset'] = 150,
        ['Radius'] = 250.0, -- For some reason doesn't work without .0
        ['Color'] = 3,
        ['Alpha'] = 128
    },
    ['VehicleBlip'] = {
        ['Color'] = 6,
        ['Icon'] = 523,
        ['Scale'] = 0.8,
    },
    ['GarageBlip'] = {
        ['Color'] = 3,
        ['Icon'] = 524,
        ['Scale'] = 0.8,
    },
    ['DeliveryBlip'] = {
        ['Color'] = 3,
        ['Icon'] = 304,
        ['Scale'] = 0.8,
    },
    ['SpawnRadius'] = 250,
    ['AddVehicleBlipInterval'] = 10000,
    ['PedModel'] = 'A_M_Y_GenStreet_01'
}

Config.Shell = {
    ['Model'] = 'mani_garage_a',
    ['Offsets'] = {
        ['Exit'] = vec3(2.99, -19.13, 9.80),
        ['Computer'] = vec3(8.16, -4.72, 9.59),
        ['Slots'] = {
            vec4(-9.60, 1.85, 8.79, 270),
            vec4(-9.60, -2.91, 8.79, 270),
            vec4(-9.60, -6.52, 8.79, 270),
            vec4(-9.60, -10.98, 8.79, 270),
            vec4(-9.60, -14.72, 8.79, 270),

            vec4(-9.60, 1.85, 4.40, 270),
            vec4(-9.60, -2.91, 4.40, 270),
            vec4(-9.60, -6.52, 4.40, 270),
            vec4(-9.60, -10.98, 4.40, 270),
            vec4(-9.60, -14.72, 4.40, 270),

            vec4(4.50, -11.26, 4.40, 90),
            vec4(4.50, -6.52, 4.40, 90),
            vec4(4.50, -2.91, 4.40, 90),
            vec4(4.50, 1.85, 4.40, 90),
            vec4(4.50, 5.18, 4.40, 90),

            vec4(-9.60, 1.85, -0.04, 270),
            vec4(-9.60, -2.91, -0.04, 270),
            vec4(-9.60, -6.52, -0.04, 270), 
            vec4(-9.60, -10.98, -0.04, 270),
            vec4(-9.60, -14.72, -0.04, 270),

            vec4(4.50, -11.26, -0.04, 90),
            vec4(4.50, -6.52, -0.04, 90),
            vec4(4.50, -2.91, -0.04, 90),
            vec4(4.50, 1.85, -0.04, 90),
            vec4(4.50, 5.18, -0.04, 90),
        }
    }
}

Config.WarehouseLimit = #Config.Shell['Offsets']['Slots']

Config.PersonalLimit = 2

Config.CommandPerms = {
    ['SetXP'] = {
        ['Group'] = 'group.god',
        ['Command'] = 'admin:setBiltyvXP'
    }
}

return Config