fx_version   'cerulean'
lua54        'yes'
game         'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'config.lua',
}

client_scripts {
	'functions.lua',
	'cl_targetOptions.lua',
	'cl_radialOptions.lua',
}

server_scripts {
	'server.lua',
}