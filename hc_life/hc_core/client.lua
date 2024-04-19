-- local teleportLocation = vector3(1200.0, 5000.0, 110.0)  -- Change coordinates to your desired location
local teleportLocation = vector3(-1500.0, -1000.0, 110.0)  -- Change coordinates to your desired location

AddEventHandler('playerSpawned', function(spawn)
    -- Teleport the player to the specified location after spawning
    teleportPlayerToGround(teleportLocation.x, teleportLocation.y, teleportLocation.z)
end)

RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function()
    -- Teleport the player to the specified location after death (note: might need a delay)
    Citizen.Wait(5000)  -- Delay to ensure player is ready to be teleported, adjust as necessary
    teleportPlayerToGround(teleportLocation.x, teleportLocation.y, teleportLocation.z)
end)

-- Function to teleport player to a position and ensure they are on the ground
function teleportPlayerToGround(x, y, z)
    local ped = PlayerPedId()  -- Get the player's ped
    local groundZ = 0.0
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z + 999.0, 0)  -- Attempt to find the ground level
    if foundGround then
        SetEntityCoords(ped, x, y, groundZ + 1.0, false, false, false, true)  -- Place the player at the ground level
    else
        SetEntityCoords(ped, x, y, z, false, false, false, true)  -- Use the provided Z if ground not found
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- Adjust timing based on performance needs

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local peds = GetNearbyPeds(pos.x, pos.y, pos.z, 60.0) -- Adjust the radius as needed

        for i = 1, #peds do
            local ped = peds[i]
            pos = GetEntityCoords(ped)
            GiveWeaponToPed(ped, `WEAPON_CARBINERIFLE`, 300, false, true)
            if not IsPedAPlayer(ped) then
                local pedGroup = GetPedRelationshipGroupHash(ped)
                if pedGroup ~= `HATES_EVERYONE` then
                    SetPedRelationshipGroupHash(ped, `HATES_EVERYONE`)
                end

                -- Find the nearest target for each ped
                local nearestPed = nil
                local shortestDistance = math.huge  -- Initialize with a very large number
                for j = 1, #peds do
                    if i ~= j then
                        local targetPed = peds[j]
                        local targetPos = GetEntityCoords(targetPed)
                        local distance = Vdist(pos.x, pos.y, pos.z, targetPos.x, targetPos.y, targetPos.z)
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPed = targetPed
                        end
                    end
                end
            
                if nearestPed then
                    TaskCombatPed(ped, nearestPed, 0, 16)
                end
            end
        end
    end
end)

function GetNearbyPeds(x, y, z, radius)
    local peds = {}
    local handle, ped = FindFirstPed()
    local success
    repeat
        success, ped = FindNextPed(handle)
        if DoesEntityExist(ped) and IsPedHuman(ped) and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            if Vdist(x, y, z, pedCoords.x, pedCoords.y, pedCoords.z) <= radius then
                table.insert(peds, ped)
            end
        end
    until not success
    EndFindPed(handle)
    return peds
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- This runs every frame
        SetPedDensityMultiplierThisFrame(1.0)  -- Max pedestrian density
        SetVehicleDensityMultiplierThisFrame(1.0)  -- Max vehicle density
        SetRandomVehicleDensityMultiplierThisFrame(1.0)  -- Max random vehicles
        SetParkedVehicleDensityMultiplierThisFrame(1.0)  -- Max parked vehicles
        SetScenarioPedDensityMultiplierThisFrame(1.0, 1.0) -- Normal and special peds
    end
end)

