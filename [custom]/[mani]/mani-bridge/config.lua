Config = Config or {}

local function dependencyCheck(resources)
    for k, v in pairs(resources) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

Config.Framework = dependencyCheck({
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
    ['qbx_core'] = 'qbx'
}) or nil

Config.Inventory = dependencyCheck({
    ['ox_inventory'] = 'ox',
    ['codem-inventory'] = 'codem',
    ['qb-inventory'] = 'qb',
    ['ps-inventory'] = 'ps',
    ['qs-inventory'] = 'qs'
}) or nil

Config.Dispatch = {
    resource = dependencyCheck({
        ['linden_outlawalert'] = 'linden',
        ['cd_dispatch'] = 'cd',
        ['ps-dispatch'] = 'ps',
        ['qs-dispatch'] = 'qs',
        ['core_dispatch'] = 'core',
        ['codem-dispatch'] = 'codem',
        ['origen_police'] = 'origen'
    }) or nil,
    jobs = { 'police' }, -- If using Origen, add 'police' to the list instead of a table.
    types = { 'leo' }
}

Config.Target = dependencyCheck({
    ['ox_target'] = 'ox',
    ['qb-target'] = 'qb',
}) or nil

Config.Clothing = dependencyCheck({
    ['rcore_clothing'] = 'rcore',
}) or nil

Config.oxOptions = { -- ox_lib usage options
    Notify = true,
    ProgressBar = 'bar' -- 'bar' or 'circle' - false to disable
}