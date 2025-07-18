Config = Config or {}

Config.radialOptions = function()
    return {
        {
            id = 'spiller_interactions',
            label = 'Spiller Handlinger',
            icon = 'fas fa-user-cog',
            menu = 'spiller_interactions_actions',
        },
        {
            id = 'vis_spiller_id',
            label = 'Vis ID',
            icon = 'fa-solid fa-id-card',
            onSelect = function()
                local serverId, playerPed, playerCoords = nearestPlayer()
                if serverId then
                    local idItem = exports['ox_inventory']:Search('slots', 'id')
                    if idItem[1] and next(idItem[1].metadata) then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), serverId, idItem[1].metadata)
                    else
                        lib.notify({ title = 'Du har intet idkort', type = 'error' })
                    end
                end
            end
        },
    }
end