fx_version 'cerulean'

game "gta5"

author "ManiMods"
version '1.0.0'
description 'Radio system for FiveM'

lua54 'yes'

ui_page 'build/index.html'

shared_script {
    '@ox_lib/init.lua',
}

server_script {
    'server/**'
}

client_script {
    'client/**',
}

files {
    'build/**',
    'locales/*.json',
    'shared/config.lua'
}

escrow_ignore {
    'client/open.lua',
    'server/open.lua',
    'shared/config.lua'
}
dependency '/assetpacks'