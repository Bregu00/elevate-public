fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'FH'
description 'Crypto'
version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
    'config.lua',
	'server/server.lua',
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
	'client/client.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
    'config.lua',
}

escrow_ignore {
    'config.lua',
}

ui_page 'html/dist/index.html'

files {
    'html/dist/index.html',
    'html/dist/assets/*.js',
    'html/dist/assets/*.css'
}

dependency '/assetpacks'