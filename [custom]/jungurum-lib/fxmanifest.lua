fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "JungurumLand"
description "En masse shit til JungurumLand Scripts"
version "1.0.0"

client_scripts {
    'modules/**/client.lua',
}

server_scripts {
    'modules/**/server.lua',
}

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',
}