local HC = exports.hc_core.GetHC()


RegisterNetEvent('hc:garage:show')
AddEventHandler('hc:garage:show', function()
    local src = source

    local vehs = HC.Vehicles.GetPlayerGarage(src)

    TriggerClientEvent('hc:garage:receiveGarageData', src, vehs)
end)

RegisterNetEvent('hc:garage:getVehicle')
AddEventHandler('hc:garage:getVehicle', function(model, id)
    local src = source

    local vehData = HC.Vehicles.Retrieve(id)

    --print("VehData: " .. vehData.model .. " " .. vehData.ownerKey)

    TriggerClientEvent('hc:garage:spawnVehicle', src, vehData)
end)

RegisterNetEvent('hc:garage:registerVehicle')
AddEventHandler('hc:garage:registerVehicle', function(vehicleId, data)
    HC.Vehicles.Register(source, vehicleId,  data)
end)

-- Add the following function to process item purchases
function processItemPurchase(src, itemName, amount, price)
    local totalCost = price * amount
    if HC.Bank.GetMoney(src) < totalCost then
        print("hc:core: Not enough money to buy " .. itemName)
        return
    end

    local added =  HC.Inventory.AddItem(src, itemName, amount)
    if not added then
        print("not enough space in inventory")
        return
    end

    HC.Bank.RemoveMoney(src, totalCost)

    TriggerClientEvent("hc:shops:updateMarket", src)

    print("Player ID " .. src .. " bought " .. amount .. " " .. itemName .. " for " .. totalCost)
end

-- Add the following event handler for item purchases
RegisterNetEvent('hc:shops:market:buyItem')
AddEventHandler('hc:shops:market:buyItem', function(itemName, amount, cb)
    local src = source

    -- Check if the item is available for purchase at the market
    local price = nil
    for _, item in ipairs(Config.ShopItems) do
        if item.name == itemName then
            price = item.price
            break
        end
    end

    if not price then
        print("hc:shops: Item " .. itemName .. " is not available for purchase at the market.")
        return
    end

    -- Process the purchase through the processItemPurchase function
    processItemPurchase(src, itemName, amount, price)
end)