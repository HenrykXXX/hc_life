-- Ensure the script runs for every player when they spawn
AddEventHandler('playerSpawned', function()
    local playerPed = PlayerPedId()
    
    local continue = false
	TriggerEvent('skinchanger:loadDefaultModel', true, function()
		continue = true
	end)
	
	while not continue do
		Wait(100)
    end

    TriggerEvent("sc:defaultSkin")
    
    -- Set player ped relationship to prevent friendly fire
    SetPedRelationshipGroupHash(playerPed, GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("PLAYER")) -- 1 = Neutral/Ignore
end)

