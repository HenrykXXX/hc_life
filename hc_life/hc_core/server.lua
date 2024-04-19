local invItems = {} -- Player inventory items

-- Function to add a peach to a player's inventory
local function addPeachToInventory(playerId)
    table.insert(invItems, "Peach") -- Add a peach to the player's inventory
end

-- Function to get the player's inventory
local function getPlayerInventory(playerId)
    return invItems
end

-- Event handler for player pressing 'E' key to gather peaches
RegisterServerEvent("playerPressedE")
AddEventHandler("playerPressedE", function()
    local playerId = source
    addPeachToInventory(playerId)
end)

-- Event handler for player requesting inventory
RegisterServerEvent("getPlayerInventory")
AddEventHandler("getPlayerInventory", function()
    local playerId = source
    local inventory = getPlayerInventory(playerId)
    TriggerClientEvent("showInventory", playerId, inventory)
end)