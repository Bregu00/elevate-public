RegisterNetEvent('elevate-politi:getFines', function(target)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)
    if xPlayer.job.name == "police" then
        local allPlayerFines = MySQL.Sync.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
            ['@identifier'] = xTarget.identifier
        })
        if allPlayerFines[1] then
            local options = {}
            for k, v in pairs(allPlayerFines) do
                table.insert(options, {
                    title = v.label,
                    description = "Firma: " .. v.target,
                })
            end
            lib.callback.await("elevate-politi:Client:createContextMenu", src, options)
        else
            TriggerClientEvent('esx:showNotification', src, "No bills found for this player.")
        end
    end
end, false)
