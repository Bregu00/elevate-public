fx_version 'cerulean'
game 'gta5'

name "dynyx_oxyrun"
description "Oxy Run"
author "Green"
version "1.0."

lua54 'yes'

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua",
}

client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/main.lua',
}

server_scripts {
	'server/main.lua',
}

escrow_ignore {
    'config.lua',
    'README.md',
    'client/main.lua',
    'server/main.lua',
}

dependency '/assetpacks'