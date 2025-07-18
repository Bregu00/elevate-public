return {
    ["shopLocation"] = {
        name = "Miner Butik",
        blip = {
            id = 59,
            colour = 69,
            scale = 0.5,
        },
        inventory = {
            {
                name = "hammer",
                price = 1000,
                currency = "autoall",
            },
            {
                name = "pickaxe",
                price = 10000,
                currency = "autoall",
            },
            {
                name = "minerhelmet",
                price = 0,
                currency = "autoall",
            },
        },
        locations = {
            vec4(2835.0977, 2806.9419, 56.4008, 85.5901),
        },
        targets = {
            {
                ped = GetHashKey("S_M_M_AutoShop_02"),
                scenario = "WORLD_HUMAN_AA_SMOKE",
                loc = vec3(2835.0977, 2806.9419, 56.4008),
                heading = 85.5901,
            },
        },

    },

    ["startLocation"] = {
        name = "Mineinformation",
        blip = {
            id = 618,
            colour = 46,
            scale = 0.5,
            label = "Mine Information",
        },
        ped = {
            model = "S_M_Y_Construct_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            loc = vec4(2953.8618, 2741.7737, 42.7651, 256.0453),
        },
    },

    ["mineLocations"] = {
        {
            allowOnlyWhenWearingHelmet = true,
            coords = vector3(2952.5300, 2789.1101, 41.3800),
            label = "Mine Sted 1",
            blip = {
                sprite = 618,
                color = 5,
                scale = 0.5,
                label = "Mine Lokation",
            },
            ["locations"] = {
                {
                    coords = vector4(2989.3503, 2808.4504, 44.8515, 279.6433),
                    type = "wall",
                },
                {
                    coords = vector4(2998.6594, 2758.6084, 42.9793, 238.7581),
                    type = "ground",
                },
                {
                    coords = vector4(2954.8376, 2786.2971, 41.3846, 53.9299),
                    type = "ground",
                },
                {
                    coords = vector4(2939.0583, 2778.4841, 39.3347, 105.6816),
                    type = "ground",
                },
                {
                    coords = vector4(2925.3821, 2804.1047, 42.1646, 31.6234),
                    type = "ground",
                },
                {
                    coords = vector4(2946.3467, 2850.6389, 48.5844, 12.6377),
                    type = "wall",
                },
                {
                    coords = vector4(2972.2246, 2841.3135, 46.0487, 280.5458),
                    type = "wall",
                },
            },
        },
    },

    ["minerHelmet"] = {
        prop = 145,
        texture = 2,
    },

    ["miningRewards"] = {
        ["normalRewards"] = {
            {
                item = "stone",
                min = 1,
                max = 3,
                label = "Du fandt nogle sten.",
            },
            {
                item = "copper",
                min = 1,
                max = 2,
                label = "Du fandt noget kobber!",
            },
            {
                item = "iron",
                min = 1,
                max = 2,
                label = "Du fandt noget jern!",
            },
        },
        ["rareRewards"] = {
            {
                item = "gold",
                min = 1,
                max = 2,
                label = "Jackpot! Du fandt guld!",
            },
            {
                item = "silver",
                min = 1,
                max = 3,
                label = "Jackpot! Du fandt sølv!",
            },
            {
                item = "diamond",
                min = 1,
                max = 1,
                label = "Jackpot! Du fandt en diamant!",
            },
        },
        ["bonusItems"] = {
            {
                item = "gold",
                amount = 1,
                label = "Du fandt en åre med ekstra guld!",
            },
            {
                item = "silver",
                amount = 2,
                label = "Du fandt en åre med ekstra sølv!",
            },
            {
                item = "iron",
                amount = 3,
                label = "Du fandt en åre med ekstra jern!",
            },
            {
                item = "copper",
                amount = 3,
                label = "Du fandt en åre med ekstra kobber!",
            },
        },
        ["surpriseItems"] = {
            {
                item = "fossil",
                amount = 1,
                label = "Du fandt et sjældent fossil!",
            },
            {
                item = "gemstone",
                amount = 1,
                label = "Du fandt en upoleret ædelsten!",
            },
            {
                item = "ancient_coin",
                amount = 1,
                label = "Du fandt en antik mønt!",
            },
        },
    },

    ["defaultSmeltTime"] = 15000,

    ["smeltLocations"] = {
        {
            name = "Mine Smelteri",
            coords = vector3(1105.0079, -2016.4886, 30.9059),
            blip = {
                id = 618,
                colour = 1,
                scale = 0.5,
                label = "Mine Smelteri",
            },
            props = {
                {
                    model = "prop_bbq_5",
                    coords = vector4(1105.0079, -2016.4886, 29.9059, 250.5106),
                    isInteraction = true,
                },
            },
        },
    },

    ["smeltRecipes"] = {
        {
            label = "Knuse Sten",
            icon = "fas fa-hammer",
            time = 10000,
            requiresSkillCheck = false,
            input = {
                item = "stone",
                amount = 4,
                label = "Sten",
            },
            output = {
                item = "gravel",
                amount = 2,
                label = "Grus",
            },
        },

        {
            label = "Smelt Kobber",
            icon = "fas fa-fire",
            time = 12000,
            requiresSkillCheck = true,
            input = {
                item = "copper",
                amount = 3,
                label = "Kobber",
            },
            output = {
                item = "copper_ingot",
                amount = 1,
                label = "Kobberbarrer",
            },
        },

        {
            label = "Smelt Jern",
            icon = "fas fa-fire",
            time = 15000,
            requiresSkillCheck = true,
            input = {
                item = "iron",
                amount = 3,
                label = "Jern",
            },
            output = {
                item = "iron_ingot",
                amount = 1,
                label = "Jernbarrer",
            },
        },

        {
            label = "Smelt Sølv",
            icon = "fas fa-fire-alt",
            time = 18000,
            requiresSkillCheck = true,
            input = {
                item = "silver",
                amount = 2,
                label = "Sølv",
            },
            output = {
                item = "silver_ingot",
                amount = 1,
                label = "Sølvbarrer",
            },
        },

        {
            label = "Smelt Guld",
            icon = "fas fa-fire-alt",
            time = 20000,
            requiresSkillCheck = true,
            input = {
                item = "gold",
                amount = 2,
                label = "Guld",
            },
            output = {
                item = "gold_ingot",
                amount = 1,
                label = "Guldbarrer",
            },
        },
    },

    ["sellLocations"] = {
        ["Materialehandler"] = {
            coords = vector4(1185.1351, -3109.1414, 6.0280, 4.8266),
            blip = {
                enable = true,
                sprite = 365,
                color = 46,
                scale = 0.5,
            },
            pedModel = "S_M_M_DockWork_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
            premium = false,
        },
        ["Juveler"] = {
            coords = vector4(-645.3272, -226.3284, 37.7348, 174.3242),
            blip = {
                enable = true,
                sprite = 617,
                color = 46,
                scale = 0.5,
            },
            pedModel = "s_m_y_shop_high",
            scenario = "WORLD_HUMAN_STAND_IMPATIENT",
            premium = true,
        },
    },

    ["sellPrices"] = {
        ["gravel"] = 25,
        ["diamond"] = 500,
        ["fossil"] = 100,
        ["gemstone"] = 150,
        ["ancient_coin"] = 200,
        ["copper_ingot"] = 45,
        ["iron_ingot"] = 60,
        ["silver_ingot"] = 105,
        ["gold_ingot"] = 150,
    },

    ["premiumMultiplier"] = {
        ["silver"] = 1.2,
        ["gold"] = 1.5,
        ["diamond"] = 2.0,
        ["silver_ingot"] = 1.5,
        ["gold_ingot"] = 2.0,
        ["fossil"] = 1.8,
        ["gemstone"] = 2.0,
        ["ancient_coin"] = 2.2,
    },

}
