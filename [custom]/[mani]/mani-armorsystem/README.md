## Installation Guide
1. Install latest version of mani-bridge -- https://github.com/manipou/mani-bridge

2. Add items to ox_inventory/data/items.lua: (NEEDS TO MATCH CONFIG)

	['armor'] = {
		label = 'Lvl 1 Armor',
		description = 'Light Plate Carrier',
		weight = 2000,
		stack = true,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlateCarrier',
		},
		buttons = {
			{
				label = 'Remove Plates',
				action = function(slot)
					exports['mani-armorsystem']:removePlates(slot)
				end
			},
		}
	},

	['armor2'] = {
		label = 'Lvl 2 Armor',
		description = 'Medium Plate Carrier',
		weight = 3000,
		stack = false,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlateCarrier',
		},
		buttons = {
			{
				label = 'Remove Plates',
				action = function(slot)
					exports['mani-armorsystem']:removePlates(slot)
				end
			},
		}
	},

	['armor3'] = {
		label = 'Lvl 3 Armor',
		description = 'Heavy Plate Carrier',
		weight = 4000,
		stack = false,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlateCarrier',
		},
		buttons = {
			{
				label = 'Remove Plates',
				action = function(slot)
					exports['mani-armorsystem']:removePlates(slot)
				end
			},
		}
	},

	['policearmor'] = {
		label = 'Police Armor',
		description = 'Police Plate Carrier',
		weight = 3000,
		stack = false,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlateCarrier',
		},
		buttons = {
			{
				label = 'Remove Plates',
				action = function(slot)
					exports['mani-armorsystem']:removePlates(slot)
				end
			},
		}
	},

	['plate'] = {
		label = 'Lvl 1 Plate',
		weight = 500,
		stack = true,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlate',
		},
	},

	['plate2'] = {
		label = 'Lvl 2 Plate',
		weight = 750,
		stack = true,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlate',
		},
	},

	['plate3'] = {
		label = 'Lvl 3 Plate',
		weight = 1000,
		stack = true,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlate',
		},
	},

	['policeplate'] = {
		label = 'Police Plate',
		weight = 750,
		stack = true,
		close = true,
		client = {
			export = 'mani-armorsystem.equipPlate',
		},
	},

3. Client Exports:
    exports['mani-armorsystem']:resetArmor() -- IMPORTANT -- ADD TO DEATH EVENTS IF YOU WISH FOR THE PLAYER TO LOSE ARMOR RIG ON DEATH.
    exports['mani-armorsystem']:equipPlateCarrier()
    exports['mani-armorsystem']:equipPlate()
    exports['mani-armorsystem']:removePlates()
	

## DISCORD SUPPORT
Join discord for support: https://discord.gg/qd882rDMyB
