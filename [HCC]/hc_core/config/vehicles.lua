HC.Config.Vehicles = {
    {
        --panto
        model = -431692672,
        basePrice = 5000,
        trunkCapacity = 48,
    },
    {
        --baller
        model = -808831384,
        basePrice = 15000,
        trunkCapacity = 96,
    },
    {
        --dump
        model = -2130482718,
        basePrice = 500000,
        trunkCapacity = 480,
    }
}

function HC.Config.Vehicles.GetPrice(model)
    local price = 0

    for _, veh in ipairs(HC.Config.Vehicles) do
        if veh.model == model then
            price = veh.basePrice
            break
        end
    end

    return price
end

function HC.Config.Vehicles.GetTrunkCapacity(model)
    local capacity = 0

    for _, veh in ipairs(HC.Config.Vehicles) do
        if veh.model == model then
            capacity = veh.trunkCapacity
            break
        end
    end

    return capacity
end

