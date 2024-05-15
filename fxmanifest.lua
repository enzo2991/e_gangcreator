fx_version 'cerulean'
game 'gta5'
author 'Enzo'
lua54 'yes'

shared_scripts {
    'shared/config.lua',
    '@ox_lib/init.lua',
    'shared/locale.lua',
	'locales/*.lua',
}

client_scripts {
    'client/function.lua',
    'client/menu.lua',
}

server_scripts {
    'server/commands.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/callback.lua'
}