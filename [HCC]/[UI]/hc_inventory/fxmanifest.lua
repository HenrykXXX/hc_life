fx_version 'bodacious'
game 'gta5'

author 'HenrykXXX'
version '1.0.0'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_script 'shared.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}


dependencies {
    'hc_core'
}