fx_version 'cerulean'
game 'gta5'

description 'wert-banking'
version '1.0.0'

ui_page {'html/index.html'}
    
files {
    'html/index.html',
    'html/js/*',
    'html/css/*',
    'html/*.png'
}

shared_scripts {
    'lang.lua',
    'config.lua'
}

client_scripts {
    'editable.lua',
	'client.lua',
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'discord.lua',
	'server.lua',
}

escrow_ignore {
    'editable.lua',
    'discord.lua',
    'config.lua',
    'lang.lua'
}

lua54 'yes'
dependency '/assetpacks'