HC.Config.Items = {
    {
        name = "pineapple",
        model = -845035989,
        basePrice = 50,
        weight = 2,
    },
    {
        name = "pocketsuv",
        model = -845035989,
        basePrice = 5000,
        weight = 1,
    },
    {
        name = "applecrate",
        model = -845035989,
        basePrice = 120,
        weight = 5,
    },
}

local function findItem(name)
    for _, item in ipairs(HC.Config.Items) do
        if item.name == name then
            return item -- Return item
        end
    end
    return nil -- Return nil if  no item in config
end

function HC.Config.Items.GetPrice(name)
    local item = findItem(name)

    if item then
        return item.basePrice
    else
        return 0
    end
end

function HC.Config.Items.GetWeight(name)
    local item = findItem(name)

    if item then
        return item.weight
    else
        return 0
    end
end

