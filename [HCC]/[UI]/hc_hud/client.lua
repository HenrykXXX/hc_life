local isHudVisible = true

Citizen.CreateThread(function()
    while true do
        if isHudVisible then
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped) - 100
            local armor = GetPedArmour(ped)
            local food = 75  -- Example value
            local water = 80 -- Example value
            local energy = 100 - GetPlayerSprintStaminaRemaining(PlayerId())

            SendNUIMessage({
                type = 'updateHUD',
                health = health,
                armor = armor,
                food = food,
                water = water,
                energy = energy
            })
        end
        Citizen.Wait(200) -- Update every 200ms
    end
end)

-- Toggle HUD visibility
RegisterCommand('hc.hud.toggle', function()
    isHudVisible = not isHudVisible
    SetNuiFocus(false, false)
end, false)

RegisterCommand('hc.hud.setarmor', function(source, args)
    local armorValue = tonumber(args[1])
    
    if armorValue and armorValue >= 0 and armorValue <= 100 then
        local ped = PlayerPedId()
        SetPedArmour(ped, armorValue)
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"SYSTEM", "Invalid armor value. Please use a number between 0 and 100."}
        })
    end
end, false)