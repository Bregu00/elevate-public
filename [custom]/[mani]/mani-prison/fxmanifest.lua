fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "ManiMods"
description "Prison System For FiveM"
version "1.0.0"

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
}

files {
	'config.lua',
	'util.lua'
}