function openShop()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show'
    })
end

RegisterNUICallback('setHandlingData', function(data, cb)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if vehicle ~= 0 then
        local value = data.value
        local price = 0;
        if type(data.value) == 'number' then
            price = value * value
        elseif type(data.value) == 'table' then
            price = value.x * value.y * value.z
        end
        print(price)
        TriggerServerEvent("hc:tunerShop:buy", price, data)
    end
    cb({})
end)

RegisterNUICallback('hideTunerShop', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- Function to tune the vehicle to maximum specs with an optional engine power multiplier
function maxTuneVehicle(vehicle, multiplier)
    if vehicle then
        -- Set vehicle modifications to maximum
        SetVehicleModKit(vehicle, 0) -- Must be set before any other modification
        for modType = 0, 48 do -- Iterate through all mod types
            local maxModIndex = GetNumVehicleMods(vehicle, modType) - 1
            SetVehicleMod(vehicle, modType, maxModIndex, false)
        end

        SetVehicleTyresCanBurst(vehicle, false) -- Bulletproof tires
        SetVehicleWindowTint(vehicle, 1) -- Window tint

        -- Visual enhancements
        --SetVehicleWheelType(vehicle, 7) -- Wheel type to "Sport"

        -- Apply a custom primary and secondary color
        SetVehicleColours(vehicle, 12, 12) -- Dark Blue

        -- Apply a neon layout with custom colors
        SetVehicleNeonLightsColour(vehicle, 0, 255, 255) -- Cyan
        SetVehicleNeonLightEnabled(vehicle, 0, true) -- Front
        SetVehicleNeonLightEnabled(vehicle, 1, true) -- Back
        SetVehicleNeonLightEnabled(vehicle, 2, true) -- Left
        SetVehicleNeonLightEnabled(vehicle, 3, true) -- Right

        -- Set vehicle's engine power multiplier (for extra speed)
        local engineMultiplier = tonumber(multiplier) or 100.0 -- Default to 20.0 if no multiplier provided
        SetVehicleEnginePowerMultiplier(vehicle, engineMultiplier)

    else
        -- If player is not in a vehicle, this line does nothing or you could add feedback here
    end
end

RegisterNetEvent('hc:tunerShop:receiveUpgrade')
AddEventHandler('hc:tunerShop:receiveUpgrade', function(success, data)
    if success then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if vehicle == 0 then
            print("not in a vehicle")
            return
        end
        local value = data.value
        print(type(value))
        if data.handlingType == 'fEnginePower' then
            maxTuneVehicle(vehicle, ToFloat(value))
            return
        end
        if type(value) == 'number' then
            print("set value: " .. data.handlingType .. " to " .. value)
            SetVehicleHandlingFloat(vehicle, 'CHandlingData', data.handlingType, ToFloat(value))
            print(GetVehicleHandlingFloat(vehicle, 'CHandlingData', data.handlingType))
        elseif type(value) == 'table' then
            print("set value: " .. data.handlingType .. " to " .. vector3(value.x, value.y, value.z))
            SetVehicleHandlingVector(vehicle, 'CHandlingData', data.handlingType, vector3(ToFloat(value.x), ToFloat(value.y), ToFloat(value.z)))
            print(GetVehicleHandlingVector(vehicle, 'CHandlingData', data.handlingType))
        end
    else
        print("not enough money!!!")
    end
end)


AddEventHandler('hc:tunerShop:open', function()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if vehicle ~= 0 then
        openShop()
    end
end)