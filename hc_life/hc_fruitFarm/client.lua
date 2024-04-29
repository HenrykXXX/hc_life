-- Constants
local fruitHash = -845035989 -- Pineapple model hash
local spawnPos = vector3(340.0, 6522.0, 28.0) -- Fixed spawn position
local spawnRadius = 20.0
local maxFruits = 50

-- Function to load model
function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

-- Function to spawn a fruit near the spawn position
function spawnFruitNearPosition()
    local angle = math.random() * math.pi * 2
    local radius = math.random() * spawnRadius
    local x = spawnPos.x + radius * math.cos(angle)
    local y = spawnPos.y + radius * math.sin(angle)
    local z = spawnPos.z

    loadModel(fruitHash)
    
    local fruit = CreateObject(fruitHash, x, y, z, false, true, true)
    PlaceObjectOnGroundProperly(fruit)
    return fruit
end

-- Global table to keep track of spawned fruits
local spawnedFruits = {}

-- Function to manage fruit collection and play sound
function manageFruitCollection(fruit)
    CreateThread(function()
        while true do
            Wait(0)
            local playerPos = GetEntityCoords(PlayerPedId())
            local fruitPos = GetEntityCoords(fruit)
            if #(playerPos - fruitPos) < 1.5 then  -- If player is close enough to collect the fruit
                -- Increase the 'appleCrates' stat
                local currentFruits = GetResourceKvpInt("appleCrates") or 0
                SetResourceKvpInt("appleCrates", currentFruits + 1)

                -- Print new fruit count (for debugging)
                print("Collected a fruit! Total now: ", currentFruits + 1)

                -- Play collection sound
                PlaySoundFromCoord(-1, "PICK_UP", fruitPos.x, fruitPos.y, fruitPos.z, "HUD_FRONTEND_DEFAULT_SOUNDSET", false, 0, false)

                -- Delete the fruit
                DeleteObject(fruit)
                TriggerServerEvent('hc:ff:addItem', 'pineapple', 1)
                break  -- Exit the loop once the fruit is collected
            end
        end
    end)
end

-- Main thread for spawning fruits and managing collection
CreateThread(function()
    while true do
        Wait(1000)  -- Wait one second between spawns
        if #spawnedFruits < maxFruits then
            local newFruit = spawnFruitNearPosition()
            table.insert(spawnedFruits, newFruit)
            manageFruitCollection(newFruit)
        end
    end
end)

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