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



