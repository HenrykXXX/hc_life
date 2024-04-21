RegisterCommand("tpto", function(_, args)
    local target = args[1]

    if not target then
        TriggerEvent("chat:addMessage", "Target not valid")
    
        return
    end

    TriggerServerEvent("hc_tp:tpto", target)

end)

