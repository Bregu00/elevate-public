if GetResourceState('qbx_core') ~= 'started' then return end

AddEventHandler('QBCore:Server:OnPlayerUnload', function(playerId)
    playerLogout(playerId)
end)