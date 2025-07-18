fx_version 'cerulean'
game 'gta5'

name 'elevate_garage'
description 'zakz26'
author 'Elevate Scripts'
version '1.0.0'
lua54 'yes'

shared_scripts {
   '@es_extended/imports.lua',
   '@ox_lib/init.lua',
   'config.lua'
}

client_scripts {
   '@PolyZone/client.lua',
   '@PolyZone/BoxZone.lua',
   '@PolyZone/EntityZone.lua',
   '@PolyZone/CircleZone.lua',
   '@PolyZone/ComboZone.lua',
   'client/main.lua'
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
   'server/main.lua'
}

ui_page 'web/build/index.html'

files {
   'web/build/index.html',
   'web/build/**/*'
}

dependencies {
   'es_extended',
   'ox_lib',
   'PolyZone'
}

