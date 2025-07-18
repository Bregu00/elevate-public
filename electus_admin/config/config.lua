Config = {
	framework = "esx", -- "esx", "qb" or "qbx"
	inventory = "ox_inventory", -- "ox_inventory", "qs-inventory", "core_inventory", "qb-inventory"
	garage = "esx_garage", -- "esx_garage", "qb-garages", "jg-advancedgarages" -- if unsure use "esx_garage" or "qb-garages" as they set a standard for the database structure.
	locale = "en",
	keyActions = { -- if you change KeyActions the Key must also be avaliable in Keys table.
		cancel = "BACKSPACE",
	},
	adminLogs = {
		enabled = false,
		service = "ox_lib", -- "ox_lib", "fivemanage", "discord"
	},
	serverIp = "178.208.177.42", -- your server ip
	inventoryPath = "/web/images",
	statistics = {
		jobs = { -- what jobs to track
			"police",
		},
		items = { -- what weapons to track
			"weapon_pistol",
		},
	},
}
