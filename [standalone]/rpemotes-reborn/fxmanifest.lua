fx_version 'cerulean'
game 'gta5'
description 'rpemotes-reborn'
version '1.8.4'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

provide "rpemotes"

dependencies {
    -- '/server:7290',
    '/server:6683',
    '/onesync'
}

-- Uncomment the below line if you would like to use the SQL keybinds. Requires oxmysql.
-- server_script '@oxmysql/lib/MySQL.lua'

files {
    'conditionalanims.meta',
    'header.png'
}

data_file 'CONDITIONAL_ANIMS_FILE' 'conditionalanims.meta'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locale.lua',
    'locales/*.lua',
    'animals.lua'
}

server_scripts {
    'server/Server.lua',
    'server/Updates.lua',
    'server/frameworks/*.lua'
}

client_scripts {
    'NativeUI.lua',
    'client/Utils.lua',
    'client/AnimationList.lua',
    'client/AnimationListCustom.lua',
    'client/Binoculars.lua',
    'client/Crouch.lua',
    'client/Emote.lua',
    'client/EmoteMenu.lua',
    'client/Expressions.lua',
    'client/Keybinds.lua',
    'client/NewsCam.lua',
    'client/NoIdleCam.lua',
    'client/Pointing.lua',
    'client/Ragdoll.lua',
    'client/Syncing.lua',
    'client/Walk.lua',
    'client/frameworks/*.lua'
}