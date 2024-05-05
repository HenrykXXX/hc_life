HC = {
    PlayerData = {},
    Vehicles = {}
}

-- Function to get player data
function HC:GetPlayerData(source)
    local identifier = source --GetPlayerIdentifiers(source)[1]
    return self.PlayerData[identifier]
end

-- Function to get all vehicle data --
function HC:GetVehicleData()
    return self.Vehicles
end

exports('GetHC', function() return HC end)

