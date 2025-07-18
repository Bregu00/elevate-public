fx_version 'cerulean'

game 'gta5'

author 'TuKeh_'

description 'Dispatch System'

version '1.2.5'

lua54 'yes'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
	'locales/*.lua',
	'config_sv.lua',
	'config.lua',
}

client_scripts {
    'client/frameworks/*.lua',
    'client/main_editable.lua',
    'client/main.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server/frameworks/*.lua',
    'server/main_editable.lua',
    'server/main.lua',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
	'config_sv.lua',
    'client/frameworks/*.lua',
    'server/frameworks/*.lua',
    'client/main_editable.lua',
    'server/main_editable.lua',
}

provide 'ps-dispatch'
provide 'qs-dispatch'
provide 'cd_dispatch'
dependency '/assetpacks'