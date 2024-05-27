HC.Bank = {}

function HC.Bank.AddMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.money = math.floor((playerData.money or 0) + amount)
end

function HC.Bank.RemoveMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.money = math.floor((playerData.money or 0) - amount)
end

function HC.Bank.GetMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)
    
    return math.floor(playerData.money)
end

function HC.Bank.AddBankMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.bankMoney = math.floor((playerData.bankMoney or 0) + amount)
end

function HC.Bank.RemoveBankMoney(playerId, amount)
    local playerData = HC:GetPlayerData(playerId)

    playerData.bankMoney = math.floor((playerData.bankMoney or 0) - amount)
end