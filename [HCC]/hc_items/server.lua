AddEventHandler('hc:items:consume', function(src, item, value)
    local playerName = GetPlayerName(src) -- Assuming this function exists to get the player's name
    
    if item == 'food' then
        TriggerEvent("hc:core:player:addStat", src, 'food', value)
    elseif item == 'water' then
        TriggerEvent("hc:core:player:addStat", src, 'water', value)
    else
        print(string.format("[UNKNOWN] Player %s consumed an unknown item '%s', with value %d.", playerName, item, value))
    end
end)