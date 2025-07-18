fx_version 'cerulean'
games { 'gta5' }

author 'Made with Love by Samuel0008'
description 'Police Radar for FiveM'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

files { 'html/index.html', 'html/script.js', 'html/style.css' }

client_scripts { 'client.lua' }

server_scripts { 'server.lua', '@oxmysql/lib/MySQL.lua' }

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
