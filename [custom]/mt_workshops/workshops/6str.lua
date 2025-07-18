Config.workshops = Config.workshops or {}

Config.workshops.sixstr = {
    enabled = true,
    label = "6STR",
    job = '6str',
    blip = { enabled = true, coords = vec3(138.54, -3030.27, 6.04), color = 1, scale = 0.5, display = 4, sprite = 488 },
    zone = {
        points = {
            vec3(117.51, -3004.83, 5.0),
            vec3(117.87, -3054.28, 5.0),
            vec3(157.27, -3052.16, 5.0),
            vec3(155.84, -3005.72, 5.0)
            
        },
        thickness = 50
    },
    stashes = {
        { coords = vec3(121.14, -3028.48, 7.04), radius = 0.8, slots = 50, weight = 1000 },
    },
    crafts = {
        { coords = vec3(129.44, -3031.42, 7.04), radius = 2.5, categories = { 'performance', 'others' } },
    },
    -- shops = {
    --     { coords = vec3(836.0419, -811.7117, 26.35336), radius = 1.5, categories = { 'performance', 'others' } },
    --     { coords = vec3(836.329, -817.8915, 26.35213), radius = 1.5, categories = { 'performance', 'others' } },
    -- },
    garage = {
        -- {
        --     coords = vec4(911.56, -975.15, 38.50, 93.36),
        --     spawnCoords = vec4(922.68, -975.90, 39.50, 273.40),
        --     vehicles = {
        --         { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
        --         { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
        --     },
        -- },
    },
}