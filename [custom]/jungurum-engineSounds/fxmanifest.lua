fx_version 'cerulean'
games { 'gta5' }

author 'Blanco & Mani'
description 'engineSounds'
version '1.0.0'
lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server.lua',
}

client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
	'client.lua',
}

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
    '@ox_lib/init.lua'
}