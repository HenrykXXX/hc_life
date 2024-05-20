-- Trigger this function to request the inventory data from the server
function requestInventoryData()
    TriggerServerEvent('hc:inventory:show')
end

RegisterNUICallback('hideInventory', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

AddEventHandler('hc:inventory:show', function()
    requestInventoryData()
end)

RegisterNetEvent('hc:inventory:receive')
AddEventHandler('hc:inventory:receive', function(inventoryData)
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "show",
        inventory = inventoryData.inventory.items,
        maxWeight = inventoryData.inventory.maxWeight,
        currentWeight = inventoryData.inventory.currentWeight,
        money = inventoryData.money,
        bankMoney = inventoryData.bankMoney
    })
end)