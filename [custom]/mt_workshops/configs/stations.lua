Config = Config or {}

Config.stations = {
    { -- La Mesa LS Customs
        label = "Værksted",
        job = false,
        checkMecs = true,
        price = 50000,
        progress = 15000,
        blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
        type = 'zone', -- zone or prop
        zone = {
            points = {
                vec3(-1152.2088623047, -1995.2021484375, 13.160172462463),
                vec3(-1166.1789550781, -2008.8316650391, 13.160172462463),
                vec3(-1162.3015136719, -2012.6624755859, 13.160172462463),
                vec3(-1166.9006347656, -2018.2100830078, 13.160172462463),
                vec3(-1158.0965576172, -2025.9918212891, 13.160172462463),
                vec3(-1140.498046875, -2008.3168945312, 13.160172462463)
            },
            thickness = 5
        }
    },
    { -- Airport LS Customs
    label = "Værksted",
    job = false,
    checkMecs = true,
    price = 50000,
    progress = 15000,
    blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
    type = 'zone', -- zone or prop
    zone = {
        points = {
            vec3(724.69049072266, -1091.2758789062, 22.168),
            vec3(738.52880859375, -1094.6921386719, 22.168),
            vec3(738.13397216797, -1076.3740234375, 22.168),
            vec3(724.16107177734, -1077.2191162109, 22.168)
        },
        thickness = 5
    }
},
    { -- LSC
    label = "Værksted",
    job = false,
    checkMecs = true,
    price = 50000,
    progress = 15000,
    blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
    type = 'zone', -- zone or prop
    zone = {
        points = {
            vec3(-348.35452270508, -139.20495605469, 38.987),
            vec3(-331.63354492188, -145.53900146484, 38.987),
            vec3(-322.68634033203, -142.37533569336, 38.987),
            vec3(-319.24487304688, -131.2785949707, 38.987),
            vec3(-342.81094360352, -122.57281494141, 38.987)
        },
        thickness = 5
    }
},
    { -- Route 68 Harmony
        label = "Værksted",
        job = false,
        checkMecs = true,
        price = 50000,
        progress = 15000,
        blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
        type = 'zone', -- zone or prop
        zone = {
            points = {
                vec3(1171.92, 2645.99, 37.8),
                vec3(1178.87, 2644.73, 37.8),
                vec3(1178.01, 2635.96, 37.8),
                vec3(1172.33, 2635.59, 37.8)
            },
            thickness = 5
        }
    },
    { -- Paleto LSC
        label = "Værksted",
        job = false,
        checkMecs = true,
        price = 50000,
        progress = 15000,
        blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
        type = 'zone', -- zone or prop
        zone = {
            points = {
                vec3(116.42, 6624.58, 31.8),
                vec3(113.01, 6621.05, 31.8),
                vec3(105.44, 6627.51, 31.8),
                vec3(109.25, 6631.74, 31.8)
            },
            thickness = 5
        }
    },
    { -- Benny's Customs
    label = "Værksted",
    job = false,
    checkMecs = true,
    price = 50000,
    progress = 15000,
    blip = { enabled = true, color = 0, sprite = 446, display = 4, scale = 0.6 },
    type = 'zone', -- zone or prop
    zone = {
        points = {
            vec3(-203.43518066406, -1315.6304931641, 30.890),
            vec3(-216.28450012207, -1321.5407714844, 30.890),
            vec3(-227.94866943359, -1321.9583740234, 30.890),
            vec3(-228.24604797363, -1334.2454833984, 30.890),
            vec3(-208.20922851562, -1333.9141845703, 30.890),
            vec3(-207.75241088867, -1327.3819580078, 30.890),
            vec3(-204.0862121582, -1327.3107910156, 30.890)
        },
        thickness = 5
    }
},
    { -- Weasel News PG Repair
    label = "VPG Repair",
    job = 'police',
    checkMecs = true,
    price = 0,
    progress = 15000,
    blip = { enabled = false, color = 0, sprite = 446, display = 4, scale = 0.6 },
    type = 'prop', -- zone or prop
    prop = {
        model = 'gr_prop_gr_bench_02a',
        radius = 5,
        coords = vec4(-556.7751, -910.2324, 22.8536, 177.5813),
    }
},
    { -- MRPG Repair
        label = "MRPG Repair",
        job = 'police',
        checkMecs = true,
        price = 0,
        progress = 15000,
        blip = { enabled = false, color = 0, sprite = 446, display = 4, scale = 0.6 },
        type = 'prop', -- zone or prop
        prop = {
            model = 'gr_prop_gr_bench_02a',
            radius = 5,
            coords = vec4(437.96, -971.21, 24.71, 359.14),
        }
    },
    { -- Paleto PG Repair
    label = "Paleto PG Repair",
    job = 'police',
    checkMecs = true,
    price = 0,
    progress = 15000,
    blip = { enabled = false, color = 0, sprite = 446, display = 4, scale = 0.6 },
    type = 'prop', -- zone or prop
    prop = {
        model = 'gr_prop_gr_bench_02a',
        radius = 5,
        coords = vec4(-479.0766, 6015.6694, 30.3405, 137.1370),
    }
},
    { -- Sandy PG Repair
        label = "Sandy PG Repair",
        job = 'police',
        checkMecs = true,
        price = 0,
        progress = 15000,
        blip = { enabled = false, color = 0, sprite = 446, display = 4, scale = 0.6 },
        type = 'prop',
        prop = {
            model = 'gr_prop_gr_bench_02a',
            radius = 5,
            coords = vector4(1864.465, 3698.882, 32.97468, 121.8976 - 180),
        }
    },
}