RegisterNetEvent('hc:vehDealer:callOpenMenu')
AddEventHandler('hc:vehDealer:callOpenMenu', function()
    TriggerServerEvent("hc:vehDealer:getCars")
end)

RegisterNetEvent('hc:vehDealer:openMenu')
AddEventHandler('hc:vehDealer:openMenu', function(cars)
    SendNUIMessage({
        type = "OPEN_MENU",
        cars = cars
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('buyCar', function(data, cb)
    local car = data.car
    TriggerServerEvent('hc:vehDealer:buyCar', car)
    cb('ok')
end)

RegisterNetEvent('hc:vehDealer:spawnCar')
AddEventHandler('hc:vehDealer:spawnCar', function(carModel)
    local playerPed = PlayerPedId()

    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
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

RegisterNUICallback('hideCarDealer', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)