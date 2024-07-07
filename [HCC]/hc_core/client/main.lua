-- Ensure the script runs for every player when they spawn
AddEventHandler('playerSpawned', function()
    local playerPed = PlayerPedId()
    
    -- Set player ped relationship to prevent friendly fire
    SetPedRelationshipGroupHash(playerPed, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("PLAYER")) -- 1 = Neutral/Ignore
end)

