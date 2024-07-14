local spawnPoint = nil

RegisterNetEvent('hc:garage:show')
AddEventHandler('hc:garage:show', function(extra)
    spawnPoint = extra
    TriggerServerEvent('hc:garage:show')
end)

RegisterNetEvent('hc:garage:receiveGarageData')
AddEventHandler('hc:garage:receiveGarageData', function(garageData)
    for _, veh in ipairs(garageData) do
        veh.name = GetDisplayNameFromVehicleModel(tonumber(veh.model))
        veh.seats = GetVehicleModelNumberOfSeats(tonumber(veh.model))
        veh.maxSpeed = math.floor(GetVehicleModelMaxSpeed(tonumber(veh.model)) * 3.6 + 0.5)
    end

    SendNUIMessage({
        type = "show",
        vehicles = garageData
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('getVehicle', function(data, cb)
    TriggerServerEvent('hc:garage:getVehicle', data.model, data.key)
    cb('ok')
end)

RegisterNUICallback('hideGarage', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

RegisterNetEvent('hc:garage:spawnVehicle')
AddEventHandler('hc:garage:spawnVehicle', function(data)
    local model = tonumber(data.model)
    local playerPed = PlayerPedId()
    local coords = spawnPoint.spawnPoint
    local heading = spawnPoint.heading
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('hc:garage:registerVehicle', netId, data)

    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    
    TriggerEvent("hc:hint:show", "You retrieved your " .. GetDisplayNameFromVehicleModel(model))
end)