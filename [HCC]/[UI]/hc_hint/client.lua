local function showHint(msg)
    SendNUIMessage({
        type = "show",
        msg = msg,
    })
end

RegisterNetEvent('hc:hint:show')
AddEventHandler('hc:hint:show', function(msg)
    showHint(msg)
end)

RegisterCommand('hc.hint', function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    showHint(msg)
end, false)