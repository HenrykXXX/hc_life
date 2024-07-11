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

RegisterNetEvent('hc:vehDealer:buyVeh')
AddEventHandler('hc:vehDealer:buyVeh', function(veh)
    local _source = source

    local money = HC.Bank.GetMoney(source)
    if money >= veh.price then
        HC.Bank.RemoveMoney(source, veh.price)
        TriggerClientEvent('hc:vehDealer:spawnVeh', _source, veh)
    else
        print("not enoguh money")
    end
end)

RegisterNetEvent('hc:vehDealer:registerVeh')
AddEventHandler('hc:vehDealer:registerVeh', function(veh, data)
    HC.Vehicles.AddVehicle(source, veh, data)
end)