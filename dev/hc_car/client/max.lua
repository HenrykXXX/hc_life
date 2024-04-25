
-- Function to tune the vehicle to maximum specs with an optional engine power multiplier
function maxTuneVehicle(multiplier)
    local playerPed = PlayerPedId() -- Get the player's Ped
    local vehicle = GetVehiclePedIsIn(playerPed, false) -- Get the vehicle the player is in
    
    if vehicle and IsPedInAnyVehicle(playerPed, false) then
        -- Set vehicle modifications to maximum
        SetVehicleModKit(vehicle, 0) -- Must be set before any other modification
        for modType = 0, 48 do -- Iterate through all mod types
            local maxModIndex = GetNumVehicleMods(vehicle, modType) - 1
            SetVehicleMod(vehicle, modType, maxModIndex, false)
        end

        SetVehicleTyresCanBurst(vehicle, false) -- Bulletproof tires
        SetVehicleWindowTint(vehicle, 1) -- Window tint

        -- Visual enhancements
        SetVehicleWheelType(vehicle, 7) -- Wheel type to "Sport"

        -- Apply a custom primary and secondary color
        SetVehicleColours(vehicle, 12, 12) -- Dark Blue

        -- Apply a neon layout with custom colors
        SetVehicleNeonLightsColour(vehicle, 0, 255, 255) -- Cyan
        SetVehicleNeonLightEnabled(vehicle, 0, true) -- Front
        SetVehicleNeonLightEnabled(vehicle, 1, true) -- Back
        SetVehicleNeonLightEnabled(vehicle, 2, true) -- Left
        SetVehicleNeonLightEnabled(vehicle, 3, true) -- Right

        -- Set vehicle's engine power multiplier (for extra speed)
        local engineMultiplier = tonumber(multiplier) or 20.0 -- Default to 20.0 if no multiplier provided
        SetVehicleEnginePowerMultiplier(vehicle, engineMultiplier)
    else
        -- If player is not in a vehicle, this line does nothing or you could add feedback here
    end
end

-- Register the 'max' command
RegisterCommand('max', function(source, args, rawCommand)
    local multiplier = args[1] -- Get the first argument as multiplier
    maxTuneVehicle(multiplier)
end, false)