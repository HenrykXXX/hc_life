HC.Vehicles.last = nil

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
    
       local vehCapacity = HC.Config.Vehicles.GetTrunkCapacity(vehModel)
       print("veh capacity: " .. vehCapacity)
       HC.Vehicles[vehicleId] = {
            model = vehModel,
            trunk = {
                items = {},
                currentWeight = 0,
                maxWeight = vehCapacity
            },
            ownerKey = playerData.key,
            spawned = true
        }

        local vehicleData = HC.Vehicles[vehicleId]
        HC.Vehicles.last = vehicleId
        exports['mysql-async']:mysql_execute('INSERT INTO vehicles (model, trunk, owner, spawned) VALUES (@model, @trunk, @owner, @spawned)', {
            ['@model'] = vehicleData.model,
            ['@trunk'] = json.encode(vehicleData.trunk),
            ['@owner'] = vehicleData.ownerKey,
            ['@spawned'] = vehicleData.spawned
        }, function(rowsChanged)
            exports['mysql-async']:mysql_fetch_all('SELECT LAST_INSERT_ID() AS id', {}, function(result)
                local vehicleId = result[1].id
                --local HC = exports.hc_core.GetHC()
                if HC.Vehicles.last then
                    local last = HC.Vehicles.last
                    print("last: " .. last)
                    HC.Vehicles[last].key = vehicleId
                    HC.Vehicles.last = nil
                end
            end)
        end)

        while HC.Vehicles.last do
            Wait(1)
        end
        
        HC.Vehicles.AddTrunkItem(id, vehicleId, 'pineapple', 1)
        print("key: ", HC.Vehicles[vehicleId].key)
        print("hc:core: Vehicle " .. vehModel .. " added to player ID " .. id .. " vehicles.")
    else
        print("hc:core: No player data found for player ID " .. id)
    end
end

function HC.Vehicles.TrunkHasItemAmount(playerId, vehicleId, itemName, amount)
    local trunk = HC:GetVehicleData(vehicleId).trunk
    print("name: " .. itemName .. " amount " .. amount)
    for _, item in ipairs(trunk.items) do
        if item[1] == itemName and item[2] >= amount then
            return true
        end
    end
    return false
end

function HC.Vehicles.AddTrunkItem(id, vehicleId, itemName, amount)
    local vehicle = HC:GetVehicleData(vehicleId)
    if vehicle then
        local trunk = vehicle.trunk
        local items = trunk.items
        local maxWeight = trunk.maxWeight

        local itemWeight = HC.Config.Items.GetWeight(itemName)
        local totalWeight = HC.Vehicles.GetTrunkWeight(vehicleId)

        if (totalWeight + itemWeight * amount) > maxWeight then
            print("Not enough space in vehicle trunk for vehicle ID: " .. vehicleId)
            return false
        end

        local itemFound = false
        -- Check if the item already exists in the trunk
        for i, item in ipairs(items) do
            if item[1] == itemName then
                item[2] = item[2] + amount  -- Increase the amount of the existing item
                itemFound = true
                break
            end
        end

        -- If the item was not found, add it as a new entry
        if not itemFound then
            table.insert(items, {itemName, amount})
        end

        -- Update current weight
        trunk.currentWeight = HC.Vehicles.GetTrunkWeight(vehicleId)

        print("hc:core: Item " .. itemName .. " added to vehicle ID " .. vehicleId .. " trunk.")
        return true
    else
        print("hc:core: Vehicle ID " .. vehicleId .. " not found.")
        return false
    end
end

function HC.Vehicles.RemoveTrunkItem(id, vehicleId, itemName, amount)
    local vehicle = HC:GetVehicleData(vehicleId)
    if vehicle then
        local trunk = vehicle.trunk
        local items = trunk.items
        local itemFound = false
        
        -- Check if the item exists in the trunk
        for i, item in ipairs(items) do
            if item[1] == itemName then
                item[2] = item[2] - amount  -- Decrease the amount of the existing item
                
                -- If the item count goes to zero or below, remove it from the trunk
                if item[2] <= 0 then
                    print("removeing table")
                    table.remove(items, i)
                end
                itemFound = true
                break
            end
        end
        
        if itemFound then
            print("hc:core: Item " .. itemName .. " removed from vehicle ID " .. vehicleId .. " trunk.")
            trunk.currentWeight = HC.Vehicles.GetTrunkWeight(vehicleId)
        else
            print("hc:core: Item " .. itemName .. " not found in vehicle ID " .. vehicleId .. " trunk.")
        end
    else
        print("hc:core: Vehicle ID " .. vehicleId .. " not found.")
    end
end

function HC.Vehicles.GetTrunkWeight(vehicleId)
    local vehicle = HC:GetVehicleData(vehicleId)
    if vehicle then
        local trunk = vehicle.trunk
        local items = trunk.items

        local totalWeight = 0

        -- Calculate the total weight of items in the trunk
        for i, item in ipairs(items) do
            local itemName = item[1]
            local itemCount = item[2]

            local itemWeight = HC.Config.Items.GetWeight(itemName)

            totalWeight = totalWeight + (itemWeight * itemCount)
        end

        return totalWeight
    else
        print("hc:core: Vehicle ID " .. vehicleId .. " not found.")
        return 0
    end
end

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

