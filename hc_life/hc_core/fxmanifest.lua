fx_version 'bodacious'
game 'gta5'

author 'HenrykXXX'
version '1.0.0'

client_scripts {
    'client/main.lua',

    --inventory--
    'inventory/client.lua',

    --time--
    'time/client.lua',

    --mapmanager--
    'mapmanager/client.lua',

    --vehicles--
    'vehicles/client.lua'
}

server_scripts {
    'server/main.lua',
    "server/events.lua",

    --inventory--
    'inventory/server.lua',

    --vehicles--
    'vehicles/server.lua',

    --time--
    'time/server.lua'
}

ui_page 'inventory/html/index.html'

files {
    'inventory/html/index.html',
    'inventory/html/style.css',
    'inventory/html/script.js'
}
