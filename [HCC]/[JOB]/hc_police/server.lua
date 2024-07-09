local HC = exports.hc_core.GetHC()

RegisterNetEvent("hc:police:getGear")
AddEventHandler("hc:police:getGear", function()
    local src = source

    local pd = HC:GetPlayerData(src)
    if not pd then
        print("Coudl not get player data...")
        return
    end

    local rank = pd.police.rank
    TriggerClientEvent("hc:police:recieveGear", src, rank)
end)

RegisterNetEvent('hc:police:restrain')
AddEventHandler('hc:police:restrain', function(target)
	TriggerClientEvent("hc:police:restrain", target, source)
    print("target:  " .. target)
end)