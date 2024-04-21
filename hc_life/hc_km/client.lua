-- Define key bindings in an array
local keyBindings = {
    {
        command = 'hc.openWeaponSelector',
        description = 'Open Weapon Selector',
        defaultKey = 'F10',
        event = 'hc:showWeaponSelector'
    }
}

-- Function to register commands and key mappings
for _, binding in ipairs(keyBindings) do
    RegisterCommand(binding.command, function()
        TriggerEvent(binding.event)
    end, false)
    RegisterKeyMapping(binding.command, binding.description, 'keyboard', binding.defaultKey)
end