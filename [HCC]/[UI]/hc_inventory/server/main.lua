local HC = exports.hc_core.GetHC()


RegisterNetEvent('hc:inventory:use')
AddEventHandler('hc:inventory:use', function(item)
    HC.Inventory.Use(source, item)
end)

RegisterNetEvent('hc:inventory:show')
AddEventHandler('hc:inventory:show', function()
    local src = source

    TriggerClientEvent('hc:inventory:receive', src, {
        inventory = HC:GetPlayerData(src).inventory,
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney
    })
end)