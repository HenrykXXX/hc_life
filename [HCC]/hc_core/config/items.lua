HC.Config.Items = {
    pineapple = {
        name = "Pine Apple",
        model = -845035989,
        basePrice = 50,
        weight = 2,
    },
    pocketsuv = {
        name = "pocketsuv",
        model = -1249748547,
        basePrice = 5000,
        weight = 1,
    },
    applecrate = {
        name = "Apple Crate",
        model = -845035989,
        basePrice = 120,
        weight = 5,
    },
    ironore = {
        name = "Iron Ore",
        model = -845035989,
        basePrice = 120,
        weight = 2,
    },
    ironbar = {
        name = "Iron Bar",
        model = -845035989,
        basePrice = 1200,
        weight = 1,
    },
    jackhammer = {
        name = "Jackhammer",
        model = -1249748547,
        basePrice = 1500,
        weight = 4,
        use = function(src)
            TriggerClientEvent('hc:mine:start', src)
        end
    },
    
    --consumable items
    waterBottle = {
        name = "Water Bottle",
        model = -1249748547,
        basePrice = 10,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'water', 25)
        end
    },
    sandwich = {
        name = "Sandwich",
        model = -1249748547,
        basePrice = 15,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'food', 30)
        end
    },
    apple = {
        name = "Apple",
        model = -1249748547,
        basePrice = 5,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'food', 10)
        end
    },
    energyBar = {
        name = "Energy Bar",
        model = -1249748547,
        basePrice = 8,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'food', 20)
        end
    },
    soda = {
        name = "Soda",
        model = -1249748547,
        basePrice = 12,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'water', 15)
        end
    },
    energyDrink = {
        name = "Energy Drink",
        model = -1249748547,
        basePrice = 20,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'water', 20)
        end
    },
    coffee = {
        name = "Coffee",
        model = -1249748547,
        basePrice = 18,
        weight = 1,
        use = function(src)
            TriggerEvent('hc:items:consume', src, 'water', 10)
        end
    }
}

local function findItem(name)
    return HC.Config.Items[name]
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

function HC.Config.Items.GetName(name)
    local item = findItem(name)
    
    if item then
        return item.name
    else
        return "EPTY STRING"
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


