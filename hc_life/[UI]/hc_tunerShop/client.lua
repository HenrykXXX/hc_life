RegisterCommand('handlingeditor', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show'
    })
end)

RegisterNUICallback('setHandlingData', function(data, cb)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if vehicle ~= 0 then
        print("player in vehicle")
        print("setting " .. data.handlingType .. " to " .. data.value)
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', data.handlingType, data.value)
    end
    cb({})
end)

RegisterNUICallback('hideTunerShop', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)