-- Lua: client.lua
RegisterNUICallback('sellItem', function(data, cb)
    TriggerServerEvent('hc:shops:market:sellItem', data.item, data.quantity)
    cb('ok')
end)

RegisterNetEvent('hc:shops:showMarket')
AddEventHandler('hc:shops:showMarket', function()
    TriggerServerEvent('hc:shops:showMarket')
end)

RegisterNetEvent('hc:shops:updateMarket')
AddEventHandler('hc:shops:updateMarket', function()
    print("update")
    TriggerServerEvent('hc:shops:showMarket')
end)

RegisterNetEvent('hc:shops:receiveInventoryData')
AddEventHandler('hc:shops:receiveInventoryData', function(inventoryData)
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "show",
        inventory = inventoryData.inventory,
        money = inventoryData.money,
        bankMoney = inventoryData.bankMoney,
        shopItems = inventoryData.shopItems
    })
end)

RegisterNUICallback('hideMarket', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)