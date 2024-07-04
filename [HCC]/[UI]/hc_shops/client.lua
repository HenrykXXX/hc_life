local shopName = nil

-- Lua: client.lua
RegisterNUICallback('sellItem', function(data, cb)
    TriggerServerEvent('hc:shops:market:sellItem', data.item, data.quantity, shopName)
    cb('ok')
end)

RegisterNUICallback('buyItem', function(data, cb)
    TriggerServerEvent('hc:shops:market:buyItem', data.item, data.quantity, shopName)
    cb('ok')
end)

RegisterNetEvent('hc:shops:showMarket')
AddEventHandler('hc:shops:showMarket', function(extra)
    shopName = extra.shop

    TriggerServerEvent('hc:shops:showMarket', extra.shop)
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
    shopName = nil
    SetNuiFocus(false, false)
end)