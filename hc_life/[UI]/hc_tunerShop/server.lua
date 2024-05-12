local HC = exports.hc_core.GetHC()

RegisterNetEvent('hc:tunerShop:buy')
AddEventHandler('hc:tunerShop:buy', function(amount, data)
    local src = source

    local playerData = HC:GetPlayerData(src)
    if playerData.money >= amount then
        HC:RemoveMoney(src, amount)

        TriggerClientEvent('hc:tunerShop:receiveUpgrade', src, true, data)
    else
        -- Insufficient funds, handle the error
    end
end)