fx_version   'cerulean'
lua54        'yes'
game         'gta5'

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'config.lua',
}

client_scripts {
	'client.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
    'events.meta',
    'popgroups.ymt',
    'relationships.dat',
}