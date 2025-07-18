Config.workshops = Config.workshops or {}

Config.workshops.larrys = {
    enabled = true,
    label = "Larry's Auto",
    job = 'larrys',
    blip = { enabled = false, coords = vec3(1221.276, 2729.198, 38.102), color = 6, scale = 0.5, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(1204.244, 2695.248, 37.922),
            vec3(1203.994, 2749.835, 37.472),
            vec3(1255.934, 2749.079, 38.306),
            vec3(1255.227, 2695.202, 37.569),
        },
        thickness = 20
    },
    stashes = {
        { coords = vec3(1227.318, 2733.583, 38.102), radius = 0.8, slots = 50, weight = 1000 },
        { coords = vec3(1218.861, 2733.444, 38.102), radius = 0.8, slots = 50, weight = 1000 },
    },
    crafts = {
        { coords = vec3(1223.995, 2733.220, 38.102), radius = 2.5, categories = { 'performance', 'others' } },
        -- { coords = vec3(836.329, -817.8915, 26.35213), radius = 2.5, categories = { 'performance', 'others' } },
    },
    -- shops = {
    --     { coords = vec3(836.0419, -811.7117, 26.35336), radius = 1.5, categories = { 'performance', 'others' } },
    --     { coords = vec3(836.329, -817.8915, 26.35213), radius = 1.5, categories = { 'performance', 'others' } },
    -- },
    garage = {
        {
            coords = vector4(1247.37, 2721.843, 38.00532, 185.808),
            spawnCoords = vector4(1246.779, 2715.633, 38.02365, 180.1148),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}