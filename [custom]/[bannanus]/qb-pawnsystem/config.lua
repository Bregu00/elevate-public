Config = {}

Config.pickAmounts = 10 -- This is amount of pickups each person can do per restart.
Config.PickupRunCost = 400 -- This is pickup cost
Config.inventory = "ox" -- This can be qb or ox
Config.PolyDebug = false

-- Leveringssystem indstillinger
Config.DeliveryDepositFee = 1000 -- Depositum for at starte en leveringstur
Config.DeliveryBaseReward = 150 -- Standardbelønning per levering hvis item ikke har specifik værdi


Config.Locations = { -- This is the places you want to have a pawnshop, remember to insert everything including blip color, and the polyzone information.
    {coords = vector4(432.723, -773.472, 29.5865, 180), blipid = "", blip = 431, color = 5, length = 1.2, width = 2.6, minZ = 28.34, maxZ = 29.94, name = "pawnshopsmelt", label = "Lux Broker", job = "luxbroker", bossrank = 3 },
    {coords = vector4(454.94, -1471.53, 28.29, 111.38), blipid = "", blip = 431, color = 5, length = 1.2, width = 2.6, minZ = 28.34, maxZ = 29.94, name = "pawnshopsmelt", label = "Pant & Profit", job = "pop", bossrank = 3 },
    --{coords=vector3(253.56, -1201.13, 29.29), h=359, length=1.4, width=1.2, minZ=28.29, maxZ=30.49, name="pawnshop2", job="pawns", bossrank=1},
}

Config.Stashes = { -- This is the places you want to have Stashes, remember to insert the polyzone information and everything.
    {coords = vector4(435.9036, -771.5416, 29.48589, 0), length = 1.2, width = 1.1, minZ = 28.2, maxZ = 30.1, name = "BawsStash", job = "luxbroker", requiredRank = 1, slots = 200, maxweight = 25000000},
    {coords = vector4(462.16, -1483.93, 28.29, 198.73), length = 1.2, width = 1.1, minZ = 28.2, maxZ = 30.1, name = "BawsStash2", job = "pop", requiredRank = 0, slots = 200, maxweight = 25000000},
}

Config.CarSpawner = {
    -- {coords=vector4(417.493, -777.388, 29.39308, 92.31664), ped="a_f_m_bevhills_02", targetTakeOutLabel="Take out car", targetParkLabel="Park car", spawnLocation=vector4(164.0270, -1326.04, 29.063, 236.5), job = "police"}
}

Config.PawnCars = {
    [1] = {
        spawnName = "futo",
        Label = "Futo",
        AuthorizedRanks = {0, 1, 2, 3, 4}
    },
}

Config.Trays = { -- This is all your trays, its all just polyzone info needed.
    -- This is for Lux Broker
    {coords = vector4(428.4749, -777.4633, 29.5, 90), length = 0.8, width = 1.4, minZ = 28.95, maxZ = 29.55, name = "pawntray1", job = ""}, -- Lux Broker
    {coords = vector4(428.4797, -774.9798, 29.5, 90), length = 0.8, width = 1.4, minZ = 28.95, maxZ = 29.55, name = "pawntray2", job = ""}, -- Lux Broker
    {coords = vector4(428.427, -772.6438, 29.5, 90), length = 0.8, width = 1.4, minZ = 28.95, maxZ = 29.55, name = "pawntray3", job = ""}, -- Lux Broker

    -- This is for Pant & Profit
    {coords = vector4(449.73, -1469.39, 29.30, 105.58), length = 0.8, width = 1.4, minZ = 28.30, maxZ = 30.30, name = "pawntray4", job = "pop"}, -- Pant & Profit
    {coords = vector4(450.78, -1472.19, 29.30, 108.68), length = 0.8, width = 1.4, minZ = 28.30, maxZ = 30.30, name = "pawntray5", job = "pop"}, -- Pant & Profit
}

Config.StartRun = { -- With this resource you can do tech runs, wich makes you able to go from door to door and buy people's old tech stuff like phone.
    {coords = vector4(430.7642, -772.8298, 29.4407, 270), length = 1, width = 2.0, minZ = 28.34, maxZ = 30.14, name = "pawnrun1", label = "Start the run.", job = "luxbroker"},
    {coords = vector4(451.85, -1461.71, 29.10, 16.10), length = 1, width = 2.0, minZ = 28.10, maxZ = 30.10, name = "pawnrun2", label = "Start the run.", job = "pop"},
}

Config.PickupPlaces = { -- This is all the front doors where you can pickup the old tech stuff from.
    -- MIRROR PARK
    { coords = vec4(996.83, -729.66, 57.81, 310), blip = 556, color = 18, name = "NewRandomPlace26", label = "New Random Place 26"},
    { coords = vec4(979.16, -716.36, 58.22, 310.78), blip = 556, color = 18, name = "NewRandomPlace27", label = "New Random Place 27"},
    { coords = vec4(970.79, -701.51, 58.48, 354.71), blip = 556, color = 18, name = "NewRandomPlace28", label = "New Random Place 28"},
    { coords = vec4(959.86, -669.89, 58.45, 299.85), blip = 556, color = 18, name = "NewRandomPlace29", label = "New Random Place 29"},
    { coords = vec4(943.27, -653.29, 58.63, 219.74), blip = 556, color = 18, name = "NewRandomPlace30", label = "New Random Place 30"},
    { coords = vec4(928.82, -639.81, 58.24, -42.51), blip = 556, color = 18, name = "NewRandomPlace31", label = "New Random Place 31"},
    { coords = vec4(902.92, -615.53, 58.45, -133.70), blip = 556, color = 18, name = "NewRandomPlace32", label = "New Random Place 32"},
    { coords = vec4(886.81, -608.19, 58.45, -43.58), blip = 556, color = 18, name = "NewRandomPlace33", label = "New Random Place 33"},
    { coords = vec4(861.76, -583.67, 58.16, 2.95), blip = 556, color = 18, name = "NewRandomPlace34", label = "New Random Place 34"},
    { coords = vec4(844.08, -562.64, 57.99, -170.82), blip = 556, color = 18, name = "NewRandomPlace35", label = "New Random Place 35"},
    { coords = vec4(850.23, -532.61, 57.93, -91.02), blip = 556, color = 18, name = "NewRandomPlace36", label = "New Random Place 36"},
    { coords = vec4(861.51, -509.05, 57.72, -132.39), blip = 556, color = 18, name = "NewRandomPlace37", label = "New Random Place 37"},
    { coords = vec4(878.38, -497.94, 58.09, -132.09), blip = 556, color = 18, name = "NewRandomPlace38", label = "New Random Place 38"},
    { coords = vec4(906.29, -489.40, 59.44, -157.94), blip = 556, color = 18, name = "NewRandomPlace39", label = "New Random Place 39"},
    { coords = vec4(921.86, -477.76, 61.08, -156.01), blip = 556, color = 18, name = "NewRandomPlace40", label = "New Random Place 40"},
    { coords = vec4(944.44, -463.19, 61.55, 126.38), blip = 556, color = 18, name = "NewRandomPlace41", label = "New Random Place 41"},
    { coords = vec4(967.14, -451.57, 62.79, -147.16), blip = 556, color = 18, name = "NewRandomPlace42", label = "New Random Place 42"},
    { coords = vec4(987.45, -432.90, 64.05, -145.02), blip = 556, color = 18, name = "NewRandomPlace43", label = "New Random Place 43"},
    { coords = vec4(1010.44, -423.44, 65.35, -54.81), blip = 556, color = 18, name = "NewRandomPlace44", label = "New Random Place 44"},
    { coords = vec4(1028.77, -408.29, 66.34, -140.29), blip = 556, color = 18, name = "NewRandomPlace45", label = "New Random Place 45"},
    { coords = vec4(1060.47, -378.15, 68.23, -137.95), blip = 556, color = 18, name = "NewRandomPlace46", label = "New Random Place 46"},
    { coords = vec4(1114.41, -391.34, 68.95, 63.62), blip = 556, color = 18, name = "NewRandomPlace47", label = "New Random Place 47"},
    { coords = vec4(1101.06, -411.36, 67.56, 85.69), blip = 556, color = 18, name = "NewRandomPlace48", label = "New Random Place 48"},
    { coords = vec4(1099.49, -438.64, 67.79, -7.84), blip = 556, color = 18, name = "NewRandomPlace49", label = "New Random Place 49"},
    { coords = vec4(1098.56, -464.54, 67.32, 164.80), blip = 556, color = 18, name = "NewRandomPlace50", label = "New Random Place 50"},
    { coords = vec4(1090.43, -484.36, 65.66, 80.20), blip = 556, color = 18, name = "NewRandomPlace51", label = "New Random Place 51"},
    { coords = vec4(1056.22, -448.92, 66.26, -12.09), blip = 556, color = 18, name = "NewRandomPlace52", label = "New Random Place 52"},
    { coords = vec4(1051.06, -470.39, 64.30, -100.75), blip = 556, color = 18, name = "NewRandomPlace53", label = "New Random Place 53"},
    { coords = vec4(1046.18, -498.12, 64.28, -13.61), blip = 556, color = 18, name = "NewRandomPlace54", label = "New Random Place 54"},
    { coords = vec4(1006.47, -510.96, 60.99, 115.67), blip = 556, color = 18, name = "NewRandomPlace55", label = "New Random Place 55"},
    { coords = vec4(987.86, -525.75, 60.69, -150.91), blip = 556, color = 18, name = "NewRandomPlace56", label = "New Random Place 56"},
    { coords = vec4(965.30, -541.91, 59.73, -149.92), blip = 556, color = 18, name = "NewRandomPlace57", label = "New Random Place 57"},
    { coords = vec4(919.71, -569.53, 58.37, -157.16), blip = 556, color = 18, name = "NewRandomPlace58", label = "New Random Place 58"},
    { coords = vec4(893.22, -540.54, 58.51, 114.80), blip = 556, color = 18, name = "NewRandomPlace59", label = "New Random Place 59"},
    { coords = vec4(924.38, -526.05, 59.80, 27.07), blip = 556, color = 18, name = "NewRandomPlace60", label = "New Random Place 60"},
    { coords = vec4(945.72, -519.00, 60.82, -61.67), blip = 556, color = 18, name = "NewRandomPlace61", label = "New Random Place 61"},
    { coords = vec4(970.53, -502.41, 62.14, 71.98), blip = 556, color = 18, name = "NewRandomPlace62", label = "New Random Place 62"},
    { coords = vec4(1014.65, -469.32, 64.50, 35.18), blip = 556, color = 18, name = "NewRandomPlace63", label = "New Random Place 63"},
    { coords = vec4(1009.57, -572.47, 60.59, -99.11), blip = 556, color = 18, name = "NewRandomPlace64", label = "New Random Place 64"},
    { coords = vec4(999.54, -593.96, 59.64, -100.14), blip = 556, color = 18, name = "NewRandomPlace65", label = "New Random Place 65"},
    { coords = vec4(980.21, -627.65, 59.24, 38.41), blip = 556, color = 18, name = "NewRandomPlace66", label = "New Random Place 66"},
    { coords = vec4(964.42, -596.12, 59.90, 74.89), blip = 556, color = 18, name = "NewRandomPlace67", label = "New Random Place 67"},
    { coords = vec4(976.63, -580.69, 59.85, 38.60), blip = 556, color = 18, name = "NewRandomPlace68", label = "New Random Place 68"},
    { coords = vec4(1229.60, -725.42, 60.96, 97.18), blip = 556, color = 18, name = "NewRandomPlace69", label = "New Random Place 69"},
    { coords = vec4(1223.07, -696.85, 60.80, 104.17), blip = 556, color = 18, name = "NewRandomPlace70", label = "New Random Place 70"},
    { coords = vec4(1221.48, -669.30, 63.69, 11.58), blip = 556, color = 18, name = "NewRandomPlace71", label = "New Random Place 71"},
    { coords = vec4(1207.47, -620.26, 66.44, 94.13), blip = 556, color = 18, name = "NewRandomPlace72", label = "New Random Place 72"},
    { coords = vec4(1203.62, -598.38, 68.06, -177.98), blip = 556, color = 18, name = "NewRandomPlace73", label = "New Random Place 73"},
    { coords = vec4(1200.98, -575.54, 69.14, 135.15), blip = 556, color = 18, name = "NewRandomPlace74", label = "New Random Place 74"},
    { coords = vec4(1204.89, -557.76, 69.62, 90.30), blip = 556, color = 18, name = "NewRandomPlace75", label = "New Random Place 75"},
    { coords = vec4(1262.36, -429.89, 70.01, -67.12), blip = 556, color = 18, name = "NewRandomPlace76", label = "New Random Place 76"},
    { coords = vec4(1265.64, -458.04, 70.52, -85.27), blip = 556, color = 18, name = "NewRandomPlace77", label = "New Random Place 77"},
    { coords = vec4(1259.53, -480.16, 70.19, -53.73), blip = 556, color = 18, name = "NewRandomPlace78", label = "New Random Place 78"},
    { coords = vec4(1251.51, -494.18, 69.91, -101.62), blip = 556, color = 18, name = "NewRandomPlace79", label = "New Random Place 79"},
    { coords = vec4(1250.82, -515.43, 69.35, -103.23), blip = 556, color = 18, name = "NewRandomPlace80", label = "New Random Place 80"},
    { coords = vec4(1241.41, -566.31, 69.66, -49.35), blip = 556, color = 18, name = "NewRandomPlace81", label = "New Random Place 81"},
    { coords = vec4(1240.54, -601.62, 69.78, -89.59), blip = 556, color = 18, name = "NewRandomPlace82", label = "New Random Place 82"},
    { coords = vec4(1250.89, -620.94, 69.57, -150.47), blip = 556, color = 18, name = "NewRandomPlace83", label = "New Random Place 83"},
    { coords = vec4(1265.62, -648.67, 68.12, 31.06), blip = 556, color = 18, name = "NewRandomPlace84", label = "New Random Place 84"},
    { coords = vec4(1270.97, -683.59, 66.03, 4.82), blip = 556, color = 18, name = "NewRandomPlace85", label = "New Random Place 85"},
    { coords = vec4(1264.71, -702.74, 64.91, -125.73), blip = 556, color = 18, name = "NewRandomPlace86", label = "New Random Place 86"},
    { coords = vec4(1303.15, -527.35, 71.46, 155.68), blip = 556, color = 18, name = "NewRandomPlace87", label = "New Random Place 87"},
    { coords = vec4(1328.65, -535.99, 72.44, 68.77), blip = 556, color = 18, name = "NewRandomPlace88", label = "New Random Place 88"},
    { coords = vec4(1348.38, -546.70, 73.89, 156.67), blip = 556, color = 18, name = "NewRandomPlace89", label = "New Random Place 89"},
    { coords = vec4(1373.24, -555.73, 74.69, 70.57), blip = 556, color = 18, name = "NewRandomPlace90", label = "New Random Place 90"},
    { coords = vec4(1389.10, -569.49, 74.50, 110.07), blip = 556, color = 18, name = "NewRandomPlace91", label = "New Random Place 91"},
    { coords = vec4(1386.31, -593.51, 74.49, 44.55), blip = 556, color = 18, name = "NewRandomPlace92", label = "New Random Place 92"},
    { coords = vec4(1367.23, -606.68, 74.71, 5.24), blip = 556, color = 18, name = "NewRandomPlace93", label = "New Random Place 93"},
    { coords = vec4(1341.33, -597.22, 74.70, -127.25), blip = 556, color = 18, name = "NewRandomPlace94", label = "New Random Place 94"},
    { coords = vec4(1323.38, -583.16, 73.25, -23.32), blip = 556, color = 18, name = "NewRandomPlace95", label = "New Random Place 95"},
    { coords = vec4(1300.99, -574.29, 71.73, -17.09), blip = 556, color = 18, name = "NewRandomPlace96", label = "New Random Place 96"},
    -- Morningwood blok
    { coords = vec4(-1714.24, -463.62, 41.65, -91.27), blip = 556, color = 18, name = "NewRandomPlace132", label = "New Random Place 132"},
    { coords = vec4(-1713.44, -470.51, 41.65, -85.04), blip = 556, color = 18, name = "NewRandomPlace133", label = "New Random Place 133"},
    { coords = vec4(-1712.85, -477.28, 41.65, -94.88), blip = 556, color = 18, name = "NewRandomPlace134", label = "New Random Place 134"},
    { coords = vec4(-1709.78, -480.90, 41.65, -32.14), blip = 556, color = 18, name = "NewRandomPlace135", label = "New Random Place 135"},
    { coords = vec4(-1704.52, -480.40, 41.65, 49.43), blip = 556, color = 18, name = "NewRandomPlace136", label = "New Random Place 136"},
    { coords = vec4(-1699.96, -474.80, 41.65, 54.80), blip = 556, color = 18, name = "NewRandomPlace137", label = "New Random Place 137"},
    { coords = vec4(-1692.98, -464.70, 41.65, 139.56), blip = 556, color = 18, name = "NewRandomPlace138", label = "New Random Place 138"},
    { coords = vec4(-1698.23, -460.36, 41.65, 142.51), blip = 556, color = 18, name = "NewRandomPlace139", label = "New Random Place 139"},
    { coords = vec4(-1706.82, -453.41, 42.65, 132.95), blip = 556, color = 18, name = "NewRandomPlace140", label = "New Random Place 140"},
    { coords = vec4(-1715.42, -447.26, 42.65, 44.86), blip = 556, color = 18, name = "NewRandomPlace141", label = "New Random Place 141"},
    -- Morningwood blok 2
    { coords = vec4(-1772.32, -378.59, 46.49, 17.50), blip = 556, color = 18, name = "NewRandomPlace142", label = "New Random Place 142"},
    { coords = vec4(-1778.88, -389.97, 46.47, -76.73), blip = 556, color = 18, name = "NewRandomPlace143", label = "New Random Place 143"},
    { coords = vec4(-1788.59, -403.01, 46.47, -79.19), blip = 556, color = 18, name = "NewRandomPlace144", label = "New Random Place 144"},
    { coords = vec4(-1799.90, -422.07, 41.86, 59.99), blip = 556, color = 18, name = "NewRandomPlace145", label = "New Random Place 145"},
    { coords = vec4(-1778.08, -427.08, 41.45, -174.57), blip = 556, color = 18, name = "NewRandomPlace146", label = "New Random Place 146"},
    { coords = vec4(-1748.06, -394.74, 43.68, -100.15), blip = 556, color = 18, name = "NewRandomPlace147", label = "New Random Place 147"},
    { coords = vec4(-1768.19, -372.24, 46.48, -19.13), blip = 556, color = 18, name = "NewRandomPlace148", label = "New Random Place 148"},
    { coords = vec4(-1790.26, -369.58, 45.11, -29.90), blip = 556, color = 18, name = "NewRandomPlace149", label = "New Random Place 149"},
    { coords = vec4(-1821.37, -404.78, 46.65, 159.28), blip = 556, color = 18, name = "NewRandomPlace150", label = "New Random Place 150"},
    -- Kanalerne
    { coords = vec4(-995.42, -967.36, 2.55, -66.38), blip = 556, color = 18, name = "NewRandomPlace151", label = "New Random Place 151"},
    { coords = vec4(-1003.26, -977.72, 2.15, -62.79), blip = 556, color = 18, name = "NewRandomPlace152", label = "New Random Place 152"},
    { coords = vec4(-1023.09, -997.89, 2.15, -119.38), blip = 556, color = 18, name = "NewRandomPlace153", label = "New Random Place 153"},
    { coords = vec4(-1054.05, -1000.18, 6.41, 112.20), blip = 556, color = 18, name = "NewRandomPlace154", label = "New Random Place 154"},
    { coords = vec4(-1041.72, -1025.85, 2.75, 41.18), blip = 556, color = 18, name = "NewRandomPlace155", label = "New Random Place 155"},
    { coords = vec4(-1022.03, -1022.87, 2.15, 30.67), blip = 556, color = 18, name = "NewRandomPlace156", label = "New Random Place 156"},
    { coords = vec4(-1008.40, -1015.25, 2.15, 24.93), blip = 556, color = 18, name = "NewRandomPlace157", label = "New Random Place 157"},
    { coords = vec4(-997.14, -1012.74, 2.15, 119.46), blip = 556, color = 18, name = "NewRandomPlace158", label = "New Random Place 158"},
    { coords = vec4(-978.68, -990.67, 4.55, -45.71), blip = 556, color = 18, name = "NewRandomPlace159", label = "New Random Place 159"},
    { coords = vec4(-1076.29, -1027.04, 4.55, -43.92), blip = 556, color = 18, name = "NewRandomPlace160", label = "New Random Place 160"},
    { coords = vec4(-1088.09, -1028.05, 2.15, -62.94), blip = 556, color = 18, name = "NewRandomPlace161", label = "New Random Place 161"},
    { coords = vec4(-1097.18, -1033.13, 2.15, -61.16), blip = 556, color = 18, name = "NewRandomPlace162", label = "New Random Place 162"},
    { coords = vec4(-1108.91, -1041.00, 2.15, -152.41), blip = 556, color = 18, name = "NewRandomPlace163", label = "New Random Place 163"},
    { coords = vec4(-1122.12, -1046.24, 2.15, -157.86), blip = 556, color = 18, name = "NewRandomPlace164", label = "New Random Place 164"},
    { coords = vec4(-1134.13, -1050.13, 2.15, -65.30), blip = 556, color = 18, name = "NewRandomPlace165", label = "New Random Place 165"},
    { coords = vec4(-1122.71, -1089.36, 2.55, 111.28), blip = 556, color = 18, name = "NewRandomPlace166", label = "New Random Place 166"},
    { coords = vec4(-1114.10, -1069.25, 2.15, 29.34), blip = 556, color = 18, name = "NewRandomPlace167", label = "New Random Place 167"},
    { coords = vec4(-1104.02, -1059.98, 2.75, 26.17), blip = 556, color = 18, name = "NewRandomPlace168", label = "New Random Place 168"},
    { coords = vec4(-1065.88, -1055.28, 6.41, -62.05), blip = 556, color = 18, name = "NewRandomPlace169", label = "New Random Place 169"},
    { coords = vec4(-1031.80, -1109.42, 2.16, -60.41), blip = 556, color = 18, name = "NewRandomPlace170", label = "New Random Place 170"},
    { coords = vec4(-1047.98, -1123.46, 2.16, -62.06), blip = 556, color = 18, name = "NewRandomPlace171", label = "New Random Place 171"},
    { coords = vec4(-1040.49, -1135.94, 2.16, -158.09), blip = 556, color = 18, name = "NewRandomPlace172", label = "New Random Place 172"},
    { coords = vec4(-1063.92, -1133.45, 2.16, -62.77), blip = 556, color = 18, name = "NewRandomPlace173", label = "New Random Place 173"},
    { coords = vec4(-1074.06, -1152.84, 2.16, -49.66), blip = 556, color = 18, name = "NewRandomPlace174", label = "New Random Place 174"},
    { coords = vec4(-1068.11, -1163.67, 2.74, 28.22), blip = 556, color = 18, name = "NewRandomPlace175", label = "New Random Place 175"},
    { coords = vec4(-1063.42, -1160.26, 2.76, 30.46), blip = 556, color = 18, name = "NewRandomPlace176", label = "New Random Place 176"},
    { coords = vec4(-1045.75, -1159.68, 2.16, 43.91), blip = 556, color = 18, name = "NewRandomPlace177", label = "New Random Place 177"},
    { coords = vec4(-1035.16, -1147.40, 2.16, 37.46), blip = 556, color = 18, name = "NewRandomPlace178", label = "New Random Place 178"},
    { coords = vec4(-1024.32, -1139.89, 2.75, 32.65), blip = 556, color = 18, name = "NewRandomPlace179", label = "New Random Place 179"},
    { coords = vec4(-986.23, -1121.21, 4.55, 128.75), blip = 556, color = 18, name = "NewRandomPlace180", label = "New Random Place 180"},
    { coords = vec4(-970.67, -1120.77, 2.17, 124.97), blip = 556, color = 18, name = "NewRandomPlace181", label = "New Random Place 181"},
    { coords = vec4(-978.01, -1108.22, 2.15, 13.07), blip = 556, color = 18, name = "NewRandomPlace182", label = "New Random Place 182"},
    { coords = vec4(-959.73, -1109.72, 2.15, 28.43), blip = 556, color = 18, name = "NewRandomPlace183", label = "New Random Place 183"},
    { coords = vec4(-948.62, -1107.30, 2.17, 54.50), blip = 556, color = 18, name = "NewRandomPlace184", label = "New Random Place 184"},
    { coords = vec4(-938.65, -1087.87, 2.15, 147.90), blip = 556, color = 18, name = "NewRandomPlace185", label = "New Random Place 185"},
    { coords = vec4(-921.73, -1094.82, 2.15, -60.27), blip = 556, color = 18, name = "NewRandomPlace186", label = "New Random Place 186"},
    { coords = vec4(-943.42, -1075.47, 2.74, -150.21), blip = 556, color = 18, name = "NewRandomPlace187", label = "New Random Place 187"},
    { coords = vec4(-952.49, -1077.58, 2.69, -156.55), blip = 556, color = 18, name = "NewRandomPlace188", label = "New Random Place 188"},
    { coords = vec4(-967.48, -1080.36, 2.17, -38.51), blip = 556, color = 18, name = "NewRandomPlace189", label = "New Random Place 189"},
    { coords = vec4(-982.52, -1084.04, 2.55, -59.45), blip = 556, color = 18, name = "NewRandomPlace190", label = "New Random Place 190"},
    { coords = vec4(-991.92, -1103.59, 2.15, -142.24), blip = 556, color = 18, name = "NewRandomPlace191", label = "New Random Place 191"},
    { coords = vec4(-1100.10, -1231.89, 3.19, 50.12), blip = 556, color = 18, name = "NewRandomPlace192", label = "New Random Place 192"},
    { coords = vec4(-1107.32, -1222.89, 2.56, -155.44), blip = 556, color = 18, name = "NewRandomPlace193", label = "New Random Place 193"},
    { coords = vec4(-1113.33, -1195.79, 6.68, 16.49), blip = 556, color = 18, name = "NewRandomPlace194", label = "New Random Place 194"},
    { coords = vec4(-1125.91, -1171.81, 2.36, 113.83), blip = 556, color = 18, name = "NewRandomPlace195", label = "New Random Place 195"},
    { coords = vec4(-1135.68, -1153.19, 2.75, 112.89), blip = 556, color = 18, name = "NewRandomPlace196", label = "New Random Place 196"},
    { coords = vec4(-1142.53, -1144.30, 2.85, 121.34), blip = 556, color = 18, name = "NewRandomPlace197", label = "New Random Place 197"},
    { coords = vec4(-1152.06, -1132.49, 2.75, 121.91), blip = 556, color = 18, name = "NewRandomPlace198", label = "New Random Place 198"},
    { coords = vec4(-1143.14, -1121.81, 2.60, -168.65), blip = 556, color = 18, name = "NewRandomPlace199", label = "New Random Place 199"},
    { coords = vec4(-1161.16, -1099.89, 2.22, 15.08), blip = 556, color = 18, name = "NewRandomPlace200", label = "New Random Place 200"},
    { coords = vec4(-1183.65, -1078.12, 2.15, 124.70), blip = 556, color = 18, name = "NewRandomPlace201", label = "New Random Place 201"},
    { coords = vec4(-1182.87, -1064.33, 2.15, 125.49), blip = 556, color = 18, name = "NewRandomPlace202", label = "New Random Place 202"},
    { coords = vec4(-1190.87, -1054.86, 2.15, 117.26), blip = 556, color = 18, name = "NewRandomPlace203", label = "New Random Place 203"},
    { coords = vec4(-1188.28, -1041.28, 2.30, -152.56), blip = 556, color = 18, name = "NewRandomPlace204", label = "New Random Place 204"},
    { coords = vec4(-1200.44, -1032.05, 2.15, 91.70), blip = 556, color = 18, name = "NewRandomPlace205", label = "New Random Place 205"},
    { coords = vec4(-1195.38, -1036.30, 2.30, 18.41), blip = 556, color = 18, name = "NewRandomPlace206", label = "New Random Place 206"},
    { coords = vec4(-1208.77, -1023.26, 2.15, 121.09), blip = 556, color = 18, name = "NewRandomPlace207", label = "New Random Place 207"},
    -- Strandkanten ved molen
    { coords = vec4(-1753.22, -724.02, 10.41, 112.50), blip = 556, color = 18, name = "NewRandomPlace208", label = "New Random Place 208"},
    { coords = vec4(-1764.09, -707.80, 10.61, 136.88), blip = 556, color = 18, name = "NewRandomPlace209", label = "New Random Place 209"},
    { coords = vec4(-1777.08, -701.48, 10.53, 140.84), blip = 556, color = 18, name = "NewRandomPlace210", label = "New Random Place 210"},
    { coords = vec4(-1771.19, -677.34, 10.39, -45.21), blip = 556, color = 18, name = "NewRandomPlace211", label = "New Random Place 211"},
    { coords = vec4(-1790.95, -683.21, 10.64, 174.09), blip = 556, color = 18, name = "NewRandomPlace212", label = "New Random Place 212"},
    { coords = vec4(-1800.13, -667.29, 10.60, 37.83), blip = 556, color = 18, name = "NewRandomPlace213", label = "New Random Place 213"},
    { coords = vec4(-1813.63, -664.07, 10.97, 172.92), blip = 556, color = 18, name = "NewRandomPlace214", label = "New Random Place 214"},
    { coords = vec4(-1814.02, -656.78, 10.89, -126.54), blip = 556, color = 18, name = "NewRandomPlace215", label = "New Random Place 215"},
    { coords = vec4(-1824.48, -646.04, 10.95, 38.54), blip = 556, color = 18, name = "NewRandomPlace216", label = "New Random Place 216"},
    { coords = vec4(-1834.43, -642.21, 11.48, 49.60), blip = 556, color = 18, name = "NewRandomPlace217", label = "New Random Place 217"},
    { coords = vec4(-1836.40, -631.65, 10.76, 64.04), blip = 556, color = 18, name = "NewRandomPlace218", label = "New Random Place 218"},
    { coords = vec4(-1845.82, -634.05, 11.18, 138.57), blip = 556, color = 18, name = "NewRandomPlace219", label = "New Random Place 219"},
    { coords = vec4(-1880.78, -606.53, 12.20, 136.71), blip = 556, color = 18, name = "NewRandomPlace220", label = "New Random Place 220"},
    { coords = vec4(-1884.64, -600.00, 11.90, 137.58), blip = 556, color = 18, name = "NewRandomPlace221", label = "New Random Place 221"},
    { coords = vec4(-1883.41, -578.87, 11.82, -102.62), blip = 556, color = 18, name = "NewRandomPlace222", label = "New Random Place 222"},
    { coords = vec4(-1901.90, -585.69, 11.87, 145.12), blip = 556, color = 18, name = "NewRandomPlace223", label = "New Random Place 223"},
    { coords = vec4(-1913.49, -574.06, 11.44, 142.31), blip = 556, color = 18, name = "NewRandomPlace224", label = "New Random Place 224"},
    { coords = vec4(-1919.97, -569.78, 11.91, 141.63), blip = 556, color = 18, name = "NewRandomPlace225", label = "New Random Place 225"},
    { coords = vec4(-1923.52, -558.73, 12.06, -120.73), blip = 556, color = 18, name = "NewRandomPlace226", label = "New Random Place 226"},
    { coords = vec4(-1918.69, -542.51, 11.83, -36.47), blip = 556, color = 18, name = "NewRandomPlace227", label = "New Random Place 227"},
    { coords = vec4(-1946.88, -543.95, 11.86, -74.04), blip = 556, color = 18, name = "NewRandomPlace228", label = "New Random Place 228"},
    { coords = vec4(-1958.10, -538.36, 11.90, 153.32), blip = 556, color = 18, name = "NewRandomPlace229", label = "New Random Place 229"},
    { coords = vec4(-1967.80, -531.79, 12.17, 134.73), blip = 556, color = 18, name = "NewRandomPlace230", label = "New Random Place 230"},
    { coords = vec4(-1968.74, -522.63, 11.85, -147.30), blip = 556, color = 18, name = "NewRandomPlace231", label = "New Random Place 231"},
    { coords = vec4(-1979.88, -520.14, 11.89, 131.39), blip = 556, color = 18, name = "NewRandomPlace232", label = "New Random Place 232"},
    -- Rancho / davis omkring impound
    { coords = vec4(329.405, -1845.936, 27.7481, 230.7849), blip = 556, color = 18, name = "NewRandomPlace233", label = "New Random Place 233"},
    { coords = vec4(320.2585, -1854.145, 27.5109, 230.7081), blip = 556, color = 18, name = "NewRandomPlace234", label = "New Random Place 234"},
    { coords = vec4(338.6034, -1829.587, 28.33747, 131.9832), blip = 556, color = 18, name = "NewRandomPlace235", label = "New Random Place 235"},
    { coords = vec4(348.5979, -1820.911, 28.89409, 141.384), blip = 556, color = 18, name = "NewRandomPlace236", label = "New Random Place 236"},
    { coords = vec4(288.7005, -1792.547, 28.08906, 141.7309), blip = 556, color = 18, name = "NewRandomPlace237", label = "New Random Place 237"},
    { coords = vec4(300.2568, -1783.813, 28.43866, 326.0221), blip = 556, color = 18, name = "NewRandomPlace238", label = "New Random Place 238"},
    { coords = vec4(304.3995, -1775.588, 29.10093, 31.06964), blip = 556, color = 18, name = "NewRandomPlace239", label = "New Random Place 239"},
    { coords = vec4(320.5965, -1759.957, 29.63786, 63.45952), blip = 556, color = 18, name = "NewRandomPlace240", label = "New Random Place 240"},
    { coords = vec4(333.0129, -1740.875, 29.73052, 320.1446), blip = 556, color = 18, name = "NewRandomPlace241", label = "New Random Place 241"},
    { coords = vec4(282.0941, -1694.833, 29.6479, 234.4468), blip = 556, color = 18, name = "NewRandomPlace242", label = "New Random Place 242"},
    { coords = vec4(269.7108, -1712.956, 29.66877, 325.2532), blip = 556, color = 18, name = "NewRandomPlace243", label = "New Random Place 243"},
    { coords = vec4(257.6118, -1722.924, 29.65412, 319.2005), blip = 556, color = 18, name = "NewRandomPlace244", label = "New Random Place 244"},
    { coords = vec4(250.1269, -1730.762, 29.67987, 230.6202), blip = 556, color = 18, name = "NewRandomPlace245", label = "New Random Place 245"},
    { coords = vec4(216.2977, -1717.066, 29.6777, 106.1588), blip = 556, color = 18, name = "NewRandomPlace246", label = "New Random Place 246"},
    { coords = vec4(222.5529, -1702.451, 29.68972, 35.33562), blip = 556, color = 18, name = "NewRandomPlace247", label = "New Random Place 247"},
    { coords = vec4(240.6872, -1687.652, 29.69475, 51.47546), blip = 556, color = 18, name = "NewRandomPlace248", label = "New Random Place 248"},
    { coords = vec4(252.8744, -1670.814, 29.66319, 307.0917), blip = 556, color = 18, name = "NewRandomPlace249", label = "New Random Place 249"},
    { coords = vec4(368.6771, -1895.737, 25.17856, 327.29), blip = 556, color = 18, name = "NewRandomPlace250", label = "New Random Place 250"},
    { coords = vec4(385.2237, -1881.41, 26.03337, 44.66132), blip = 556, color = 18, name = "NewRandomPlace251", label = "New Random Place 251"},
    { coords = vec4(399.2057, -1864.898, 26.71632, 139.3412), blip = 556, color = 18, name = "NewRandomPlace252", label = "New Random Place 252"},
    { coords = vec4(412.3686, -1856.278, 27.32313, 138.4672), blip = 556, color = 18, name = "NewRandomPlace253", label = "New Random Place 253"},
    { coords = vec4(427.1049, -1841.927, 28.46348, 143.1984), blip = 556, color = 18, name = "NewRandomPlace254", label = "New Random Place 254"},
    { coords = vec4(440.5896, -1829.651, 28.36184, 315.6426), blip = 556, color = 18, name = "NewRandomPlace255", label = "New Random Place 255"},
    { coords = vec4(495.4796, -1823.422, 28.8697, 136.6416), blip = 556, color = 18, name = "NewRandomPlace256", label = "New Random Place 256"},
    { coords = vec4(500.6178, -1813.334, 28.8912, 136.977), blip = 556, color = 18, name = "NewRandomPlace257", label = "New Random Place 257"},
    { coords = vec4(512.538, -1790.863, 28.92013, 269.4895), blip = 556, color = 18, name = "NewRandomPlace258", label = "New Random Place 258"},
    { coords = vec4(514.2752, -1781.007, 28.91226, 274.2285), blip = 556, color = 18, name = "NewRandomPlace259", label = "New Random Place 259"},
    { coords = vec4(472.1575, -1775.102, 29.07088, 96.08327), blip = 556, color = 18, name = "NewRandomPlace260", label = "New Random Place 260"},
    { coords = vec4(474.5379, -1757.625, 29.09261, 68.29633), blip = 556, color = 18, name = "NewRandomPlace261", label = "New Random Place 261"},
    { coords = vec4(479.6092, -1735.744, 29.15102, 325.2198), blip = 556, color = 18, name = "NewRandomPlace262", label = "New Random Place 262"},
    { coords = vec4(489.6591, -1714.056, 29.70689, 82.34749), blip = 556, color = 18, name = "NewRandomPlace263", label = "New Random Place 263"},
    { coords = vec4(500.8561, -1697.336, 29.78934, 312.8524), blip = 556, color = 18, name = "NewRandomPlace264", label = "New Random Place 264"},
    { coords = vec4(-34.10553, -1847.035, 26.19352, 58.8805), blip = 556, color = 18, name = "NewRandomPlace265", label = "New Random Place 265"},
    { coords = vec4(-20.51655, -1859.039, 25.40867, 239.6504), blip = 556, color = 18, name = "NewRandomPlace266", label = "New Random Place 266"},
    { coords = vec4(-4.804734, -1872.255, 24.15101, 212.6209), blip = 556, color = 18, name = "NewRandomPlace267", label = "New Random Place 267"},
    { coords = vec4(5.207539, -1884.393, 23.69725, 262.9348), blip = 556, color = 18, name = "NewRandomPlace268", label = "New Random Place 268"},
    { coords = vec4(23.04099, -1896.682, 22.96586, 140.853), blip = 556, color = 18, name = "NewRandomPlace269", label = "New Random Place 269"},
    { coords = vec4(39.02351, -1911.546, 21.95351, 357.71), blip = 556, color = 18, name = "NewRandomPlace270", label = "New Random Place 270"},
    { coords = vec4(56.60613, -1922.742, 21.91104, 121.5689), blip = 556, color = 18, name = "NewRandomPlace271", label = "New Random Place 271"},
    { coords = vec4(72.0139, -1938.895, 21.36905, 136.7443), blip = 556, color = 18, name = "NewRandomPlace272", label = "New Random Place 272"},
    { coords = vec4(76.52701, -1947.898, 21.17417, 31.41029), blip = 556, color = 18, name = "NewRandomPlace273", label = "New Random Place 273"},
    { coords = vec4(85.59054, -1959.562, 21.12171, 211.5084), blip = 556, color = 18, name = "NewRandomPlace274", label = "New Random Place 274"},
    { coords = vec4(114.0936, -1961.333, 21.33201, 237.4675), blip = 556, color = 18, name = "NewRandomPlace275", label = "New Random Place 275"},
    { coords = vec4(126.7259, -1930.001, 21.38241, 227.4126), blip = 556, color = 18, name = "NewRandomPlace276", label = "New Random Place 276"},
    { coords = vec4(118.2044, -1921.274, 21.3234, 232.7699), blip = 556, color = 18, name = "NewRandomPlace277", label = "New Random Place 277"},
    { coords = vec4(100.8831, -1912.074, 21.39986, 332.2657), blip = 556, color = 18, name = "NewRandomPlace278", label = "New Random Place 278"},
    { coords = vec4(54.41023, -1873.02, 22.80004, 325.8384), blip = 556, color = 18, name = "NewRandomPlace279", label = "New Random Place 279"},
    { coords = vec4(46.09107, -1864.183, 23.27386, 314.9212), blip = 556, color = 18, name = "NewRandomPlace280", label = "New Random Place 280"},
    { coords = vec4(29.99592, -1854.681, 24.06882, 262.4022), blip = 556, color = 18, name = "NewRandomPlace281", label = "New Random Place 281"},
    { coords = vec4(21.32549, -1844.624, 24.60173, 236.9161), blip = 556, color = 18, name = "NewRandomPlace282", label = "New Random Place 282"},
    { coords = vec4(115.3691, -1887.863, 23.92822, 268.372), blip = 556, color = 18, name = "NewRandomPlace283", label = "New Random Place 283"},
    { coords = vec4(128.2027, -1897.005, 23.67423, 226.4456), blip = 556, color = 18, name = "NewRandomPlace284", label = "New Random Place 284"},
    { coords = vec4(148.6994, -1904.454, 23.53174, 124.5817), blip = 556, color = 18, name = "NewRandomPlace285", label = "New Random Place 285"},
    { coords = vec4(130.887, -1853.407, 25.23473, 2.81944), blip = 556, color = 18, name = "NewRandomPlace286", label = "New Random Place 286"},
    { coords = vec4(149.9707, -1864.697, 24.5913, 6.826437), blip = 556, color = 18, name = "NewRandomPlace287", label = "New Random Place 287"},
    { coords = vec4(171.5339, -1871.53, 24.40022, 238.3544), blip = 556, color = 18, name = "NewRandomPlace288", label = "New Random Place 288"},
    { coords = vec4(192.2976, -1883.254, 25.0566, 299.2085), blip = 556, color = 18, name = "NewRandomPlace289", label = "New Random Place 289"},
    { coords = vec4(208.4303, -1895.451, 24.81411, 247.7213), blip = 556, color = 18, name = "NewRandomPlace290", label = "New Random Place 290"},
    { coords = vec4(179.3478, -1924.065, 21.37511, 0), blip = 556, color = 18, name = "NewRandomPlace291", label = "New Random Place 291"},
    { coords = vec4(165.0541, -1944.952, 20.23515, 59.16739), blip = 556, color = 18, name = "NewRandomPlace292", label = "New Random Place 292"},
    { coords = vec4(148.8079, -1960.664, 19.45889, 31.23898), blip = 556, color = 18, name = "NewRandomPlace293", label = "New Random Place 293"},
    { coords = vec4(144.2602, -1968.964, 18.85762, 323.854), blip = 556, color = 18, name = "NewRandomPlace294", label = "New Random Place 294"},
    { coords = vec4(140.7416, -1982.907, 18.32197, 77.53931), blip = 556, color = 18, name = "NewRandomPlace295", label = "New Random Place 295"},
}

Config.Items = { -- This is all the items that you wanna be able to shred into raaw maaterials like rubber iron and what not.
    ["phone"] = { -- This item is the item naame of the items you wanna be able to pickup and be able to shred in the machine.
        item = {
            materials = 2,
        },
        reward = "electronics", -- This is a random award you can get when shredding items.
        rewardAmount = 1, -- This is the amount of the random item you get when you get lucky
        rewardChance = 0, -- This fx math.random(1, 100) <= 5 (if no reward set to 0)
        runChance = 0, -- This fx math.random(1, 100) <= 5 (if no reward set to 0)
        runAmount = math.random(2,5), -- This is the amount of items you get when you pick up the item
        deliveryMoney = 1800 -- Delivery Money
    },
    ["laptop"] = {
        item = {
            materials = 7,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 0,
        runAmount = math.random(1,2),
        deliveryMoney = 6900
    },
    ["radio"] = {
        item = {
            materials = 2,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 2,
        runChance = 0,
        runAmount = math.random(2,5),
        deliveryMoney = 1900
    },
    ["contracts_tablet"] = {
        item = {
            materials = 350,
        },
        reward = "electronics",
        rewardAmount = 0.5,
        rewardChance = 0,
        runChance = 1,
        runAmount = 1,
        deliveryMoney = 290000
    },
    ["diamond_ring"] = {
        item = {
            materials = 4,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 5,
        runAmount = math.random(1, 4),
        deliveryMoney = 3600    -- Var 3250, nu 20% højere (3250 * 1.2 = 3900)
    },
    ["necklace"] = {
        item = {
            materials = 1,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 10,
        runAmount = math.random(2, 10),
        deliveryMoney = 1000    -- Var 1000, nu 20% højere (1000 * 1.2 = 1200)
    },
    ["diamond_necklace"] = {
        item = {
            materials = 4,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 5,
        runAmount = math.random(1, 4),
        deliveryMoney = 3500    -- Var 3250, nu 20% højere (3250 * 1.2 = 3900)
    },
    ["ring"] = {
        item = {
            materials = 1,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 15,
        runAmount = math.random(1, 4),
        deliveryMoney = 700     -- Var 750, nu 20% højere (750 * 1.2 = 900)
    },
    ["watch"] = {
        item = {
            materials = 1,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 15,
        runAmount = math.random(2, 10),
        deliveryMoney = 750     -- Var 750, nu 20% højere (750 * 1.2 = 900)
    },
    ["luxurious_watch"] = {
        item = {
            materials = 3,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 5,
        runAmount = math.random(1, 4),
        deliveryMoney = 3140    -- Var 2950, nu 20% højere (2950 * 1.2 = 3540)
    },
    ["gold_bar"] = {
        item = {
            materials = 3,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 5,
        runAmount = math.random(1, 4),
        deliveryMoney = 3100    -- Var 3000, nu 20% højere (3000 * 1.2 = 3600)
    },
    ["diamantboks"] = {
        item = {
            materials = 4,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 3,
        runAmount = math.random(1, 3),
        deliveryMoney = 4180    -- Var 3900, nu 20% højere (3900 * 1.2 = 4680)
    },
    ["pendrive"] = {
        item = {
            materials = 2,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 0,
        runAmount = math.random(3, 5),
        deliveryMoney = 2200
    },
    ["black_usb"] = {
        item = {
            materials = 50,
        },
        reward = "electronics",
        rewardAmount = 0.5,
        rewardChance = 0,
        runChance = 1,
        runAmount = math.random(1),
        deliveryMoney = 48000
    },
    ["lockpick"] = {
        item = {
            materials = 14,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 0,
        runAmount = math.random(1),
        deliveryMoney = 17000
    },
    ["coins"] = {
        item = {
            materials = math.random(2, 3),
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 1,
        runAmount = math.random(1, 10),
        deliveryMoney = 2800
    },
    ["skull_art"] = {
        item = {
            materials = 40,
        },
        reward = "electronics",
        rewardAmount = 1,
        rewardChance = 0,
        runChance = 1,
        runAmount = math.random(1, 2),
        deliveryMoney = 37500
    },
-- Vinkelsliber, Lockpick, Plates, 

}
Config.Lang = {
    openMachine = "Åbn maskine",
    startMachine = "Start processen",
    machineEmpty = "Maskinen er tom.",
    startRun = "Start panterute.",
    stopRun = "Stop ruten",
    openTray = "Åbn bakke",
    progressbarUsingMachine = "Bruger maskinen...",
    youCancelled = "Du afbrød handlingen.",
    notEnoughMoney = "Du har ikke nok penge.",
    cantDoMoreRuns = "Du kan ikke udføre flere ruter.",
    tookItem = "Du fik noget.",
    tookNothing = "Du fik ikke noget.",
    pickup = "Saml op.",
    openStash = "Åbn boks.",
    registerTray = "Registrer salg",
    
    -- Leveringssystem oversættelser
    startDelivery = "Start leveringsrute",
    stopDelivery = "Stop leveringsrute",
    deliveryCancelled = "Leveringsrute annulleret",
    notEnoughMoneyDeposit = "Du har ikke nok penge til at betale depositum",
    deliveryStarted = "Leveringsrute startet",
    deliveryDescription = "Leverér dine pantegenstande til de markerede lokationer",
    deliveryLocation = "Afleveringspunkt",
    newDelivery = "Ny afleveringsdestination",
    deliveryLocationDesc = "Gå til det markerede afleveringspunkt",
    deliverItems = "Aflever genstande",
    noItemsToDeliver = "Ingen genstande at aflevere",
    findItemsFirst = "Du skal først finde nogle pantegenstande",
    deliverThisItem = "Aflever denne genstand",
    reward = "Belønning",
    currency = "kr",
    cancelDelivery = "Annuller levering",
    stopDeliveryDesc = "Stop leveringsruten og få dit depositum tilbage",
    deliveryMenuTitle = "Vælg genstand til aflevering",
    deliveringItem = "Afleverer genstand...",
    deliveryPaid = "Aflevering gennemført",
    currencyReceived = "kr modtaget",
    deliveryFailed = "Aflevering mislykkedes",
    noItemFound = "Genstand ikke fundet i dit inventar",
    depositReturned = "Dit depositum er returneret",
    deliveryCancelledDesc = "Din leveringsrute er annulleret og dit depositum er returneret",
    checkTrayValue = "Lommeregner",
    trayValueDescription = "Indkøbsprisen på varen(ene) er: %s,- DKK",
}
