Config = Config or {}

Config.Debug = false

Config.Marker = {
    ['skunk'] = {
        points = {
            vec(-217.4267, 2060.359, 140),
            vec(-229.5637, 2054.458, 140),
            vec(-222.5867, 2045.004, 140),
            vec(-211.8141, 2051.81, 140)
        },
        label = 'Farmer skunk blade',
        amount = 8,
        farmTime = 10500
    },
    ['opium'] = {
        points = {
            vec(3807.623, 4502.733, 5),
            vec(3804.205, 4513.161, 5),
            vec(3792.816, 4509.539, 5),
            vec(3795.611, 4498.096, 5)
        },
        label = 'Farmer opium blade',
        amount = 8,
        farmTime = 10500
    },
    ['meth'] = {
        points = {
            vec(2697.816, -831.2603, 26),
            vec(2713.453, -822.8035, 26),
            vec(2711.769, -839.4076, 26),
            vec(2695.005, -836.4559, 26)
        },
        label = 'Farmer meth',
        amount = 8,
        farmTime = 10500
    },
    ['kokain'] = {
        points = {
            vec(1536.42, 1705.358, 109),
            vec(1535.455, 1699.304, 109),
            vec(1524.413, 1701.099, 109),
            vec(1525.335, 1707.562, 109)
        },
        label = 'Farmer kokain blade',
        amount = 8,
        farmTime = 10500
    }
}

Config.Omdanner = {
    ['joint'] = {
        points = {
            vec(531.3531, 3085.932, 40),
            vec(535.8632, 3094.037, 40),
            vec(524.5339, 3098.704, 40),
            vec(519.2887, 3090.946, 40)
        },
        label = 'Omdanner til joints',
        omdanTime = 10500,
        amount = 8,
        requires = {
            ['skunk'] = 16,
            ['jointpapir'] = 8
        }
    },
    ['kanyleindhold'] = {
        points = {
            vec(2327.965, 2530.011, 46),
            vec(2324.631, 2530.737, 46),
            vec(2322.078, 2521.184, 46),
            vec(2325.417, 2519.558, 46)
        },
        label = 'Omdanner til kanyle med indhold',
        omdanTime = 10500,
        amount = 8,
        requires = {
            ['opium'] = 16,
            ['kanyle'] = 8
        }
    },
    ['posemeth'] = {
        points = {
            vec(1903.559, 4914.979, 48),
            vec(1897.81, 4917.692, 48),
            vec(1904.382, 4931.139, 48),
            vec(1910.175, 4929.126, 48)
        },
        label = 'Omdanner til meth i pose',
        omdanTime = 10500,
        amount = 8,
        requires = {
            ['meth'] = 16,
            ['pose'] = 8
        }
    },
    ['posekokain'] = {
        points = {
            vec(1499.458, -2105.031, 76),
            vec(1500.936, -2095.448, 76),
            vec(1510.277, -2096.627, 76),
            vec(1508.291, -2105.246, 76)
        },
        label = 'Omdanner til coke i pose',
        omdanTime = 10500,
        amount = 8,
        requires = {
            ['kokain'] = 16,
            ['pose'] = 8
        }
    },
}