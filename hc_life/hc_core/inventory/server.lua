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

function hasItemAmount(playerId, itemName, amount)
    print("db")
    print(playerId)
    local inventory = playerStats[playerId].inventory
    
    for _, item in ipairs(inventory) do
        if item[1] == itemName and item[2] >= amount then
            return true
        end
    end
    return false
end

-- In the inventory resource
RegisterNetEvent('hc:core:inventory:checkItem')
AddEventHandler('hc:core:inventory:checkItem', function(playerId, itemName, amount, cb)
    local hasEnough = hasItemAmount(playerId, itemName, amount)
    cb(hasEnough)  -- Use a callback to send the response
end)

function addMoney(playerId, amount)
    playerStats[playerId].money = (playerStats[playerId].money or 0) + amount
end

RegisterNetEvent('hc:core:inventory:addMoney')
AddEventHandler('hc:core:inventory:addMoney', function(playerId, amount)
    addMoney(playerId, amount)
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

-- Function to remove an item from the player's inventory, callable by the client
RegisterNetEvent('hc:core:inventory:removeItem')
AddEventHandler('hc:core:inventory:removeItem', function(playerId, itemName, amount)
    local src = playerId

    print("rem item")
    if not playerStats[src] then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats[src].inventory
    local itemFound = false

    -- Check if the item exists in the inventory
    for i, item in ipairs(inventory) do
        if item[1] == itemName then
            item[2] = item[2] - amount  -- Decrease the amount of the existing item

            -- If the item count goes to zero or below, remove it from the inventory
            if item[2] <= 0 then
                table.remove(inventory, i)
            end
            itemFound = true
            break
        end
    end

    if not itemFound then
        print("hc:core: Item " .. itemName .. " not found in player ID " .. src .. " inventory.")
    else
        print("hc:core: Item " .. itemName .. " removed from player ID " .. src .. " inventory.")
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

-- Server-side Lua to trigger the inventory display
RegisterNetEvent('hc:core:inventory:show')
AddEventHandler('hc:core:inventory:show', function()
    local src = source
    TriggerClientEvent('hc:core:receiveInventoryData', src, {
        inventory = playerStats[src].inventory,
        money = playerStats[src].money,
        bankMoney = playerStats[src].bankMoney
    })
end)