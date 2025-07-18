return {
    ['Debug'] = false,
    ['Locations'] = {
        ['Drift'] = {
            vec3(-683.06, -956.06, 20.57),
            vec3(-717.7, -1177.37, 10.62),
            vec3(-647.18, -1405.96, 10.64),
            vec3(-530.24, -1760.92, 21.44),
            vec3(-389.99, -1798.44, 21.52),
            vec3(-215.79, -1818.55, 29.85),
            vec3(121.96, -1875.32, 23.84),
            vec3(242.74, -1706.06, 29.04),
            vec3(119.97, -1548.45, 29.25),
            vec3(23.08, -1568.29, 29.21),
            vec3(-184.0, -1486.44, 32.06),
            vec3(505.23, -759.7, 24.89),
            vec3(335.84, -957.28, 29.34),
            vec3(435.52, -1130.55, 29.43),
            vec3(497.96, -1264.33, 29.3),
            vec3(242.06, -1436.24, 29.3),
            vec3(5.3, -1365.62, 29.37),
            vec3(-213.46, -562.91, 34.62),
            vec3(-533.13, -738.05, 32.71),
            vec3(-535.71, -969.86, 23.46),
            vec3(-110.38, -1202.85, 27.59),
            vec3(86.2, -1059.49, 29.4),
            vec3(114.46, -1004.48, 29.37),
            vec3(180.51, -822.86, 31.14),
            vec3(312.08, -784.44, 29.33),
            vec3(325.41, -744.55, 29.33),
            vec3(376.85, -623.19, 28.99),
        },
        ['JobLocation'] = vec4(537.03, -1652.04, 28.27, 321.14),
        ['VehicleSpawn'] = vec4(550.22, -1659.87, 27.60, 114.64),
    },
    ['Blip'] = {
        ['Job'] = {
            name = "Mandehul A/S",
            scale = 0.5,
            color = 47,
            sprite = 280,
        },
        ['Drift'] = {
            name = '',
            scale = 0.8,
            color = 3,
            sprite = 402,
        },
        ['Vehicle'] = {
            name = 'Arbejdsbil',
            scale = 0.8,
            color = 3,
            sprite = 67,
        }
    },
    ['Jobs'] = {
        {
            ['Label'] = 'Small',
            ['Locations'] = { min = 1, max = 2 },
            ['Vehicle'] = GetHashKey('burrito'),
            ['Props'] = { fuelLevel = 100, dirtLevel = 0, livery = 3 },
            ['MoneyReward'] = 10000,
            ['RequiredXP'] = 0,
        },
        {
            ['Label'] = 'Medium',
            ['Locations'] = { min = 2, max = 3 },
            ['Vehicle'] = GetHashKey('burrito'),
            ['Props'] = { fuelLevel = 100, dirtLevel = 0, livery = 3 },
            ['MoneyReward'] = 12000,
            ['RequiredXP'] = 50,
        },
        {
            ['Label'] = 'Large',
            ['Locations'] = { min = 3, max = 5 },
            ['Vehicle'] = GetHashKey('boxville'),
            ['Props'] = { fuelLevel = 100, dirtLevel = 0 },
            ['MoneyReward'] = 14000,
            ['RequiredXP'] = 100,
        }
    },
    ['PedModel'] = GetHashKey('S_M_M_DockWork_01'),
    ['VehicleOffsets'] = {
        [GetHashKey('burrito')] = vec3(0.0, -2.66, 0.45),
        [GetHashKey('boxville')] = vec3(0.0, -3.5, 0.45),
    },
    ['MaxMember'] = 3, -- Don't reccomend to change this.
    ['TeamBonus'] = 15, -- 10% Per team member
    ['XPGain'] = 1, -- XP Per manhole
}