HC.Player = {}

function HC.Player.AddStat(src, stat, value)
    print("add stat")
    local pd = HC:GetPlayerData(src)

    if pd then
        print(pd.stats[stat])
        pd.stats[stat] = pd.stats[stat] + value
        print(pd.stats[stat])
    end
end

AddEventHandler("hc:core:player:addStat", function(src, stat, value)
    HC.Player.AddStat(src, stat, value)
end)

RegisterNetEvent("hc:core:player:tick")
AddEventHandler("hc:core:player:tick", function()
    local src = source
    local pd = HC:GetPlayerData(src)
    if pd then
        pd.stats.water = pd.stats.water - 2
        pd.stats.food = pd.stats.food - 1
    end
    TriggerClientEvent("hc:core:player:updateStats", src, pd.stats)
end)