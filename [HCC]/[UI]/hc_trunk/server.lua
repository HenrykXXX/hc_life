local HC = exports.hc_core.GetHC()

local function showTrunk(src, vehicle)
    local vehData = HC:GetVehicleData(vehicle)
    local pd = HC:GetPlayerData(src)

    if not vehData then
        print("Vehicle Data not found for vehId: " .. vehicle)
        return
    end

    if not pd then
        print("Player Data not found")
        return
    end

    local items = {}

    for _, item in ipairs(pd.inventory.items) do
        table.insert(items, {
            item = item[1],
            quantity = item[2],
            name = HC.Config.Items.GetName(item[1])
        })
    end

    local vehItems = {}

    for _, item in ipairs(vehData.trunk.items) do
        table.insert(vehItems, {
            item = item[1],
            quantity = item[2],
            name = HC.Config.Items.GetName(item[1])
        })
    end

    TriggerClientEvent('hc:trunk:receiveInventoryData', src, {
        inventory = {
            items = items,
            currentWeight = pd.inventory.currentWeight,
            maxWeight = pd.inventory.maxWeight
        },
        trunk = {
            items = vehItems,
            currentWeight = vehData.trunk.currentWeight,
            maxWeight = vehData.trunk.maxWeight
        }
       
    })
end

RegisterNetEvent('hc:trunk:show')
AddEventHandler('hc:trunk:show', function(vehicle)
    local src = source
    showTrunk(src, vehicle)
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
        return
    end

    if HC.Inventory.AddItem(src, itemName, amount) then
        HC.Vehicles.RemoveTrunkItem(src, data.vehicle, itemName, amount)
        
        showTrunk(src, data.vehicle)
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
        return
    end

    if HC.Vehicles.AddTrunkItem(src, data.vehicle, itemName, amount) then
        HC.Inventory.RemoveItem(src, itemName, amount)
        
        showTrunk(src, data.vehicle)
    end
end)
