lib.locale()

local cached_players = {}
local cached_companies = {}

-- function sendToDiscord(title, message, color, extraFields)
    
--     local embed = {
--         {
--             ["title"] = title,
--             ["description"] = message,
--             ["type"] = "rich",
--             ["color"] = color,
--             ["fields"] = extraFields or {},
--             ["footer"] = {
--                 ["text"] = "Billing • " .. os.date("%Y-%m-%d %H:%M:%S"),
--             }
--         }
--     }

--     local data = {
--         username = "Billing Logs",
--         embeds = embed
--     }

--     PerformHttpRequest("https://discord.com/api/webhooks/1341971746466693151/aCXXLB46Il6WFxUHfuCbXr12E9s9rTjjjJ9xYNvM1xhcxnd0s4t0cknCCLbI1c9GJBeF?thread_id=1341971642234175528", function(err, text, headers)print(json.encode(err), json.encode(text), json.encode(headers)) end, 'POST', 
--         json.encode(data), 
--         { ['Content-Type'] = 'application/json' }
--     )
-- end

-- function getPlayerIdentifiers(source)
--     local identifiers = {
--         steam = "Not Found",
--         discord = "Not Found",
--         license = "Not Found"
--     }
    
--     for _, v in pairs(GetPlayerIdentifiers(source)) do
--         if string.find(v, "steam") then
--             identifiers.steam = v
--         elseif string.find(v, "discord") then
--             identifiers.discord = v:gsub("discord:", "")
--         elseif string.find(v, "license") then
--             identifiers.license = v
--         end
--     end
    
--     return identifiers
-- end

-- function createPlayerInfoFields(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local identifiers = getPlayerIdentifiers(source)
    
--     return {
--         {
--             ["name"] = "👤 Player Information",
--             ["value"] = string.format(
--                 "**Player ID:** %s\n**Character:** %s\n**Job:** %s",
--                 source,
--                 xPlayer and xPlayer.getName() or "Unknown",
--                 xPlayer and xPlayer.job.name or "Unknown"
--             ),
--             ["inline"] = true
--         },
--         {
--             ["name"] = "🔍 Identifiers",
--             ["value"] = string.format(
--                 "**Discord:** <@%s> `%s`\n**Steam:** `%s`",
--                 identifiers.discord,
--                 identifiers.discord,
--                 identifiers.steam
--             ),
--             ["inline"] = true
--         }
--     }
-- end 

local function GetCache()
    local billings = MySQL.query.await('SELECT * FROM `billing` ORDER BY `identifier` ASC')
    local temp_players = {}
    local temp_companies = {}
    
    for _, bill in ipairs(billings) do
        local identifier = bill.identifier
        local company = bill.target and bill.target:gsub("^society_", "") or nil
        
        if not temp_players[identifier] then
            temp_players[identifier] = {}
        end
        
        local billData = {
            id = bill.id,
            identifier = bill.identifier,
			name = (exports["jungurum-smallresources"]:getFullName(bill.identifier) and exports["jungurum-smallresources"]:getFullName(bill.identifier).fullname) or bill.identifier,
            sender = bill.sender,
            target_type = bill.target_type,
            target = bill.target,
            label = bill.label,
            amount = string.format(locale('currency_format'), GroupDigits(bill.amount)),
            amount_raw = bill.amount,
            time = bill.time or os.time()
        }
        
        table.insert(temp_players[identifier], billData)
        
        if company then
            if not temp_companies[company] then
                temp_companies[company] = {}
            end
            table.insert(temp_companies[company], billData)
        end
    end
    
    return {
        players = temp_players,
        companies = temp_companies
    }
end

-- Function to refresh the entire cache
local function RefreshCache()
    local caches = GetCache()
    cached_players = caches.players
    cached_companies = caches.companies
    return true
end

-- Initial cache load
RefreshCache()

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount, note)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	if note == nil then note = "" end

	if amount < 0 then
		print('esx_billing: ' .. GetPlayerName(_source) .. ' tried sending a negative bill!')
		return
	end

	if xTarget == nil then
		print('esx_billing: ' .. playerId .. ' is offline!')
		return
	end

	MySQL.query('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
		['@identifier']  = xTarget.identifier,
		['@sender']      = xPlayer.identifier,
		['@target_type'] = 'society',
		['@target']      = sharedAccountName,
		['@label']       = label,
		['@amount']      = amount
	}, function(rowsChanged)
		local billingType = sharedAccountName == "society_police" and "bøde" or "faktura"
		exports["lb-phone"]:SendNotification(xTarget.source, {
			app = "billing_app",
			title = string.format(locale('billing_received_title'), billingType),
			content = string.format(locale('billing_received_content'), billingType, amount),
		})
		
		if cached_players[xTarget.identifier] then
			local label = ""
			local jobName = sharedAccountName:gsub("society_", "")
			if ESX.GetJobs()[jobName] then
				local labelname = ESX.GetJobs()[jobName].label
				label = ("%s"):format(labelname)
			end

			local amountLabel = string.format(locale('currency_format'), GroupDigits(amount))

			table.insert(cached_players[xTarget.identifier], {
				id = rowsChanged.insertId,
				identifier = xTarget.identifier,
				name = (exports["jungurum-smallresources"]:getFullName(xTarget.identifier) and exports["jungurum-smallresources"]:getFullName(xTarget.identifier).fullname) or xTarget.identifier,
				sender = xPlayer.identifier,
				target_type = 'society',
				target = sharedAccountName,
				label = label,
				amount = string.format(locale('currency_format'), GroupDigits(amount)),
				amount_raw = amount,
				time = os.time()
			})

			local company = sharedAccountName:gsub("^society_", "")
			table.insert(cached_companies[company], {
				id = rowsChanged.insertId,
				identifier = xTarget.identifier,
				name = (exports["jungurum-smallresources"]:getFullName(xTarget.identifier) and exports["jungurum-smallresources"]:getFullName(xTarget.identifier).fullname) or xTarget.identifier,
				sender = xPlayer.identifier,
				target_type = 'society',
				target = sharedAccountName,
				label = label,
				amount = string.format(locale('currency_format'), GroupDigits(amount)),
				amount_raw = amount,
				time = os.time()
			})
		end

		TriggerClientEvent("esx_billing:addBill", xTarget.source)
		TriggerEvent("esx_billing:addBill", rowsChanged.insertId, sharedAccountName, amount, xTarget, xPlayer)
		exports.onl_logsender:SendLog(xPlayer.source, "Send a " .. GroupDigits(amount) .. " bill to: " .. xTarget.identifier, {
			labels = {
				job = "logs",
				discordId = true,
				steamId = true,
				license = true,
				playerJob = true,
				jobGrade = true,
				playerName = true,
				screenshot = false,
				money = false,
				black_money = false,
				bank = true,
				coords = true,
				radio = false,

			},
			discordTitle = "Send a bill to: " .. xTarget.identifier,
			discordWebhook = "https://discord.com/api/webhooks/1344524613647990835/UAWEOAesUMqdV0V0HqWKnisO-k7LF1iHLVflRjjHZqx83fsgxMBL0OYD6FrTDnzdBXfx?thread_id=1344524554948706345" -- Another webhook
		})
	end)
end)

lib.callback.register('st_billing_app:GetBills', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local billings = {}

	local esxJobs = ESX.GetJobs()
	local response = cached_players[xPlayer.identifier]
	if response then
		for i = 1, #response do
			local row = response[i]

			local label = ""
			local jobName = row.target:gsub("society_", "")
			if esxJobs[jobName] then
				local labelname = esxJobs[jobName].label
				label = ("%s"):format(labelname)
			end

			table.insert(billings, {
				id = row.id,
				identifier = row.identifier,
				sender = row.sender,
				targetType = row.target_type,
				target = row.target,
				label = label,
				amount = row.amount
			})
		end
	end

	cached_players[xPlayer.identifier] = deepcopy(billings)

    return billings
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb, reOpen)
	local xPlayer = ESX.GetPlayerFromId(source)
	local time = os.nanotime()

	if reOpen then
		Debug(("Sended %s bills to %s - In %s ms"):format(#cached_players[xPlayer.identifier], xPlayer.identifier, (os.nanotime() - time) / 1000000))
		cb(cached_players[xPlayer.identifier])
	end

	if not reOpen then
		MySQL.query('SELECT * FROM billing WHERE identifier = @identifier', {
			["@identifier"] = xPlayer.identifier
		}, function(result)
			local bills = {}

			if result[1] then
				for i=1, #result, 1 do
					table.insert(bills, {
						id         = result[i].id,
						identifier = result[i].identifier,
						sender     = result[i].sender,
						targetType = result[i].target_type,
						target     = result[i].target,
						label      = result[i].label,
						amount     = result[i].amount
					})
				end
			end

			cached_players[xPlayer.identifier] = deepcopy(bills)
			Debug(("Send %s bills to %s - In %s ms"):format(#cached_players[xPlayer.identifier], xPlayer.identifier, (os.nanotime() - time) / 1000000))

			cb(bills)
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.query('SELECT * FROM billing WHERE identifier = @identifier', {
		["@identifier"] = xPlayer.identifier
	}, function(result)
		local bills = {}

		if result[1] then
			for i=1, #result, 1 do
				table.insert(bills, {
					id         = result[i].id,
					identifier = result[i].identifier,
					sender     = result[i].sender,
					targetType = result[i].target_type,
					target     = result[i].target,
					label      = result[i].label,
					amount     = result[i].amount
				})
			end
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	local time = os.nanotime()
	if exports["fh_accountclose"]:isAccountLocked(source) then return end

	MySQL.query('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)
		if not result[1] then
			return cb(cached_players[xPlayer.identifier])
		end

		local sender = result[1].sender
		local targetType = result[1].target_type
		local target = result[1].target
		local amount = result[1].amount
		local label = result[1].label

		local xTarget = ESX.GetPlayerFromIdentifier(sender)
		if targetType ~= 'player' then
			local job = string.match(target, "[^_]+$")
			-- print(job)
			if xPlayer.getAccount('bank').money >= amount then
				MySQL.query('DELETE from billing WHERE id = @id', {
					['@id'] = id
				}, function(rowsChanged)
					xPlayer.removeAccountMoney('bank', amount)
					exports['elevate-multijob']:addAccountBalance(job, amount)

					if cached_players[xPlayer.identifier] ~= nil then
						local playerBills = cached_players[xPlayer.identifier]
						for k,v in pairs(playerBills) do
							if v.id == id then table.remove(cached_players[xPlayer.identifier], k) end
						end
					end

					local billingType = target == "society_police" and "bøde" or "faktura"
					exports["lb-phone"]:SendNotification(xPlayer.source, {
						app = "billing_app",
						title = locale("billing_paid_title"),
						content = string.format(locale("billing_paid_content"), billingType, GroupDigits(amount)),
					})

					if xTarget ~= nil then
						exports["lb-phone"]:SendNotification(xTarget.source, {
							app = "billing_app",
							title = locale("billing_paid_title"),
							content = string.format(locale("billing_payed_content"), GroupDigits(amount)),
						})
					end

					TriggerEvent("esx_billing:paidBill", id, target, amount, xPlayer, sender)
					Debug(("%s paid %s,- DKK (%s) to %s - In %s ms"):format(xPlayer.identifier, GroupDigits(amount), id, job, (os.nanotime() - time) / 1000000))
					exports.onl_logsender:SendLog(xPlayer.source, "Payed a " .. GroupDigits(amount) .." bill from: " .. job, {
						labels = {
							job = "logs",
							discordId = true,
							steamId = true,
							license = true,
							playerJob = true,
							jobGrade = true,
							playerName = true,
							screenshot = false,
							money = false,
							black_money = false,
							bank = true,
							coords = true,
							radio = false,
			
						},
						discordTitle = "Payed a bill from: " .. job,
						discordWebhook = "https://discord.com/api/webhooks/1344524613647990835/UAWEOAesUMqdV0V0HqWKnisO-k7LF1iHLVflRjjHZqx83fsgxMBL0OYD6FrTDnzdBXfx?thread_id=1344524554948706345" -- Another webhook
					})
					
					exports["fh_bossmenu"]:AddIncome(xPlayer.getJob().name, { amount = amount, type = "income", description = 'Faktura Betaling' }, xPlayer.getJob().label)
			
					function urlencode(str)
						if str then
							str = string.gsub(str, "\n", "\r\n")
							str = string.gsub(str, "([^%w ])", function(c) return string.format("%%%02X", string.byte(c)) end)
							str = string.gsub(str, " ", "+")
						end
						return str or "" 
					end
					
					local option1 = urlencode(xPlayer.getName())
					local option2 = urlencode(xPlayer.identifier)
					local xTargetName = (exports["jungurum-smallresources"]:getFullName(xTarget.identifier) and exports["jungurum-smallresources"]:getFullName(xTarget.identifier).fullname) or xTarget.identifier

					local option3 = urlencode(xTargetName)
					local option4 = urlencode(xTarget.identifier)
					local option5 = urlencode(target)
					local option6 = urlencode(targetType)
					local option7 = urlencode(amount)
					local option8 = urlencode(label)
				
					local url = "https://script.google.com/macros/s/AKfycbw08YDS6oLMQlQhytZmVjhmxjYOci8wJotNkHNU5SXT_EGxO_STJGZfsSbmQiYtjFoViA/exec"
					url = url .. "?option1=" .. option1 ..
						"&option2=" .. option2 ..
						"&option3=" .. option3 ..
						"&option4=" .. option4 ..
						"&option5=" .. option5 ..
						"&option6=" .. option6 ..
						"&option7=" .. option7 ..
						"&option8=" .. option8
				
					PerformHttpRequest(url, function(statusCode, responseText, headers)
					end, "GET", "", {["User-Agent"] = "FiveM"})

					cb(cached_players[xPlayer.identifier])
				end)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, locale("insufficient_funds"))
				cb(cached_players[xPlayer.identifier])
			end
		end
	end)
end)

payCity = function(amount)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_city', function(account)
		account.addMoney(amount)
	end)
end

exports('getAllBills', function()
    return cached_players, cached_companies
end)

exports('getAllCompanyBills', function()
    return cached_companies
end)

exports('getAllPlayerBills', function()
    return cached_players
end)

exports('getCompanyBills', function(companyName)
    return cached_companies[companyName] or {}
end)

exports('getPlayerBills', function(identifier)
    return cached_players[identifier] or {}
end)

exports('RemoveBill', function(identifier, bill)   
    if not bill or not bill.id then
        return false
    end
    
    local removed = false
    
    if cached_players[identifier] then
        for i = #cached_players[identifier], 1, -1 do
            if cached_players[identifier][i].id == bill.id then
                table.remove(cached_players[identifier], i)
                removed = true
                break
            end
        end
    end
    
    if bill.target then
        local companyName = bill.target:gsub("^society_", "")
        
        if cached_companies[companyName] then
            for i = #cached_companies[companyName], 1, -1 do
                if cached_companies[companyName][i].id == bill.id then
                    table.remove(cached_companies[companyName], i)
                    removed = true
                    break
                end
            end
        end
    end
    
    if not removed then
        RefreshCache()
        return true
    end
    
    return true
end)

exports('RefreshCache', function()
    return RefreshCache()
end)

exports('getCompanyOutstanding', function(companyName)
    if not companyName or not cached_companies[companyName] then return 0 end
    local total = 0
    for _, bill in ipairs(cached_companies[companyName]) do
        total = total + (bill.amount_raw or 0)
    end
    return total
end)

lib.callback.register("st_billing:server:GetAllJobs", function(source)
	local allJobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs WHERE isgang = 0 AND whitelisted = 1')
	for k, v in pairs(jobs) do
		allJobs[v.name] = 0
	end
	return allJobs
end)

if Config.VersionCheck then 
    lib.versionCheck('Stausi/Stausi-Billing')
    return 
end

