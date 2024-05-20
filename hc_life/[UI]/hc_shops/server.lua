local HC = exports.hc_core.GetHC()

local Config = {
    ShopItems = {
        {name = "pineapple", price = 200000},
        {name = "applecrate", price = 120}
    }
}


-- In the market resource
function processItemSale(src, itemName, amount, price)
    HC.Inventory.HasItemAmount(src, itemName, amount, function(hasEnough)
        if not hasEnough then
            print("hc:core: Not enough " .. itemName .. " to sell.")
            return
        end

        -- Proceed with the transaction if the item check is successful
        HC.Inventory.RemoveItem(src, itemName, amount)
        local totalEarnings = price * amount
        --TriggerEvent("hc:core:inventory:addMoney", src, totalEarnings)
        HC.Bank.AddMoney(src, totalEarnings)

        TriggerClientEvent("hc:shops:updateMarket", src)
        print("Player ID " .. src .. " sold " .. amount .. " " .. itemName .. " for " .. totalEarnings)
    end)
end

RegisterNetEvent('hc:shops:market:sellItem')
AddEventHandler('hc:shops:market:sellItem', function(itemName, amount, cb)
    local src = source

    -- Check if the item is sellable at the market
    local price = nil
    for _, item in ipairs(Config.ShopItems) do
        if item.name == itemName then
            price = item.price
            break
        end
    end

    if not price then
        print("hc:shops: Item " .. itemName .. " cannot be sold at the market.")
        return
    end

    -- Process the sale through the processItemSale function
    processItemSale(src, itemName, amount, price)
end)

-- Server-side Lua to trigger the inventory display
RegisterNetEvent('hc:shops:showMarket')
AddEventHandler('hc:shops:showMarket', function()
    local src = source

    TriggerClientEvent('hc:shops:receiveInventoryData', src, {
        inventory = HC:GetPlayerData(src).inventory.items,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney,
        shopItems = Config.ShopItems
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