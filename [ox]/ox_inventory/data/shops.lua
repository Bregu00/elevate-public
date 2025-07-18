return {
	General = {
		name = 'Butik',
		blip = {
			id = 59, colour = 69, scale = 0.5
		}, inventory = {
			{ name = 'burger', price = 10, currency = "auto" },
			{ name = 'water', price = 10, currency = "auto" },
			-- { name = 'cola', price = 10, currency = "auto" },
			{ name = 'zipties', price = 25, currency = "auto" },
			{ name = 'pose', price = 6, currency = "auto" },
			{ name = 'jointpapir', price = 6, currency = "auto" },
			{ name = 'kanyle', price = 6, currency = "auto" },
			{ name = 'bandage', price = 3500, currency = "auto" },
			{ name = 'ingredients', price = 250, currency = "auto" }
		},
		locations = {
            vec3(-705.98, -914.59, 19.22),
        },
        targets = {
            { -- Little Soul
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-705.98, -914.59, 18.22),
				heading = 90.37,
				distance = 3,
            },
            { -- Innocence
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(24.90, -1346.99, 28.50),
				heading = 268.84,
				distance = 3,
            },
			{ -- Grove Street
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-47.40, -1758.68, 28.42),
				heading = 49.18,
				distance = 3,
			},
			{ -- San Andreas Ave.
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-1221.44, -907.92, 11.33),
				heading = 36.18,
				distance = 3,
			},
			{ -- Prosperity Street
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-1486.71, -377.59, 39.16),
				heading = 135.21,
				distance = 3,
			},
			{ -- El Rancho Blvd.
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1134.31, -983.11, 45.42),
				heading = 276.34,
				distance = 3,
			},
			{ -- Mirror Park
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1164.86, -323.74, 68.21),
				heading = 97.38,
				distance = 3,
			},
			{ -- Vinewood
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(373.12, 326.90, 102.57),
				heading = 255.35,
				distance = 3,
			},
			{ -- Palamino Fwy.
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(2556.77, 381.24, 107.62),
				heading = 358.20,
				distance = 3,
			},
			{ -- Great Ocean 1
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-2966.38, 391.60, 14.04),
				heading = 84.74,
				distance = 3,
			},
			{ -- Great Ocean 2
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-3039.62, 584.74, 6.91),
				heading = 17.51,
				distance = 3,
			},
			{ -- Great Ocean 3
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(-3242.75, 1000.42, 11.83),
				heading = 353.20,
				distance = 3,
			},
			{ -- Harmony
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(548.79, 2670.72, 41.16),
				heading = 97.7,
				distance = 3,
			},
			{ -- Route 68
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1165.30, 2710.77, 37.16),
				heading = 177.65,
				distance = 3,
			},
			{ -- Senora Fwy.
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(2677.77, 3280.03, 54.24),
				heading = 329.12,
				distance = 3,
			},
			{ -- Sandy 1
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1960.24, 3740.54, 31.34),
				heading = 297.80,
				distance = 3,
			},
			{ -- Sandy 2
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1392.04, 3606.13, 33.98),
				heading = 202.11,
				distance = 3,
			},
			{ -- Grapeseed
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1697.27, 4923.48, 41.06),
				heading = 323.99,
				distance = 3,
			},
			{ -- Paleto 1
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(161.10, 6641.70, 30.70),
				heading = 227.71,
				distance = 3,
			},
			{ -- Paleto 2
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_AA_COFFEE',
				loc = vec3(1728.41, 6415.55, 34.04),
				heading = 240.54,
				distance = 3,
			},
        }
	},

	Ammunation = {
		name = 'Våbenbutik',
		blip = {
			id = 110, colour = 69, scale = 0.5
		}, inventory = {
			{ name = 'WEAPON_KNIFE', price = 5000, currency = "auto" },
			{ name = 'WEAPON_BAT', price = 2500, currency = "auto" },
			{ name = 'WEAPON_SWITCHBLADE', price = 5000, currency = "auto" },
			{ name = 'WEAPON_MACHETE', price = 5000, currency = "auto" },
			{ name = 'WEAPON_KNUCKLE', price = 5000, currency = "auto" },
			{ name = 'weapon_poolcue', price = 2500, currency = "auto" },
			{ name = 'weapon_wrench', price = 3999, currency = "auto" },
			{ name = 'weapon_hammer', price = 4778, currency = "auto" },
			{ name = 'weapon_crowbar', price = 4981, currency = "auto" },
			{ name = 'weapon_battleaxe', price = 5000, currency = "auto" },
		}, locations = {
			vec3(-659.178, -939.965, 21.829),
			vec3(812.841, -2155.212, 29.619),
			vec3(1698.041, 3757.44, 34.705),
			vec3(-326.001, 6081.204, 31.454),
			vec3(246.744, -51.376, 69.941),
			vec3(18.787, -1108.226, 29.797),
			vec3(2564.752, 298.954, 108.735),
			vec3(-1112.357, 2697.156, 18.554),
			vec3(841.092, -1028.653, 28.194)
		}, targets = {
			{ -- Adams apple blvd.
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(16.92, -1107.51, 28.80),
				heading = 159.19,
				distance = 3,
			},
			{ -- Little Soul
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(-659.09, -938.59, 20.83),
				heading = 87.11,
				distance = 3,
			},
			{ -- La Mesa
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(841.17, -1030.04, 27.19),
				heading = 268.36,
				distance = 3,
			},
			{ -- Cypress
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(814.87, -2155.20, 28.62),
				heading = 3.96,
				distance = 3,
			},
			{ -- Hawick
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(248.13, -51.87, 68.94),
				heading = 341.92,
				distance = 3,
			},
			{ -- Route 68
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(-1113.37, 2698.16, 17.55),
				heading = 130.23,
				distance = 3,
			},
			{ -- Sandy
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(1696.94, 3758.36, 33.71),
				heading = 135.43,
				distance = 3,
			},
			{ -- Paleto
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(-327.01, 6082.15, 30.45),
				heading = 135.07,
				distance = 3,
			},
			{ -- Palamino
				ped = `mp_m_weapexp_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(2564.83, 297.56, 107.74),
				heading = 270.49,
				distance = 3,
			},
		}
	},

	Divingstore = {
		name = 'Dykker butik',
		blip = {
			id = 110, colour = 69, scale = 0.5
		}, inventory = {
			{ name = 'scuba_set', price = 50000, currency = "auto" },
			{ name = 'scuba_tank', price = 20000, currency = "auto" },
		}, targets = {
			{
				ped = `a_m_y_jetski_01`,
				scenario = 'WORLD_HUMAN_GUARD_STAND',
				loc = vec3(-1263.68, -1435.65, 3.35),
				heading = 124.03,
				distance = 3,
			},
		}
	},

	ClickLovers = {
		name = 'Click Lovers',
		blip = {
			id = 521, colour = 26  , scale = 0.5
		}, inventory = {
			{ name = 'phone', price = 5000, 	currency = "auto" },
			{ name = 'radio', price = 5000, 	currency = "auto" },
			{ name = 'laptop', price = 15000, 	currency = "auto" },
			{ name = 'pendrive', price = 5000, 	currency = "auto" },
			{ name = 'camera', price = 25000, 	currency = "auto" },
			{ name = 'gopro', price = 500000, 	currency = "auto" },
			{ name = 'boombox', price = 75000, 	currency = "auto" },
		}, locations = {
			vec3(212.9265, -1509.051, 29.29454),
		}, targets = {
			{ loc = vec3(212.5265, -1508.551, 28.09454), length = 2, width = 2, heading = 223.1601, minZ = 28, maxZ = 31.2, distance = 4.0 },
		}
	},

	["6starNitro"] = {
		name = '6STR Nitro',
		groups = {
			['6str'] = 0
		},
		inventory = {
			{ name = 'nitro', price = 5000, metadata = { nitro = 100 }, currency = "auto" },
		}, locations = {
			vec3(141.07, -3051.11, 6.91),
		}, targets = {
			{ loc = vec3(141.07, -3051.11, 6.91), length = 2, width = 2, heading = 223.1601, minZ = 6.91, maxZ = 9.91, distance = 4.0 },
		}
	},

	-- Medicine = {
	-- 	name = 'Medicine Cabinet',
	-- 	groups = {
	-- 		['ambulance'] = 0
	-- 	},
	-- 	blip = {
	-- 		id = 403, colour = 69, scale = 0.5
	-- 	}, inventory = {
	-- 		{ name = 'medikit', price = 26, currency = "auto" },
	-- 		{ name = 'bandage', price = 5, currency = "auto" }
	-- 	}, locations = {
	-- 		vec3(306.3687, -601.5139, 43.28406)
	-- 	}, targets = {

	-- 	}
	-- },

	Politimad = {
		name = 'Politi Kantine',
		groups = {
			['police'] = 0
		},
		inventory = {
			{ name = 'burger', price = 0, currency = "auto" },
			{ name = 'water', price = 0, currency = "auto" }
		}, locations = {
			vec3(456.94351196289, -984.52410888672, 34.66047668457),
		}, targets = {
			{ loc = vec3(456.94351196289, -984.52410888672, 34.66047668457), length = 4.0, width = 4.0, heading = 180.0, minZ = 28.8, maxZ = 31.2, distance = 2.0 },
			{ loc = vec3(454.6423, -981.6381, 34.7536), length = 4.0, width = 4.0, heading = 180.0, minZ = 28.8, maxZ = 31.2, distance = 2.0 },
			{ loc = vec3(840.3808, -1285.8351, 27.2899), length = 4.0, width = 4.0, heading = 180.0, minZ = 27.2, maxZ = 30.2, distance = 2.0 },
		}
	},

	evidenceShop = {
		name = 'Krim Evidence',
		groups = {
			['police'] = 0
		},
		inventory = {
			{ name = 'evidence_camera', price = 0, currency = "auto" },
			{ name = 'evidence_pouch', price = 0, currency = "auto" },
			{ name = 'dna_swab_kit', price = 0, currency = "auto" },
			{ name = 'bleach', price = 0, currency = "auto" },
			{ name = 'evidence_tweezers', price = 0, currency = "auto" },

		}, locations = {
			vec3(464.85, -1001.81, 26.39),
		}, targets = {
			{ loc = vec3(464.86, -1001.80, 26.39), length = 4.0, width = 4.0, heading = 0.0, minZ = 25.8, maxZ = 27.2, distance = 3.0 },
		}
	},

	VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			{ name = 'water', price = 10, currency = "auto" },
			{ name = 'cola', price = 10, currency = "auto" },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}
}
