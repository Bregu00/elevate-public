Config = Config or {}
Config.Classes = {
    ["D"] = {
        ["Prices"] = {normal = {min = 1, max = 2}, vinscratch = {min = 22, max = 33}, payout = 1},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 0,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 6, max = 11}, hacker = {min = 6, max = 11}, group = {min = 5, max = 8}},
        ["FailEXP"] = {min = 2, max = 5}, -- If the DeliveryTime expires, we will remove EXP from the driver (doesn't affect hacker)
        ['ContractTime'] = 2, -- (in hours) Time to start a contract before it expires
        ["Hacks"] = false,
        ["NextClass"] = "C",
        ["Guards"] = {min = 0, max = 0},
        ["Weapons"] = {"WEAPON_BAT", "WEAPON_KNUCKLE"},
        ['canVinscratch'] = false,
    },
    ["C"] = {
        ["Prices"] = {normal = {min = 3, max = 3}, vinscratch = {min = 33, max = 44}, payout = 2},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 0,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 6, max = 11}, hacker = {min = 6, max = 11}, group = {min = 5, max = 8}},
        ["FailEXP"] = {min = 3, max = 5},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 1, max = 2},
        ["NextClass"] = "B",
        ["Guards"] = {min = 2, max = 3},
        ["Weapons"] = {"WEAPON_BAT", "WEAPON_CROWBAR"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
    ["B"] = {
        ["Prices"] = {normal = {min = 5, max = 5}, vinscratch = {min = 44, max = 66}, payout = 11},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 1,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 6, max = 11}, hacker = {min = 6, max = 11}, group = {min = 5, max = 8}},
        ["FailEXP"] = {min = 4, max = 7},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 2, max = 3},
        ["NextClass"] = "A",
        ["Guards"] = {min = 2, max = 3},
        ["Weapons"] = {"WEAPON_MACHETE", "WEAPON_BATTLEAXE"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
    ["A"] = {
        ["Prices"] = {normal = {min = 5, max = 5}, vinscratch = {min = 42, max = 56}, payout = 18},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 3,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 10, max = 20}, hacker = {min = 10, max = 15}, group = {min = 8, max = 12}},
        ["FailEXP"] = {min = 6, max = 10},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 3, max = 5},
        ["NextClass"] = "A+",
        ["Guards"] = {min = 3, max = 4},
        ["Weapons"] = {"WEAPON_PISTOL", "WEAPON_SAWNOFFSHOTGUN"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
    ["A+"] = {
        ["Prices"] = {normal = {min = 7, max = 7}, vinscratch = {min = 56, max = 70}, payout = 25},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 3,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 15, max = 25}, hacker = {min = 10, max = 20}, group = {min = 8, max = 15}},
        ["FailEXP"] = {min = 10, max = 15},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 5, max = 7},
        ["NextClass"] = "S",
        ["Guards"] = {min = 3, max = 4},
        ["Weapons"] = {"WEAPON_SAWNOFFSHOTGUN", "WEAPON_PISTOL50"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
    ["S"] = {
        ["Prices"] = {normal = {min = 21, max = 21}, vinscratch = {min = 70, max = 84}, payout = 63},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 4,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 20, max = 30}, hacker = {min = 15, max = 25}, group = {min = 13, max = 20}},
        ["FailEXP"] = {min = 15, max = 20},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 8, max = 10},
        ["NextClass"] = "S+",
        ["Guards"] = {min = 4, max = 5},
        ["Weapons"] = {"WEAPON_MICROSMG", "WEAPON_COMBATPDW", "WEAPON_MINISMG", "WEAPON_COMPACTRIFLE"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
    ["S+"] = {
        ["Prices"] = {normal = {min = 32, max = 32}, vinscratch = {min = 84, max = 105}, payout = 84},
        ['Cops'] = { -- Min cops needed to start the contract
            ['normal'] = 4,
            ['vin'] = 0,
        },
        ["EXP"] = {driver = {min = 25, max = 35}, hacker = {min = 25, max = 30}, group = {min = 15, max = 25}},
        ["FailEXP"] = {min = 20, max = 30},
        ['ContractTime'] = 2,
        ["Hacks"] = {min = 10, max = 12},
        ["NextClass"] = "Max",
        ["Guards"] = {min = 4, max = 5},
        ["Weapons"] = {"WEAPON_COMPACTRIFLE", "WEAPON_ASSAULTRIFLE", "WEAPON_ADVANCEDRIFLE"},
        ['canVinscratch'] = false, -- disable vinscratch for this vehicles class
    },
}