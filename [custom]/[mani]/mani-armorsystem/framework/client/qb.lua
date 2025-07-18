if GetResourceState('qb-core') ~= 'started' then return end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerLoaded()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('mani-armorsystem:server:qbUnload')
end)