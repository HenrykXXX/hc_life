local HC = exports.hc_core.GetHC()

local Config = {
    ShopItems = {
        {itemname = "pineapple", price = 50},
        {itemname = "applecrate", price = 120}
    }
}


-- In the market resource
function processItemSale(src, itemName, amount, price)
    HC:HasItemAmount(src, itemName, amount, function(hasEnough)
        if not hasEnough then
            print("hc:core: Not enough " .. itemName .. " to sell.")
            return
        end

        -- Proceed with the transaction if the item check is successful
        HC:RemoveItem(src, itemName, amount)
        local totalEarnings = price * amount
        --TriggerEvent("hc:core:inventory:addMoney", src, totalEarnings)
        HC:AddMoney(src, totalEarnings)

        TriggerClientEvent("hc:shops:updateMarket", src)
        print("hc:core: Player ID " .. src .. " sold " .. amount .. " " .. itemName .. " for " .. totalEarnings)
    end)
end

RegisterNetEvent('hc:shops:market:sellItem')
AddEventHandler('hc:shops:market:sellItem', function(itemName, amount, cb)
    local src = source

    -- Check if the item is sellable at the market
    local price = nil
    for _, item in ipairs(Config.ShopItems) do
        if item.itemname == itemName then
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
        inventory = HC:GetPlayerData(src).inventory,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney
    })
end)