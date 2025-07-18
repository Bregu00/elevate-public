Config = {}

Config.Rewards = {
    { item = 'flaske', label = 'Plastik Flaske', min = 1, max = 4, chance = 70 },
    { item = 'panta_flaske', label = 'Pant A Flaske', min = 1, max = 3, chance = 40 },
    { item = 'pantb_flaske', label = 'Pant B Flaske', min = 1, max = 3, chance = 50 },
    { item = 'pantc_flaske', label = 'Pant C Flaske', min = 2, max = 5, chance = 60 },
    { cash = true, min = 50, max = 500, chance = 20 },
    { item = 'ammo', label = 'Ammunation', min = 4, max = 10, chance = 5 },
    { item = 'lockpick', label = 'Lockpick', min = 1, max = 2, chance = 15 },
    { item = 'joint', label = 'Joint', min = 5, max = 8, chance = 30 },
    { item = 'posekokain', label = 'Kokain Pose', min = 3, max = 6, chance = 30 },
    { item = 'kanyle', label = 'Tom Kanyle', min = 4, max = 9, chance = 30 },
    { item = 'plate', label = 'Armor Plade', min = 1, max = 1, chance = 3 },
}

Config.Dumpster = {
    'prop_dumpster_4b',
    'prop_dumpster_4a',
    'prop_dumpster_01a',
    'prop_dumpster_02b',
    'prop_dumpster_02a'
}

Config.RecyclingSystem = {
    Cooldown = 600,
    SearchTime = 7000,
    EmptyChance = 20
}

Config.RecyclingValues = {
    ['flaske'] = 450,
    ['panta_flaske'] = 1000,
    ['pantb_flaske'] = 850,
    ['pantc_flaske'] = 600
}

Config.DepositLocations = { 
    vec3(25.4444, -1345.6597, 29.7458), 
    vec3(-3040.8388, 585.0568, 8.1577), 
    vec3(-3243.7705, 1001.1959, 13.1240),
    vec3(1729.4234, 6416.1899, 35.2860),
    vec3(1698.3787, 4923.2553, 42.2410),
    vec3(1960.1284, 3741.8007, 32.5925),
    vec3(548.2675, 2669.6276, 42.4053),
    vec3(2677.1232, 3280.9897, 55.4899),
    vec3(2555.6130, 381.6807, 108.8406),
    vec3(373.8878, 327.6780, 103.8151),
    vec3(162.2107, 6642.0131, 31.9477),
    vec3(-1820.5584, 793.9172, 138.2765),
    vec3(-47.2251, -1757.5423, 29.5983),
    vec3(-706.7102, -913.5667, 19.3929),
    vec3(1164.1452, -322.7899, 69.3824),
    vec3(813.3516, -781.0529, 26.4238),
}
