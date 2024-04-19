local bMenu = false

function ShowWeaponSelector()
    bMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "toggleVisibility",
        show = true
    })
end

RegisterNUICallback('selectWeapon', function(data, cb)
    GiveWeaponToPed(PlayerPedId(), data.weapon, 250, false, true)
    cb({ success = true })
end)

RegisterNUICallback('HideWeaponSelector', function(data, cb)
    SendNUIMessage({
        type = "toggleVisibility",
        show = false
    })
    bMenu = false
    cb('ok')
    print("d")
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed (0, 38) then -- E key
            ShowWeaponSelector()
        end
    end
end)
