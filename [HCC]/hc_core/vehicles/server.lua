HC.Vehicles.last = nil

function HC.Vehicles.AddVehicle(id, vehicleId)
    local playerData = HC:GetPlayerData(id)
    if playerData then
        table.insert(playerData.vehicles, vehicleId)
        
        while HC.Vehicles.last do
            Wait(10)
            print("Vehicles: last is still processing...")
        end 

        while 0 == NetworkGetEntityFromNetworkId(vehicleId) do
            Wait(1)
            print("Vehicles: Waiting for entity")
        end

        local vehEntity = NetworkGetEntityFromNetworkId(vehicleId)
        print("Vehicles: Entity - " .. vehEntity)
        local vehModel = GetEntityModel(vehEntity)
        
        --print(vehModel)
       -- local vehName = GetDisplayNameFromVehicleModel(vehModel)
    
       local vehCapacity = HC.Config.Vehicles.GetTrunkCapacity(vehModel)
       --print("veh capacity: " .. vehCapacity)
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
        HC.DB.Execute('INSERT INTO vehicles (model, trunk, owner, spawned) VALUES (@model, @trunk, @owner, @spawned)', {
            ['@model'] = vehicleData.model,
            ['@trunk'] = json.encode(vehicleData.trunk),
            ['@owner'] = vehicleData.ownerKey,
            ['@spawned'] = vehicleData.spawned
        }, function(rowsChanged)
            HC.DB.FetchAll('SELECT MAX(id) AS id FROM vehicles', {}, function(result)
                local vid = result[1].id
                print("Vehicles: DBID - " .. vid)

                if HC.Vehicles.last then
                    local last = HC.Vehicles.last
                    --print("last: " .. last)
                    HC.Vehicles[last].key = vid
                    HC.Vehicles.last = nil
                end
            end)
        end)

        while HC.Vehicles.last do
            Wait(1)
        end
        
        print("key: ", HC.Vehicles[vehicleId].key)
        print("hc:core: Vehicle " .. vehModel .. " added to player ID " .. id .. " vehicles.")
    else
        print("hc:core: No player data found for player ID " .. id)
    end
end

function HC.Vehicles.Register(id, vehicleId, data)
    local playerData = HC:GetPlayerData(id)
    
    if playerData then
        table.insert(playerData.vehicles, vehicleId)
        HC.Vehicles[vehicleId] = data
    end
end

function HC.Vehicles.SaveDB(id)
    local vehData = HC.Vehicles[id]
    if vehData then
        print("Vehicles: ID - " .. id .. " storing DB...")
        
        HC.DB.Execute('UPDATE vehicles SET trunk = @trunk, owner = @owner, spawned = @spawned WHERE id = @id', {
            ['@trunk'] = json.encode(vehData.trunk),
            ['@owner'] = vehData.ownerKey,
            ['@spawned'] = vehData.spawned,
            ['@id'] = vehData.key
        }, function(rowsChanged)
            if rowsChanged > 0 then
                print("Vehicles: Updated1")
            else
                print("Vehicles: Update failed")
            end
        end)
    end
end

function HC.Vehicles.Retrieve(vehicleId)
    local updated = false
    local ret = {}

    HC.DB.Execute('UPDATE vehicles SET spawned = @spawned WHERE id = @id', {
        ['@spawned'] = 1,
        ['@id'] = vehicleId
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print("hc:core: Vehicle ID " .. vehicleId .. " retrieved and 'spawned' field updated to 1.")
        else
            print("hc:core: Vehicle ID " .. vehicleId .. " not found in the database.")
        end
    end)

    HC.DB.FetchAll('SELECT * FROM vehicles WHERE id = @id', {
        ['@id'] = vehicleId
    }, function(vehData)
        if vehData[1] then
            res = vehData[1]
        else 
            print("Vehicles: Coudl not retrieve data for vehicel id: " .. vehicleId)
        end
        updated = true
    end)

    while not updated do
        Wait(1)
    end

    return {
        model = tonumber(res.model),
        trunk = json.decode(res.trunk),
        ownerKey = res.owner,
        spawned = true,
        key = vehicleId
    }
end

function HC.Vehicles.TrunkHasItemAmount(playerId, vehicleId, itemName, amount)
    local trunk = HC:GetVehicleData(vehicleId).trunk

    for _, item in ipairs(trunk.items) do
        if item[1] == itemName and item[2] >= amount then
            return true
        end
    end

    TriggerClientEvent("hc:hint:show", playerId, "Not enough items in trunk.")
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
            TriggerClientEvent("hc:hint:show", playerId, "Not enough space in trunk.")
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
       
        HC.Vehicles.SaveDB(vehicleId)
        print("Vehicles: Item " .. itemName .. " added to vehicle ID " .. vehicleId .. " trunk.")
        return true
    else
        print("Vehicles: Vehicle ID " .. vehicleId .. " not found.")
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

function HC.Vehicles.GetPlayerGarage(id)
    local playerData = HC:GetPlayerData(id)
    if playerData then
        local vehicles = {}
        local ownerKey = playerData.key
        
        -- Fetch all vehicles from the database where ownerKey is equal to the player's key
        HC.DB.FetchAll('SELECT * FROM vehicles WHERE owner = @owner AND spawned = 0', {
            ['@owner'] = ownerKey
        }, function(result)
            for _, vehicle in ipairs(result) do
                local vehicleId = vehicle.id
                local vehicleData = {
                    key = vehicleId,
                    model = vehicle.model,
                    trunk = json.decode(vehicle.trunk),
                    ownerKey = vehicle.owner,
                    spawned = vehicle.spawned
                }
                HC.Vehicles[vehicleId] = vehicleData
                table.insert(vehicles, vehicleData)
            end
        end)

        -- Ensure the vehicles are retrieved before returning
        while next(vehicles) == nil do
            Wait(1)
        end

        print("hc:core: Retrieved " .. #vehicles .. " vehicles for player ID " .. id)

        return vehicles
    else
        print("hc:core: No player data found for player ID " .. id)
        return {}
    end
end

RegisterCommand("hc.getplayergarage", function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    if playerId then
        local vehicles = HC.Vehicles.GetPlayerGarage(playerId)
        if #vehicles > 0 then
            for _, vehicle in ipairs(vehicles) do
                local vehicleId = vehicle.key
                local vehicleModel = vehicle.model
                TriggerClientEvent('chat:addMessage', source, {
                    args = { "HC Core", "Vehicle ID: " .. vehicleId .. " Model: " .. vehicleModel }
                })
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { "HC Core", "No vehicles found for player ID " .. playerId }
            })
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { "HC Core", "Invalid player ID. Usage: /hc.getplayergarage [playerId]" }
        })
    end
end, false)

