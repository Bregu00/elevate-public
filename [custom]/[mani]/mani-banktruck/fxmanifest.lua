fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "ManiMods"
description "Banktruck Heist For FiveM"
version "2.0.0"

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@es_extended/imports.lua',
	'server/*.lua',
	'open/sv_open.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

files {
	'config.lua',
	'open/cl_open.lua',
	'locales/*.json'
}

escrow_ignore {
	'open/*.lua',
	'config.lua',
	'locales/*.json',
}

data_file 'DLC_ITYP_REQUEST' 'stream/mani_landmine.ytyp'
dependency '/assetpacks'