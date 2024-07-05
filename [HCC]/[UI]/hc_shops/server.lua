local HC = exports.hc_core.GetHC()


-- In the market resource
function processItemSale(src, itemName, amount, price)
    if not HC.Inventory.HasItemAmount(src, itemName, amount) then
        print("not enough items in inventory")
        return
    end

    -- Proceed with the transaction if the item check is successful
    HC.Inventory.RemoveItem(src, itemName, amount)
    local totalEarnings = price * amount
    --TriggerEvent("hc:core:inventory:addMoney", src, totalEarnings)
    HC.Bank.AddMoney(src, totalEarnings)

    TriggerClientEvent("hc:shops:updateMarket", src)
    print("Player ID " .. src .. " sold " .. amount .. " " .. itemName .. " for " .. totalEarnings)
end

RegisterNetEvent('hc:shops:market:sellItem')
AddEventHandler('hc:shops:market:sellItem', function(itemName, amount, shopName)
    local src = source

    local shopItems = HC.Config.Shops.GetItems(shopName)

    -- Check if the item is sellable at the market
    local price = nil
    for _, item in ipairs(shopItems) do
        if item.item == itemName then
            price = item.price
            break
        end
    end

    if not price then
        print("hc:shops: Item " .. itemName .. " cannot be sold at the " .. shopName)
        return
    end

    -- Process the sale through the processItemSale function
    processItemSale(src, itemName, amount, price)
end)

-- Server-side Lua to trigger the inventory display
RegisterNetEvent('hc:shops:showMarket')
AddEventHandler('hc:shops:showMarket', function(name)
    local src = source
    local items = {}

    for _, item in ipairs(HC:GetPlayerData(src).inventory.items) do
        table.insert(items, {
            item = item[1],
            quantity = item[2],
            name = HC.Config.Items.GetName(item[1])
        })
    end

    TriggerClientEvent('hc:shops:receiveInventoryData', src, {
        inventory = items,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney,
        shopItems = HC.Config.Shops.GetItems(name)
    })
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
AddEventHandler('hc:shops:market:buyItem', function(itemName, amount, shopName)
    local src = source
    local shopItems = HC.Config.Shops.GetItems(shopName)

    -- Check if the item is available for purchase at the market
    local price = nil
    for _, item in ipairs(shopItems) do
        if item.item == itemName then
            price = item.price
            break
        end
    end

    if not price then
        print("hc:shops: Item " .. itemName .. " is not available for purchase at the " .. shopName)
        return
    end

    -- Process the purchase through the processItemPurchase function
    processItemPurchase(src, itemName, amount, price)
end)