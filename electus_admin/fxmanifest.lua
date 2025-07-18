fx_version("cerulean")
author("@electus_scripts (ELECTUS SCRIPTS)")
version("1.0.1")
lua54("yes")

games({
	"gta5",
})

files({
	"ui/build/index.html",
	"ui/build/**/*",
	"config/locales/*.lua",
})

ui_page("ui/build/index.html")
-- ui_page("http://localhost:5173")

shared_scripts({
	"config/**/*",
	"shared/**/*",
	"escrowed/shared/*",
	"@ox_lib/init.lua",
	-- "@qbx_core/modules/lib.lua", -- uncomment this if you are using Qbox
})

client_scripts({
	-- "@qbx_core/modules/playerdata.lua", -- uncomment this if you are using Qbox
	"client/**/*",
	"escrowed/client/*",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/**/*",
	"escrowed/server/*",
	"server_config/*",
	"backend/dist/index.js",
})

server_exports({
	"GetTotalBank",
	"GetPlayerCount",
	"GetTotalCash",
	"GetStaffOnline",
	"GetPeakPlayers",
	"Announce",
	"KickAll",
	"ReviveAll",
	"SetTime",
	"SetWeather",
	"DeleteAllVehicles",
	"DeleteAllPeds",
	"DeleteAllProps",
	"GetAllPlayers",
	"GetExtendedPlayer",
	"GetOnlinePlayers",
	"GetVehiclesInDatabase",
	"GetSpecificVehicleInDatabase",
	"TransferVehicleOwnership",
	"RepairVehicle",
	"FlipVehicle",
	"DeleteVehicle",
	"UpdateGarage",
	"FreezeAllPlayers",
	"IdentifierGetInventory",
	"IdentifierAddItem",
	"IdentifierRemoveItemAmount",
	"IdentifierSetItem",
	"RemoveCountFromAllPlayers",
	"AddItemCountToAllPlayers",
	"SetItemCountForAllPlayers",
	"GetItems",
	"GetItemPlayers",
	"GetDailyStatistics",
	"GetWeeklyStatistics",
	"GetMonthlyStatistics",
	"ChangePlate",
	"RemoveVehicleFromDatabase",
	"GetGarages",
	"GetMapData",
})

escrow_ignore({
	"client/**",
	"server/**",
	"shared/**",
	"config/**",
	"server_config/**",
})

dependency '/assetpacks'