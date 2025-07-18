RegisterNetEvent('jungurum-tireslash:server:sync', function(id, tireIndex)
	TriggerClientEvent('jungurum-tireslash:client:sync', id, tireIndex)
end)