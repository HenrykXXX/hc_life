local HC = exports.hc_core.GetHC()

-- server.lua or a script where you define cars
local carsForSale = {
    { carModel = "adder", price = 10000, trunkCapacity = 20 },
    { carModel = "zentorno", price = 25000, trunkCapacity = 10 },
    { carModel = "t20", price = 500000, trunkCapacity = 15 },
    { carModel = "panto", price = 250000, trunkCapacity = 250 }
}

RegisterNetEvent('hc:vehDealer:getCars')
AddEventHandler('hc:vehDealer:getCars', function()
    print("getCars")
    TriggerClientEvent('hc:vehDealer:openMenu', source, carsForSale)
end)

RegisterNetEvent('hc:vehDealer:buyCar')
AddEventHandler('hc:vehDealer:buyCar', function(car)
    local _source = source

    local money = HC:GetMoney(source)
    if money >= car.price then
        HC:RemoveMoney(source, car.price)
        TriggerClientEvent('hc:vehDealer:spawnCar', _source, car.carModel)
    else
        print("not enoguh money")
    end
end)

RegisterNetEvent('hc:vehDealer:registerCar')
AddEventHandler('hc:vehDealer:registerCar', function(veh)
    print(veh)
    HC:AddVehicle(source, veh)
end)