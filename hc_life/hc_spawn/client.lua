local hc = exports.hc_com.hc()

local spawnPoints = {
    {x = -1661.0, y = -1037.0, z = 14.0},
    {x = 227.0, y = 214.0, z = 107.0},
    {x = -1654.0, y = -3145.0, z =  14.0},
    {x = -192.0, y = 6206.0, z = 32.0}
}

-- NUI Callback from JavaScript
RegisterNUICallback('selectSpawn', function(data, cb)
    local spawnIdx = data.spawnIndex
    if spawnPoints[spawnIdx] then
        DisplayRadar(true)
        local pos = spawnPoints[spawnIdx]
        SetEntityCoords(PlayerPedId() , pos.x, pos.y, pos.z, false, false, false, false)
        --hc.com.teleportPlayerToGround(pos.x, pos.y, pos.z)
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'hide'})
    end
    deactivateFixedCamera()
    cb('ok')
end)

local teleportLocation = vector3(-1500.0, -1000.0, 10.0)  -- Change coordinates to your desired location

AddEventHandler('playerSpawned', function()
    DisplayRadar(false)
    SetNuiFocus(true, true)
    activateFixedCamera()
    hc.com.teleportPlayerToGround(teleportLocation.x, teleportLocation.y, teleportLocation.z)
    SendNUIMessage({type = 'show'})
end)

-- Define the fixed camera position and rotation
local fixedCameraPosition = vector3(200.0, -1000.0, 90.0)  -- Example coordinates
local fixedCameraRotation = vector3(0.0, 0.0, 0.0)       -- Example rotation (pitch, roll, yaw)

-- Variable to store the camera
local fixedCamera

-- Function to create and activate the fixed camera
function activateFixedCamera()
    -- Create the camera; `0` denotes default camera type
    fixedCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    -- Set the camera position and rotation
    SetCamCoord(fixedCamera, fixedCameraPosition.x, fixedCameraPosition.y, fixedCameraPosition.z)
    SetCamRot(fixedCamera, fixedCameraRotation.x, fixedCameraRotation.y, fixedCameraRotation.z, 2)
    -- Render the camera
    SetCamActive(fixedCamera, true)
    RenderScriptCams(true, false, 0, true, false)
end


-- Command to switch back to player's normal camera
function deactivateFixedCamera()
    -- Disable the custom camera
    RenderScriptCams(false, false, 0, true, false)
    -- Destroy the camera for good measure
    DestroyCam(fixedCamera, false)
end

