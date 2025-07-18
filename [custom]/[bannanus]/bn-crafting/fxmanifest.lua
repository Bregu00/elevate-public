fx_version 'cerulean'

game "gta5"

author "Banannus"
version '2.0'
description 'Crafting Menu'

lua54 'yes'

ui_page 'build/index.html'

shared_script {
    '@bn_lib/init.lua',
    '@ox_lib/init.lua',
    'shared/**',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/**'
}

client_script {
    'client/ui.lua',
    'client/**',
}

files {
    'build/**',
    'locales/**',
}

escrow_ignore {
    'shared/**',
}
dependency '/assetpacks'