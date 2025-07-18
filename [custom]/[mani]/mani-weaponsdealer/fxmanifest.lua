fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'ManiMods'
description 'Weapon Dealer For Gangs'
version '1.0.0'

ui_page 'web/build/index.html'

client_scripts {
    'client/*.lua',
}

server_scripts {   
    "@mysql-async/lib/MySQL.lua", 
    'server/*.lua',
    'open/sv_util.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

files {
    'config.lua',
    'open/cl_util.lua',
    'missions/*.lua',
    'web/build/index.html',
    'web/build/**/*'
}

escrow_ignore {
    'config.lua',
    'open/*.lua',
    'missions/*.lua',
    'server/*.lua',
    'client/missions.lua'
}
dependency '/assetpacks'