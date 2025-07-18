Config = Config or {}

-- Police Officers needed for doing action on Containers.

Config.PoliceNeeded = 0

-- Checking Police only on start 
-- If this is true, it will only check police online on starting the heist.

Config.OnlyCheckOnStart = true

-- How often the server removes all containers and runs a new spawn
-- The value is determine in Minutes (180m = 3 hours).
-- The Refresh timer RESET after every restart.

Config.RefreshTimer = 180

-- Determines the cooldown for when the containers should spawn after a restart.
-- So just to both to 1, if you want to have them instant spawned.

Config.MinDelay = 5
Config.MaxDelay = 10

-- How many containers which should spawn.
-- This number cannot exceeds the number og elements in the array.

Config.SpawnContainerAmount = 40

-- If you want to use Stausi interaction menu for this script, set this to false.
-- If you want to use your ox_target interaction menu, set this to true.

Config.UseOxTarget = true

-- This will enable or disable if police should be alerted.

Config.PoliceAlert = true

-- This will enable or disable police alert if a NPC see you are robbing a container
-- Config.PoliceAlert NEEDS to be true, for this to function.

Config.NPCNotify = true

-- The chance for notify the police in percentage from 0 to 100

Config.NotifyChance = 10

-- The translation for every error message.
-- If you don't want any message you test leave it blank with "".

Config.Error = "Fejl"

Config.NoPolice = "Der er ikke nok politi"
Config.NotDeleted = "Containeren blev ikke slettet. Find en anden."

Config.NoItems = "Du har ikke nok genstande til dette."
Config.CantCarry = "Du kan ikke bære resultatet af dette."

Config.EmptyingSafe = "Tømmer pengeskabet"
Config.EmptyingCrate = "Tømmer kassen"

Config.OpenContainer = "Åbn container"
Config.OpenSafe = "Åbn pengeskab"
Config.EmptySafe = "Tøm pengeskab"
Config.TakeMoney = "Tag pengene"
Config.OpenBox = "Åbn kassen"

-- SafeCracking Button Configuration
-- This configuration links each button label to a variable in the Config for easier translation and customization.
-- These variables define the instructions for the SafeCracking mini-game controls.

Config.FastRight = "Hurtigt Højre"         -- Label for the button to rotate the dial quickly to the right
Config.SlowRight = "Langsomt Højre"        -- Label for the button to rotate the dial slowly to the right
Config.SlowLeft = "Langsomt Venstre"       -- Label for the button to rotate the dial slowly to the left
Config.FastLeft = "Hurtigt Venstre"        -- Label for the button to rotate the dial quickly to the left
Config.AttemptCrack = "Forsøg Dirke"       -- Label for the button to try cracking the safe at the current position
Config.Cancel = "Annuller"                 -- Label for the button to cancel the attempt and exit

-- Required Items for each action, the players does.
-- Use the example below, to determine what items should be used.
-- Please don't delete any action, you could maybe use it later.

Config.RequiredItems = {
    ["open"] = {
        { name = "angle_grinder", amount = 1 },
    },
    ["safe"] = {
        { name = "lockpick", amount = 1 },
    },
    ["lootsafe"] = {
    },
    ["lootcrate"] = {
    },
    ["loot"] = {
    },
}

-- Reward Items for each action, the players does.
-- Use the example below, to determine what items should be reward.
-- The amount is in an array, with a minimum and a maximum value, which should be rewarded.
-- The chance is from 1 to 100, if you want variable items in your rewards.

Config.RewardItems = {
    ["open"] = {},
    ["safe"] = {},
    ["lootsafe"] = {
        { item = "black_money", amount = { min = 11500, max = 20500 }, chance = 100 },
        { item = "luxurious_watch", amount = { min = 1, max = 2 }, chance = 15 },
        { item = "gold_bar", amount = { min = 1, max = 1 }, chance = 10 },
        { item = "ring", amount = { min = 2, max = 6 }, chance = 15 },
        { item = "weapon_snspistol", amount = { min = 1, max = 1 }, chance = 1 },
    },
    ["lootcrate"] = {
        { item = "ammo", amount = { min = 10, max = 25 }, chance = 100 },
        { item = "thermite", amount = { min = 1, max = 1 }, chance = 5 },
        { item = "bomb_c4", amount = { min = 1, max = 1 }, chance = 5 },
        { item = "gold_bar", amount = { min = 1, max = 2 }, chance = 15 },
    },
    ["loot"] = {
        { item = "black_money", amount = { min = 19000, max = 31000 }, chance = 100 },
    },
}

-- Time it takes the player to empty the safe in the container.
-- The value is in MS, so the default value is 20000, which is 20 seconds.

Config.EmptySafeTime = 20000

-- Time it takes the player to empty the crate in the container.
-- The value is in MS, so the default value is 20000, which is 20 seconds.

Config.EmptyBoxTime = 20000

-- Container Location List
-- This list would randomize every spawn, so the order wouldn't matter.

Config.ContainerLocations = {
    vector4(-1925.25, -3006.16, 13.94, 182.5),
    vector4(-1931.15, -3003.91, 13.94, 104.5),
    vector4(-1444.43, -3328.52, 13.94, 151.5),
    vector4(-1399.90, -3325.28, 13.94, 242.5),
    vector4(-1568.96, -3244.32, 13.94, 330.5),
    vector4(-1678.28, -3181.15, 13.94, 329.5),
    vector4(-15.71, 6255.07, 31.3, 204.5),
    vector4(-56.91, 6272.05, 31.39, 215.5),
    vector4(-1491.28, -3275.11, 13.94, 333.5),
    vector4(-150.51, 6186.5, 31.22, 169.5),
    vector4(-189.45, 6235.82, 31.49, 140.5),
    vector4(-805.22, -2846.64, 13.94, 78.5),
    vector4(-147.51, 6262.66, 31.54, 284.5),
    vector4(-805.80, -2854.8, 13.94, 62.5),
    vector4(-206.27, 6302.47, 31.48, 45.5),
    vector4(-887.81, -2977.37, 13.94, 154.5),
    vector4(-224.38, 6271.79, 31.68, 321.5),
    vector4(-889.22, -2967.61, 13.94, 148.5),
    vector4(-1310.28, -2340.17, 14.09, 242.5),
    vector4(-1298.49, -2318.62, 14.08, 244.5),
    vector4(-193.86, 6563.08, 11.11, 342.5),
    vector4(-1178.67, -2033.78, 13.85, 80.5),
    vector4(-187.66, 6559.50, 11.1, 330.5),
    vector4(-1177.48, -2029.56, 13.57, 73.5),
    vector4(-221.17, 6528.72, 11.09, 79.5),
    vector4(-214.6, 6545.24, 11.09, 56.5),
    vector4(-1154.76, -2035.83, 13.16, 318.5),
    vector4(-397.03, 6159.07, 31.47, 174.5),
    vector4(-1022.07, -2202.33, 8.98, 46.5),
    vector4(-1008.78, -2201.54, 8.98, 317.5),
    vector4(-401.54, 6083.76, 31.5, 137.5),
    vector4(-305.72, 6039.99, 31.45, 314.5),
    vector4(-277.47, 6022.34, 31.77, 228.5),
    vector4(-666.69, 5829.24, 17.33, 316.5),
    vector4(-520.67, -2867.93, 6.0, 226.5),
    vector4(-442.72, -2751.91, 6.0, 184.5),
    vector4(-595.92, 5341.36, 70.37, 191.5),
    vector4(-596.06, 5324.02, 70.29, 331.5),
    vector4(-384.46, -2668.25, 6.0, 43.5),
    vector4(-372.5, -2657.05, 6.0, 13.5),
    vector4(-465.7, 5371.59, 80.78, 257.5),
    vector4(-529.26, 5384.0, 70.3, 344.5),
    vector4(-333.5, -2432.83, 6.0, 232.5),
    vector4(-285.77, -2420.3, 6.0, 235.5),
    vector4(-85.04, -2548.78, 6.01, 237.5),
    vector4(-91.73, -2556.55, 6.0, 207.5),
    vector4(-2227.74, 4219.96, 46.93, 245.5),
    vector4(-2173.54, 4260.98, 48.95, 242.5),
    vector4(-226.31, -2671.43, 6.0, 3.5),
    vector4(-186.8, -2641.85, 6.02, 180.5),
    vector4(-105.63, -2712.94, 6.0, 359.5),
    vector4(47.9, -2751.19, 6.0, 358.5),
    vector4(53.88, -2743.77, 6.0, 93.5),
    vector4(77.88, -2672.94, 6.0, 178.5),
    vector4(-2194.12, -418.82, 13.09, 139.5),
    vector4(-110.49, -2482.67, 6.02, 56.5),
    vector4(-116.22, -2478.92, 6.02, 236.5),
    vector4(-24.94, -2472.83, 6.0, 51.5),
    vector4(-16.19, -2475.76, 6.0, 236.5),
    vector4(15.73, -2454.57, 6.0, 234.5),
    vector4(66.0, -2489.71, 6.0, 235.5),
    vector4(-1301.95, -1615.68, 4.1, 211.5),
    vector4(73.05, -2403.44, 5.99, 273.5),
    vector4(56.34, -2483.2, 8.81, 236.5),
    vector4(118.5, -2691.78, 6.0, 92.5),
    vector4(-631.26, -1727.39, 24.09, 301.5),
    vector4(211.73, -2833.07, 6.01, 270.5),
    vector4(-653.31, -1708.68, 24.75, 316.5),
    vector4(314.92, -2943.12, 5.99, 267.5),
    vector4(-630.19, -1784.23, 24.0, 308.5),
    vector4(245.1, -3338.63, 5.81, 183.5),
    vector4(124.66, -3327.3, 6.02, 1.5),
    vector4(136.69, -2968.35, 6.27, 27.5),
    vector4(-343.45, -1576.51, 25.22, 211.5),
    vector4(-351.27, -1515.44, 27.72, 271.5),
    vector4(240.18, -2734.22, 5.96, 316.5),
    vector4(-357.72, -1498.11, 30.17, 90.5),
    vector4(561.03, -2842.2, 6.0, 308.5),
    vector4(455.63, -2773.53, 6.0, 332.5),
    vector4(-310.7, -1170.12, 23.35, 91.5),
    vector4(587.33, -2884.46, 6.05, 271.5),
    vector4(-433.81, -1077.95, 23.94, 192.5),
    vector4(-477.61, -1022.06, 23.55, 2.5),
    vector4(491.74, -3003.19, 6.04, 91.5),
    vector4(477.76, -2994.79, 6.04, 267.5),
    vector4(-493.64, -916.65, 23.96, 55.5),
    vector4(-466.41, -874.87, 23.74, 274.5),
    vector4(444.04, -3080.1, 6.06, 179.5),
    vector4(-521.13, -1009.52, 23.25, 186.5),
    vector4(-507.83, -1060.96, 23.31, 241.5),
    vector4(598.1, -3148.44, 6.06, 89.5),
    vector4(463.18, -3231.28, 6.06, 91.5),
    vector4(503.44, -3383.34, 6.06, 178.5),
    vector4(473.58, -3351.88, 6.06, 92.5),
    vector4(474.28, -3338.78, 6.06, 88.5),
    vector4(-440.65, -2277.93, 7.6, 276.5),
    vector4(1285.21, -2563.34, 44.18, 156.5),
    vector4(-372.61, -2283.48, 7.6, 179.5),
    vector4(1525.56, -2535.77, 57.31, 171.5),
    vector4(1509.87, -2135.41, 76.52, 2.5),
    vector4(367.02, -2750.16, 6.14, 7.5),
    vector4(1566.98, -2137.14, 77.61, 288.5),
    vector4(1523.85, -2079.39, 77.19, 119.5),
    vector4(1661.34, -1843.15, 109.35, 2.5),
    vector4(1748.38, -1469.35, 112.77, 316.5),
    vector4(879.72, -3309.58, 5.89, 87.5),
    vector4(991.36, -3257.96, 5.89, 241.5),
    vector4(1244.43, -3168.78, 5.52, 88.5),
    vector4(1458.95, -1936.35, 71.31, 86.5),
    vector4(1285.95, -3127.12, 5.9, 273.5),
    vector4(1240.42, -3104.94, 6.02, 180.5),
    vector4(1748.34, -1583.38, 112.6, 239.5),
    vector4(1167.57, -2978.92, 5.9, 87.5),
    vector4(1110.86, -3031.63, 5.9, 89.5),
    vector4(1054.49, -3039.54, 5.9, 87.5),
    vector4(959.46, -3097.57, 5.9, 93.5),
    vector4(959.31, -3088.96, 5.9, 267.5),
    vector4(942.56, -3086.3, 5.9, 89.5),
    vector4(852.25, -3097.33, 5.9, 102.5),
    vector4(2548.89, 339.43, 108.45, 86.5),
    vector4(681.74, -2730.91, 6.07, 306.5),
    vector4(2785.88, 1681.22, 24.48, 182.5),
    vector4(993.44, -2411.04, 30.5, 264.5),
    vector4(2859.04, 1447.14, 24.56, 163.5),
    vector4(1130.38, -2086.77, 31.0, 181.5),
    vector4(1141.35, -2019.51, 31.01, 327.5),
    vector4(2660.87, 1576.03, 24.5, 359.5),
    vector4(1100.44, -1982.31, 31.01, 235.5),
    vector4(2799.26, 1411.34, 24.44, 259.5),
    vector4(1035.91, -1960.34, 31.01, 358.5),
    vector4(1005.94, -1917.34, 31.13, 340.5),
    vector4(2450.83, 1580.79, 32.72, 179.5),
    vector4(1140.06, -1332.39, 34.65, 121.5),
    vector4(1150.65, -1276.79, 34.64, 173.5),
    vector4(2525.15, 2599.88, 37.94, 229.5),
    vector4(2531.58, 2575.17, 37.94, 179.5),
    vector4(1176.92, -1250.01, 34.74, 270.5),
    vector4(1132.89, -1248.04, 21.05, 307.5),
    vector4(1087.12, -1278.81, 20.13, 122.5),
    vector4(1016.83, -314.64, 49.44, 313.5),
    vector4(998.6, -141.19, 73.96, 317.5),
    vector4(1009.85, -111.74, 73.9, 326.5),
    vector4(770.86, 549.48, 127.52, 39.5),
    vector4(-449.29, 1582.97, 359.04, 47.5),
    vector4(-2297.72, 259.2, 169.6, 202.5),
    vector4(-1933.07, 2062.97, 140.84, 77.5),
    vector4(263.37, 2578.18, 45.04, 273.5),
    vector4(1136.72, 2085.96, 55.66, 263.5),
    vector4(892.79, 2861.95, 56.25, 142.5),
    vector4(296.19, 2882.84, 43.6, 31.5),
    vector4(60.88, 3701.0, 39.75, 233.5),
    vector4(81.01, 3759.62, 39.75, 359.5),
    vector4(713.39, 4178.55, 40.7, 91.5),
    vector4(1366.5, 4384.43, 44.31, 3.5),
    vector4(1343.0, 4318.24, 37.98, 169.5),
    vector4(1728.82, 4772.35, 41.81, 177.5),
    vector4(1729.01, 4723.31, 42.14, 166.5),
    vector4(2516.95, 4989.14, 44.91, 312.5),
    vector4(2572.34, 4656.36, 34.07, 219.5),
    vector4(2662.85, 3937.81, 42.03, 49.5),
    vector4(2675.26, 3507.71, 52.71, 157.5),
    vector4(2461.3, 3447.64, 49.83, 358.5),
    vector4(2409.1, 3039.69, 48.15, 178.5),
    vector4(1513.31, 3597.55, 35.38, 27.5),
    vector4(2975.33, 3502.21, 71.38, 30.5),
    vector4(2914.09, 4634.63, 48.54, 134.5),
    vector4(2923.02, 4322.64, 50.31, 116.5),
    vector4(3792.25, 4445.43, 4.58, 183.5),
    vector4(1529.97, 6318.56, 24.1, 166.5),
    vector4(-1206.69, -1796.47, 3.9, 307.5),
}
