CreateThread(function ()
	local options = {}

	for i = 1, #Config.engineCategories do
		local v = Config.engineCategories[i]
		local options2 = {}
		for index = 1, #v.engineTypes do
			local value = v.engineTypes[index]
			options2[#options2 + 1] = {
				title = value.label,
				icon = 'volume-high',
				onSelect = function()
					local playerPed = PlayerPedId()
					local veh = GetVehiclePedIsIn(playerPed ,false)
					local plate = GetVehicleNumberPlateText(veh)
					ESX.TriggerServerCallback('syn-engineSound:server:updateVehicleSound', function(installed, text, type)
						lib.notify({
							title = text,
							type = type
						})
					end, i, plate, index)
				end
			}
		end
		lib.registerContext({
			id = v.categoriName,
			title = v.categoriName,
			options = options2
		})

		options[#options + 1] = {
			title = v.categoriName,
			menu = v.categoriName,
			icon = 'gear'
        }
	end
	lib.registerContext({
		id = 'vehicleSoundMenu',
		title = 'Administrer Køretøjets Lyd',
		options = options
	})
end)


CreateThread(function()
	local vehiclesToUpdate = lib.callback.await("syn-engineSound:server:getVehiclesToUpdate", false)
    while true do
        Wait(1000)
        for i = 1, #vehiclesToUpdate do
			if vehiclesToUpdate[i] then
				local v = vehiclesToUpdate[i]
				if NetworkDoesNetworkIdExist(v.vehicle) then
					local vehicle = NetworkGetEntityFromNetworkId(v.vehicle)
					if DoesEntityExist(vehicle) then
						ForceVehicleEngineAudio(vehicle, v.sound)
						table.remove(vehiclesToUpdate, i)
					end
				end
			end
        end

        -- Exit the loop if all entities are processed
        -- if #vehiclesToUpdate == 0 then
        --     break
        -- end
    end
end)

CreateThread(function ()
	for k, v in pairs(Config.Companies) do
        lib.zones.box({
            coords = vector3(v.zone.coords.xyz),
            rotation = v.zone.coords.w,
            size = v.zone.size,
            name = v.zone.name,
            label = v.zone.label,
            onEnter = function()
				local job = ESX.GetPlayerData().job.name
				if not v.zone.job[job] then return end
				lib.addRadialItem({
					id = k,
					icon = 'house',
					label = v.zone.label,
					onSelect = function()
						local playerPed = PlayerPedId()
						local veh = GetVehiclePedIsIn(playerPed ,false)
						if veh ~= 0 then
							lib.showContext('vehicleSoundMenu')
						end
					end
				})
            end,
            onExit = function()
				local job = ESX.GetPlayerData().job.name
				if not v.zone.job[job] then return end
				lib.removeRadialItem(k)
            end,
            debug = Config.debug,
        })
    end
	exports.ox_target:addGlobalVehicle({
		{
			label = "Fjern motorlyd",
			name = "removeCustomEngineSound",
			icon = "fa-car",
			distance = 2,
			canInteract = function(entity)
				local playerJob = ESX.GetPlayerData().job.name
				for k, v in pairs(Config.Companies) do
					for job, _ in pairs(v.zone.job) do
						if job == playerJob then
							return true
						end
					end
				end
			end,
			onSelect = function(entity)
				local plate = GetVehicleNumberPlateText(entity.entity)
				ESX.TriggerServerCallback('syn-enginesounds:server:removeCustomSound', function(removeSound, text, type)
					lib.notify({
						title = text,
						type = type
					})
				end, plate, NetworkGetNetworkIdFromEntity(entity.entity))
			end
		},
		{
			label = "Check motorlyd",
			name = "checkEngineSound",
			icon = "fa-car",
			distance = 2,
			canInteract = function(entity)
				local playerJob = ESX.GetPlayerData().job.name
				for k, v in pairs(Config.Companies) do
					for job, _ in pairs(v.zone.job) do
						if job == playerJob then
							return true
						end
					end
				end
			end,
			onSelect = function(entity)
				local plate = GetVehicleNumberPlateText(entity.entity)
				ESX.TriggerServerCallback('syn-enginesounds:server:checkCustomSound', function(removeSound, text, type)
					lib.notify({
						title = text,
						type = type
					})
				end, plate)
			end
		}
	})
end)

AddStateBagChangeHandler('muffler' , nil, function(bagName, key, value, _unused, replicated)
	local entity = GetEntityFromStateBagName(bagName)
	if not value or entity == 0 then return end
	ForceVehicleEngineAudio(entity, value)
end)


RegisterCommand("checkentityid", function()
    local vehiclesToUpdate = lib.callback.await("syn-engineSound:server:getVehiclesToUpdate", false)
    for i = 1, #vehiclesToUpdate do
        local v = vehiclesToUpdate[i]
    end
end)