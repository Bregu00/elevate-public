fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "ManiMods"
description "Advanced Armor System For Roleplaying Purposes"
version "1.0.0"

client_scripts {
	'client.lua',
	'framework/client/*.lua'
}

server_scripts {
	'server.lua',
	'framework/server/*.lua',
	'log.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

files {
	'locales/*.json'
}

escrow_ignore {
	'config.lua',
	'framework/client/*.lua',
	'framework/server/*.lua',
	'log.lua'
}
dependency '/assetpacks'