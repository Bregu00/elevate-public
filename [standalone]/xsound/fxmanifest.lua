fx_version 'adamant'
game 'gta5'

author 'highrider#2873'
description 'High-3DSounds'
version '0.2.2-beta'
lua54 'yes'

ui_page 'index.html'

files {
    'index.html',
    'assets/**/*.*',
    'assets/**/**/*.*'
}

client_scripts {
    'code/client.lua',
    "addon/**/client/*.lua",
}
server_scripts {
    'config.lua', -- This is shared to the client later on, thats to hide the API for getting the youtube song MP3.
    'code/server.lua',
    "addon/**/server/*.lua",
}
shared_scripts {
    'sh_config.lua',
    'code/utils.lua'
}

escrow_ignore {
    'config.lua',
    'sh_config.lua',
    "addon/**/**/*.lua",
}

provide {
    'xsound',
    'interact-sound'
}
dependency '/assetpacks'