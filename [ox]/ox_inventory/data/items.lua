return {

    ["bandage"] = {
        label = "Bandage",
        weight = 25,
        client = {
            anim = {
                dict = "anim@gangops@facility@servers@",
                clip = "hotwire",
                flag = 49,
            },
            prop = {
                model = "prop_rolled_sock_02",
                pos = vec3(0.05, 0.0, 0.05),
                rot = vec3(0.0, 90.0, 0.0),
            },
            disable = {
                move = false,
                car = false,
                combat = true,
            },
            usetime = 3500,
        },
    },

    ["medkit"] = {
        label = "Medicin Kit",
        weight = 100,
        client = {
            anim = {
                dict = "amb@medic@standing@tendtodead@idle_a",
                clip = "idle_a",
                flag = 1,
            },
            disable = {
                move = true,
                car = true,
                combat = true,
            },
            usetime = 10000,
        },
    },

    ["pantkvittering"] = {
        label = "Pant Kvittering",
        weight = 15,
        stack = false,
    },

    ["panta_flaske"] = {
        label = "Pant A Flaske",
        weight = 35,
        stack = true,
        description = "Kan returneres for pant",
    },

    ["pantb_flaske"] = {
        label = "Pant B Flaske",
        weight = 35,
        stack = true,
        description = "Kan returneres for pant",
    },

    ["pantc_flaske"] = {
        label = "Pant C Flaske",
        weight = 35,
        stack = true,
        description = "Kan returneres for pant",
    },
    ["flaske"] = {
        label = "Tom Flaske",
        weight = 35,
        stack = true,
        description = "Kan returneres for pant",
    },

    ["lockpick"] = {
        label = "Lockpick",
        weight = 160,
        decay = true,
    },

    ["hotwire"] = {
        label = "Cutter",
        weight = 160,
        server = {
            export = "mVehicle.hotwire",
        },
    },

    ["fakeplate"] = {
        label = "Falsk Nummerplade",
        consume = 0,
        server = {
            export = "mVehicle.fakeplate",
        },
    },

    ["black_money"] = {
        label = "Sorte Penge",
    },

    ["burger"] = {
        label = "Burger",
        weight = 20,
        client = {
            status = {
                hunger = 200000,
            },
            anim = "eating",
            prop = "burger",
            usetime = 2500,
            notification = "Du spiste en lækker burger",
        },
    },

    ["sprunk"] = {
        label = "Sprunk",
        weight = 80,
        client = {
            status = {
                thirst = 200000,
            },
            anim = {
                dict = "mp_player_intdrink",
                clip = "loop_bottle",
            },
            prop = {
                model = GetHashKey("prop_ld_can_01"),
                pos = vec3(0.01, 0.01, 0.06),
                rot = vec3(5.0, 5.0, -180.5),
            },
            usetime = 2500,
            notification = "Du slukkede din tørst med en sprunk",
        },
    },

    ["parachute"] = {
        label = "Faldskærm",
        weight = 1800,
        stack = false,
        client = {
            anim = {
                dict = "clothingshirt",
                clip = "try_shirt_positive_d",
            },
            usetime = 1500,
        },
    },

    ["garbage"] = {
        label = "Affald",
    },

    ["phone"] = {
        label = "Telefon",
        weight = 300,
        stack = false,
        consume = 0,
    },

    ["money"] = {
        label = "Kontanter",
    },

    ["bank"] = {
        label = "DKK",
    },

    ["auto"] = {
        label = "DKK",
        client = {
            image = "bank.png",
        },
    },

    ["autoall"] = {
        label = "DKK",
        client = {
            image = "bank.png",
        },
    },

    ["mustard"] = {
        label = "Sennep",
        weight = 200,
        client = {
            status = {
                hunger = 25000,
                thirst = 25000,
            },
            anim = {
                dict = "mp_player_intdrink",
                clip = "loop_bottle",
            },
            prop = {
                model = GetHashKey("prop_food_mustard"),
                pos = vec3(0.01, 0.0, -0.07),
                rot = vec3(1.0, 1.0, -1.5),
            },
            usetime = 2500,
            notification = "Du.. drak sennep",
        },
    },

    ["water"] = {
        label = "Vand",
        weight = 20,
        client = {
            status = {
                thirst = 200000,
            },
            anim = {
                dict = "mp_player_intdrink",
                clip = "loop_bottle",
            },
            prop = {
                model = GetHashKey("prop_ld_flow_bottle"),
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5),
            },
            usetime = 2500,
            cancel = true,
            notification = "Du drak noget forfriskende vand",
        },
    },

    ["radio"] = {
        label = "Radio",
        weight = 400,
        stack = false,
        allowArmed = true,
        client = {
            export = "mani-radio.ToggleRadio",
        },
    },

    -- ARMOR SYSTEM

    ["armor"] = {
        label = "Armor",
        description = "Plate Carrier",
        weight = 1000,
        stack = true,
        close = true,
        client = {
            export = "mani-armorsystem.equipPlateCarrier",
        },
        buttons = {
            {
                label = "Fjern Plates",
                action = function(slot)
                    exports["mani-armorsystem"]:removePlates(slot)
                end,
            },
        },
    },

    ["policearmor"] = {
        label = "Politi Armor",
        description = "Politi Plate Carrier",
        weight = 1000,
        stack = true,
        close = true,
        client = {
            export = "mani-armorsystem.equipPlateCarrier",
        },
        buttons = {
            {
                label = "Fjern Plates",
                action = function(slot)
                    exports["mani-armorsystem"]:removePlates(slot)
                end,
            },
        },
    },

    ["plate"] = {
        label = "Plate",
        weight = 70,
        stack = true,
        close = true,
        client = {
            export = "mani-armorsystem.equipPlate",
        },
    },

    -- STOFFER ETC...

    ["oxyboxes"] = {
        label = "Oxy Pakke",
        weight = 950,
        close = true,
        stack = false,
        description = "Stor kasse",
        client = {
            export = "elevate-oxyRun.oxycarry",
        },
    },

    ['policecone'] = {
		label = 'Politi Kegle',
		weight = 500,
        client = {
            export = "ND_Police.useItem",
            model = "prop_roadcone02a",
            freeze = false,
        },
	},
    ['policebarricade'] = {
		label = 'Politi Barrikade',
		weight = 500,
        client = {
            export = "ND_Police.useItem",
            model = "prop_barrier_work06a",
            freeze = true,
        },
	},
    ['policeroadsign'] = {
		label = 'Politi gade skilt',
		weight = 500,
        client = {
            export = "ND_Police.useItem",
            model = "prop_snow_sign_road_06g",
            freeze = false,
        },
	},
    ['policetent'] = {
		label = 'Politi Telt',
		weight = 500,
        client = {
            export = "ND_Police.useItem",
            model = "prop_gazebo_02",
            freeze = true,
        },
	},
    ['policespotlight'] = {
		label = 'Politi Spots',
		weight = 500,
        client = {
            export = "ND_Police.useItem",
            model = "prop_worklight_03b",
            freeze = true,
        },
	},

    ["oxy"] = {
        label = "Oxy Pille",
        weight = 2,
        stack = true,
        close = true,
        client = {
            export = "jungurum-smallresources.oxy",
        },
    },

    ["skunk"] = {
        label = "Skunk Blade",
        weight = 1,
        stack = true,
        close = true,
    },

    ["jointpapir"] = {
        label = "Joint Papir",
        weight = 1,
        stack = true,
        close = true,
    },

    ["joint"] = {
        label = "Joint",
        weight = 3,
        stack = true,
        close = true,
    },

    ["pakket_skunk"] = {
        label = "Pakket Skunk",
        weight = 50,
        stack = true,
        close = true,
    },

    ["opium"] = {
        label = "Opium Blade",
        weight = 1,
        stack = true,
        close = true,
    },

    ["kanyle"] = {
        label = "Kanyle",
        weight = 1,
        stack = true,
        close = true,
    },

    ["kanyleindhold"] = {
        label = "Kanyle med indhold",
        weight = 2,
        stack = true,
        close = true,
    },

    ["pakket_heroin"] = {
        label = "Pakket Heroin",
        weight = 50,
        stack = true,
        close = true,
    },

    ["kokain"] = {
        label = "Kokain Blade",
        weight = 1,
        stack = true,
        close = true,
    },

    ["pose"] = {
        label = "Pose",
        weight = 1,
        stack = true,
        close = true,
    },

    ["posekokain"] = {
        label = "Pose med kokain",
        weight = 2,
        stack = true,
        close = true,
    },

    ["pakket_kokain"] = {
        label = "Pakket Kokain",
        weight = 50,
        stack = true,
        close = true,
    },

    ["meth"] = {
        label = "Meth",
        weight = 1,
        stack = true,
        close = true,
    },

    ["posemeth"] = {
        label = "Pose med meth",
        weight = 2,
        stack = true,
        close = true,
    },

    ["pakket_meth"] = {
        label = "Pakket Meth",
        weight = 50,
        stack = true,
        close = true,
    },

    -- BANKTRUCK

    ["landmine"] = {
        label = "Landmine",
        weight = 250,
        stack = false,
        close = true,
        description = "En eksposiv landmine, brugbar til banktrucks",
    },

    ["police_stormram_lille"] = {
        label = "Lille Rambuk",
        weight = 1000,
        stack = false,
        close = true,
        durability = 100,
        description = "Rambuk til politi bruges til at åbne døre",
        client = {
            export = "elevate-politi.useRambuk",
        },
    },

    ["police_stormram"] = {
        label = "Stor Rambuk",
        weight = 1000,
        stack = false,
        close = true,
        description = "Rambuk til politi bruges til at ransage huse",
    },

    ["drivingplan"] = {
        label = "Banktruck Køreplan",
        weight = 50,
        stack = false,
        close = true,
        description = "Køreplan for banktruck",
        client = {
            export = "mani-banktruck.UseDocument",
        },
    },

    ["hackingdevice"] = {
        label = "Hacking Device",
        weight = 750,
        stack = false,
        close = false,
        description = "Hacking værktøj til at katte sig igennem en mainframe",
    },

    ["medicalbag"] = {
        label = "Medicin Taske",
        weight = 220,
        stack = true,
        description = "Et omfattende medicinkit til behandling af skader og sygdomme.",
    },

    -- HOSPITAL

    ["defibrillator"] = {
        label = "Defibrillator",
        weight = 1000,
        stack = true,
        description = "Bruges til at genoplive patienter.",
    },

    ["tweezers"] = {
        label = "Pincet",
        weight = 100,
        stack = true,
        description = "Præcisionspincet til sikkert at fjerne fremmedlegemer, såsom kugler, fra sår.",
    },

    ["burncream"] = {
        label = "Brandsalve",
        weight = 100,
        stack = true,
        description = "Specialiseret creme til behandling og lindring af mindre forbrændinger og hudirritationer.",
    },

    ["suturekit"] = {
        label = "Sy Kit",
        weight = 100,
        stack = true,
        description = "Et kit indeholdende kirurgiske værktøjer og materialer til at sy og lukke sår.",
    },

    ["icepack"] = {
        label = "Ispose",
        weight = 200,
        stack = true,
        description = "En ispose der bruges til at reducere hævelse og give lindring fra smerte og betændelse.",
    },

    ["stretcher"] = {
        label = "Båre",
        weight = 5000,
        stack = true,
        description = "En båre der bruges til at flytte patienter der kræver medicinsk pleje.",
    },

    ["emstablet"] = {
        label = "EMS Tablet",
        weight = 200,
        stack = true,
    },

    -- Mekaniker System

    ["engine_s"] = {
        label = "Motor S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_a"] = {
        label = "Motor A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_b"] = {
        label = "Motor B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_c"] = {
        label = "Motor C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["engine_d"] = {
        label = "Motor D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_s"] = {
        label = "Gearkasse S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_a"] = {
        label = "Gearkasse A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_b"] = {
        label = "Gearkasse B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_c"] = {
        label = "Gearkasse C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["transmission_d"] = {
        label = "Gearkasse D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_s"] = {
        label = "Affjedring S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_a"] = {
        label = "Affjedring A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_b"] = {
        label = "Affjedring B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_c"] = {
        label = "Affjedring C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["suspension_d"] = {
        label = "Affjedring D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_s"] = {
        label = "Bremse S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_a"] = {
        label = "Bremse A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_b"] = {
        label = "Bremse B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_c"] = {
        label = "Bremse C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["brake_d"] = {
        label = "Bremse D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_s"] = {
        label = "Turbo S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_a"] = {
        label = "Turbo A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_b"] = {
        label = "Turbo B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_c"] = {
        label = "Turbo C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["turbo_d"] = {
        label = "Turbo D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_s"] = {
        label = "Panser S",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_a"] = {
        label = "Panser A",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_b"] = {
        label = "Panser B",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_c"] = {
        label = "Panser C",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["armour_d"] = {
        label = "Panser D",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["repairkit"] = {
        label = "Reparations Kit",
        weight = 450,
        stack = true,
        close = true,
        description = "",
    },
    ["cosmetics"] = {
        label = "Kosmetik",
        weight = 100,
        stack = true,
        close = true,
        description = "",
    },
    ["mechanic_toolbox"] = {
        label = "Mekaniker Værktøjskasse",
        weight = 450,
        stack = true,
        close = true,
        description = "",
        client = {
            export = "mt_workshops.openToolboxMenu",
        },
    },
    ["neons_controller"] = {
        label = "Neon Controller",
        weight = 450,
        stack = true,
        close = true,
        description = "",
        client = {
            export = "mt_workshops.openLightsController",
        },
    },
    ["mods_list"] = {
        label = "Køretøjs Mods Liste",
        weight = 0,
        stack = true,
        close = true,
        description = "",
        client = {
            export = "mt_workshops.openCosmeticsMenu",
        },
    },
    ["extras_controller"] = {
        label = "Køretøjs Ekstra",
        weight = 0,
        stack = true,
        close = true,
        description = "",
        client = {
            export = "mt_workshops.openExtrasMenu",
        },
    },
    ["materials"] = {
        label = "Materials",
        weight = 10,
        stack = true,
        close = true,
        description = "Materials til at lave dele",
    },
    ["id"] = {
        label = "ID Kort",
        weight = 0,
        stack = false,
        close = true,
        description = "",
        client = {
            export = "jsfour-idcard.useIdCard",
        },
    },
    ["camera"] = {
        label = "Kamera",
        weight = 500,
        stack = false,
        consume = 0,
        close = true,
        description = "Et kamera",
        client = {
            export = "ps-camera.UseCam",
        },
    },
    ["photo"] = {
        label = "Fotografi",
        weight = 100,
        stack = false,
        close = true,
        description = "",
        client = {
            export = "ps-camera.usePhoto",
        },
    },
    ["spikestrip"] = {
        label = "Spikestrip",
        weight = 200,
        client = {
            export = "ND_Police.deploySpikestrip",
        },
    },
    ["cuffs"] = {
        label = "Håndjern",
        weight = 50,
        client = {
            export = "ND_Police.cuff",
        },
    },
    ["zipties"] = {
        label = "Strips",
        weight = 10,
        client = {
            export = "ND_Police.ziptie",
        },
    },
    ["tools"] = {
        label = "Værktøj",
        description = "En skævbidder og en skruetang.",
        weight = 800,
        consume = 1,
        stack = true,
        close = true,
        client = {
            event = "ND_Police:unziptie",
        },
    },
    ["handcuffkey"] = {
        label = "Håndjerns Nøgle",
        weight = 10,
        client = {
            export = "ND_Police.uncuff",
        },
    },
    ["casing"] = {
        label = "Patron Hylster",
    },
    ["casing2"] = {
        label = "Patron Hylster",
    },
    ["projectile"] = {
        label = "Projektil",
    },
    ["projectile2"] = {
        label = "Projektil",
    },
    ["rope"] = {
        label = "Reb",
        weight = 50,
        client = {
            export = "iconic_rope.rope",
        },
    },
    ["office_key"] = {
        label = "Nøgle",
        weight = 0,
        decay = true,
        degrade = 30,
    },
    ["laptop"] = {
        label = "Laptop",
        weight = 1,
        stack = false,
        close = true,
        description = "",
    },
    ["decrypter"] = {
        label = "Decrypter",
        weight = 1,
        stack = true,
        close = true,
        description = "",
    },
    ["black_usb"] = {
        label = "Sort USB",
        weight = 1,
        stack = true,
        close = true,
        description = "",
    },
    ["pendrive"] = {
        label = "USB Nøgle",
        weight = 1,
        stack = false,
        close = false,
        description = "Kan gemme personlige data",
    },
    ["gopro"] = {
        label = "Action Cam",
        weight = 1,
        stack = true,
        close = true,
        description = "A camera",
    },
    ["cam_jammer"] = {
        label = "Kamera Jammer",
        weight = 1,
        stack = true,
        close = true,
        description = "Kamera Jammer",
    },
    ["ingredients"] = {
        label = "Ingredienser Kasse",
        weight = 200,
        stack = true,
        close = true,
        description = "kasse fuld af madvare",
    },
    ["dongle"] = {
        label = "USB Dongle",
        weight = 1,
        stack = false,
        close = true,
        description = "",
    },
    ["vpn"] = {
        label = "VPN",
        weight = 1,
        stack = true,
        close = false,
        description = "",
    },
    ["transponder"] = {
        label = "Transponder",
        weight = 1,
        stack = true,
        close = true,
        description = "",
    },
    ["pecanpie"] = {
        label = "Pecan Pie",
        weight = 45,
        consume = false,
        stack = true,
        close = true,
        description = "Meget god kage",
    },
    ["scuba_set"] = {
        label = "Dykkerudstyr",
        weight = 250,
        description = "Dykkerudstyr",
        stack = false,
        client = {
            export = "mani-divingsystem.equipScuba",
        },
    },
    ["scuba_tank"] = {
        label = "Ilt Tank",
        weight = 500,
        stack = false,
        client = {
            export = "mani-divingsystem.refillOxygen",
        },
    },
    ["blue_keycard"] = {
        label = "Blå Nøglekort",
        weight = 100,
        stack = false,
    },
    ["purple_keycard"] = {
        label = "Lilla Nøglekort",
        weight = 100,
        stack = false,
    },
    ["hack_card"] = {
        label = "Spoofing Kort",
        weight = 100,
        stack = false,
    },
    ["coins"] = {
        label = "Mønter",
        weight = 10,
    },
    ["painting"] = {
        label = "Maleri",
        weight = 100,
    },
    ["bomb_c4"] = {
        label = "C4 Sprængstof",
        weight = 800,
    },
    ["angle_grinder"] = {
        label = "Vinkelsliber",
        weight = 1500,
    },
    ["contracts_tablet"] = {
        label = "Kontrakt Tablet",
        stack = false,
        weight = 400,
    },
    ["classified_docs"] = {
        label = "Hemmelige Dokumenter",
        weight = 10,
    },
    ["diamond_necklace"] = {
        label = "Diamant Halskæde",
        weight = 10,
    },
    ["diamantboks"] = {
        label = "Diamant Boks",
        weight = 40,
    },
    ["necklace"] = {
        label = "Halskæde",
        weight = 5,
    },
    ["diamonds_box"] = {
        label = "Diamant Kasse",
        weight = 200,
    },
    ["luxurious_watch"] = {
        label = "Luksuriøst Ur",
        weight = 20,
    },
    ["watch"] = {
        label = "Ur",
        weight = 10,
    },
    ["rare_coins"] = {
        label = "Sjældne Mønter",
        weight = 50,
    },
    ["diamond_ring"] = {
        label = "Diamant Ring",
        weight = 5,
    },
    ["ring"] = {
        label = "Ring",
        weight = 2,
    },
    ["skull_art"] = {
        label = "Kranium Kunst",
        weight = 20,
    },
    ["thermite"] = {
        label = "Thermite",
        weight = 35,
    },
    ["gold_bar"] = {
        label = "Guldbarre",
        weight = 50,
    },
    ["large_drill"] = {
        label = "Stor Bor",
        weight = 1250,
        stack = true,
        close = true,
    },
    ["casino_keycard"] = {
        label = "Casino Nøglekort",
        weight = 100,
        stack = false,
    },
    ["small_drill"] = {
        label = "Lille Bor",
        weight = 200,
        stack = true,
        close = true,
    },
    ["explosives"] = {
        label = "Sprængstof",
        weight = 300,
    },
    ["rullekebab"] = {
        label = "Rulle Kebab",
        weight = 45,
        consume = false,
        stack = true,
        close = true,
        description = "En rulle med kebab i",
    },
    ["kemibox"] = {
        label = "Kasse med Kemikalier",
        weight = 2000,
        stack = true,
        close = true,
        description = "En kasse med en masse kemikalier i.",
        client = {
            export = "elm_lab.kemibox",
        },
    },
    ["kemi"] = {
        label = "Kemikalier",
        weight = 40,
        stack = true,
        close = true,
        description = "Kemikalie.",
    },
    ["carradio"] = {
        label = "Bil radio",
        weight = 400,
        stack = false,
        close = true,
        description = "Bil Radio.",
        server = {
            export = "mVehicle.mradio",
        },
    },

    ["assaultrifle_case"] = {
        label = "AK47 Kasse",
        weight = 550,
        stack = true,
        close = true,
    },

    ["cermaicpistol_case"] = {
        label = "Ceramic Pistol Kasse",
        weight = 100,
        stack = true,
        close = true,
    },

    ["compactrifle_case"] = {
        label = "Kompakt Riffel Kasse",
        weight = 370,
        stack = true,
        close = true,
    },

    ["dbshotgun_case"] = {
        label = "DB-Shotgun Kasse",
        weight = 230,
        stack = true,
        close = true,
    },

    ["gusenberg_case"] = {
        label = "Gussenberg Kasse",
        weight = 600,
        stack = true,
        close = true,
    },

    ["machinepistol_case"] = {
        label = "TEC-9 Kasse",
        weight = 170,
        stack = true,
        close = true,
    },

    ["microsmg_case"] = {
        label = "Micro SMG Kasse",
        weight = 500,
        stack = true,
        close = true,
    },

    ["minismg_case"] = {
        label = "Mini SMG Kasse",
        weight = 370,
        stack = true,
        close = true,
    },

    ["navyrevolver_case"] = {
        label = "Navy Revolver Kasse",
        weight = 130,
        stack = true,
        close = true,
    },

    ["pistol50_case"] = {
        label = "Pistol 50 Kasse",
        weight = 200,
        stack = true,
        close = true,
    },

    ["snspistol_case"] = {
        label = "SNS Pistol Kasse",
        weight = 200,
        stack = true,
        close = true,
    },

    ["xm_case"] = {
        label = "XM3 Pistol Kasse",
        weight = 200,
        stack = true,
        close = true,
    },

    ["pistol_case"] = {
        label = "Pistol Kasse",
        weight = 130,
        stack = true,
        close = true,
    },

    ["pumpshotgun_case"] = {
        label = "Haglgevær Kasse",
        weight = 450,
        stack = true,
        close = true,
    },

    ["revolver_case"] = {
        label = "Revolver Kasse",
        weight = 200,
        stack = true,
        close = true,
    },

    ["vintagepistol_case"] = {
        label = "Vintage Pistol Kasse",
        weight = 100,
        stack = true,
        close = true,
    },
    ["vehicle_tyre"] = {
        label = "Vehicle Tyre",
        weight = 1,
        stack = true,
        close = false,
    },
    ["vehicle_door"] = {
        label = "Vehicle Door",
        weight = 1,
        stack = true,
        close = false,
    },
	['citronlemonade'] = {
		label = 'Citron Lemonade',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['kaffecafelatte'] = {
		label = 'Kaffe - Cafe Latte',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['lasagne'] = {
		label = 'Lasagne',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['vinhvid'] = {
		label = 'Vin - Hvid',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['kaffeespresso'] = {
		label = 'Kaffe - Espresso',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['sodavandcola'] = {
		label = 'Sodavand - Cola',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['kaffecappuccino'] = {
		label = 'Kaffe - Cappuccino',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['canoli'] = {
		label = 'Canoli.',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['whiskyontherocks'] = {
		label = 'Whisky on the rocks',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['tiramisumkaffe'] = {
		label = 'Tiramisu /m Kaffe',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['stracciatellais'] = {
		label = 'Stracciatella Is',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['vinrose'] = {
		label = 'Vin - Rose',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['vinrød'] = {
		label = 'Vin - Rød',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pizzavesuvio'] = {
		label = 'Pizza - Vesuvio',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pizzasalsiccia'] = {
		label = 'Pizza - Salsiccia',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pizzapollomkylling'] = {
		label = 'Pizza - Pollo /m Kylling',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pizzamargherita'] = {
		label = 'Pizza - Margherita',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pizzaquattroformaggi'] = {
		label = 'Pizza - Quattro Formaggi',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pastapolpette'] = {
		label = 'Pasta - Polpette',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['pastaalfredomkylling'] = {
		label = 'Pasta - Alfredo /m Kylling',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['spaghetticarbonára'] = {
		label = 'Spaghetti - Carbonára',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['spaghettibolognesemkødsovs'] = {
		label = 'Spaghetti - bolognese /m Kødsovs',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['sodavandoranotang'] = {
		label = 'Sodavand - Oran-O-Tang',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = ""
	},
	['miyakespecial6x'] = {
		label = 'MIYAKE SPECIAL 6X',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "MIYAKE SPECIAL, BESTÅENDE AF 6 SUSHI"
	},
	['miyakesingle'] = {
		label = 'MIYAKE SINGLE',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "MIYAKE SINGLE SUSHI, MMMM"
	},
	['caosushi'] = {
		label = 'CAO SUSHI',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "SINGLE SUSHI, TASYYY"
	},
	['caosushi13x'] = {
		label = 'CAO SUSHI 13x',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "BIG MENU, VERY TASTYYY"
	},
	['chowsushi'] = {
		label = 'CHOW SUSHI',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "CHOW SUSHI, 2 BIG PIECE"
	},
	['chowsushisingle'] = {
		label = 'CHOW SUSHI SINGLE',
		weight = 100,
		consume = false,
		stack = true,
		close = true,
		description = "CHOW SUSHI ONE PIECE, TASTY"
	},
    ["pickaxe"] = {
        label = "Pickaxe",
        weight = 100,
        stack = true,
        close = false,
    },
    ["hammer"] = {
        label = "Hammer",
        weight = 500,
        stack = true,
        close = false,
    },
    
    ["minerhelmet"] = {
        label = "Miner Hjelm",
        weight = 100,
        stack = true,
        close = false,
        client = {
            export = "bach_legalJobs.toggleMinerHelmet",
        },
    },
    
    ["gold"] = {
        label = "Guld",
        weight = 100,
        stack = true,
        close = false,
    },
    
    ["silver"] = {
        label = "Sølv",
        weight = 100,
        stack = true,
        close = false,
    },
    
    ["iron"] = {
        label = "Jern",
        weight = 100,
        stack = true,
        close = false,
    },
    
    ["copper"] = {
        label = "Kobber",
        weight = 100,
        stack = true,
        close = false,
    },
    
    ["fossil"] = {
        label = "Fossil",
        weight = 100,
        stack = true,
        close = false,
    },
    
    ["gemstone"] = {
        label = "Ædelsten",
        weight = 500,
        stack = true,
        close = false,
    },
    
    ["ancient_coin"] = {
        label = "Ældre Mønt",
        weight = 50,
        stack = true,
        close = false,
    },
    
    ["diamond"] = {
        label = "Diamant",
        weight = 500,
        stack = true,
        close = false,
    },
    
    ["stone"] = {
        label = "Sten",
        weight = 500,
        stack = true,
        close = false,
    },
    
    ["gravel"] = {
        label = "Grus",
        weight = 500,
        stack = true,
        close = false,
    },
    
    ["copper_ingot"] = {
        label = "Kobber Ingot",
        weight = 50,
        stack = true,
        close = false,
    },
    
    ["iron_ingot"] = {
        label = "Jern Ingot",
        weight = 50,
        stack = true,
        close = false,
    },
    
    ["silver_ingot"] = {
        label = "Sølv Ingot",
        weight = 50,
        stack = true,
        close = false,
    },
    
    ["gold_ingot"] = {
        label = "Guld Ingot",
        weight = 500,
        stack = true,
        close = false,
    },

    -- Fængsels Items

    ['detergent'] = {
        label = "Vaskemiddel",
        weight = 10,
        stack = true,
    },

    ['peas'] = {
        label = "Ærter",
        weight = 10,
        stack = true,
    },

    ['rice'] = {
        label = "Ris",
        weight = 10,
        stack = true,
    },

    ['fries'] = {
        label = "Pomfritter",
        weight = 10,
        stack = true,
    },

    ['soda'] = {
        label = "Sodavand",
        weight = 10,
        stack = true,
    },
	['chinesebeer'] = {
		label = 'CHINESE BEER',
		weight = 5000,
		consume = false,
		stack = true,
		close = true,
		description = "CHINESE HOMEBREW BEER"
	},
	['crispyroll'] = {
		label = 'CRISPY ROLL',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "CRISPY ROLL SINGLE SNACK"
	},
	['sashimisushi'] = {
		label = 'SASHIMI SUSHI',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "SASHIMI SUSHI 6X"
	},
	['sashimi2piece'] = {
		label = 'SASHIMI 2 PIECE',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "SASHIMI 2 PIECE, TASTYYY"
	},
	['chinesejackd'] = {
		label = 'CHINESE JACK D',
		weight = 5000,
		consume = false,
		stack = true,
		close = true,
		description = "JACK D SPECIAL EDITION"
	},
	['miyakespecialalcohol'] = {
		label = 'MIYAKE SPECIAL ALCOHOL',
		weight = 5000,
		consume = false,
		stack = true,
		close = true,
		description = "SPECIAL HOMEBREW"
	},
     -- evidence script
     ["collected_evidence_bag"] = {
		label = "Bevispose",
		weight = 20,
		stack = false,
		close = false,
		description = "En fyldt bevispose",
	},

	["evidence_camera"] = {
		label = "Evidens kamera",
		weight = 200,
		stack = false,
		close = true,
		description = "Kamera til at tage billeder af beviser",
		client = {
			image = "evidence_camera.png",
		},
		server = {
			export = "snipe-evidence.useCam"
		},
		consume = 0,
	},

	["evidence_pouch"] = {
		label = "Bevispose",
		weight = 20,
		stack = false,
		close = false,
		server = {
			export = 'snipe-evidence.usePouch'
		},
		client = {
			image = "evidence_pouch.png",
		},
		description = "Pose til at holde alle dine beviser",
		consume = 0,
		allowArmed = true,
	},

	["dna_swab_kit"] = {
		label = "DNA-podningssæt",
		weight = 20,
		stack = true,
		close = true,
		description = "Et sæt til at tage DNA-prøver",
		client = {
			image = "dna_swab_kit.png",
		},
		server = {
			export = "snipe-evidence.swabDNA"
		},
		consume = 0,
	},

	-- ["accesstool"] = {
	-- 	label = "Access Tool",
	-- 	weight = 200,
	-- 	stack = true,
	-- 	close = true,
	-- 	description = "Tool to get into locked cars",
	-- 	client = {
	-- 		image = "accesstool.png",
	-- 	},
	-- 	server = {
	-- 		export = "snipe-evidence.useAccessTool"
	-- 	},
	-- 	consume = 0,
	-- },

	["bleach"] = {
		label = "blegemiddel",
		weight = 20,
		stack = false,
		close = false,
		description = "Ryd alle blodpletter op med dette",
	},

	["evidence_tweezers"] = {
		label = "Pincet",
		weight = 20,
		stack = true,
		close = false,
		description = "Du kan samle småting op med denne",
	},
	['pommesfrites'] = {
		label = 'Pommes Frites',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Lækre fritter"
	},
	['hosabusha'] = {
		label = 'Hos Abu Sha',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "east or west, sha is best"
	},
	['sucukmankish'] = {
		label = 'Sucuk Mankish',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "bare spis ik tænk"
	},
	['gazoz'] = {
		label = 'Gazoz',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "bedste drik når du er basket"
	},
	['fantalemonbref'] = {
		label = 'Fanta Lemon Bref',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Bare drik den "
	},
	['fantalemon'] = {
		label = 'Fanta Lemon',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "bare drik"
	},
	['shaburger'] = {
		label = 'Sha Burger',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Det er det nyeste af det nyeste"
	},
	['hosabuburger'] = {
		label = 'Hos Abu Burger',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Det er det nyeste af det nyeste"
	},
	['ayran'] = {
		label = 'Ayran',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Abu Special"
	},

    ["boombox"] = {
        label = "Boombox",
        description = "Musik Shizzle",
        weight = 750,
        stack = true,
        close = true,
        client = {
            export = "mani-music.useBoombox",
        },
    },
    ["nitro"] = {
        label = "Nitro",
        description = "Nitro",
        weight = 750,
        stack = false,
        close = true,
        client = {
            export = "elevate-nitro.installNitro",
        },
    },
    ["weaponmat"] = {
        label = "Våben Materialer",
        weight = 750,
        stack = true,
        decay = true,
        degrade = 60,
    },
	['kamera'] = {
		label = 'Kamera',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Til overvågning"
	},
	['thehookmenu'] = {
		label = 'The Hook Menu',
		weight = 1000,
		consume = false,
		stack = true,
		close = true,
		description = "Det normale på Hookies"
	},
    ["crypto_usb"] = {
        label = "Crypto USB",
        weight = 20,
        stack = true,
        decay = true,
        degrade = 60,
    },
}