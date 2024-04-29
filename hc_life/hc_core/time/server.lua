-- server.lua
-- Time variables
local hour = 0
local minute = 0

-- Update the time every real-world minute to simulate one in-game hour
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- wait 60 seconds (1 minute)
        minute = minute + 60 -- increment by one in-game hour

        if minute >= 60 then
            minute = 0
            hour = 14 -- h + 1
            if hour >= 24 then
                hour = 0
            end

            -- Trigger the client event to update time
            TriggerClientEvent('hc:core:time:updateTime', -1, hour, minute)
        end
    end
end)