Config = {}

Config.Notifications = "ox" -- ox / mythic_notify / esx
Config.Phone = "qbphone" -- "qbphone" / "roadphone" (Phone System that you are using (this is only if you have Config.SendEmails == true))

Config.MinCops = 0 -- Min amt of cops required to start the job
Config.PoliceJob = 'police'
Config.CallCopsChance = 50
Config.PoliceDispatch = "none" -- "ps-dispatch" / "core_dispatch" / "qs-dispatch" / none

Config.Cooldown = 0 -- Cooldown per job (Seconds)
Config.CostToStart = 0
Config.Deliveries = 5 -- Amount of times the player can deliver packages to the buyer per job
Config.SendEmails = false
Config.WaitListTimer = 15 -- Timer to get a job. (Seconds)

Config.WaitUntilNextBuyer = 15 -- Timer untill the next buyer spawns

Config.OxyBoxItem = "oxyboxes"
Config.OxyItem = "oxy"
Config.OxyMin = 6 -- Min Amount of Oxy Given
Config.OxyMax = 13 -- Max Amount of Oxy Given
Config.ChanceOfOxy = 100 --  Chance of Getting Oxy

Config.GiveMoney = false
Config.ChanceofGivingMoney = 50
Config.AmountOfMoneyMin = 300
Config.AmountofMoneyMax = 600

Config.WashMoney = false
Config.DirtyMoneyItem = "markedbills"
Config.WashMoneyChance = 100
Config.AmountPerDirtyMoneyMin = 500 
Config.AmountPerDirtyMoneyMax = 1000
Config.WashAmount = 5 -- Amount of Dirty Money that can be washed per buyer

Config.SpecialRewardChance = 0
Config.SpecialRewardAmtMin = 0
Config.SpecialRewardAmtMax = 0
Config.SpecialReward = {
    -- "security_card_01",
    -- "tenkgoldchain",
    -- "goldbar",
    -- "goldchain",
    -- "diamond_ring"
}

Config.BossCoords = { -- You can add multiple locations (Every Restart a new location is selected)
    vector4(196.76, -2231.34, 5.95, 92.24)
}

Config.Peds = { -- All Peds used in this script
    "g_m_y_salvaboss_01",
    "a_m_m_og_boss_01",
    "a_m_m_paparazzi_01",
    "a_m_m_socenlat_01",
    "a_m_y_cyclist_01",
    "a_m_y_vinewood_02",
    "a_m_y_smartcaspat_01",
    "g_m_m_casrn_01",
    "g_m_m_chicold_01",
    "g_m_m_armlieut_01",
    "mp_m_bogdangoon",
    "mp_f_execpa_02",
}

Config.PickUpLocations = { -- Locations to pick up the oxy boxes
    vector4(1072.2345, -787.6505, 58.2627, 175.7418),
    vector4(1222.27, -487.97, 66.94, 257.27),
    vector4(1280.4253, 1909.1232, 82.1223, 122.6185),
    vector4(839.3458, 2176.8843, 52.2895, 161.2974),
    vector4(435.7209, 3513.8320, 33.9425, 96.1414),
    vector4(1383.5388, 4305.5420, 36.6635, 34.4972),
    vector4(-474.7727, 6285.8330, 13.6097, 328.6804),
    vector4(-2172.1890, 4286.2119, 49.0967, 58.7330),
    vector4(-2521.1331, 2310.0613, 33.2158, 266.1071),
}

Config.OxyVehicles = { -- Vehicle Spawn Name that the buyers will drive up in
    'sultan',
    'habanero',
    'gresley',
    'fq2',
    'novak',
    'felon',
    'zion',
    'jackal',
    'futo',
    'sentinel',
    'asea',
    'glendale',
    'ingot',
    'surge'
}

Config.PedDrivers = { -- Locations where you deliver the oxy boxes
    [1] = {
        info = {
            startPoint = vector4(-1031.6633, -1524.8673, 5.1941, 121.8719), -- NPC Start Point
            MeetPoint = vector4(-990.0505, -1438.6194, 5.0513, 115.1750), -- NPC Meet Point with Player
            DespawnPoint = vector4(-1137.3114, -1483.3544, 4.4362, 115.5563) -- NPC End Point
        },
    },
    [2] = {
        info = {
            startPoint = vector4(-557.0524, 426.4308, 99.0403, 312.9275),
            MeetPoint = vector4(-570.0207, 322.6127, 84.4806, 349.8416),
            DespawnPoint = vector4(-542.9153, 439.6522, 99.1240, 6.8574)
        },
    },
    [3] = {
        info = {
            startPoint = vector4(902.4401, -87.3093, 78.7620, 61.8786),
            MeetPoint = vector4(840.6104, -143.1678, 77.3780, 233.8478),
            DespawnPoint = vector4(902.4401, -87.3093, 78.7620, 61.8786)
        },
    },
    [4] = {
        info = {
            startPoint = vector4(590.1517, -2226.1274, 5.9863, 166.4852),
            MeetPoint = vector4(502.0261, -2168.0396, 5.9186, 179.2121),
            DespawnPoint = vector4(471.0012, -2145.7800, 5.9225, 280.7334)
        },
    },
    [5] = {
        info = {
            startPoint = vector4(961.5167, -2469.3948, 28.4197, 267.0618),
            MeetPoint = vector4(989.6653, -2512.4192, 28.3020, 1.0402),
            DespawnPoint = vector4(989.6467, -2545.3218, 28.2992, 199.9163)
        },
    },
    [6] = {
        info = {
            startPoint = vector4(1315.1028, -2595.5854, 47.2937, 287.0857),
            MeetPoint = vector4(1438.4523, -2599.0562, 48.1662, 206.5678),
            DespawnPoint = vector4(1462.6993, -2591.9392, 48.5802, 290.8886)
        },
    },
}