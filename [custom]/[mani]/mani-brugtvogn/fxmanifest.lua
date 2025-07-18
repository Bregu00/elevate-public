fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

author 'ManiMods'
description 'Brugtvognsforhandler'

ui_page 'web/build/index.html'

client_scripts {
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',
}

files {
	'web/build/index.html',
	'web/build/**/*'
}

escrow_ignore {
	'config.lua',
}
dependency '/assetpacks'