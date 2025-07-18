fx_version "cerulean"
game "gta5"
author "DanishRP - Bach"
lua54 "yes"
ui_page "html/index.html"
-- ui_page "http://localhost:5173"

files {
    "html/**/**/*",
    "dPay.png",
}

client_scripts {
    "client/**/**",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/**/**",
}

shared_scripts {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "config.lua",
}
