local hc = {}
hc.com = {}

hc.com.teleportPlayerToGround = function(x, y, z)
    local playerPed = PlayerPedId()  -- Get the player ped

    -- Start from a high altitude and move downward to find the ground
    local testZ = 1000.0
    local foundGround, groundZ = false, 0.0

    while not foundGround and testZ > 0 do
        foundGround, groundZ = GetGroundZFor_3dCoord(x, y, testZ, false)
        testZ = testZ - 10  -- Decrease Z and check again
        Wait(50)  -- Wait a short duration to allow the game to process
    end

    if foundGround then
        -- If ground was found, teleport to the exact ground Z coordinate
        SetPedCoordsKeepVehicle(playerPed, x, y, groundZ)
        print("Teleported to ground level!")
    else
        -- If no ground was detected, teleport to the original Z or a safe default altitude
        SetPedCoordsKeepVehicle(playerPed, x, y, z)  -- Use the provided Z if ground not found
        print("Teleported to provided altitude; ground level not detected.")
    end
end

exports('hc', function()
    return hc
end)