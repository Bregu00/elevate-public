function ToggleNuiFrame(shouldShow)
	SetNuiFocus(shouldShow, shouldShow)
	SendReactMessage("setVisible", shouldShow)
end

function ToggleVisibility(shouldShow)
	SendReactMessage("setVisible", shouldShow)
end

RegisterNUICallback("hideFrame", function(_, cb)
	ToggleNuiFrame(false)
	cb({})
end)

RegisterCommand("close", function()
	ToggleNuiFrame(false)
end)

RegisterNUICallback("loadUtils", function(data, cb)
	cb(GetUtils())
end)

OnlineMenu = false

RegisterCommand("adminmenu", function()
	local isAdmin = lib.callback.await("electus_admin:isAdmin", false)

	if not isAdmin then
		return
	end

	if OnlineMenu then
		ToggleVisibility(true)
	else
		ToggleNuiFrame(true)
	end
end)

RegisterNUICallback("setOnlineMenu", function(data, cb)
	OnlineMenu = data.onlineMenu
	SetNuiFocus(not data.onlineMenu, not data.onlineMenu)
	cb({})
end)

RegisterNUICallback("requestFocus", function(data, cb)
	SetNuiFocus(data.focus, data.focus)
	cb({})
end)

RegisterNUICallback("spawnVehicle", function(data, cb)
	local vehicle = data.model

	-- print(vehicle)
	local vehicleNet = lib.callback.await("electus_admin:spawnVehicle", false, vehicle)

	while not NetworkDoesNetworkIdExist(vehicleNet) do
		Wait(100)
	end

	local vehicleEntity = NetworkGetEntityFromNetworkId(vehicleNet)

	SetEntityAsMissionEntity(vehicleEntity, true, true)
	SetVehicleOnGroundProperly(vehicleEntity)

	cb({})
end)

RegisterNUICallback("isAdmin", function(data, cb)
	local isAdmin = lib.callback.await("electus_admin:isAdmin", false)

	if not isAdmin then
		return cb({ isAdmin = false })
	end

	cb({ isAdmin = isAdmin })
end)

RegisterNUICallback("teleportToPlayer", function(data, cb)
	local playerPed = PlayerPedId()
	local playerId = PlayerId()
	local targetId = GetPlayerFromServerId(data.target)
	local targetPed = GetPlayerPed(targetId)

	if not DoesEntityExist(targetPed) then
		return cb({ success = false, message = "Player not found" })
	end

	local targetCoords = GetEntityCoords(targetPed)
	SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z + 1.0, false, false, false, true)

	cb({ success = true })
end)

-- print(MumbleGetVoiceChannelFromServerId(GetPlayerServerId(PlayerId())))
-- print(LocalPlayer.state["callChannel"])
