local hc = exports.hc_com.hc()

local spawnPoints = {
    {x = 200.0, y = 200.0, z = 20.0},
    {x = 300.0, y = 300.0, z = 20.0},
    {x = 400.0, y = 400.0, z = 20.0},
    {x = 1200.0, y = 5000.0, z = 20.0}
}

-- NUI Callback from JavaScript
RegisterNUICallback('selectSpawn', function(data, cb)
    local spawnIdx = data.spawnIndex
    if spawnPoints[spawnIdx] then
        local pos = spawnPoints[spawnIdx]
        hc.com.teleportPlayerToGround(pos.x, pos.y, pos.z)
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'hide'})
    end
    cb('ok')
end)

local teleportLocation = vector3(-1500.0, -1000.0, 10.0)  -- Change coordinates to your desired location

AddEventHandler('playerSpawned', function()
    hc.com.teleportPlayerToGround(teleportLocation.x, teleportLocation.y, teleportLocation.z)
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'show'})
end)