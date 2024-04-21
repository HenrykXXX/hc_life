RegisterNetEvent("hc_god:god", function()
    local playerPed = GetPlayerPed(source)

    if GetPlayerInvincible(source) then
        TriggerClientEvent("chat:addMessage", -1, "has god")
    else
        TriggerClientEvent("chat:addMessage", -1, "no god")
    end
end)