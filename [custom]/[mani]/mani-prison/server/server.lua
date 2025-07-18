local Config = lib.load('config')
local verifiedItems = {}
local acWebhook = exports['elevate-confidential']:fetch('ac_webhook')

CreateThread(function()
	for i, Job in ipairs(Config.Prison['Jobs']) do
		if Job['Reward']['Item'] then
			local item = Job['Reward']['Item']['item']
			verifiedItems[item] = true
		end
		if Job['FoodLocations'] then
			for _, Food in pairs(Job['FoodLocations']) do
				local item = Food['Item']
				if item then
					verifiedItems[item] = true
				end
			end
		end
	end

	exports['ox_inventory']:RegisterStash('prison_kitchen', 'Fængsels Køkken', 15, 1000)
end)

local function acBan(src, msg, item)
	exports['onl_logsender']:SendLog(src, msg, {
		labels = {
			job = "logs",
			discordId = true,
			steamId = true,
			license = true,
			playerJob = true,
			jobGrade = true,
			playerName = true,
			screenshot = true,
			money = true,
			black_money = true,
			bank = true,
			coords = true,
			radio = true,
		},
		discordTitle = msg,
		discordWebhook = acWebhook
	})
	exports["av_blackmarket"]:fg_BanPlayer(src, ('[CHEAT] - Forsøg på at spawne %s via Prison event'):format(item), true)
end

RegisterNetEvent('esx:playerLoaded', function(src)
	Wait(1000)

	local data = exports['mani-bridge']:getMetaData(src, 'sentence', 'table')
	if not next(data) then return end

	local timeServed = (os.time() - data.os) / 60
	if timeServed >= data.time then
		TriggerClientEvent('mani-prison:client:unjailPlayer', src)
		exports['mani-bridge']:setMetaData(src, 'sentence', {})
	else
		TriggerClientEvent('mani-prison:client:jailPlayer', src, data.time - timeServed, true)
	end	
end) 

local function jailPlayer(src, jailerSrc, time)
	exports['mani-bridge']:setMetaData(src, 'sentence', { os = os.time(), time = time })

	TriggerClientEvent('mani-prison:client:jailPlayer', src, time)
	log({ src = jailerSrc, action = 'Jailed', targetSrc = src, time = time })
end

exports('jailPlayer', jailPlayer)

lib.addCommand(Config.Commands['jail'], {
    help = 'Sæt en spiller i fængsel',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target spiller\'s id',
        },
		{
            name = 'time',
            type = 'number',
            help = 'Jail tid i minutter',
        }
    },
}, function(source, args, raw)
	if args.time < 1 then return end
	local xTarget = ESX.GetPlayerFromId(args.target)
	if not xTarget then return end

	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.getJob().name ~= Config.PoliceJob then return end

	if args.target == source or xTarget.getJob().name == Config.PoliceJob or Config.Setings['RequestConfirm'] then
		local confirm = lib.callback.await('mani-prison:client:confirm', source, xTarget.getName(), args.time)
		if confirm == 'cancel' then return end
	end

	jailPlayer(args.target, source, args.time)
end)

lib.addCommand(Config.Commands['unjail'], {
    help = 'Fjern en spiller fra fængsel',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target spiller\'s id',
        },
    },
}, function(source, args, raw)
	local xTarget = ESX.GetPlayerFromId(args.target)
	if not xTarget then return end

	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.getJob().name ~= Config.PoliceJob then return end
	
	if args.target == source and not Config.Setings['CanUnjailYourself'] then return end
	
	TriggerClientEvent('mani-prison:client:unjailPlayer', args.target)
	exports['mani-bridge']:setMetaData(args.target, 'sentence', {})
	
	log({ src = source, action = 'Unjailed', targetSrc = args.target })
end)

lib.callback.register('mani-prison:server:jailPlayer', function(source, serverId, time)
	local xPlayer = ESX.GetPlayerFromId(serverId)
	if not xPlayer or not xPlayer.getJob().name == Config.PoliceJob then return end

	jailPlayer(serverId, source, time)
end)

lib.callback.register('mani-prison:server:unjailPlayer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	exports['mani-bridge']:setMetaData(source, 'sentence', {})
end)

lib.callback.register('mani-prison:server:updateSentence', function(source, newSentence)
	exports['mani-bridge']:setMetaData(source, 'sentence', { os = os.time(), time = newSentence })
end)

lib.callback.register('mani-prison:server:giveItem', function(source, item, amount)
	if not verifiedItems[item] then acBan(source, ('[%s] %s - Forsøgt at spawne %s [mani-prison:server:giveItem]'), source, GetPlayerName(source), item) return end
	exports['ox_inventory']:AddItem(source, item, amount or 1)
end)

lib.callback.register('mani-prison:server:deliverFood', function(source, recipe)
    local stash = exports['ox_inventory']:GetInventoryItems('prison_kitchen')
    local hasAllItems = true

	for recipeIndex = 1, #recipe do
		local recipeItem = recipe[recipeIndex]
        local itemName = recipeItem.Item
        local requiredAmount = recipeItem.Amount
        local found = false

		for stashIndex = 1, #stash do
			local stashItem = stash[stashIndex]
            if stashItem.name == itemName and stashItem.count >= requiredAmount then
                found = true
                break
            end
        end
		
        if not found then
            hasAllItems = false
            break
        end
    end

	if hasAllItems then
		for i = 1, #recipe do
			exports['ox_inventory']:RemoveItem('prison_kitchen', recipe[i].Item, recipe[i].Amount)
		end
	end

    return hasAllItems
end)