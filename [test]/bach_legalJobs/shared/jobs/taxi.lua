return {
    ["depots"] = {
        {
            name = "airport",
            coords = vector4(-1036.24, -2733.69, 20.17, 328.05),
            vehicleSpawn = vector4(-1033.5278, -2729.4333, 19.7159, 238.3653),
            blip = {
                sprite = 198,
                color = 5,
                scale = 0.5,
                label = "Taxacentral - Lufthavn",
            },
            pedModel = "a_m_y_business_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
        },
        {
            coords = vector4(903.9504, -171.3133, 74.0870, 247.9675),
            vehicleSpawn = vector4(908.7039, -176.0133, 74.1814, 236.8329),
            blip = {
                sprite = 198,
                color = 5,
                scale = 0.5,
                label = "Taxacentral",
            },
            pedModel = "a_m_y_business_01",
            scenario = "WORLD_HUMAN_CLIPBOARD",
        },
    },

    ["vehicles"] = {
        {
            model = "taxi",
            label = "Taxi",
            deposit = 2000,
            description = "Standard taxakøretøj",
        },
    },

    ["fares"] = {
        baseFare = 40,
        perMeter = 0.015,
        perSecondWaiting = 0.10,
        tipChance = 40,
        tipAmount = {
            20,
            50,
            100,
            200,
        },
    },

    ["passengers"] = {
        spawnDistance = 100,
        minDistance = 1000,
        maxDistance = 4000,
        scenarios = {
            "WORLD_HUMAN_STAND_MOBILE",
            "WORLD_HUMAN_STAND_IMPATIENT",
            "WORLD_HUMAN_SMOKING",
        },
        destinationTypes = {
            "residential",
            "commercial",
            "tourist",
        },
    },

    ["customers"] = {
        maxWaitTime = 180,
        cancelChance = 15,
        pickupRadius = 25.0,
        dropoffRadius = 50.0,
    },

    ["meterToggleKey"] = "F6",

    ["pedModels"] = {
        "A_M_M_AfriAmer_01",
        "A_F_M_SouCent_02",
        "A_M_M_Beach_01",
        "A_M_M_Beach_02",
        "A_M_M_BevHills_01",
        "A_M_M_BevHills_02",
        "A_M_M_Business_01",
        "A_M_M_EastSA_01",
        "A_M_M_GenFat_01",
        "A_F_M_Beach_01",
        "A_F_M_BevHills_01",
        "A_F_M_BevHills_02",
        "A_F_M_Business_02",
        "A_F_M_Downtown_01",
        "A_F_M_EastSA_01",
        "A_F_M_EastSA_02",
        "A_F_M_FatBla_01",
        "A_F_M_FatWhite_01",
        "A_F_M_SouCent_01",
        "A_F_M_TrampBeac_01",
        "A_F_O_Salton_01",
    },
}

