fx_version 'cerulean'
game 'gta5'
name 'Refund'
version '1.0.0'
description 'Refund Bot'
lua54 'yes'

shared_script {
	'config/config.lua'
}

client_scripts {
    'client/cl_refund.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/sv_refund.lua',
}