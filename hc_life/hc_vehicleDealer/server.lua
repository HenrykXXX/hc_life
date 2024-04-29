local HC = exports.hc_core.GetHC()

-- server.lua or a script where you define cars
local carsForSale = {
    { carModel = "adder", price = 10000, trunkCapacity = 20 },
    { carModel = "zentorno", price = 25000, trunkCapacity = 10 },
    { carModel = "t20", price = 500000, trunkCapacity = 15 },
    { carModel = "panto", price = 250000, trunkCapacity = 250 }
}

RegisterNetEvent('carDealer:getCars')
AddEventHandler('carDealer:getCars', function()
    print("getCars")
    TriggerClientEvent('carDealer:openMenu', source, carsForSale)
end)

RegisterNetEvent('carDealer:buyCar')
AddEventHandler('carDealer:buyCar', function(car)
    local _source = source

    local money = HC:GetMoney(source)
    if money >= car.price then
        HC:RemoveMoney(car.price)
        TriggerClientEvent('carDealer:spawnCar', _source, car.carModel)
    else
        print("not enoguh money")
    end
end)