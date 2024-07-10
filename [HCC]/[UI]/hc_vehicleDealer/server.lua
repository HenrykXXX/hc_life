local HC = exports.hc_core.GetHC()

-- server.lua or a script where you define cars
local carsForSale = {
    --panto
    { model = -431692672 }, --panto
    { model = -808831384 }, -- baller
    { model = -2130482718 } --dump
}

RegisterNetEvent('hc:vehDealer:getVehicles')
AddEventHandler('hc:vehDealer:getVehicles', function()
    local vehicles = carsForSale

    local config = HC.Config.Vehicles

    for _, veh in ipairs(carsForSale) do
        veh.price = config.GetPrice(veh.model)
        veh.trunkSpace = config.GetTrunkCapacity(veh.model)
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