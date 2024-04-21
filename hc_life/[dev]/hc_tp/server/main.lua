RegisterNetEvent("hc_tp:tpto", function(target)
    local playerId = source
    local playerPed = GetPlayerPed(playerId)
    local targetPed = GetPlayerPed(target)
    local targetPos = GetEntityCoords(targetPed)
    

    if targetPed < 1 then
        return
    end

    SetEntityCoords(playerPed, targetPos)

end)