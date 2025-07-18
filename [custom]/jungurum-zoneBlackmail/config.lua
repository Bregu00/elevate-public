Config = Config or {}

Config.Seconds = function(seconds) return seconds * 1000 end
Config.Minutes = function(minutes) return minutes * 60 * 1000 end
Config.Hours = function(hours) return hours * 3600 * 1000 end
Config.Days = function(days) return days * 86400 * 1000 end

Config.PhoneContactName = "Ukendt"

Config.cooldown = Config.Days(1)

Config.minGangMembers = 3

Config.locations = {
    {coords = vector4(646.7499, 267.8561, 103.2625, 60.14716), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 42, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-530.8524, -1221.536, 18.45501, 333.2227), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 78, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(289.5773, -1266.211, 29.44074, 92.60032), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 15, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(2001.133, 3779.742, 32.18074, 213.5214), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 23, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-92.82118, 6409.941, 31.64046, 45.42775), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 91, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-708.013, -903.4478, 19.21563, 181.2741), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 67, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-41.71762, -1748.869, 29.42097, 140.1685), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 34, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1160.885, -313.0533, 69.20499, 189.4787), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 56, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1707.564, 4918.778, 42.06359, 52.73446), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 19, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1427.874, -268.1703, 46.22874, 130.9007), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 82, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(166.7149, -1553.305, 29.26175, 220.6758), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 47, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(818.2263, -1040.929, 26.75078, 5.295342), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 63, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1211.19, -1389.48, 35.38, 180.0), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 29, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(170.2498, 6642.184, 31.69892, 0.2818598), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 95, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1479.861, -372.573, 39.16339, 134.7736), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 38, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1217.697, -915.6855, 11.32628, 36.85015), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 71, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(380.608, 331.9046, 103.5662, 31.96566), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 52, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(30.93715, -1340.175, 29.49693, 41.04083), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 14, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1962.092, 3749.568, 32.34362, 71.00437), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 88, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(448.4812, -800.6568, 27.80519, 278.5609), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 26, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(201.8314, -26.25775, 69.90956, 250.3847), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 60, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(201.8314, -26.25775, 69.90956, 250.3847), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 33, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1316.176, -383.5912, 36.67293, 120.3376), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 77, deductPoints = 100, cooldown = Config.cooldown},
    -- {coords = vector4(937.2526, -1010.654, 42.01167, 5.245647), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 45, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(937.2526, -1010.654, 42.01167, 5.245647), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 31, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1705.248, 3780.323, 34.75783, 210.3689), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 99, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-406.4987, 6062.842, 31.50011, 137.6022), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 21, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(50.04769, -1453.805, 29.31119, 52.65421), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 68, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-24.88313, 6472.696, 31.48646, 133.3058), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 36, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1642.012, 4853.46, 42.08417, 100.4023), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 84, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(121.7455, -239.8558, 53.35596, 160.089), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 50, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1227.204, -748.9496, 19.64414, 130.9435), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 37, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-700.3167, -147.1718, 37.84557, 302.282), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 73, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1423.357, -216.0883, 46.50044, 357.7202), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 40, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-138.6791, -257.1496, 43.59501, 298.9668), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 65, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-138.6791, -257.1496, 43.59501, 298.9668), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 28, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(387.2271, -773.2788, 29.29171, 5.493645), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 93, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-802.2063, -177.9181, 38.13534, 298.9268), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 27, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1275.488, -1139.655, 6.79391, 120.226), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 58, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(36.31441, -173.6398, 55.25851, 347.0241), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 31, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(125.8318, -1704.76, 29.29171, 138.1684), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 86, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1218.08, -474.71, 66.21, 73.25), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 24, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-298.5425, 6273.594, 31.49231, 318.2198), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 69, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1921.191, 3728.292, 32.78352, 35.48305), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 16, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(313.369, 189.5509, 103.9599, 31.32979), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 54, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-1171.207, -1435.165, 4.468637, 34.37106), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 37, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1320.081, -1662.162, 51.23639, 132.84), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 80, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(1871.093, 3750.296, 33.00254, 299.9138), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 30, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(400.6738, -1926.611, 24.80574, 328.9417), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 67, deductPoints = 100, cooldown = Config.cooldown},
    {coords = vector4(-703.6381, -2275.652, 13.45537, 229.7542), label = "Request Protection Money", ped = GetHashKey('g_m_m_chiboss_01'), payoutMultiplier = 55, deductPoints = 100, cooldown = Config.cooldown},
}