fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'

author 'Elevate'
description 'Multijob System for Elevate'
version '1.0.0'
lua54 'yes'

client_script 'client.lua'
server_scripts {
  "@mysql-async/lib/MySQL.lua",
  'server.lua'
}

shared_scripts {
  "@ox_lib/init.lua",
  "@es_extended/imports.lua",
  "config.lua",
}