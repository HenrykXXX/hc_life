function HC.Vehicles.AddVehicle(id, vehicleId)
    local playerData = HC:GetPlayerData(id)
    if playerData then
        print("veh id " .. vehicleId)
        table.insert(playerData.vehicles, vehicleId)
        local vehEntity = NetworkGetEntityFromNetworkId(vehicleId)
        print(vehEntity)
        local vehModel = GetEntityModel(vehEntity)
        
        print(vehModel)
       -- local vehName = GetDisplayNameFromVehicleModel(vehModel)
    

        HC:GetVehicleData()[vehicleId] = {vehModel, {}}
        print("hc:core: Vehicle " .. vehModel .. " added to player ID " .. id .. " vehicles.")
    else
        print("hc:core: No player data found for player ID " .. id)
    end
end

function HC.Vehicles.AddTrunkItem(id, vehicleId, itemName, amount)
    local vehicle = HC:GetVehicleData(vehicleId)
    if vehicle then
        local trunk = vehicle[2]
        local itemFound = false
        
        -- Check if the item already exists in the trunk
        for i, item in ipairs(trunk) do
            if item[1] == itemName then
                item[2] = item[2] + amount  -- Increase the amount of the existing item
                itemFound = true
                break
            end
        end
        
        -- If the item was not found, add it as a new entry
        if not itemFound then
            table.insert(trunk, {itemName, amount})
        end
        
        print("hc:core: Item " .. itemName .. " added to vehicle ID " .. vehicleId .. " trunk.")
    else
        print("hc:core: Vehicle ID " .. vehicleId .. " not found.")
    end
end

function HC.Vehicles.RemoveTrunkItem(id, vehicleId, itemName, amount)
    local vehicle = HC:GetVehicleData(vehicleId)
    if vehicle then
        local trunk = vehicle[2]
        local itemFound = false
        
        -- Check if the item exists in the trunk
        for i, item in ipairs(trunk) do
            if item[1] == itemName then
                item[2] = item[2] - amount  -- Decrease the amount of the existing item
                
                -- If the item count goes to zero or below, remove it from the trunk
                if item[2] <= 0 then
                    table.remove(trunk, i)
                end
                itemFound = true
                break
            end
        end
        
        if itemFound then
            print("hc:core: Item " .. itemName .. " removed from vehicle ID " .. vehicleId .. " trunk.")
        else
            print("hc:core: Item " .. itemName .. " not found in vehicle ID " .. vehicleId .. " trunk.")
        end
    else
        print("hc:core: Vehicle ID " .. vehicleId .. " not found.")
    end
end

-- Add this function to your server-side code
function HC.Vehicles.GetPlayerVehicles(id)
    local playerData = HC:GetPlayerData(id)
    if playerData then
        local vehicles = {}
        for _, vehicleId in ipairs(playerData.vehicles) do
            print(vehicleId)
            local vehs = HC:GetVehicleData()
            local vehicle = vehs[vehicleId]
            if vehicle then
                print("found vehicle")
                table.insert(vehicles, {vehicleId, vehicle[1]})
            end
        end
        return vehicles
    else
        print("hc:core: No player data found for player ID " .. id)
        return {}
    end
end

-- Register the command
RegisterCommand("hc.core.getPlayerVehicles", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    if playerId then
        local vehicles = HC.Vehicles.GetPlayerVehicles(playerId)
        if #vehicles > 0 then
            print("Player ID " .. playerId .. " owns the following vehicles:")
            for _, vehicle in ipairs(vehicles) do
                print("- Vehicle ID: " .. vehicle[1] .. ", Name: " .. vehicle[2])
            end
        else
            print("Player ID " .. playerId .. " does not own any vehicles.")
        end
    else
        print("Usage: hc.core.getPlayerVehicles [playerId]")
    end
end, true)