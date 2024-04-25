-- Register the event handler for 'entityDamaged'
AddEventHandler('entityDamaged', function(victim, culprit, weapon, baseDamage)
    -- Get the player's own ped ID
    local playerPedId = PlayerPedId()

    -- Check if the culprit is the player's own ped
    if culprit == playerPedId then
        -- Print the details of the damage event to the console
        print("Entity Damaged Event Triggered by My Player")
        print("Victim Entity ID: " .. victim)
        print("Culprit Entity ID: " .. culprit)
        print("Weapon Hash: " .. weapon)
        print("Base Damage: " .. baseDamage)
    end
end)