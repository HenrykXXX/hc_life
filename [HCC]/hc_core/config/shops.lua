HC.Config.Shops = {
    {
        name = "market",
        items = {
            "pineapple",
            "applecrate"
        }
    },
    {
        name = "iron",
        items = {
            "ironore",
            "ironbar",
            "jackhammer"
        }
    },
}

local function findShop(name)
    for _, shop in ipairs(HC.Config.Shops) do
        if shop.name == name then
            return shop -- Return item
        end
    end
    return nil -- Return nil if  no item in config
end

function HC.Config.Shops.GetItems(name)
    local shop = findShop(name)

    if shop then
        local ret = {}
        for _, item in ipairs(shop.items) do
            print(item)
            table.insert(ret, {name = item, price = HC.Config.Items.GetPrice(item)})
        end
        return ret
    else
        return nil
    end
end
