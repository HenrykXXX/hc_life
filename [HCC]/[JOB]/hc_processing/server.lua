local HC = exports.hc_core.GetHC()

-- Function to process an item
local function processItem(playerId, item)
    local config = HC.Config.Processing.GetData(item)
    
    if not config then
        print("No processing configuration found for item " .. itemName)
        return false
    end
    
    if HC.Inventory.HasItemAmount(playerId, item, config.amountRequired) then
        -- Remove the required amount of the raw item
        HC.Inventory.RemoveItem(playerId, item, config.amountRequired)
        
        -- Add the produced item to the inventory
        HC.Inventory.AddItem(playerId, config.result, config.amountProduced)
        
        print("Processed " .. config.amountRequired .. " " .. item .. " to " .. config.amountProduced .. " " .. config.result .. " for player ID " .. playerId)
        return true
    else
        print("hc:core: Player ID " .. playerId .. " does not have enough " .. itemName .. " to process.")
        return false
    end
end

RegisterNetEvent('hc:processing:start')
AddEventHandler('hc:processing:start', function(proc)
    local src = source

    if processItem(src, proc) then
        TriggerClientEvent('hc:processing:continue', src, true)
    end
end)