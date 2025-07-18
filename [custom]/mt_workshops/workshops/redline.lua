Config.workshops = Config.workshops or {}

Config.workshops.redline = {
    enabled = true,
    label = "Redline Cars",
    job = '',
    blip = { enabled = false, coords = vec3(-842.2547, -251.3847, 38.8905), color = 6, scale = 0.5, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(-814.55, -277.75, 36.11),
            vec3(-834.81, -283.18, 37.55),
            vec3(-855.95, -248.06, 38.51),
            vec3(-833.58, -239.40, 36.15),
            
            

        },
        thickness = 50
    },
    -- stashes = {
    --     -- { coords = vec3(-6.717637, -1677.141, 29.49553), radius = 1.2, slots = 50, weight = 10000 },
    --     -- { coords = vec3(-0.8251004, -1670.002, 29.49552), radius = 1.2, slots = 50, weight = 10000 },
    --     -- { coords = vec3(-16.98604, -1657.297, 29.49139), radius = 1.2, slots = 50, weight = 10000 },
    --     -- { coords = vec3(-22.52789, -1663.753, 29.49553), radius = 1.2, slots = 50, weight = 10000 },
    -- },
    -- crafts = {
    --     -- { coords = vec3(-13.70201, -1657.202, 29.4955), radius = 3.5, categories = { 'performance', 'others' } },
    --     -- { coords = vec3(836.329, -817.8915, 26.35213), radius = 2.5, categories = { 'performance', 'others' } },
    -- },
    -- -- shops = {
    -- --     { coords = vec3(836.0419, -811.7117, 26.35336), radius = 1.5, categories = { 'performance', 'others' } },
    -- --     { coords = vec3(836.329, -817.8915, 26.35213), radius = 1.5, categories = { 'performance', 'others' } },
    -- -- },
    -- garage = {
    --     {
    --         -- coords = vector4(-16.16233, -1680.363, 28.49185, 194.9696),
    --         -- spawnCoords = vector4(-22.21903, -1677.699, 28.48087, 118.0935),
    --         -- vehicles = {
    --         --     { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
    --         --     { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
    --         -- },
    --     },
    -- },
}