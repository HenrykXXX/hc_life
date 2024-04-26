-- Client-side script: client.lua

-- Function to request player stats from the server
function requestPlayerStats()
    TriggerServerEvent('hc:core:getPlayerStats')
end

-- Listen for server response with player stats
RegisterNetEvent('hc:core:receivePlayerStats')
AddEventHandler('hc:core:receivePlayerStats', function(stats)
    print("Received player stats from server:")
    print("Money: $" .. tostring(stats.money))
    print("Bank Money: $" .. tostring(stats.bankMoney))
    print("Inventory Items: " .. #stats.inventory)
    print("Licenses: " .. #stats.licenses)
    -- Additional display or processing can be done here
end)

-- Function to send updated stats to the server
function updatePlayerStats(newStats)
    TriggerServerEvent('hc:core:updatePlayerStats', newStats)
end

-- Register command to get stats
RegisterCommand('hc.core.getStats', function()
    requestPlayerStats()
end, false)  -- false indicates this command does not require admin rights

-- Trigger this function to request the inventory data from the server
function requestInventoryData()
    print("client show")
    TriggerServerEvent('hc:core:inventory:show')
end

RegisterNUICallback('hideInventory', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

RegisterNetEvent('hc:core:showInventory')
AddEventHandler('hc:core:showInventory', function()
    requestInventoryData()
end)

RegisterNetEvent('hc:core:receiveInventoryData')
AddEventHandler('hc:core:receiveInventoryData', function(inventoryData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show",
        inventory = inventoryData.inventory,
        money = inventoryData.money,
        bankMoney = inventoryData.bankMoney
    })
end)