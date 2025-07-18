if GetResourceState('es_extended') ~= 'started' then return end

AddEventHandler('esx:playerLogout', function (playerId)
    playerLogout(playerId)
end)