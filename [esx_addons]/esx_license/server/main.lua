local licenses = {}
local playerLicenses = {}

MySQL.ready(function()
	local p = promise.new()
	MySQL.query('SELECT type, label FROM licenses', function(result)
		licenses = result
		p:resolve(true)
	end)
	Citizen.Await(p)
	ESX.Trace('[esx_license] : ' .. #licenses .. ' Loaded.')
end)

MySQL.ready(function()
	local p = promise.new()
	MySQL.query('SELECT * FROM user_licenses', function(result)
		for k, v in ipairs(result) do
			if not playerLicenses[v.owner] then
				playerLicenses[v.owner] = {}
			end
			table.insert(playerLicenses[v.owner], v.type)
		end
		p:resolve(true)
	end)
	Citizen.Await(p)
	ESX.Trace('[esx_license] : ' .. #licenses .. ' Loaded.')
end)

local function AddLicense(identifier, licenseType, cb)
	MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {licenseType, identifier}, function(rowsChanged)
		if cb then
			for i=1,#licenses do
				if licenses[i].type == licenseType then
					if not playerLicenses[identifier] then
						playerLicenses[identifier] = {}
					end
					table.insert(playerLicenses[identifier], licenseType)
					break
				end
			end
			cb(rowsChanged)
		end
	end)
end

local function RemoveLicense(identifier, licenseType, cb)
	MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(rowsChanged)
		if cb then
			if playerLicenses[identifier] then
				for i=1,#playerLicenses[identifier] do
					if playerLicenses[identifier][i] == licenseType then
						table.remove(playerLicenses[identifier], i)
						break
					end
				end
			end
			cb(rowsChanged)
		end
	end)
end

local function GetLicense(licenseType, cb)
	MySQL.scalar('SELECT label FROM licenses WHERE type = ?', {licenseType}, function(result)
		if cb then
			cb({type = licenseType, label = result})
		end
	end)
end

local function GetLicenses(identifier, cb)
	if playerLicenses[identifier] then
		local result = {}
		for i=1,#playerLicenses[identifier] do
			for j=1,#licenses do
				if playerLicenses[identifier][i] == licenses[j].type then
					table.insert(result, {type = licenses[j].type, label = licenses[j].label})
					break
				end
			end
		end
		cb(result)
	else
		cb({})
	end
end

local function CheckLicense(identifier, licenseType, cb)
	if playerLicenses[identifier] then
		local result = false
		for i=1,#playerLicenses[identifier] do
			if playerLicenses[identifier][i] == licenseType then
				result = true
				break
			end
		end
		cb(result)
	else
		cb(false)
	end
end

local function GetLicensesList(cb)
	cb(licenses)
end

local function isValidLicense(licenseType)
	local flag = false
	for i=1,#licenses do
		if licenses[i].type == licenseType then
			flag = true
			break
		end
	end
	return flag
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		if isValidLicense(licenseType) then
			AddLicense(xPlayer.getIdentifier(), licenseType, cb)
		else
			print(('[esx_license]: Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(licenseType, target))
		end
	end
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then 
		if Config.allowedJobs[xPlayer.getJob().name] then
			local xTarget = ESX.GetPlayerFromId(target)
			if xTarget then
				RemoveLicense(xTarget.getIdentifier(), licenseType, cb)
			end
		else
			xPlayer.showNotification('Your job is not allowed to remove the license', 'error', 3000)
		end
	end
end)

AddEventHandler('esx_license:getLicense', function(licenseType, cb)
	GetLicense(licenseType, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

AddEventHandler('esx_license:checkLicense', function(target, licenseType, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, licenseType)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		GetLicense(licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		GetLicenses(xPlayer.getIdentifier(), cb)
	end
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, licenseType)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		CheckLicense(xPlayer.getIdentifier(), licenseType, cb)
	end
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)


-- RegisterCommand("addLicense", function(source, args, rawCommand)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	if xPlayer then
-- 		if isValidLicense(args[1]) then
-- 			AddLicense(xPlayer.getIdentifier(), args[1], function(rowsChanged)
-- 				if rowsChanged > 0 then
-- 					xPlayer.showNotification('License added successfully', 'success', 3000)
-- 				else
-- 					xPlayer.showNotification('Failed to add license', 'error', 3000)
-- 				end
-- 			end)
-- 		else
-- 			print(('[esx_license]: Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(args[1], source))
-- 		end
-- 	end
-- end, false)

-- RegisterCommand("removeLicense", function(source, args, rawCommand)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	if xPlayer then
-- 		if isValidLicense(args[1]) then
-- 			RemoveLicense(xPlayer.getIdentifier(), args[1], function(rowsChanged)
-- 				if rowsChanged > 0 then
-- 					xPlayer.showNotification('License removed successfully', 'success', 3000)
-- 				else
-- 					xPlayer.showNotification('Failed to remove license', 'error', 3000)
-- 				end
-- 			end)
-- 		else
-- 			print(('[esx_license]: Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(args[1], source))
-- 		end
-- 	end
-- end, false)

-- RegisterCommand("getLicenses", function(source, args, rawCommand)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	if xPlayer then
-- 		GetLicenses(xPlayer.getIdentifier(), function(licenses)
-- 			if #licenses > 0 then
-- 				xPlayer.showNotification('You have the following licenses: ' .. json.encode(licenses), 'success', 3000)
-- 			else
-- 				xPlayer.showNotification('You have no licenses', 'error', 3000)
-- 			end
-- 		end)
-- 	end
-- end, false)

exports('AddLicense', AddLicense)
exports('RemoveLicense', RemoveLicense)
exports('GetLicenses', GetLicenses)
