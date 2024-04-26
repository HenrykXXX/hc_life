RegisterCommand("sellItem", function(source, args, rawCommand)
    -- args[1] should be the item name
    -- args[2] should be the amount to sell
    if #args < 2 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", "Usage: /sellItem [itemName] [amount]"}
        })
        return
    end

    local itemName = args[1]
    local amount = tonumber(args[2])

    if not amount or amount <= 0 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", "Please enter a valid amount."}
        })
        return
    end

    -- Trigger the server event to handle the item sale
    TriggerServerEvent('hc:shops:market:sellItem', itemName, amount)
end, false)  -- false means the command is not restricted to admins