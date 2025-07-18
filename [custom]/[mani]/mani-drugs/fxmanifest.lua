fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mani'
version '1.0.0'
description 'Drug system for Elevate'

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
	'sv_util.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}