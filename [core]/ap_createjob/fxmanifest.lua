fx_version 'cerulean'
games {'gta5'}

author 'Adzeepulse#7832'
description 'ap_createjob'
version '1.0.0'
lua54 'yes'

client_scripts {
	'client.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}