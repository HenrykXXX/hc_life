AddEventHandler('playerJoining', function()
    local src = source
    
    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

    for k,v in pairs(GetPlayerIdentifiers(source))do
        print(v)
            
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        end
        
    end

    HC.PlayerData[src] = {
        money = 1000,       -- Default money
        bankMoney = 5000,   -- Default bank money
        inventory = {},     -- Empty inventory
    }
    print("hc:core: Player stats initialized for player ID " .. src)
end)

-- Clean up player stats on player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    if HC.PlayerData[src] then
        HC.PlayerData[src] = nil
        print("hc:core: Player stats removed for player ID " .. src)
    end
end)