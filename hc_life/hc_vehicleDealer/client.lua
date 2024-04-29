RegisterNetEvent('carDealer:callOpenMenu')
AddEventHandler('carDealer:callOpenMenu', function()
    print("open c")
    TriggerServerEvent("carDealer:getCars")
end)

RegisterNetEvent('carDealer:openMenu')
AddEventHandler('carDealer:openMenu', function(cars)
    print("open c back")
    SendNUIMessage({
        type = "OPEN_MENU",
        cars = cars
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('buyCar', function(data, cb)
    local car = data.car
    TriggerServerEvent('carDealer:buyCar', car)
    cb('ok')
end)

RegisterNetEvent('carDealer:spawnCar')
AddEventHandler('carDealer:spawnCar', function(carModel)
    local playerPed = PlayerPedId()

    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    RequestModel(carModel)

    while not HasModelLoaded(carModel) do
        Wait(1)
    end

    local vehicle = CreateVehicle(carModel, coords.x + 5, coords.y + 5, coords.z, heading, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

RegisterNUICallback('hideCarDealer', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)