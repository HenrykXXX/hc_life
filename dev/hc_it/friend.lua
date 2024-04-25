
-- Register a command that players can use to spawn the NPC
RegisterCommand('sf', function(source, args, rawCommand)
    -- Get the player's ped and current coordinates
    local player = GetPlayerPed(-1)
    local px, py, pz = table.unpack(GetEntityCoords(player, true))
    
    -- Define the model for the NPC
    local npcModel = GetHashKey("a_m_m_business_01")
    
    -- Request the model
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(1)
    end

    -- Create the ped (NPC) a few meters away from the player
    local npc = CreatePed(4, npcModel, px + 2, py + 2, pz, 0.0, true, false)
    
    -- Set the NPC to be friendly
    SetPedFleeAttributes(npc, 0, 0)
    SetPedAsEnemy(npc, false)
    SetPedRelationshipGroupHash(npc, GetHashKey("PLAYER"))
    
    -- Make NPC follow the player
    TaskFollowToOffsetOfEntity(npc, player, 0.0, 0.0, 2.0, 5.0, -1, 1.0, true)

    -- Ensure the NPC model is unloaded after use to save resources
    SetModelAsNoLongerNeeded(npcModel)
end, false)

-- Register a command that players can use to spawn the NPC
RegisterCommand('sp', function(source, args, rawCommand)
    -- Get the player's ped and current coordinates
    local player = GetPlayerPed(-1)
    local px, py, pz = table.unpack(GetEntityCoords(player, true))
    
    -- Define the model for the NPC
    local npcModel = GetHashKey("a_m_y_genstreet_02")
    
    -- Request the model
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(1)
    end
    
    -- Create the ped (NPC) a few meters away from the player
    local npc = CreatePed(4, npcModel, px + 2, py + 2, pz, 0.0, true, false)
    
    -- Set the NPC to be friendly to the player but hostile to others
    SetPedFleeAttributes(npc, 0, 0)
    SetPedAsEnemy(npc, false)
    local playerGroupId = GetHashKey("PLAYER")
    local enemyGroupId = GetHashKey("AMBIENT_GANG_LOST")
    SetPedRelationshipGroupHash(npc, playerGroupId)
    
    -- Define relationship between the NPC and other NPCs
    SetRelationshipBetweenGroups(5, enemyGroupId, playerGroupId)
    SetRelationshipBetweenGroups(5, playerGroupId, enemyGroupId)
    SetRelationshipBetweenGroups(1, playerGroupId, playerGroupId)

    -- Make NPC hostile and arm it
    GiveWeaponToPed(npc, GetHashKey("WEAPON_PISTOL"), 255, true, true)
    TaskCombatHatedTargetsAroundPed(npc, 30.0, 0)
    
    -- Ensure the NPC model is unloaded after use to save resources
    SetModelAsNoLongerNeeded(npcModel)
end, false)

function spawnRegularNPC()
    local player = GetPlayerPed(-1)
    local px, py, pz = table.unpack(GetEntityCoords(player, true))
    local npcModel = GetHashKey("a_m_y_skater_01")
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(1)
    end
    local npc = CreatePed(4, npcModel, px + 2, py + 2, pz, 0.0, true, false)
    SetPedFleeAttributes(npc, 0, 0)
    SetPedAsEnemy(npc, false)
    SetPedCanRagdoll(npc, true)
    SetModelAsNoLongerNeeded(npcModel)
end


Citizen.CreateThread(function()
    while true do
        SpawnRegularNPC()
        Citizen.Wait(1000)  -- Delay of 1000 milliseconds (1 second)
    end
end)
