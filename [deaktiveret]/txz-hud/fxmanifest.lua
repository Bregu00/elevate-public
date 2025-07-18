fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Taxzyyy"
description "FiveM Hud"
version "1.0"

client_scripts {
  'client.lua'
}

server_scripts {
  'server.lua'
}

shared_scripts {
  'config.lua',
}

ui_page 'dist/index.html'

files {
  'dist/index.html',
  'dist/**/*'
}