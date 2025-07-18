fx_version 'cerulean'
games { 'gta5' }

author 'Blanco'
description 'Zone Blackmail'
version '1.0.0'
lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server.lua',
}

client_scripts {
	'client.lua',
}

shared_scripts {
	'@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}