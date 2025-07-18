fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "ManiMods"
description "Bridge/Library for ManiMods resources"
version "1.0.0"

client_scripts {
    'modules/**/client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/**/server.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}