fx_version 'bodacious'
game 'gta5'
use_fxv2_oal 'yes'

author 'ManiMods'
description 'ManiMods - Elevate Boombox'
version '1.0.0'
lua54 'yes'

ui_page 'html/index.html'

client_script "client/**/*"
server_script "server/**/*"

shared_scripts {
  	'@ox_lib/init.lua'
}

files { 'html/index.html' }