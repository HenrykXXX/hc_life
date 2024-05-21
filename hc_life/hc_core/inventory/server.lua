HC.Inventory = {}

function HC.Inventory.HasItemAmount(playerId, itemName, amount)
    local inventory = HC:GetPlayerData(playerId).inventory
    print("name: " .. itemName .. " amount " .. amount)
    for _, item in ipairs(inventory.items) do
        if item[1] == itemName and item[2] >= amount then
            return true
        end
    end
    return false
end

function HC.Inventory.AddItem(id, itemName, amount)
    local src = tonumber(id)
    
    local playerStats = HC:GetPlayerData(src)
    if not playerStats then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats.inventory
    local items = playerStats.inventory.items
    local maxWeight = playerStats.inventory.maxWeight

    local itemWeight = HC.Config.Items.GetWeight(itemName)
    local totalWeight = HC.Inventory.GetWeight(src)

    if (totalWeight + itemWeight) > maxWeight then
        print("Not enough space in inventory for player ID: " .. src)
        return false
    end


    local itemFound = false
    -- Check if the item already exists in the inventory
    for i, item in ipairs(items) do
        if item[1] == itemName then
            item[2] = item[2] + amount  -- Increase the amount of the existing item
            itemFound = true
            break
        end
    end

    -- If the item was not found, add it as a new entry
    if not itemFound then
        table.insert(items, {itemName, amount})
    end

    --update current weight--
    inventory.currentWeight = HC.Inventory.GetWeight(src)

    --playerStats.inventory = inventory
    print("Item " .. itemName .. " added to player ID " .. src .. " inventory.")
    return true
end

function HC.Inventory.RemoveItem(playerId, itemName, amount)
    local src = playerId

    local playerStats = HC:GetPlayerData(src)

    if not playerStats then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats.inventory
    local items = playerStats.inventory.items
    local itemFound = false

    -- Check if the item exists in the inventory
    for i, item in ipairs(items) do
        if item[1] == itemName then
            item[2] = item[2] - amount  -- Decrease the amount of the existing item

            -- If the item count goes to zero or below, remove it from the inventory
            if item[2] <= 0 then
                table.remove(items, i)
            end
            itemFound = true
            break
        end
    end

    inventory.currentWeight = HC.Inventory.GetWeight(src)

    if not itemFound then
        print("hc:core: Item " .. itemName .. " not found in player ID " .. src .. " inventory.")
    else
        print("hc:core: Item " .. itemName .. " removed from player ID " .. src .. " inventory.")
    end
end

function HC.Inventory.GetWeight(id)
    local src = tonumber(id)
    
    
    local playerStats = HC:GetPlayerData(src)
    if not playerStats then
        print("hc:core: No player stats found for player ID " .. src)
        return
    end

    local inventory = playerStats.inventory
    local items = playerStats.inventory.items
    local maxWeight = playerStats.inventory.maxWeight

    local totalWeight = 0

    -- Check if the item already exists in the inventory
    for i, item in ipairs(items) do
        local itemName = item[1]
        local itemCount = item[2]

        local itemWeight = HC.Config.Items.GetWeight(itemName)

        totalWeight = totalWeight + (itemWeight*itemCount)
    end

    return totalWeight
end


-- Register the command
RegisterCommand("hc.core.addMoney", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local amount = tonumber(args[2])

    HC.Bank.AddBankMoney(playerId, amount)
end, true)