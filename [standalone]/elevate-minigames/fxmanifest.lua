fx_version 'cerulean'
game 'gta5'

author 'Elevate'
description 'Elevate Minigames'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

client_script {
    'client/**/*.lua',

    'client/utils/scaleforms.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
}

files {
    'client/class.lua',
}