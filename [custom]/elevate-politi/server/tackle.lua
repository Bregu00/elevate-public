RegisterServerEvent('elevate_politi:TacklePlayer')
AddEventHandler('elevate_politi:TacklePlayer', function(playerIds, forwardVector)
        assert(type(playerIds) == 'table')

        for _, playerId in ipairs(playerIds) do TriggerClientEvent('elevate_politi:TacklePlayer', playerId, forwardVector) end
    end)
