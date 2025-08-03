Config.debug = false

Config.Companies = {
    ["otto"] = {
        zone = {
            coords = vec4(956.85, -979.48, 38.50, 182.90),
            size = vector3(5, 8, 2),
            name = 'ottoaudiotuner',
            label = 'Ottos Audio Tuning',
            job = {["otto"] = true}
        },
    },
    ["6str"] = {
        zone = {
            coords = vec4(125.26, -3047.36, 6.52, 270.15),
            size = vector3(5, 8, 2),
            name = '6straudiotuner',
            label = '6STR Audio Tuning',
            job = {["6str"] = true}
        },
    },
    ["larrys"] = {
        zone = {
            coords = vec4(1250.91, 2708.23, 37.01, 268.02),
            size = vector3(5, 8, 2),
            name = 'larrysaudiotuner',
            label = 'Larrys Audio Tuning',
            job = {["larrys"] = true}
        },
    }
}

Config.engineCategories = {
    {
        categoryName = "Supercar",
        engineTypes = {
            {name = "zentorno", label = "Zentorno Engine"},
            {name = "t20", label = "T20 Engine"},
            {name = 'ferrarif140fe', label = 'Ferrari F140FE Engine'},
            {name = 'c6v8sound', label = 'Corvette C6 Engine'},
            {name = 'diablov12', label = 'Lamborghini Diablo GT Engine'},
            {name = 'sestov10', label = 'Lamborghini Sesto Engine'},
            {name = 'urusv8', label = 'Lamborghini Urus Engine'},
            {name = 'perfov10', label = 'Lamborghini Huracan Engine'},
            {name = 'viperv10', label = 'Dodge Viper Engine'},
            {name = 'gtaspanov10', label = 'GTA Spano Engine'},
            {name = 'mclarenv8', label = 'McLaren 720s Engine'},
            {name = 'm840trsenna', label = 'McLaren Senna Engine'},
        }
    },
    {
        categoryName = "JDM",
        engineTypes = {
            {name = 'elegy2', label = 'ElegyRH8 Engine'},
            {name = 'legacycl01kcmsubwrx', label = 'Impreza Engine'},
            {name = 'ta013vq35', label = '350Z Engine'},
            {name = 'aq2jzgterace', label = 'Supra 2JZ Engine'},
            {name = 'aq31maz13btune', label = 'Mazda RX-7 Engine'},
            {name = 'rb26dett', label = 'R32 Engine'},
            {name = 'bnr34ffeng', label = 'R34 Engine'},
            {name = 'r35sound', label = 'R35 Engine'},
            {name = 'aq57mit4g63t', label = 'Lancer EVO Engine'},
            {name = 'ta4b11', label = 'Lancer EVO 10 Engine'},
        }
    },
    {
        categoryName = "Sport",
        engineTypes = {
            {name = 'banshee', label = 'Banshee Engine'},
            {name = 'penumbra', label = 'Penumbra Engine'},
            {name = 'taaud40v8', label = 'Audi Engine #1'},
            {name = 'audiwx', label = 'Audi Engine #2'},
            {name = 'audi7a', label = 'Audi Engine #3'},
            {name = 'audiea855', label = 'Audi Engine #4'},
            {name = 'n55b30t0', label = 'BMW M2 Engine'},
            {name = 's55b30', label = 'BMW M3 Engine'},
            {name = 'tagt3flat6', label = 'Porsche 911 Engine'},
        }
    },
    {
        categoryName = "Muscle",
        engineTypes = {
            {name = "buffalo", label = "Buffalo Engine"},
            {name = 'aqls7raceswap', label = 'V8 Engine'},
            {name = 'tamustanggt50', label = 'Mustang Engine #1'},
            {name = 'tascmustanggt50', label = 'Mustang Engine #2'},
        }
    },
    {
        categoryName = "Motorcycles",
        engineTypes = {
            {name = 'suzukigsxr1k', label = 'Suzuki GSX-R 1000 Engine'},
            {name = 'kc12r1200gsakrapovic', label = 'BMW R1200GS Engine'},
            {name = 'kc144kawazx10rsc', label = 'Kawasaki Ninja ZX-10R Engine'},
            {name = 'ta103ninjah2r', label = 'Kawasaki Ninja H2R Engine'},
        }
    }
}
