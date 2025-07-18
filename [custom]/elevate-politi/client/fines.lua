
lib.callback.register("elevate-politi:Client:createContextMenu", function(options)
    lib.registerContext({
        id = 'fines',
        title = 'Fines',
        options = options,
    })
    lib.showContext('fines')
    return true
end)

-- exports.ox_target:addGlobalPlayer({
--     {
--         name = 'fines',
--         icon = 'fa-solid fa-money-bill-transfer',
--         label = 'Bøder',
--         groups = {'police'},
--         onSelect = function(data)
--             TriggerServerEvent("elevate-politi:getFines", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
--         end,
--         distance = 1.5,
--     }
-- })
