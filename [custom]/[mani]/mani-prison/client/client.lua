local Config, Prison = lib.load('config'), lib.load('util')
local zone, settings, currentJob, janitorNpc = nil, {}, {}, {}

local function createBlip(coords, label, sprite, scale, color, shortRange)
	local blip = AddBlipForCoord(coords.xyz)

	SetBlipSprite(blip, sprite)
	SetBlipScale (blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, shortRange)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(label)
	EndTextCommandSetBlipName(blip)

	return blip
end

local function deletePropTimer(jobTable)
	local Job = jobTable
	CreateThread(function()
		if Job['Objects'] then
			for i = 1, #Job['Objects'] do
				DeleteEntity(Job['Objects'][i])
			end
		end
		if Job['Blips'] then
			for i = 1, #Job['Blips'] do
				RemoveBlip(Job['Blips'][i])
			end
		end
	end)
end

local Jobs = {
	['elec_boxes'] = function()
		local amount = math.random(currentJob['ToDo']['min'], currentJob['ToDo']['max'])
		local coords = {}
		local chosen = {}
		for i = 1, amount do
			local newCoord = currentJob['Coords'][math.random(1, #currentJob['Coords'])]
			while chosen[newCoord] do
				newCoord = currentJob['Coords'][math.random(1, #currentJob['Coords'])]
			end
			chosen[newCoord] = true
			coords[#coords + 1] = newCoord
		end
		
		local prop = GetHashKey('h4_prop_h4_elecbox_01a')
		lib.requestModel(prop)

		for i = 1, #coords do
			currentJob['Blips'] = {}
			currentJob['Blips'][#currentJob['Blips'] + 1] = createBlip(coords[i], '', currentJob['Blip']['Id'], currentJob['Blip']['Scale'], currentJob['Blip']['Color'], false)

			local object = CreateObjectNoOffset(prop, coords[i].x, coords[i].y, coords[i].z, true, true, true)

			while not DoesEntityExist(object) do
				Wait(100)
			end

			SetEntityHeading(object, coords[i].w)

			currentJob['Objects'] = {}
			currentJob['Objects'][#currentJob['Objects'] + 1] = object

			currentJob['CompletedTasks'] = 0

			exports['ox_target']:addLocalEntity(object, {
				label = 'Elektrisk Box',
				icon = 'fa-solid fa-bolt',
				distance = 2,
				onSelect = function()
					exports['mani-bridge']:EletricBox(object, function(hasWon)
						if hasWon then
							exports['ox_target']:removeLocalEntity(object)
							currentJob['CompletedTasks'] = currentJob['CompletedTasks'] + 1
							if currentJob['CompletedTasks'] >= amount then
								Wait(1000)
								deletePropTimer(currentJob)

								if currentJob['Reward']['Time'] then
									local reduced = amount * currentJob['Reward']['Time']
									settings['time'] = settings['time'] - reduced
									exports['mani-bridge']:Notify('Fængsel', ('%s %s reduceret'):format(reduced, reduced > 1 and 'Minutter' or 'Minut'), 'info', 5000)
									lib.callback.await('mani-prison:server:updateSentence', false, settings['time'])
								end
								
								if currentJob['Reward']['Item'] then
									lib.callback.await('mani-prison:server:giveItem', false, currentJob['Reward']['Item'])
								end

								currentJob = {}
							end
						end
					end, 15000)
				end
			})
		end
	end,
	['kitchen'] = function()
		currentJob['Blips'] = {}
		currentJob['Blips'][1] = createBlip(currentJob['Blip']['Coords'], '', currentJob['Blip']['Id'], currentJob['Blip']['Scale'], currentJob['Blip']['Color'], false)

		local recipe = {}
		local recipePoints = 0
		currentJob['Targets'] = {}

		for location, data in pairs(currentJob['FoodLocations']) do
			if location ~= 'Deliver' then
				
				local randomAmount = math.random(1, 3)
				recipe[#recipe + 1] = {
					Label = data['Label'],
					Amount = randomAmount,
					Item = data['Item']
				}
				recipePoints = recipePoints + randomAmount

				currentJob['Targets'][#currentJob['Targets'] + 1] = exports['ox_target']:addBoxZone({
					coords = data['Coords'].xyz,
					name = ('%s_prison'):format(location),
					size = vec3(1, 1, 1),
					rotation = data['Coords'].w,
					debugColour = vec4(51, 54, 92, 50.0),
					debug = Config.Debug,
					options = {
						label = data['Label'],
						icon = 'fa-solid fa-utensils',
						distance = 2,
						onSelect = function()
							if lib.progressBar({
								duration = 5000,
								label = ('Laver %s'):format(data['Label']),
								useWhileDead = false,
								canCancel = true,
								disable = {
									move = true,
									combat = true,
									sprint = true,
								},
								anim = {
									dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
									clip = 'machinic_loop_mechandplayer',
								}, 
							}) then
								lib.callback.await('mani-prison:server:giveItem', false, data['Item'])
							end
						end
					}
				})
			end
		end

		local str = ''
		for i, v in pairs(recipe) do
			str = str .. ('- %s: %s\n'):format(v['Label'], v['Amount'])
		end

		currentJob['Targets'][#currentJob['Targets'] + 1] = exports['ox_target']:addBoxZone({
			coords = currentJob['FoodLocations']['Deliver'].xyz,
			name = ('%s_prison'):format('Deliver'),
			size = vec3(1, 1, 1),
			rotation = currentJob['FoodLocations']['Deliver'].w,
			debugColour = vec4(51, 54, 92, 50.0),
			debug = Config.Debug,
			options = {
				{
					label = 'Inventar',
					icon = 'fa-solid fa-box-open',
					distance = 2,
					onSelect = function()
						exports['ox_inventory']:openInventory('stash', 'prison_kitchen')
					end
				},
				{
					label = 'Aflever',
					icon = 'fa-solid fa-check',
					distance = 2,
					onSelect = function()
						local success = lib.callback.await('mani-prison:server:deliverFood', false, recipe)
						if not success then exports['mani-bridge']:Notify('Fængsel', 'Ordren er ikke korrekt', 'error', 5000) return end
						local reducedTime = recipePoints * currentJob['Reward']['Time']

						settings['time'] = settings['time'] - reducedTime
						exports['mani-bridge']:Notify('Fængsel', ('%s Minutter reduceret'):format(reducedTime), 'info', 5000)
						lib.callback.await('mani-prison:server:updateSentence', false, settings['time'])

						CreateThread(function()
							if currentJob['Blips'] then
								for i = 1, #currentJob['Blips'] do
									RemoveBlip(currentJob['Blips'][i])
								end
							end
						
							if currentJob['Targets'] then
								for i = 1, #currentJob['Targets'] do
									exports['ox_target']:removeZone(currentJob['Targets'][i])
								end
							end
						
							lib.hideTextUI()
							currentJob = {}
						end)
					end
				},
			}
		})

		lib.showTextUI(str, { position = 'left-center' })
	end
}

local function unjailPlayer(breakout)
	settings['inJail'] = false
	if zone then
		zone:remove()
		zone = nil
	end

	if not breakout then
		exports['mani-bridge']:TeleportEntity(cache.ped, Config.Prison.Coords['UnJail'])
	else
		Prison.Dispatch()
	end

	exports['mani-bridge']:Notify('Fængsel', 'Du er fri', 'info', 5000)

	lib.callback.await('mani-prison:server:unjailPlayer', false)

	if currentJob['Objects'] then
		for i = 1, #currentJob['Objects'] do
			DeleteEntity(currentJob['Objects'][i])
		end
	end

	if currentJob['Blips'] then
		for i = 1, #currentJob['Blips'] do
			RemoveBlip(currentJob['Blips'][i])
		end
	end

	if currentJob['Targets'] then
		for i = 1, #currentJob['Targets'] do
			exports['ox_target']:removeZone(currentJob['Targets'][i])
		end
	end

	lib.hideTextUI()
	currentJob = {}

	if DoesEntityExist(janitorNpc.entity) then
		DeleteEntity(janitorNpc.entity)
		RemoveBlip(janitorNpc.blip)
	end
end

local function StartPrisonLoop(time)
	CreateThread(function()
		settings['inJail'] = true
		settings['time'] = time
		local interval = 1 * 60 * 1000

		while settings['inJail'] do
			Wait(interval)
			settings['time'] = math.floor(settings['time'] - (interval / 60 / 1000))

			if settings['time'] <= 0 then
				unjailPlayer()
			else
				exports['mani-bridge']:Notify('Tid tilbage', ('%s Minutter'):format(settings['time']), 'info', 5000)
			end
		end
	end)
end

local function CreatePrisonZone()
	if zone then return end

	zone = lib.zones.poly({
		points = Config.Prison['Zone'],
		debugColour = vec4(51, 54, 92, 50.0),
		thickness = 9999,
		debug = Config.Debug,
		onExit = function()
			unjailPlayer(true)
		end
	})
end

local function StartJobLoop()
	local npcModel = GetHashKey('MP_M_Counterfeit_01')
	lib.requestModel(npcModel)
	janitorNpc['entity'] = CreatePed(4, npcModel, Config.Prison['JobNPC'].xyz, Config.Prison['JobNPC'].w, false, false)
	FreezeEntityPosition(janitorNpc['entity'], true)
	SetEntityInvincible(janitorNpc['entity'], true)
	TaskStartScenarioInPlace(janitorNpc['entity'], "WORLD_HUMAN_GUARD_STAND", 0, true)
	SetBlockingOfNonTemporaryEvents(janitorNpc['entity'], true)

	janitorNpc['blip'] = createBlip(Config.Prison['JobNPC'].xyz, 'Fængsels Pedel', 280, 0.5, 46)

	local active = false

	exports['ox_target']:addLocalEntity(janitorNpc['entity'], {
		label = 'Start/Stop Jobs',
		name = 'prison_janitor',
		icon = 'fa-solid fa-broom',
		distance = 1.5,
		onSelect = function()
			CreateThread(function()
				if active then
					if currentJob['Objects'] then
						for i = 1, #currentJob['Objects'] do
							DeleteEntity(currentJob['Objects'][i])
						end
					end
				
					if currentJob['Blips'] then
						for i = 1, #currentJob['Blips'] do
							RemoveBlip(currentJob['Blips'][i])
						end
					end
				
					if currentJob['Targets'] then
						for i = 1, #currentJob['Targets'] do
							exports['ox_target']:removeZone(currentJob['Targets'][i])
						end
					end
				
					lib.hideTextUI()
					currentJob = {}
				end


				active = not active
				while settings['inJail'] and active do
					if not next(currentJob) then
						currentJob = Config.Prison['Jobs'][math.random(1, #Config.Prison['Jobs'])]
						Jobs[currentJob['Id']](currentJob)
					end
					Wait(5000)
				end
			end)
		end
	})
end

RegisterNetEvent('mani-prison:client:jailPlayer', function(time, spawned)
	local playerPed = cache.ped

	FreezeEntityPosition(playerPed, true)

	exports['mani-bridge']:TeleportEntity(playerPed, Config.Prison.Coords['Spawn'], not spawned)

	FreezeEntityPosition(playerPed, false)

	CreatePrisonZone()

	exports['mani-bridge']:Notify('Du er blevet fængslet', ('%s Minutter'):format(math.floor(time)), 'info', 5000)

	Prison.ResetPlayerArmor(playerPed)
	StartPrisonLoop(time)
	StartJobLoop()
end)

RegisterNetEvent('mani-prison:client:unjailPlayer', unjailPlayer)

lib.callback.register('mani-prison:client:confirm', function(Name, Time)
	return lib.alertDialog({
		header = 'Er du sikker?',
		content = ('Vil du fængsle [%s]  \n %s minutter'):format(Name, Time),
		centered = true,
		cancel = true
	})
end)

CreateThread(function()
	exports['ox_target']:addGlobalPlayer({
		label = 'Fængsel',
		name = 'mani-prison:target',
		icon = 'fas fa-lock',
		distance = 2,
		groups = Config.PoliceJob,
		onSelect = function(data)
			local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
			
			local input = lib.inputDialog('Fængsel', {{type = 'number', label = 'Måneder', description = 'Antal måneder', icon = 'hashtag'}})

			if not input then return end
			local time = tonumber(input[1])
			if not time or time < 1 then return end
			
			lib.callback.await('mani-prison:server:jailPlayer', false, serverId, time)
		end
	})

	if not Config.Prison['Coords']['Blip'] then return end
	createBlip(Config.Prison['Coords']['Blip'], Config.Prison['Blip']['Label'], Config.Prison['Blip']['Id'], Config.Prison['Blip']['Scale'], Config.Prison['Blip']['Color'], true)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
	if not currentJob['Objects'] then return end
	for i = 1, #currentJob['Objects'] do
		DeleteEntity(currentJob['Objects'][i])
	end
end)