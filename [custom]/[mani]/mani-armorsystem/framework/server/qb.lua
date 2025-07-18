if GetResourceState('qb-core') ~= 'started' then return end

RegisterNetEvent('mani-armorsystem:server:qbUnload', function()
    playerLogout(source)
end)