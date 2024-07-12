AddEventHandler('hc:items:consume', function(src, item, value)
    local playerName = GetPlayerName(src) -- Assuming this function exists to get the player's name
    
    if item == 'food' then
        print(string.format("[FOOD] Player %s consumed food, restoring %d hunger.", playerName, value))
    elseif item == 'water' then
        print(string.format("[WATER] Player %s consumed water, restoring %d thirst.", playerName, value))
    else
        print(string.format("[UNKNOWN] Player %s consumed an unknown item '%s', with value %d.", playerName, item, value))
    end
end)