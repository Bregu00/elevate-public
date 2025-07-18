local Config = {}

Config.Debug = false

Config.Migrate = false

Config.Cooldown = 14 * 1000 * 60 * 60 * 24 -- 14 Dage

Config.ItemConfig = {
    ['AngleGrinder'] = {
        Item = 'angle_grinder',
        Remove = false,
    }
}

Config.Stock = {
    ['Handguns'] = {
        ['weapon_snspistol'] = {
            Label = 'SNS Pistol',
            Item = 'snspistol_case',
            Price = 400000,
            Stock = { 0, 1, 2, 4, 8, 12, 15, 22 }
        },
        ['weapon_pistol'] = {
            Label = '9mm Pistol',
            Item = 'pistol_case',
            Price = 900000,
            Stock = { 0, 1, 2, 4, 8, 12, 15, 22 }
        },
        ['weapon_ceramicpistol'] = {
            Label = 'Ceramic Pistol',
            Item = 'cermaicpistol_case',
            Price = 750000,
            Stock = { 0, 1, 2, 4, 8, 12, 15, 22 }
        },
        ['weapon_vintagepistol'] = {
            Label = 'Vintage Pistol',
            Item = 'vintagepistol_case',
            Price = 1000000,
            Stock = { 0, 1, 2, 4, 8, 12, 15, 22 }
        },
        ['weapon_pistolxm3'] = {
            Label = 'XM3 Pistol',
            Item = 'xm_case',
            Price = 1250000,
            Stock = { 0, 0, 2, 4, 8, 12, 15, 22 }
        },
        ['weapon_pistol50'] = {
            Label = 'Pistol .50',
            Item = 'pistol50_case',
            Price = 1250000,
            Stock = { 0, 0, 0, 4, 8, 12, 15, 22 }
        },
        ['weapon_navyrevolver'] = {
            Label = 'Navy Revolver',
            Item = 'navyrevolver_case',
            Price = 1800000,
            Stock = { 0, 0, 0, 4, 8, 12, 15, 22 }
        },
        ['weapon_revolver'] = {
            Label = 'Heavy Revolver',
            Item = 'revolver_case',
            Price = 2250000,
            Stock = { 0, 0, 0, 0, 8, 12, 15, 22 }
        },
    },
    ['Shotguns'] = {
        ['weapon_pumpshotgun'] = {
            Label = 'Pump Shotgun',
            Item = 'pumpshotgun_case',
            Price = 2500000,
            Stock = { 0, 0, 0, 0, 8, 12, 15, 22 }
        }
    },
    ['Misc'] = {
        ['plate'] = {
            Label = 'Plate',
            Item = 'plate',
            Price = 35000,
            Stock = { 88, 176, 264, 352, 440, 528, 616, 704 }
        }
    },
}

Config.Levels = {
    { 0,        1000 },
    { 1001,     2500 },
    { 2501,     5500 },
    { 5501,     8000 },
    { 8001,     12000 },
    { 12001,    16000 },
    { 16001,    20000 },
    { 20001,    24000 },
}

Config.XPItems = {
    ['posemeth'] =      { Label = 'Aflever Meth',               Reward = 0.25 },
    ['posekokain'] =    { Label = 'Aflever Kokain',             Reward = 0.25 },
    ['joint'] =         { Label = 'Aflever Joint',              Reward = 0.25 },
    ['kanyleindhold'] = { Label = 'Aflever Kanyle Med Indhold', Reward = 0.25 },
}

Config.DeliveryLocations = {
    vec4(-1578.96, 5168.97, 19.38, 85.5),
    vec4(-2309.14, 264.61, 169.41, 94.5),
    vec4(3615.95, 3727.8, 28.5, 324.5),
    vec4(1263.66, 1905.15, 78.63, 53.5),
    vec4(1020.95, 2449.96, 44.23, 141.5),
    vec4(706.17, 4173.05, 40.67, 105.5),
    vec4(1908.66, 573.82, 175.63, 65.5),
    vec4(2136.28, 4776.64, 40.78, 204.5),
}

Config.NPCSpawns = {
    vec4(4835.884, -5177.596, 2.184731, 291.8989),
    vec4(4909.655, -5835.765, 28.21706, 358.7963),
    vec4(5585.725, -5222.236, 14.35076, 228.9212),
    vec4(5174.217, -4590.626, 3.744503, 77.60632),
    vec4(4280.946, -4533.561, 4.33365, 197.7444),
    vec4(5103.598, -5525.182, 54.20603, 285.2586)
}

Config.RefreshMissions = {
    {
        Hour = "17",
        Minute = "55"
    }
}

Config.Missions = {
    {
        Label = 'Våbenmateriale Heist',
        Requirements = 'Vinkelsliber',
        Image = 'https://files.fivemerr.com/images/fe448fda-61b8-44ac-86a2-445c52e3ba37.jpeg',
        Reward = 86400,
        Cooldown = 30 * 1000 * 60,
        MissionID = 1,
        ExpectedItem = {
            Item = 'weaponmat',
            Amount = 10,
        },
        Locations = {
            {
                Prop = vec4(-583.59, -1783.44, 21.86, 0.0),
                Guards = {
                    vec4(-587.78, -1780.71, 21.72, 187.20),
                    vec4(-579.67, -1785.15, 21.65, 140.61),
                    vec4(-569.02, -1783.21, 21.44, 117.32),
                    vec4(-588.99, -1766.60, 21.67, 188.59),
                    vec4(-590.34, -1779.80, 21.78, 291.62),
                    vec4(-578.79, -1771.35, 22.18, 143.88)
                }
            },
            {
                Prop = vec4(126.83, -2198.04, 5.03, 149.71),
                Guards = {
                    vec4(130.75, -2198.96, 5.04, 359.44), 	
                    vec4(124.31, -2202.72, 5.03, 327.11),
                    vec4(117.30, -2198.14, 5.03, 326.39),
                    vec4(116.81, -2193.54, 5.03, 276.19),
                    vec4(132.71, -2204.62, 6.19, 37.17),
                    vec4(128.54, -2204.85, 6.19, 4.61),
                    vec4(123.53, -2183.84, 5.03, 190.81)
                }
            },
            {
                Prop = vec4(-453.73, -986.98, 22.55, 231.05),
                Guards = {
                    vec4(-447.25, -978.34, 22.70, 137.05),
                    vec4(-442.61, -982.32, 22.85, 124.32),
                    vec4(-440.77, -992.19, 22.91, 62.71),
                    vec4(-440.92, -986.31, 24.90, 118.72),
                    vec4(-451.62, -976.17, 24.90, 133.74),
                    vec4(-440.77, -999.86, 24.90, 50.44),
                    vec4(-447.60, -997.00, 22.99, 2.32),
                    vec4(-464.64, -997.15, 22.71, 358.79)
                }
            },
            {
                Prop = vec4(-1074.51, -1665.18, 3.43, 216.04),
                Guards = {
                    vec4(-1076.31, -1671.74, 3.45, 317.14),
                    vec4(-1071.50, -1677.22, 3.57, 3.94),
                    vec4(-1064.32, -1670.95, 3.52, 61.69),
                    vec4(-1069.78, -1663.62, 3.56, 158.71),
                    vec4(-1073.92, -1657.55, 3.40, 119.08),
                    vec4(-1092.57, -1662.28, 3.62, 248.50),
                    vec4(-1090.31, -1655.75, 6.35, 245.98),                    
                }
            },
        }
    },
    {
        Label = 'Banktruck Heist',
        Requirements = 'Køreplan, C4 Bombe, Landmine',
        Image = 'https://files.fivemerr.com/images/49786fdb-dc9d-48bd-99bf-d2f990902250.jpeg',
        Reward = 86400,
        MissionID = 2,
        Coords = vec4(-66.92, -802.57, 44.23, 157.88),
        ExpectedItem = {
            Item = 'gold_bar',
            Amount = 450,
        }
    },
    {
        Label = 'Server Heist',
        Requirements = 'Hacking Device',
        Image = 'https://files.fivemerr.com/images/b9f64a3e-b36b-4e83-b184-db1b27f193cf.jpeg',
        Reward = 86400,
        Cooldown = 45 * 1000 * 60,
        MissionID = 3,
        ServerAmount = 4,
        HackingItem = 'hackingdevice',
        ExpectedItem = {
            Item = 'crypto_usb',
            Amount = 4,
        },
        Location = {
            Entrance = { Ext = vec4(2049.36, 2949.84, 46.86, 72.08), Int = vec4(2154.62, 2921.09, -82.08, 270.20) },
            Guards = {
                vec4(2175.40, 2922.32, -85.80, 46.98), 	
                vec4(2168.11, 2932.33, -85.80, 186.99), 	
                vec4(2150.49, 2909.59, -85.80, 294.09), 	
                vec4(2149.62, 2932.28, -85.80, 259.06), 	
                vec4(2127.64, 2928.30, -85.80, 80.18), 	
                vec4(2111.34, 2941.53, -85.80, 167.03), 	
                vec4(2102.35, 2921.78, -85.79, 180.13), 	
                vec4(2111.23, 2900.32, -85.80, 9.33), 	
                vec4(2184.65, 2907.67, -85.80, 354.32), 	
                vec4(2209.10, 2911.76, -85.80, 354.91), 	
                vec4(2209.01, 2931.51, -85.80, 195.77), 	
                vec4(2220.84, 2938.71, -85.80, 279.43), 	
                vec4(2251.63, 2938.39, -85.80, 175.76), 	
                vec4(2259.88, 2913.24, -85.80, 179.82), 	
                vec4(2240.73, 2896.33, -85.80, 358.37), 	
                vec4(2234.45, 2913.35, -85.80, 179.83), 	
                vec4(2281.05, 2912.42, -85.80, 87.77), 	
                vec4(2264.96, 2925.09, -85.80, 90.14),
            },
            ServerLocations = {
                vec4(2333.72, 2894.98, -84.72, 186.87),
                vec4(2293.75, 2895.32, -84.72, 184.60),
                vec4(2243.91, 2896.11, -84.72, 3.77),
                vec4(2237.74, 2895.55, -84.72, 168.45),
                vec4(2194.95, 2903.77, -84.72, 350.61),
                vec4(2154.76, 2906.32, -84.72, 11.68),
                vec4(2114.48, 2899.09, -84.72, 6.94),
                vec4(2072.82, 2895.47, -84.72, 178.93),
                vec4(2012.87, 2894.91, -84.72, 177.58),
                vec4(1992.83, 2903.61, -84.72, 176.72),
                vec4(2052.80, 2904.09, -84.72, 180.14),
                vec4(2062.41, 2904.56, -84.72, 1.54),
                vec4(2097.90, 2904.07, -84.72, 174.45),
                vec4(2140.31, 2912.02, -84.72, 193.19),
                vec4(2237.63, 2912.71, -84.72, 4.83),
                vec4(2283.31, 2912.67, -84.72, 357.08),
                vec4(2313.73, 2912.56, -84.72, 183.58),
                vec4(2353.76, 2912.11, -84.72, 175.02),
                vec4(2343.29, 2921.42, -84.72, 353.20),
                vec4(2333.72, 2920.14, -84.72, 179.16),
                vec4(2263.32, 2921.32, -84.72, 3.03),
                vec4(2255.27, 2920.63, -84.72, 179.61),
                vec4(2206.06, 2920.62, -84.72, 183.60),
                vec4(2105.68, 2921.16, -84.72, 354.09),
                vec4(2080.94, 2921.14, -84.72, 9.34),
                vec4(2072.84, 2920.50, -84.72, 185.15),
                vec4(1992.82, 2920.34, -84.72, 192.31),
                vec4(2022.42, 2929.22, -84.72, 357.12),
                vec4(2052.82, 2929.14, -84.72, 182.27),
                vec4(2098.52, 2928.98, -84.72, 186.75),
                vec4(2195.87, 2929.75, -84.72, 8.20),
                vec4(2293.71, 2929.06, -84.72, 188.04),
                vec4(2303.32, 2929.22, -84.72, 11.07),
                vec4(2343.30, 2938.23, -84.72, 351.89),
                vec4(2323.25, 2946.87, -84.72, 355.36),
                vec4(2313.79, 2945.92, -84.72, 179.67),
                vec4(2283.38, 2937.63, -84.72, 4.39),
                vec4(2273.73, 2937.19, -84.72, 179.59),
                vec4(2238.33, 2937.71, -84.72, 358.06),
                vec4(2221.70, 2942.75, -84.72, 190.66),
                vec4(2131.05, 2940.46, -84.72, 353.23),
                vec4(2108.60, 2943.99, -84.72, 170.67),
                vec4(2092.28, 2945.61, -84.72, 175.41),
                vec4(2072.82, 2937.22, -84.72, 184.44),
                vec4(2042.45, 2946.33, -84.72, 1.58),
                vec4(2012.86, 2937.25, -84.72, 174.00),
                vec4(2002.49, 2946.77, -84.72, 2.57),
                vec4(1982.44, 2938.16, -84.72, 2.01),
            }
        } 
    },
}

Config.MemberReq = 8

Config.GuardWeapons = {
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_ADVANCEDRIFLE'
}

Config.GuardPreset = function(npc)
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

Config.Categories = { -- Jeg er doven, og magter ikke at kode backend om igen.
    'Handguns',
    'Shotguns',
    'Misc'
}

return Config