fx_version 'bodacious'
game 'gta5'

author 'HenrykXXX'
version '1.0.0'

client_scripts {
    '@mysql-async/lib/MySQL.lua',
    
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

    --configuration--
    "config/vehicles.lua",
    'config/items.lua',
    'config/shops.lua',
    'config/mines.lua',

    --inventory--
    'inventory/server.lua',

    --vehicles--
    'vehicles/server.lua',

    --bank--
    'bank/server.lua',

    --time--
    'time/server.lua'
}

