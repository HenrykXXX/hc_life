-- Ensure the script runs for every player when they spawn
AddEventHandler('playerSpawned', function()
    local playerPed = PlayerPedId()
    
    local model = GetHashKey("mp_m_freemode_01")
        
    -- Request the model
    RequestModel(model)
        
    -- Wait until the model is loaded
    while not HasModelLoaded(model) do
        Wait(1)
    end
        
    -- Set the player model
    SetPlayerModel(PlayerId(), model)
        
    -- Set the player's ped to the new model
    local playerPed = PlayerPedId()
    SetPedDefaultComponentVariation(playerPed)
        
    TriggerServerEvent("hc:core:playerSpawned")
    
    -- Release the model
    SetModelAsNoLongerNeeded(model)

    -- Set player ped relationship to prevent friendly fire
    SetPedRelationshipGroupHash(playerPed, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(1, GetHashKey("PLAYER"), GetHashKey("PLAYER")) -- 3 = Neutral/Ignore

    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, false)
end)

CreateThread(function()
    while true do
        Wait(1000*5)
        TriggerServerEvent("hc:core:player:tick");
    end
end)


