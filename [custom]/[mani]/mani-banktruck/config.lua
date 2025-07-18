local Config = {}

Config.Debug = false

Config.Seconds = function(seconds) return seconds * 1000 end
Config.Minutes = function(minutes) return minutes * 60 * 1000 end
Config.Hours = function(hours) return hours * 3600 * 1000 end
Config.Days = function(days) return days * 86400 * 1000 end

Config.ItemConfig = {
    ['DrivingPlan'] = {
        Item = 'drivingplan',
        ExpireTime = Config.Days(3) / 1000,
    },
    ['HackingDevice'] = {
        Item = 'hackingdevice',
    },
    ['C4'] = {
        Item = 'bomb_c4',
        ExplodeTime = Config.Minutes(1)
    },
    ['Landmine'] = {
        Item = 'landmine',
    },
}

Config.Missions = {
    ['Office'] = {
        ['Locations'] = {
            ['DocumentLocations'] = {
                vec4(-63.70, -805.80, 243.34, 284.70),
                vec4(-66.41, -816.75, 243.18, 90.00),
                vec4(-76.35, -817.64, 243.38, 121.20),
                vec4(-65.06, -821.08, 242.78, 297.70),
                vec4(-60.94, -810.90, 243.18, 29.80),
                vec4(-60.83, -807.17, 243.18, 210.10),
                vec4(-58.35, -810.46, 243.40, 243.20),
                vec4(-65.56, -813.98, 243.18, 94.20),
                vec4(-72.23, -815.07, 243.18, 153.00),
                vec4(-81.91, -805.95, 243.16, 328.60),
                vec4(-78.47, -806.78, 243.33, 133.50),
                vec4(-81.57, -804.52, 243.39, 138.60)
            },
            ['GuardLocations'] = {
                vec4(-72.57, -824.37, 243.39, 70.30),
                vec4(-68.07, -818.97, 243.39, 67.63),
                vec4(-76.18, -815.77, 243.39, 241.58),
                vec4(-70.92, -804.78, 243.40, 138.75),
                vec4(-60.95, -805.67, 243.39, 154.27),
                vec4(-59.73, -812.11, 243.39, 98.90),
                vec4(-81.82, -803.49, 243.40, 249.90),
                vec4(-80.25, -799.20, 243.39, 244.46),
                vec4(-84.22, -814.29, 243.39, 341.35),
                vec4(-82.73, -807.35, 243.39, 230.65),
                vec4(-80.69, -813.94, 243.39, 296.71)
            },
            ['ComputerLoot'] = {
                ItemPool = { 'black_money' },
                Amount = { 250000, 400000 },
            },
            Entrance = vec4(-66.92, -802.57, 44.23, 157.88),
            Exit = vec4(-75.50, -827.09, 243.39, 67.60),
            Computer = vec4(-79.73, -801.98, 243.4, 340)
        },
        MinCops = 0,
        DocumentAmount = 2,
        Cooldown = Config.Hours(4)
    },
    ['Banktruck'] = {
        ['Locations'] = {
            vec4(1082.29, -1607.48, 29.14, 5.66),
            vec4(-2611.16, 2283.84, 26.92, 270.78),
            vec4(-1646.33, -708.77, 10.91, 60.13),
            vec4(990.78, -2582.75, 43.63, 99.80),
            vec4(-1180.41, -692.31, 10.80, 299.72),
            vec4(2332.20, 1084.15, 80.01, 219.56),
        },
        ['VehicleOptions'] = {
            ['Banktruck'] = {
                Model = 'stockade',
                BackDoors = { 2, 3 }
            },
            ['Guards'] = {
                Model = 'granger2',
                VehicleAmount = 2,
                GuardAmount = 4 -- Per vehicle
            }
        },
        ['Lootpool'] = {
            TotalAmount = 1,
            Items = {
                { item = 'gold_bar', amount = { min = 450, max = 600 } }
            }
        },
        MinCops = 2,
        Cooldown = Config.Hours(2)
    }
}

Config.GuardWeapons = {
    'WEAPON_CARBINERIFLE',
    'WEAPON_HEAVYPISTOL'
}

Config.NpcPreset = function(npc)
    SetPedCombatAttributes(npc, 46, true)
    SetPedAsEnemy(npc, true)
    SetPedArmour(npc, 100)
    SetEntityHealth(npc, 350)
    SetPedAccuracy(npc, 100)
    SetPedCombatAbility(npc, 2)
    SetPedCombatMovement(npc, 2)
    SetPedCombatRange(npc, 2)
    SetPedAlertness(npc, 3)

    GiveWeaponToPed(npc, GetHashKey(Config.GuardWeapons[math.random(1, #Config.GuardWeapons)]), 9999, false, false)
end

Config.PoliceJobs = {
    ['police'] = true
}

Config.LandmineSettings = {
    ['Radius'] = 2.5,
    -- ['WhitelistedVehicles'] = '*' -- For all vehicles
    ['WhitelistedVehicles'] = {
        [GetHashKey('stockade')] = true,
    }
}

Config.ShowItemRequirements = true

Config.RegisterItems = true -- If using QB-Inventory

return Config