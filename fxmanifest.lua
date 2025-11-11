fx_version 'cerulean'
game 'gta5'

author 'MG_SCRIPTS'
description 'Clear Area - Remove NPCs and Vehicles'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

lua54 'yes'