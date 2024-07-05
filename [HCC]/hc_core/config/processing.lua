HC.Config.Processing = {
    ironore = {
        result = "ironbar",
        amountRequired = 1,
        amountProduced = 1
    },
}

local function findProc(name)
    return HC.Config.Processing[name]
end

function HC.Config.Processing.GetData(item)
    local proc = findProc(item)

    return proc
end