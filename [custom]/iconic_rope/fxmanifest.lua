fx_version 'cerulean'
game 'gta5'
version '1.0.0'
author 'Iconic Scripts'

client_scripts {
	'config.lua',
	'client.lua',
}

server_scripts {
	'config.lua',
	'server.lua',
	'editable_server.lua',
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/imports.lua'
}

dependency 'ox_lib'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

escrow_ignore {
	-- 'client.lua',
	-- 'server.lua',
	'editable_server.lua',
	'config.lua'
}

dependency '/assetpacks'