fx_version 'cerulean'
game 'gta5'

author 'Palme x Agent'
description 'Weapon Serial Number Duplicate Checker'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/check_duplicates.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
} 