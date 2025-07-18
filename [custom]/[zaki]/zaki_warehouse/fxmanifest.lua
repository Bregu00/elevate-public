fx_version 'adamant'
games { 'gta5' }

author 'FH'
description 'Vehiclethief'
version '1.0.0'
lua54 'yes'

shared_script {
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

this_is_a_map 'yes'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/styles.css',
    'ui/app.js',
    'ui/images/*.png',
    'ui/images/*.jpg'
}

dependencies {
    'es_extended',
    'ox_lib'
}
