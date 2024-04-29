local HC = exports.hc_core.GetHC()

-- Registering a server event to listen for item addition requests
RegisterNetEvent('hc:ff:addItem')
AddEventHandler('hc:ff:addItem', function(itemName, amount)
    HC:AddItem(source, itemName, amount)
end)