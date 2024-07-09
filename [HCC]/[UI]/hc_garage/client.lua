local spawnPoint = nil

-- Lua: client.lua
RegisterNUICallback('getVehicle', function(data, cb)
    TriggerServerEvent('hc:garage:getVehicle', data.model, data.key)
    cb('ok')
end)

RegisterNetEvent('hc:garage:show')
AddEventHandler('hc:garage:show', function(extra)
    spawnPoint = extra
    TriggerServerEvent('hc:garage:show')
end)

RegisterNetEvent('hc:garage:receiveGarageData')
AddEventHandler('hc:garage:receiveGarageData', function(garageData)
    SetNuiFocus(true, true)
    
    for _, veh in ipairs(garageData) do
        local name = GetDisplayNameFromVehicleModel(tonumber(veh.model))
        veh.name = name
    end
    print(garageData[1].name)

    
    SendNUIMessage({
        type = "show",
        vehicles = garageData,
    })
end)

RegisterNUICallback('hideGarage', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

RegisterNetEvent('hc:garage:spawnVehicle')
AddEventHandler('hc:garage:spawnVehicle', function(data)
    local model = tonumber(data.model)
    
    local playerPed = PlayerPedId()

    local coords = spawnPoint.spawnPoint --GetEntityCoords(playerPed)
    local heading = spawnPoint.heading --GetEntityHeading(playerPed)
    
    RequestModel(tonumber(model))

    while not HasModelLoaded(tonumber(model)) do
        Wait(1)
    end

    local vehicle = CreateVehicle(tonumber(model), coords.x , coords.y, coords.z, heading, true, false)
    print("veh id " .. vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    print("net id " .. netId)
    TriggerServerEvent('hc:garage:registerVehicle', netId, data)

    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)