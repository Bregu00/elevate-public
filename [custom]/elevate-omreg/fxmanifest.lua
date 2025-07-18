fx_version "cerulean"
game "gta5"

name "ManiBlanco - Vehicle Transfer"
description "Vehicle Transfer System"
author "Mani & Blanco"

lua54 'yes'

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}