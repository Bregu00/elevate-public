fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'ManiMods'
description 'JobPack for FiveM[ESX/QBCore/QBX]'
version '1.0.0'

client_scripts {
    'client/**/**/**',
}

server_scripts {    
    'server/**/**/**',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

files {
    'shared/**/**/**',
    'stream/*.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

escrow_ignore {
    'shared/**/**/**',
    'server/**/**/**',
}