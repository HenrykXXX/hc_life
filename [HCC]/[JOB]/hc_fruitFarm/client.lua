-- Constants
local spawnPos = vector3(340.0, 6522.0, 28.0) -- Fixed spawn position
local spawnRadius = 20.0

-- Draw marker on map
function drawMarker()
    DrawMarker(1, spawnPos.x, spawnPos.y, spawnPos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, spawnRadius * 2.0, spawnRadius * 2.0, 1.5, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
end

-- Add a blip for the Pineapple Farm
function addPineappleFarmBlip()
    local blip = AddBlipForRadius(spawnPos.x, spawnPos.y, spawnPos.z, spawnRadius)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 2) -- Green color
    SetBlipAlpha(blip, 128) -- Semi-transparent
    SetBlipAsShortRange(blip, true)
    
    local areaBlip = AddBlipForCoord(spawnPos.x, spawnPos.y, spawnPos.z)
    SetBlipSprite(areaBlip, 285) -- Change to an appropriate sprite for a fruit farm
    SetBlipDisplay(areaBlip, 4) -- Visible on both minimap and main map
    SetBlipScale(areaBlip, 1.0)
    SetBlipColour(areaBlip, 2) -- Green color
    SetBlipAsShortRange(areaBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pineapple Farm")
    EndTextCommandSetBlipName(areaBlip)
end

-- Initialize blip and marker drawing
CreateThread(function()
    addPineappleFarmBlip()
    while true do
        Wait(0)
        local playerPos = GetEntityCoords(PlayerPedId())
        if #(playerPos - spawnPos) < spawnRadius * 2.0 then
            drawMarker()
        end
    end
end)

-- Event handler for collecting a fruit
RegisterNetEvent('hc:ff:FruitCollected')
AddEventHandler('hc:ff:FruitCollected', function(fruit)
    local fruitEntity = NetworkGetEntityFromNetworkId(fruit)


    TriggerEvent("hc:hint:show", "Collected pineapple.")

    -- Play collection sound
    local fruitPos = GetEntityCoords(fruitEntity)
    PlaySoundFromCoord(-1, "PICK_UP", fruitPos.x, fruitPos.y, fruitPos.z, "HUD_FRONTEND_DEFAULT_SOUNDSET", false, 0, false)
end)



-- not used for now until problem solved --
RegisterNetEvent('hc:ff:disableCollision')
AddEventHandler('hc:ff:disableCollision', function(fruit)
    local entity = NetworkGetEntityFromNetworkId(fruit)
    SetEntityCollision(entity, false, false)
    SetEntityInvincible(entity, true)
end)