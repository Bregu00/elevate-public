author 'Stausi'
description 'Stausi Perico Heist'
version '1.0.5'
package_id "3"

fx_version "adamant"
game "gta5"
lua54 "yes"

shared_scripts {
    '@st_libs/init.lua',
    'config.lua',
    'lang.lua',
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
    'client/heist.lua',
    'client/utils.lua',
    'client/doors.lua',
}

server_scripts {
    'server/main.lua',
    'server/utils.lua',
    'server/doors.lua',
    'server/random.js',
    'webhooks.lua',
}

escrow_ignore {
    'config.lua',
    'lang.lua',
    'webhooks.lua',
    'client/utils.lua',
    'server/utils.lua',
    'items/items.lua',
}

dependencies {
    "st_libs",
    "/server:6231",
    "/onesync"
}
dependency '/assetpacks'