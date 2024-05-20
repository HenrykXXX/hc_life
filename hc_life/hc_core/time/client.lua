-- client.lua
RegisterNetEvent('hc:core:time:updateTime')
AddEventHandler('hc:core:time:updateTime', function(h, m)
    NetworkOverrideClockTime(h, m, 0)
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    SetWeatherTypeOverTime("EXTRASUNNY", 15.0)
end)