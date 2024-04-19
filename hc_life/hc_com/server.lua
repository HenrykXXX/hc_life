local hc = {}
hc.com = {}

hc.com.teleportPlayerToGround = function(playerId, x, y, z)
    local ped = GetPlayerPed(playerId)  -- Get the player's ped
    local groundZ = 0.0
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z + 999.0, 0)  -- Attempt to find the ground level
    if foundGround then
        SetEntityCoords(ped, x, y, groundZ + 1.0, false, false, false, true)  -- Place the player at the ground level
    else
        SetEntityCoords(ped, x, y, z, false, false, false, true)  -- Use the provided Z if ground not found
    end
end

exports('hc', function()
    return hc
end)