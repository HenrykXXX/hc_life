local spawnPoint = nil

AddEventHandler('hc:vehDealer:show', function(extra)
    spawnPoint = extra
    TriggerServerEvent("hc:vehDealer:getVehicles")
end)

RegisterNetEvent('hc:vehDealer:openMenu')
AddEventHandler('hc:vehDealer:openMenu', function(vehs)
    for _, veh in ipairs(vehs) do
        veh.name = GetDisplayNameFromVehicleModel(veh.model)
        veh.seats = GetVehicleModelNumberOfSeats(veh.model)
        veh.maxSpeed = math.floor(GetVehicleModelMaxSpeed(veh.model) * 3.6 + 0.5)
    end

    SendNUIMessage({
        type = "show",
        vehs = vehs
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('buyVeh', function(data, cb)
    local veh = data.veh
    TriggerServerEvent('hc:vehDealer:buyCar', veh)
    cb('ok')
end)

RegisterNetEvent('hc:vehDealer:spawnCar')
AddEventHandler('hc:vehDealer:spawnCar', function(carModel)
    local playerPed = PlayerPedId()

    local coords = spawnPoint.spawnPoint --GetEntityCoords(playerPed)
    local heading = spawnPoint.heading --GetEntityHeading(playerPed)
    
    RequestModel(carModel)

    while not HasModelLoaded(carModel) do
        Wait(1)
    end

    local vehicle = CreateVehicle(carModel, coords.x + 5, coords.y + 5, coords.z, heading, true, false)
    print("veh id " .. vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    print("net id " .. netId)
    TriggerServerEvent('hc:vehDealer:registerCar', netId)

    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

RegisterNUICallback('hide', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)