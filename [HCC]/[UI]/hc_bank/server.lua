local HC = exports.hc_core.GetHC()

RegisterNetEvent('hc:bank:show')
AddEventHandler('hc:bank:show', function()
    local src = source
    
    TriggerClientEvent('hc:bank:receiveBankData', src, {
        money = HC:GetPlayerData(src).money,
        bankMoney = HC:GetPlayerData(src).bankMoney
    })
end)

-- Add the following lines at the end of the file
RegisterNetEvent('hc:bank:withdraw')
AddEventHandler('hc:bank:withdraw', function(amount)
    local src = source
    local data = HC:GetPlayerData(src)
    if data.bankMoney >= amount then
        HC.Bank.RemoveBankMoney(src, amount)
        HC.Bank.AddMoney(src, amount)
        TriggerClientEvent('hc:bank:receiveBankData', src, {
            money = HC:GetPlayerData(src).money,
            bankMoney = HC:GetPlayerData(src).bankMoney
        })
    else
        -- Insufficient funds, handle the error
    end
end)

RegisterNetEvent('hc:bank:deposit')
AddEventHandler('hc:bank:deposit', function(amount)
    local src = source
    local data = HC:GetPlayerData(src)
    if data.money >= amount then
        HC.Bank.RemoveMoney(src, amount)
        HC.Bank.AddBankMoney(src, amount)
        TriggerClientEvent('hc:bank:receiveBankData', src, {
            money = HC:GetPlayerData(src).money,
            bankMoney = HC:GetPlayerData(src).bankMoney
        })
    else
        -- Insufficient funds, handle the error
    end
end)
