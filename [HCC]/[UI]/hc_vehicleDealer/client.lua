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
    veh.color = tonumber(veh.color)
    
    TriggerServerEvent('hc:vehDealer:buyVeh', veh)
    cb('ok')
end)

RegisterNetEvent('hc:vehDealer:spawnVeh')
AddEventHandler('hc:vehDealer:spawnVeh', function(vehData)
    local vehModel = vehData.model
    local vehColor = tonumber(vehData.color)

    local playerPed = PlayerPedId()
    local coords = spawnPoint.spawnPoint
    local heading = spawnPoint.heading

    RequestModel(vehModel)

    while not HasModelLoaded(vehModel) do
        Wait(1)
    end

    local vehicle = CreateVehicle(vehModel, coords.x + 5, coords.y + 5, coords.z, heading, true, false)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    -- Set vehicle color
    --local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    
    SetVehicleColours(vehicle, vehColor, vehColor)

    -- Notify server about the spawned vehicle
    TriggerServerEvent('hc:vehDealer:registerVeh', netId, vehData)

    TriggerEvent("hc:hint:show", "You bought " .. vehData.name)
end)

RegisterNUICallback('hide', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)