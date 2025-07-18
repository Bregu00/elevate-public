Config.workshops = Config.workshops or {}

Config.workshops.otto = {
    enabled = true,
    label = "Otto's Auto",
    job = 'otto',
    blip = { enabled = false, coords = vec3(931.21, -970.73, 39.50), color = 6, scale = 0.5, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(912.21, -987.29, 39.50),
            vec3(902.63, -945.24, 39.50),
            vec3(961.17, -933.62, 39.50),
            vec3(964.33, -983.86, 39.50),
            
        },
        thickness = 50
    },
    stashes = {
        { coords = vec3(955.94, -957.93, 39.50), radius = 0.8, slots = 50, weight = 500 },
        { coords = vec3(962.11, -961.24, 39.50), radius = 0.8, slots = 50, weight = 1000 },
    },
    crafts = {
        { coords = vec3(953.28, -977.88, 39.50), radius = 2.5, categories = { 'performance', 'others' } },
        { coords = vec3(947.37, -969.54, 39.50), radius = 2.5, categories = { 'performance', 'others' } },
    },
    -- shops = {
    --     { coords = vec3(836.0419, -811.7117, 26.35336), radius = 1.5, categories = { 'performance', 'others' } },
    --     { coords = vec3(836.329, -817.8915, 26.35213), radius = 1.5, categories = { 'performance', 'others' } },
    -- },
    garage = {
        {
            coords = vec4(911.56, -975.15, 38.50, 93.36),
            spawnCoords = vec4(922.68, -975.90, 39.50, 273.40),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}