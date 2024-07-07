RegisterNetEvent('hc:processing:start')
AddEventHandler('hc:processing:start', function(extra)
    TriggerServerEvent("hc:processing:start", extra.proc)
end)

RegisterNetEvent('hc:processing:continue')
AddEventHandler('hc:processing:continue', function(continue)
    local pp = GetPlayerPed(-1)
    if not pp then
        return
    end

    if continue then
        TriggerEvent("hc:hint:show", "Melted Iron Ore to Iron Bar.")
        
        local pc = GetEntityCoords(pp)
        PlaySoundFromCoord(-1, "PICK_UP", pc.x, pc.y, pc.z, "HUD_FRONTEND_DEFAULT_SOUNDSET", false, 0, false)
    else
        ClearPedTasks(pp)
    end
end)

