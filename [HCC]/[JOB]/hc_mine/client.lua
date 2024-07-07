local spawnPos = vector3(2948.0, 2796.0, 41.0)
local spawnRadius = 30.0
local isMining = false

RegisterNetEvent('hc:mine:start')
AddEventHandler('hc:mine:start', function()
    local pp = GetPlayerPed(-1)
    if pp then
        local pc = GetEntityCoords(pp)
        if #(pc - spawnPos) < spawnRadius then
            TaskStartScenarioInPlace(pp, "WORLD_HUMAN_CONST_DRILL", 0, true)
            TriggerServerEvent('hc:mine:start')
        else
            print("Not near mine.")
        end
    end
end)

RegisterNetEvent('hc:mine:continue')
AddEventHandler('hc:mine:continue', function(continue)
    local pp = GetPlayerPed(-1)
    if not pp then
        return
    end

    if continue then
        TriggerEvent("hc:hint:show", "Collected Iron Ore.")

        local pc = GetEntityCoords(pp)
        PlaySoundFromCoord(-1, "PICK_UP", pc.x, pc.y, pc.z, "HUD_FRONTEND_DEFAULT_SOUNDSET", false, 0, false)
    else
        ClearPedTasks(pp)
    end
end)


function drawMarker()
    DrawMarker(1, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, spawnRadius * 2.0, spawnRadius * 2.0, 1.5, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
end

-- Add a blip for the Pineapple Farm
function addMineBlip()
    local blip = AddBlipForRadius(spawnPos.x, spawnPos.y, spawnPos.z, spawnRadius)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 2) -- Green color
    SetBlipAlpha(blip, 128) -- Semi-transparent
    SetBlipAsShortRange(blip, true)
    
    local areaBlip = AddBlipForCoord(spawnPos.x, spawnPos.y, spawnPos.z)
    SetBlipSprite(areaBlip, 285) 
    SetBlipDisplay(areaBlip, 4)
    SetBlipScale(areaBlip, 1.0)
    SetBlipColour(areaBlip, 2)
    SetBlipAsShortRange(areaBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Iron Mine")
    EndTextCommandSetBlipName(areaBlip)
end

-- Initialize blip and marker drawing
CreateThread(function()
    addMineBlip()
    while true do
        Wait(0)
        local playerPos = GetEntityCoords(PlayerPedId())
        if #(playerPos - spawnPos) < spawnRadius * 2.0 then
            drawMarker()
        end
    end
end)
