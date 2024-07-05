local HC = exports.hc_core.GetHC()


RegisterNetEvent('hc:garage:show')
AddEventHandler('hc:garage:show', function()
    local src = source

    local vehs = HC.Vehicles.GetPlayerGarage(src)

    TriggerClientEvent('hc:garage:receiveGarageData', src, vehs)
end)

RegisterNetEvent('hc:garage:getVehicle')
AddEventHandler('hc:garage:getVehicle', function(model, id)
    local src = source

    local vehData = HC.Vehicles.Retrieve(id)

    --print("VehData: " .. vehData.model .. " " .. vehData.ownerKey)

    TriggerClientEvent('hc:garage:spawnVehicle', src, vehData)
end)

RegisterNetEvent('hc:garage:registerVehicle')
AddEventHandler('hc:garage:registerVehicle', function(vehicleId, data)
    HC.Vehicles.Register(source, vehicleId,  data)
end)

