HC = {
    PlayerData = {}
}

-- Function to get player data
function HC:GetPlayerData(source)
    local identifier = source --GetPlayerIdentifiers(source)[1]
    return self.PlayerData[identifier]
end

exports('GetHC', function() return HC end)

