fx_version 'cerulean'
description 'AV Alphabet'
author 'Avilchiis'
version '1.0.0'
lua54 'yes'
games {
'gta5'
}

ui_page 'web/build/index.html'


client_scripts {
'config/*.lua',
'client/main.lua',
}


files {
'web/build/index.html',
'web/build/**/*',
}

escrow_ignore { 
'config/*.lua',
}
dependency '/assetpacks'