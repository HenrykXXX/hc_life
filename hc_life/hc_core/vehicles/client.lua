-- Add an event handler for the 'E' key press
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 70)
    
        if vehicle ~= 0 and not IsPedInAnyVehicle(playerPed, false) then
            local trunkPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
            local distanceToTrunk = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunkPos.x, trunkPos.y, trunkPos.z, true)

            if distanceToTrunk < 2 then -- Check if player is within 1.5 units of the trunk
                local vehicleClass = GetVehicleClass(vehicle)

                if vehicleClass ~= 8 and vehicleClass ~= 13 and vehicleClass ~= 14 then -- Exclude motorcycles, cycles, and boats
                    if IsControlJustReleased(0, 38) then -- Check if 'E' key is pressed
                        local vehicleDoor = 5 -- Trunk door index

                        if GetVehicleDoorAngleRatio(vehicle, vehicleDoor) > 0 then
                            SetVehicleDoorShut(vehicle, vehicleDoor, false)
                        else
                            SetVehicleDoorOpen(vehicle, vehicleDoor, false, false)
                            TriggerEvent('hc:trunk:show', vehicle)
                        end
                    end
                end
            end
        end
    end
end)