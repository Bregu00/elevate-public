fx_version 'adamant'
games { 'gta5' }

author 'Stausi'
description 'Minigames for hacking'
version '1.0.0'
lua54 'yes'

client_scripts {
    'client/*.lua',
}

ui_page {
    'dist/index.html'
}

files {
    'dist/index.html',
    'dist/css/*.css',
    'dist/font/*.ttf',
    'dist/*.css',
    'dist/js/*.js',
    'dist/js/*.js.map',
    'dist/voltlab/*.png',
    'dist/voltlab/*.jpg',
    'dist/voltlab/*.gif',
}
dependency '/assetpacks'