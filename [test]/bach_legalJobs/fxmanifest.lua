fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Bach"
description "Bach Legal Jobs"
version "1.0.0"

client_scripts {
    "client/**/**/**",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/**/**/**",
}

shared_scripts {
    "@ox_lib/init.lua",
    "@es_extended/imports.lua",
    "shared/**/**/**",
}

dependencies {
    "lb-phone",
    "ox_lib",
    "ox_target",
    "ox_inventory",
}

