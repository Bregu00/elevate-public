local Config = {}

local function dependencyCheck(resources)
    for k, v in pairs(resources) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

Config.RadioItem = 'radio' -- false to not use item

Config.EmergencyRadio = 10.99 -- 1 -> 10.99 is retricted to emergency jobs (False to disable)

Config.EmergencyJobs = {
    ['police'] = true,
    ['ambulance'] = true,
}

Config.saveItem = true -- Only works with ox_inventory by default.

Config.isPoweredByDefault = true

Config.Keybinds = {
    ['Up'] = '', -- Go .10 channel up (Empty string just means unbinded, players can choose their own bind, if they find the ability needed)
    ['Down'] = '', -- Go .10 channel down
    ['Toggle'] = 'F10', -- Toggle radio (If you dont use item)
}

Config.Values = {
    ['Up'] = 0.10,
    ['Down'] = -0.10,
}

Config.Framework = dependencyCheck({
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
    ['qbx_core'] = 'qbx'
}) or nil

return Config