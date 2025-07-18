author 'Stausi'
description 'Stausi Container Robberies'
version '1.0.10'
package_id "4"

fx_version "adamant"
game "gta5"
lua54 "yes"

shared_scripts {
    '@st_libs/init.lua',
    'config.lua',
    'utils.lua',
}

st_libs {
    'print',
    'callback',
    'jobscache',
    'discord',
    'hook',
    "inventory-bridge",
	"version-checker",
}

client_scripts {
    'client/main.lua',
    'client/utils.lua',
    'client/safecracking.lua',
    'client/npcnotify.lua',
}

server_scripts {
    'server/main.lua',
    'server/utils.lua',
    'server/random.js',
    'webhooks.lua',
}

escrow_ignore {
    'config.lua',
    'webhooks.lua',
    'client/utils.lua',
    'server/utils.lua',
}

dependencies {
    "st_libs",
    "/server:6231",
    "/onesync"
}

dependency '/assetpacks'