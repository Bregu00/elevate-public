-- Resource Metadata
fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'Visualz <https://visualz.dk>'
description 'Visualz CPR'
version '1.0.0'

client_script 'client/client.lua'
shared_scripts {
    'config/config.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}
server_script 'server/server.lua'
