local hc = exports.hc_com.hc()

local spawnPoints = {
    {x = -1661.0, y = -1037.0, z = 14.0},
    {x = 227.0, y = 214.0, z = 107.0},
    {x = 1695.0, y = 4935.0, z = 43.0},
    {x = -192.0, y = 6206.0, z = 32.0}
}

-- NUI Callback from JavaScript
RegisterNUICallback('selectSpawn', function(data, cb)
    local spawnIdx = data.spawnIndex
    if spawnPoints[spawnIdx] then
        local pos = spawnPoints[spawnIdx]
        SetEntityCoords(PlayerPedId() , pos.x, pos.y, pos.z, false, false, false, false)
        --hc.com.teleportPlayerToGround(pos.x, pos.y, pos.z)
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