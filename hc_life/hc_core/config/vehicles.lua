HC.Config.Vehicles = {
    {
        model = "panto",
        basePrice = 5000,
        trunkCapacity = 250,
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

RegisterCommand("hc.getPrice", function(_, args)
    local car = args[1]

    if car then
        local price = HC.Config.Vehicles.GetPrice(car)
        print("Price of " .. car .. ": $" .. price)
    else
        print("Please provide a vehicle model as an argument.")
    end
end)