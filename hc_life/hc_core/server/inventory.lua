local playerStats = {}

AddEventHandler('playerJoining', function()
    local src = source
    playerStats[src] = {
        money = 1000,       -- Default money
        bankMoney = 5000,   -- Default bank money
        inventory = {},     -- Empty inventory
        licenses = {}       -- Empty licenses
    }
    print("hc:core: Player stats initialized for player ID " .. src)
end)

-- Function to get player stats, callable by the client
RegisterNetEvent('hc:core:getPlayerStats')
AddEventHandler('hc:core:getPlayerStats', function()
    local src = source
    if playerStats[src] then
        TriggerClientEvent('hc:core:receivePlayerStats', src, playerStats[src])
    else
        print("hc:core: No player stats found for player ID " .. src)
    end
end)

-- Function to add an item to the player's inventory, callable by the client
RegisterNetEvent('hc:core:inventory:addItem')
AddEventHandler('hc:core:inventory:addItem', function(itemName, amount)
    local src = source
    if not playerStats[src] then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats[src].inventory
    local itemFound = false

    -- Check if the item already exists in the inventory
    for i, item in ipairs(inventory) do
        if item[1] == itemName then
            item[2] = item[2] + amount  -- Increase the amount of the existing item
            itemFound = true
            break
        end
    end

    -- If the item was not found, add it as a new entry
    if not itemFound then
        table.insert(inventory, {itemName, amount})
    end

    TriggerClientEvent('hc:core:inventoryUpdated', src, inventory) -- Optional: Notify the client about the updated inventory
    print("hc:core: Item " .. itemName .. " added to player ID " .. src .. " inventory.")
end)

-- Function to update player stats, callable by the client
RegisterNetEvent('hc:core:updatePlayerStats')
AddEventHandler('hc:core:updatePlayerStats', function(newStats)
    local src = source
    if playerStats[src] then
        playerStats[src] = newStats
        print("hc:core: Player stats updated for player ID " .. src)
    end
end)


-- Function to update player stats, callable by the client
RegisterNetEvent('hc:core:updatePlayerStats')
AddEventHandler('hc:core:updatePlayerStats', function(newStats)
    local src = source
    if playerStats[src] then
        playerStats[src] = newStats
        print("hc:core: Player stats updated for player ID " .. src)
    end
end)

-- Clean up player stats on player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    if playerStats[src] then
        playerStats[src] = nil
        print("hc:core: Player stats removed for player ID " .. src)
    end
end)