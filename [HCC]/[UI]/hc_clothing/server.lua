local HC = exports.hc_core.GetHC()

RegisterNetEvent("hc:clothing:bagAdded")
AddEventHandler("hc:clothing:bagAdded", function()
    local src = source
    HC.Inventory.SetMaxWeight(src, 64)

    print(HC:GetPlayerData(src).inventory.maxWeight)
end)