local HC = exports.hc_core.GetHC()

RegisterNetEvent('hc:trunk:show')
AddEventHandler('hc:trunk:show', function(vehicle)
    local src = source
    
    local vehData = HC:GetVehicleData(vehicle)
    if not vehData then
        print("Vehicle Data not found for vehId: " .. vehicle)
        return
    end

    TriggerClientEvent('hc:trunk:receiveInventoryData', src, {
        inventory = HC:GetPlayerData(src).inventory,
        trunk = vehData.trunk
    })
end)

RegisterNetEvent('hc:trunk:getTrunkItem')
AddEventHandler('hc:trunk:getTrunkItem', function(data)
    local src = source
    local itemName = data.item
    local amount = data.amount
    
    local vehData = HC:GetVehicleData(data.vehicle)
    if not vehData then
        print("Vehicle Data not found for vehId: " .. data.vehicle)
        return
    end

    if not HC.Vehicles.TrunkHasItemAmount(src, data.vehicle, itemName, amount) then
        print("not enough items in inventory")
        return
    end

    if HC.Inventory.AddItem(src, itemName, amount) then
        HC.Vehicles.RemoveTrunkItem(src, data.vehicle, itemName, amount)
        
        TriggerClientEvent('hc:trunk:receiveInventoryData', src, {
            inventory = HC:GetPlayerData(src).inventory,
            trunk = HC:GetVehicleData(data.vehicle).trunk
        })
    end
end)

RegisterNetEvent('hc:trunk:storePlayerItem')
AddEventHandler('hc:trunk:storePlayerItem', function(data)
    local src = source
    local itemName = data.item
    local amount = data.amount

    local vehData = HC:GetVehicleData(data.vehicle)
    if not vehData then
        print("Vehicle Data not found for vehId: " .. data.vehicle)
        return
    end

    if not HC.Inventory.HasItemAmount(src, itemName, amount) then
        print("not enough items in inventory")
        return
    end

    if HC.Vehicles.AddTrunkItem(src, data.vehicle, itemName, amount) then
        HC.Inventory.RemoveItem(src, itemName, amount)
        TriggerClientEvent('hc:trunk:receiveInventoryData', src, {
            inventory = HC:GetPlayerData(src).inventory,
            trunk = HC:GetVehicleData(data.vehicle).trunk
        })
    end
end)
