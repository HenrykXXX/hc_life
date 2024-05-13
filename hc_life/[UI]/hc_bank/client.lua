-- Trigger this function to request the inventory data from the server
function requestBankData()
    TriggerServerEvent('hc:bank:show')
end

RegisterNUICallback('hideBank', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

AddEventHandler('hc:bank:show', function()
    requestBankData()
end)

RegisterNetEvent('hc:bank:receiveBankData')
AddEventHandler('hc:bank:receiveBankData', function(bankData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show",
        money = bankData.money,
        bankMoney = bankData.bankMoney
    })
end)

-- Add the following lines at the end of the file
RegisterNUICallback('withdrawMoney', function(data, cb)
    local amount = tonumber(data.amount)
    TriggerServerEvent('hc:bank:withdraw', amount)
    cb('ok')
end)

RegisterNUICallback('depositMoney', function(data, cb)
    local amount = tonumber(data.amount)
    TriggerServerEvent('hc:bank:deposit', amount)
    cb('ok')
end)