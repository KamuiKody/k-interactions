fx_version 'cerulean'
game 'gta5'

name 'k-interactions'
author 'kamui kody'
description 'standalone dui interaction menu'

ui_page 'html/index.html'

client_scripts {
    'client/init.lua',
    'config.lua',
    'exports.lua',
    'client/interactions.lua'
}

files {
    'html/*.js',
    'html/*.html',
    'html/*.css'
}

lua54 'yes'
