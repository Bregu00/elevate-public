fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Your Name'
description 'PvP Menu with OX_LIB'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'es_extended'
} 