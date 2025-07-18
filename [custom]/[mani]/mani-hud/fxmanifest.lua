fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'

author 'ManiMods'
description 'Hud V1'
version '1.0.0'
lua54 'yes'

-- ui_page 'http://localhost:5173/' -- Uncomment this if you are using Vite (live preview when developing)
ui_page 'web/build/index.html'

client_scripts {
  'main.lua',
  'client/*.lua',
  'framework/*.lua',
}

server_scripts {   
  'server/*.lua',
}

shared_script '@ox_lib/init.lua'

files {
  'web/build/index.html',
  'web/build/**/*',
  'config.lua',
}

escrow_ignore {
  'config.lua',
  'client/*.lua',
  'framework/*.lua',
}
dependency '/assetpacks'