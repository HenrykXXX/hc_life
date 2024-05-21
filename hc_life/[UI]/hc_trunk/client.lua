local currentVehicle = 0

RegisterNetEvent('hc:trunk:show')
AddEventHandler('hc:trunk:show', function(vehicle)
    local vehNetId = NetworkGetNetworkIdFromEntity(vehicle)
    currentVehicle = vehNetId
    TriggerServerEvent('hc:trunk:show', vehNetId)
end)

RegisterNetEvent('hc:trunk:receiveInventoryData')
AddEventHandler('hc:trunk:receiveInventoryData', function(data)
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "show",
        inventory = data.inventory,
        trunk = data.trunk
    })
end)

RegisterNUICallback('hideTrunk', function(data, cb)
    cb('ok')
    currentVehicle = 0
    SetNuiFocus(false, false)
end)

RegisterNUICallback('getTrunkItem', function(data, cb)
    cb('ok')
    TriggerServerEvent('hc:trunk:getTrunkItem', {
        vehicle = currentVehicle,
        item = data.item,
        amount = data.amount
    })
end)

RegisterNUICallback('storePlayerItem', function(data, cb)
    cb('ok')
    TriggerServerEvent('hc:trunk:storePlayerItem', {
        vehicle = currentVehicle,
        item = data.item,
        amount = data.amount
    })
end)