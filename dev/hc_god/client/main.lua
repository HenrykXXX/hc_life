RegisterCommand("hcgod", function(_, args)
    local pped = GetPlayerPed(-1)
    SetEntityInvincible(pped, false)

    TriggerServerEvent("hc_god:god")
end)