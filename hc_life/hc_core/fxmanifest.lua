fx_version 'bodacious'
game 'gta5'

author 'HenrykXXX'
version '1.0.0'

client_scripts {
    'client.lua',

    --inventory--
    'inventory/client.lua'
}

server_scripts {
    'server.lua',

    --inventory--
    'inventory/server.lua'
}

ui_page 'inventory/html/index.html'

files {
    'inventory/html/index.html',
    'inventory/html/style.css',
    'inventory/html/script.js'
}
