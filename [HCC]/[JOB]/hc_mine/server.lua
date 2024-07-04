local HC = exports.hc_core.GetHC()

RegisterNetEvent('hc:mine:start')
AddEventHandler('hc:mine:start', function()
    local src = source

    while HC.Inventory.AddItem(src, "ironore", 1) do
        TriggerClientEvent('hc:mine:continue', src, true)
        Wait(5000)
    end
    TriggerClientEvent('hc:mine:continue', src, false)
end)