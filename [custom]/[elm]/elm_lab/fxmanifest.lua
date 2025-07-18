fx_version 'cerulean'
game 'gta5'
lua54 'yes'

files {
	'audio/data/oxdoorlock_sounds.dat54.rel',
	'audio/dlc_oxdoorlock/oxdoorlock.awc',
}

data_file 'AUDIO_WAVEPACK' 'audio/dlc_oxdoorlock'
data_file 'AUDIO_SOUNDDATA' 'audio/data/oxdoorlock_sounds.dat'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'configs/shared.lua'
}

client_scripts {
    'configs/client.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/server.lua',
    'configs/client.lua',
    'server/*.lua'
}

exports {
    "farm",
    "pack",
    "omdan"
}