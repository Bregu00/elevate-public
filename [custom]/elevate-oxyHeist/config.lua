Config = {}


Config.Seconds = function(seconds) return seconds * 1000 end
Config.Minutes = function(minutes) return minutes * 60 * 1000 end
Config.Hours = function(hours) return hours * 3600 * 1000 end
Config.Days = function(days) return days * 86400 * 1000 end

Config.StartPed = {
    model = "s_m_y_dealer_01",
    coords = vec4(-683.13, -172.91, 37.82, 302.65)
}

Config.OxyPrice = 3300

Config.Locations = {
    {
        boatCoords = {
            coords = vector4(-3539.3093, 736.8974, 15.8665, 0.5069),
        },
        oxySellerCoords = {
            coords = vector4(-3592.822, 738.4533, 8.574024, 269.3558),
        },
        guardCoords = {
            vector3(-3554.6919, 738.9691, 12.7863),
            vector3(-3495.1069, 738.6212, 5.8863),
            vector3(-3502.8264, 732.1125, 5.8873),
            vector3(-3522.7917, 734.9862, 11.9112),
            vector3(-3522.8306, 741.9991, 11.9111),
            vector3(-3545.3608, 744.1709, 12.7829),
            vector3(-3543.6091, 732.6163, 12.7820),
        },
    },
    {
        boatCoords = {
            coords = vector4(-2100.268, -1013.12, 8.981636, 253.7053),
        },
        oxySellerCoords = {
            coords = vector4(-2125.154, -1004.997, 8.724727, 251.7851),
        },
        guardCoords = {
            vector3(-2033.505, -1040.834, 5.882259),
            vector3(-2037.695, -1026.719, 5.882009),
            vector3(-2061.893, -1018.777, 5.882012),
            vector3(-2077.743, -1013.581, 5.882016),
            vector3(-2081.861, -1026.143, 5.883252),
            vector3(-2056.329, -1034.318, 5.882955),
            vector3(-2062.835, -1032.218, 8.971493),
            vector3(-2046.469, -1023.988, 8.97148),
            vector3(-2111.814, -1011.886, 8.969069),
            vector3(-2110.252, -1007.256, 8.968911)
        },
    },
    {
        boatCoords = {
            coords = vector4(50.62843, -3294.406, 11.91874, 166.8404),
        },
        oxySellerCoords = {
            coords = vector4(50.57172, -3349.349, 8.574089, 12.96535),
        },
        guardCoords = {
            vector3(50.69168, -3255.139, 5.886028),
            vector3(57.67631, -3257.232, 5.88739),
            vector3(43.5278, -3257.219, 5.885741),
            vector3(47.03949, -3257.225, 8.975115),
            vector3(54.59038, -3257.777, 8.975098),
            vector3(57.06079, -3270.567, 8.975098),
            vector3(51.01577, -3260.914, 11.91176),
            vector3(46.0013, -3265.708, 11.91135)
        },
    }
    -- [1] = {
    --     boatCoords = {
    --         coords = vec4(-1662.20, -902.90, 7.49, 318.36),
    --     },
    --     oxySellerCoords = {
    --         coords = vec4(-1681.95, -926.10, 6.73, 318.62),
    --     },
    --     guardCoords = {
    --         vec3(-1677.44, -914.36, 7.09),
    --         vec3(-1673.47, -907.53, 7.30),
    --         vec3(-1661.38, -920.20, 7.26),
    --         vec3(-1655.05, -913.70, 7.43),
    --         vec3(-1645.47, -909.55, 7.60),
    --         vec3(-1662.30, -894.18, 7.61),
    --         vec3(-1645.18, -886.06, 7.92),
    --     },
    -- },
}

Config.GuardPeds = {
    GetHashKey("g_m_y_lost_01"),
    GetHashKey("g_m_y_lost_02"),
    GetHashKey("g_m_y_lost_03")
}