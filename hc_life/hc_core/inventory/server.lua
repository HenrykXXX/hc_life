--local HC = exports.hc_core.GetHC()

function HC:HasItemAmount(playerId, itemName, amount, cb)
    local inventory = HC:GetPlayerData(playerId).inventory
    
    for _, item in ipairs(inventory) do
        if item[1] == itemName and item[2] >= amount then
            cb(true)
        end
    end
    cb(false)
end

function HC:AddMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.money = (playerData.money or 0) + amount
end

function HC:RemoveMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.money = (playerData.money or 0) - amount
end

function HC:GetMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)
    
    return playerData.money
end


function HC:AddItem(id, itemName, amount)
    local src = id
    
    local playerStats = HC:GetPlayerData(id)
    if not playerStats then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats.inventory
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
end

function HC:RemoveItem(playerId, itemName, amount)
    local src = playerId

    local playerStats = HC:GetPlayerData(src)

    if not playerStats then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats.inventory
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
end

-- Server-side Lua to trigger the inventory display
RegisterNetEvent('hc:core:showMarket')
AddEventHandler('hc:core:showMarket', function()
    local src = source
    TriggerClientEvent('hc:shops:receiveInventoryData', src, {
        inventory = HC:GetPlayerData(src).inventory,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney
    })
end)

RegisterNetEvent('hc:core:inventory:show')
AddEventHandler('hc:core:inventory:show', function()
    local src = source
    print(HC:GetPlayerData(src).inventory)
    TriggerClientEvent('hc:core:receiveInventoryData', src, {
        inventory = HC:GetPlayerData(src).inventory,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney
    })
end)