RegisterCommand("sellItem", function(source, args, rawCommand)
    -- args[1] should be the item name
    -- args[2] should be the amount to sell
    if #args < 2 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", "Usage: /sellItem [itemName] [amount]"}
        })
        return
    end

    local itemName = args[1]
    local amount = tonumber(args[2])

    if not amount or amount <= 0 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", "Please enter a valid amount."}
        })
        return
    end

    -- Trigger the server event to handle the item sale
    TriggerServerEvent('hc:shops:market:sellItem', itemName, amount)
end, false)  -- false means the command is not restricted to admins

-- Lua: client.lua
RegisterNUICallback('sellItem', function(data, cb)
    TriggerServerEvent('hc:shops:market:sellItem', data.item, data.quantity)
    cb('ok')
end)

RegisterNetEvent('hc:shops:showMarket')
AddEventHandler('hc:shops:showMarket', function()
    print("showmarekt")
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
    print("recieved")
    SendNUIMessage({
        type = "show",
        inventory = inventoryData.inventory,
        money = inventoryData.money,
        bankMoney = inventoryData.bankMoney
    })
end)

RegisterNUICallback('hideMarket', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)