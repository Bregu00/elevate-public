Config = Config or {}

Config.garageTypes = {
    ['default'] = {
        ['Benefactor'] = {
            {model = "str", label = "Benefactor Schneider STR", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "strcoupe", label = "Benefactor STR Coupe", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "xlsstr", label = "Benefactor XLS STR", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Obey'] = {
            {model = "srspback", label = "Obey Tailgater SR Hatch", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "sr8", label = "Obey Kernig SR8", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "tailgatersr", label = "Obey Tailgater SR", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Ubermacht'] = {
            {model = "rhinesed", label = "Ubermacht Rhinehart Sedan", minGrade = 0, spoiler = 1, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "fx3r", label = "Ubermacht FX3R", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "f340r", label = "Ubermacht F340R", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "f140r", label = "Ubermacht F140R", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['BF'] = {
            {model = "cazador", label = "BF Cazador", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
        ['Auktion'] = {
            {model = "gbtr3s", label = "Progen TR3-S", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "thrax", label = "Truffade Thrax", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "vacca", label = "Pegassi Vacca", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
            {model = "gbprospero", label = "Pegassi Prospero", minGrade = 0, spoiler = 0, extras = {["1"] = true, ["2"] = false, ["3"] = false, ["4"] = false, ["5"] = false, ["6"] = false, ["7"] = false, ["8"] = false, ["9"] = false}},
        },
    },
}
Config.redlineGarage = {
    ["redline"] = {
        ["garageType"] = 'default',
        ["parkingSpots"] = {
            vec4(-838.99, -265.65, 37.89, 39.30),
            vec4(-836.06, -261.41, 37.89, 313.56),
            vec4(-833.76, -256.33, 37.89, 36.43),
            vec4(-838.80, -250.80, 37.89, 116.13)
        },
        ["parkVehicleZone"] = {
            vec4(-848.81, -250.55, 37.89, 214.00),
            vec4(-846.96, -257.62, 37.89, 10.00),
            vec4(-832.69, -251.58, 37.89, 291.59),
            vec4(-835.42, -243.13, 37.89, 19.12)
        },
        ["label"] = "Redline Cars Udstilling",
        ["jobs"] = {["redline"] = 0},
    },
}
