local HC = exports.hc_core.GetHC()
local miningPlayers = {}

RegisterNetEvent('hc:mine:start')
AddEventHandler('hc:mine:start', function()
    local src = source

    if miningPlayers[src] then
        return
    end
 
    miningPlayers[src] = true
 
    local hasSpace = true

    while hasSpace do
        Wait(5000)
        hasSpace = HC.Inventory.AddItem(src, "ironore", 1)
        if hasSpace then
            TriggerClientEvent('hc:mine:continue', src, true)
        end
    end

    miningPlayers[src] = nil
    TriggerClientEvent('hc:mine:continue', src, false)
end)