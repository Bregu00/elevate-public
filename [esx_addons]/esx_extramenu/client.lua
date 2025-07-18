
ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	startThread()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function for 3D text:s
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

local insideMarker = false
local nearest = nil

function startThread()
	CreateThread(function()
		local wait = 1000
		while true do
			Wait(wait)
			local coords = GetEntityCoords(PlayerPedId())
			local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
			if Config.PoliceDatabaseName[ESX.PlayerData.job.name] then
				local closestDistance = math.huge
				nearest = nil
				for i = 1, #Config.ExtraZones, 1 do
					local v = Config.ExtraZones[i]
					local distance = Vdist(coords, v.x, v.y, v.z)
					if distance < 10 then
						if distance < closestDistance then
							closestDistance = distance
							nearest = i
						end
						if insideMarker == false and pedInVeh then
							DrawMarker(Config.PoliceExtraMarker, v.x, v.y, v.z - 0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.PoliceExtraMarkerScale.x, Config.PoliceExtraMarkerScale.y, Config.PoliceExtraMarkerScale.z, Config.PoliceExtraMarkerColor.r, Config.PoliceExtraMarkerColor.g, Config.PoliceExtraMarkerColor.b, Config.PoliceExtraMarkerColor.a, false, true, 2, true, false, false, false)
						end
						if distance < 2.5 and insideMarker == false and pedInVeh then
							DrawText3Ds(v.x, v.y, v.z, Config.ExtraDraw3DText)
							if IsControlJustPressed(0, Config.KeyToOpenExtraGarage) then
								OpenMainMenu()
								insideMarker = true
							end
						end
					end
				end
				if nearest then
					wait = 1
				else
					wait = 1000
				end
			end
		end
	end)
end

-- Police Extra Menu:
function OpenExtraMenu()
	local elements = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) 

			if state then
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:green;">%s</span>'):format("On"),
					value = id,
					state = not state
				})
			else
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:red;">%s</span>'):format("Off"),
					value = id,
					state = not state
				})
			end
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
		title    = Config.TitlePoliceExtra,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		SetVehicleExtra(vehicle, data.current.value, not data.current.state)
		local newData = data.current
		if data.current.state then
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		newData.state = not data.current.state

		menu.update({value = data.current.value}, newData)
		menu.refresh()
	end, function(data, menu)
		menu.close()
	end)
end

-- Police Livery Menu:
function OpenLiveryMenu()
	local elements = {}
	
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	local liveryCount = GetVehicleLiveryCount(vehicle)
			
	for i = 1, liveryCount do
		local state = GetVehicleLivery(vehicle) 
		local text
		
		if state == i then
			text = "Livery: "..i.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			text = "Livery: "..i.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		
		table.insert(elements, {
			label = text,
			value = i,
			state = not state
		}) 
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'livery_menu', {
		title    = Config.TitlePoliceLivery,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		SetVehicleLivery(vehicle, data.current.value, not data.current.state)
		SetVehicleDirtLevel(vehicle, 0.00)
		local newData = data.current
		if data.current.state then
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			newData.label = "Livery: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		newData.state = not data.current.state
		menu.update({value = data.current.value}, newData)
		menu.refresh()
		menu.close()	
	end, function(data, menu)
		menu.close()		
	end)
end

-- Police Extra Main Menu:
function OpenMainMenu()
	local elements = {
		{label = Config.LabelPrimaryCol,value = 'primary'},
		{label = Config.LabelSecondaryCol,value = 'secondary'},
		{label = Config.LabelExtra,value = 'extra'},
		{label = Config.LabelLivery,value = 'livery'}
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'color_menu', {
		title    = Config.TitlePoliceExtra,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'extra' then
			OpenExtraMenu()
		elseif data.current.value == 'livery' then
			OpenLiveryMenu()
		elseif data.current.value == 'primary' then
			OpenMainColorMenu('primary')
		elseif data.current.value == 'secondary' then
			OpenMainColorMenu('secondary')
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end)
end

-- Police Color Main Menu:
function OpenMainColorMenu(colortype)
	local elements = {}
	for k,v in pairs(Config.Colors) do
		table.insert(elements, {
			label = v.label,
			value = v.value
		})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_color_menu', {
		title    = Config.TitleColorType,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		OpenColorMenu(data.current.type, data.current.value, colortype)
	end, function(data, menu)
		menu.close()
	end)
end

-- Police Color Menu:
function OpenColorMenu(type, value, colortype)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
		title    = Config.TitleValues,
		align    = 'top-left',
		elements = GetColors(value)
	}, function(data, menu)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local pr,sec = GetVehicleColours(vehicle)
		if colortype == 'primary' then
			SetVehicleColours(vehicle, data.current.index, sec)
		elseif colortype == 'secondary' then
			SetVehicleColours(vehicle, pr, data.current.index)
		end
		SetVehicleDirtLevel(vehicle, 0.00)
		
	end, function(data, menu)
		menu.close()
	end)
end
