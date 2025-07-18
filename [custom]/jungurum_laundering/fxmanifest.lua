game 'gta5'
fx_version 'cerulean'

name 'sb_laundering'
description 'Blanco Laundering'
author 'Blanco'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    -- '@ossie_security/lib.lua',
    "config.lua",
}

server_scripts {
    "server.lua",
}

client_scripts {
    "client.lua",
}

lua54 'yes'

use_experimental_fxv2_oal 'yes'