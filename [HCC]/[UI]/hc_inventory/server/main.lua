local HC = exports.hc_core.GetHC()


RegisterNetEvent('hc:inventory:use')
AddEventHandler('hc:inventory:use', function(item)
    HC.Inventory.Use(source, item)
end)

RegisterNetEvent('hc:inventory:show')
AddEventHandler('hc:inventory:show', function()
    local src = source
    local pd = HC:GetPlayerData(src)

    if not pd then
        print("Coudl  not get PlayerData for id: " .. src)
    end

    local items = {}

    for _, item in ipairs(pd.inventory.items) do
        table.insert(items, {
            item = item[1],
            quantity = item[2],
            name = HC.Config.Items.GetName(item[1])
        })
    end
    print("mw: " .. pd.inventory.maxWeight .. " cw: " .. pd.inventory.currentWeight)

    TriggerClientEvent('hc:inventory:receive', src, {
        inventory = items,
        currentWeight = pd.inventory.currentWeight,
        maxWeight = pd.inventory.maxWeight,
        money = pd.money,
        bankMoney = pd.bankMoney
    })
end)