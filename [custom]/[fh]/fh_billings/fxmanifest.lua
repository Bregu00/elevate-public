fx_version 'cerulean'
description 'Faktura App'
author 'FH'
version '1.0.0'
lua54 'yes'
games {
    'gta5'
}

ui_page 'ui/dist/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config/*.lua'
}

client_scripts {
    'client/**/*',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**/*'
}

files {
    'ui/dist/index.html',
    'ui/dist/**/*',
    'icon.png'
}

escrow_ignore {
    'config/*.lua',
}

dependencies {
    "ox_lib",
    "av_apps"
}

dependency '/assetpacks'