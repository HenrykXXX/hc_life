local bMenu = false

function ShowWeaponSelector()
    bMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show",
    })
end

RegisterNUICallback('selectWeapon', function(data, cb)
    GiveWeaponToPed(PlayerPedId(), data.weapon, 250, false, true)
    cb({ success = true })
end)

RegisterNUICallback('HideWeaponSelector', function(data, cb)
    bMenu = false
    cb('ok')
    SetNuiFocus(false, false)
end)

RegisterNetEvent('hc:showWeaponSelector')
AddEventHandler('hc:showWeaponSelector', function()
    ShowWeaponSelector()
end)
