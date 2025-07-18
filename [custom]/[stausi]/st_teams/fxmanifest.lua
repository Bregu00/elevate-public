fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'Stausi'
description 'Stausi Teams'
version '1.0.0'

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    'webhooks.lua',
}

shared_scripts {
    "config.lua",
    "utils.lua",
}

escrow_ignore {
    'config.lua',
    'webhooks.lua',
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
}

dependency '/assetpacks'