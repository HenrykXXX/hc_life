Citizen.CreateThread(function()
    -- Configuration array for NPCs
    local npcs = {
        {npcName = "Market Vendor", npcEvent = "hc:shops:showMarket", npcModel = `a_m_m_business_01`, npcCoords = vector3(-192.0, 6212.0, 31.5), npcHeading = 180.0},
        {npcName = "Weapon Selector", npcEvent = "hc:showWeaponSelector", npcModel = `a_f_m_business_02`, npcCoords = vector3(-200.0, 6204.0, 31.5), npcHeading = 360.0},
        {npcName = "Car Dealer", npcEvent = "hc:vehDealer:callOpenMenu", npcModel = `a_f_m_business_02`, npcCoords = vector3(-205.0, 6199.0, 31.5), npcHeading = 360.0},
        
         -- Add more NPCs in the same format
    }

    -- Load and spawn each NPC from the configuration, and create map markers
    for _, npc in pairs(npcs) do
        -- Ensure the model is loaded
        RequestModel(npc.npcModel)
        while not HasModelLoaded(npc.npcModel) do
            Wait(100)
        end

        -- Create the NPC
        local ped = CreatePed(4, npc.npcModel, npc.npcCoords.x, npc.npcCoords.y, npc.npcCoords.z - 1.0, npc.npcHeading, false, true)
        FreezeEntityPosition(ped, true)  -- NPC won't move
        SetEntityInvincible(ped, true)  -- NPC won't die
        SetBlockingOfNonTemporaryEvents(ped, true)  -- NPC won't react to the environment

        SetPedFleeAttributes(ped, 0, 0)  -- NPC won't flee.
        SetPedCombatAttributes(ped, 46, true)  -- NPC won't engage in combat.
        SetPedSeeingRange(ped, 0.0)  -- NPC won't react to sight.
        SetPedHearingRange(ped, 0.0)  -- NPC won't react to sounds.
        
        -- Create a blip on the map for the NPC
        local blip = AddBlipForCoord(npc.npcCoords.x, npc.npcCoords.y, npc.npcCoords.z)
        SetBlipSprite(blip, 280) -- Icon style (change as needed)
        SetBlipDisplay(blip, 4) -- Appears on both minimap and main map
        SetBlipScale(blip, 0.8) -- Size of the blip
        SetBlipColour(blip, 2) -- Blip color
        SetBlipAsShortRange(blip, true) -- Only show when nearby
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(npc.npcName)
        EndTextCommandSetBlipName(blip)
    end

    -- Check for player interaction with any NPC
    while true do
        for _, npc in pairs(npcs) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - npc.npcCoords)
            if dist < 2.5 then  -- Interaction distance
                DrawText3D(npc.npcCoords.x, npc.npcCoords.y, npc.npcCoords.z + 1.0, "[E] Interact with " .. npc.npcName)

                if IsControlJustReleased(1, 51) then  -- E key
                    print(npc.npcEvent)
                    TriggerEvent(npc.npcEvent)  -- Triggering the configured event
                end
            end
        end
        Wait(5)
    end
end)

-- Function to display text on the screen
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end