-- Server-side script: server.lua

local playerStats = {}

AddEventHandler('playerJoining', function()
    local src = source
    playerStats[src] = {
        money = 1000,       -- Default money
        bankMoney = 5000,   -- Default bank money
        inventory = {},     -- Empty inventory
        licenses = {}       -- Empty licenses
    }
    print("Player stats initialized for player ID " .. src)
end)

-- Function to get player stats, callable by the client
RegisterNetEvent('getPlayerStats')
AddEventHandler('getPlayerStats', function()
    local src = source
    if playerStats[src] then
        TriggerClientEvent('receivePlayerStats', src, playerStats[src])
    else
        print("No player stats found for player ID " .. src)
    end
end)

-- Function to update player stats, callable by the client
RegisterNetEvent('updatePlayerStats')
AddEventHandler('updatePlayerStats', function(newStats)
    local src = source
    if playerStats[src] then
        playerStats[src] = newStats
        print("Player stats updated for player ID " .. src)
    end
end)

-- Clean up player stats on player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    if playerStats[src] then
        playerStats[src] = nil
        print("Player stats removed for player ID " .. src)
    end
end)