HC = {
    PlayerData = {},
    Config = {},
    Vehicles = {}
}

-- Function to get player data
function HC:GetPlayerData(source)
    local identifier = source --GetPlayerIdentifiers(source)[1]
    return HC.PlayerData[identifier]
end

-- Function to get all vehicle data --
function HC:GetVehicleData(vehicleId)
    return HC.Vehicles[vehicleId]
end

exports('GetHC', function() return HC end)

