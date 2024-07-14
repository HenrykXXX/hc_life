local HC = exports.hc_core.GetHC()

RegisterNetEvent('hc:garage:show')
AddEventHandler('hc:garage:show', function()
    local src = source
    local vehs = HC.Vehicles.GetPlayerGarage(src)
    print(type(vehs[1].model))
    for _, veh in ipairs(vehs) do
        local config = HC.Config.Vehicles
        veh.trunkSpace = config.GetTrunkCapacity(tonumber(veh.model))
    end

    TriggerClientEvent('hc:garage:receiveGarageData', src, vehs)
end)

RegisterNetEvent('hc:garage:getVehicle')
AddEventHandler('hc:garage:getVehicle', function(model, id)
    local src = source
    local vehData = HC.Vehicles.Retrieve(id)

    if vehData then
        TriggerClientEvent('hc:garage:spawnVehicle', src, vehData)
    else
        -- Handle error: vehicle not found
        print("Vehicle not found: " .. id)
    end
end)

RegisterNetEvent('hc:garage:registerVehicle')
AddEventHandler('hc:garage:registerVehicle', function(vehicleId, data)
    HC.Vehicles.Register(source, vehicleId, data)
end)