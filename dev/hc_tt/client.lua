local storedEntity = nil
local storedModel = nil

-- Utility function to convert rotation vector to a direction vector
function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- Function to get the entity the player is currently looking at
function GetEntityPlayerIsLookingAt()
    local playerPed = GetPlayerPed(-1)
    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local direction = RotationToDirection(camRot)

    local distance = 1000.0 -- Maximum distance to check
    local dest = vector3(camCoord.x + direction.x * distance, camCoord.y + direction.y * distance, camCoord.z + direction.z * distance)

    local rayHandle = StartShapeTestRay(camCoord.x, camCoord.y, camCoord.z, dest.x, dest.y, dest.z, -1, playerPed, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    if hit == 1 then
        return entityHit
    else
        return nil
    end
end

-- Event to listen for key press (F7 key has a keycode of 118)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 168) then -- 168 is the keycode for F7
            local entityHit = GetEntityPlayerIsLookingAt()
            storedEntity = entityHit
            if entityHit then
                local entityType = GetEntityType(entityHit)
                if entityType > 0 then
                    local entityModel = GetEntityModel(entityHit)
                    storedModel = entityModel
                    local msg = "Entity hit: " .. entityHit .. " Type: " .. entityType .. " Model: " .. entityModel
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"System", msg}
                    })
                end
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"System", "No entity detected!"}
                })
            end
        elseif IsControlJustReleased(1, 56) then -- F9 key
            print("dupa")
            if storedModel then
                local playerPed = GetPlayerPed(-1)
                local playerCoords = GetEntityCoords(playerPed)
                
                -- Ensure the model is loaded
                RequestModel(storedModel)
                while not HasModelLoaded(storedModel) do
                    Citizen.Wait(0) -- Wait for the model to load
                end
        
                -- Create the object
                if HasModelLoaded(storedModel) then
                    local object = CreateObject(storedModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
                    -- Optionally set the object on the ground properly if needed
                    PlaceObjectOnGroundProperly(object)
                    
                    -- Optional: Set the object as no longer needed for immediate cleanup
                    SetModelAsNoLongerNeeded(storedModel)
        
                    TriggerEvent('chat:addMessage', {
                        color = { 0, 255, 0},
                        multiline = true,
                        args = {"System", "Object created successfully!"}
                    })
                else
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0},
                        multiline = true,
                        args = {"System", "Failed to load model!"}
                    })
                end
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"System", "No model hash stored!"}
                })
            end
        end
    end
end)