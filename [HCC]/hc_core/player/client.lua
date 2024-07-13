RegisterNetEvent("hc:core:player:updateStats")
AddEventHandler("hc:core:player:updateStats", function(stats)
    TriggerEvent("hc:hud:updateStats", stats)
end)