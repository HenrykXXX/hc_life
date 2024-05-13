local HC = exports.hc_core.GetHC()

-- server.lua or a script where you define cars
local carsForSale = {
    { model = "panto" },
}

RegisterNetEvent('hc:vehDealer:getCars')
AddEventHandler('hc:vehDealer:getCars', function()
    local vehicles = carsForSale

    for _, veh in ipairs(carsForSale) do
        veh.price = HC.Config.Vehicles.GetPrice(veh.model)
    end
    TriggerClientEvent('hc:vehDealer:openMenu', source, vehicles)
end)

RegisterNetEvent('hc:vehDealer:buyCar')
AddEventHandler('hc:vehDealer:buyCar', function(car)
    local _source = source

    local money = HC.Bank.GetMoney(source)
    if money >= car.price then
        HC.Bank.RemoveMoney(source, car.price)
        TriggerClientEvent('hc:vehDealer:spawnCar', _source, car.model)
    else
        print("not enoguh money")
    end
end)

RegisterNetEvent('hc:vehDealer:registerCar')
AddEventHandler('hc:vehDealer:registerCar', function(veh)
    HC.Vehicles.AddVehicle(source, veh)
end)