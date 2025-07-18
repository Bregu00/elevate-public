local open = false

-- Open ID card
RegisterNetEvent('jsfour-idcard:open', function(data, type)
	if open then return end
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

-- Key events
CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)

exports('useIdCard', function(itemData)
	local playerPos = GetEntityCoords(cache.ped)
    local playerId = lib.getClosestPlayer(playerPos, 3)
	local success = lib.callback.await('jsfour-idcard:server:sendIdItem', false, itemData.slot, GetPlayerServerId(playerId))
	if not success then
		lib.notify({ title = 'Dette idkort er ugyldigt', type = 'error' })
	end
end)