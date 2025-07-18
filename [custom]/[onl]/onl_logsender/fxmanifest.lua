fx_version 'cerulean'
game 'gta5'

author 'mads_onl'
description 'A logging utility for sending logs to Loki and Discord'
version '1.0.0'
lua54 'yes'


client_scripts {
    'client.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/imports.lua',
}

dependencies {
    'pma-voice'
}

server_scripts {
    'config.lua',
    'server.lua'
}

exports {
    'SendLog'
}