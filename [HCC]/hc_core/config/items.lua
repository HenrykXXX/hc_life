HC.Config.Items = {
    {
        name = "pineapple",
        model = -845035989,
        basePrice = 50,
        weight = 2,
    },
    {
        name = "pocketsuv",
        model = -1249748547,
        basePrice = 5000,
        weight = 1,
    },
    {
        name = "applecrate",
        model = -845035989,
        basePrice = 120,
        weight = 5,
    },
    {
        name = "ironore",
        model = -845035989,
        basePrice = 120,
        weight = 2,
    },
    {
        name = "ironbar",
        model = -845035989,
        basePrice = 1200,
        weight = 1,
    },
    {
        name = "jackhammer",
        model = -1249748547,
        basePrice = 1500,
        weight = 4,
        use = function(src)
            TriggerClientEvent('hc:mine:start', src)
        end
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

function HC.Config.Items.GetUse(name)
    local item = findItem(name)

    if item then
        return item.use
    else
        return nil
    end
end


