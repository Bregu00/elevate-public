local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cooldown = false

local function setupCooldown()
	cooldown = true
	SetTimeout(1000, function()
		cooldown = false
	end)
end

-- Open ID card
RegisterServerEvent('jsfour-idcard:open', function(ID, targetID, metadata)
	if cooldown then return end
	setupCooldown()

	local show       = false
	local user = {}
	user[1] = metadata

	exports["esx_license"]:GetLicenses(metadata.identifier, function(licenses)
		show = true
		if show then
			local array = {
				user = user,
				licenses = licenses
			}
			if targetID ~= 0 then
				TriggerClientEvent('jsfour-idcard:open', targetID, array)
			end
			TriggerClientEvent('jsfour-idcard:open', ID, array)
		end
	end)
end)

lib.callback.register('jsfour-idcard:server:sendIdItem', function(source, slot, targetID)
    local src = source
    local metadata = exports['mani-bridge']:getItemFromSlot(src, slot).metadata
	if next(metadata) then
		TriggerEvent('jsfour-idcard:open', src, targetID, metadata)
		return true
	else
		return false
	end
end)

exports('CreateMetaLicense', function(src, itemTable)
	local metadata = {}
    local xPlayer = ESX.GetPlayerFromId(src)

    if type(itemTable) == 'string' then
        itemTable = { itemTable }
    end

    if type(itemTable) == 'table' then
        for _, v in pairs(itemTable) do
			local firstname = xPlayer.variables.firstName
			local lastname = xPlayer.variables.lastName
            metadata = {
                identifier = xPlayer.getIdentifier(),
                firstname = firstname,
                lastname = lastname,
                dateofbirth = xPlayer.variables.dateofbirth,
                sex = xPlayer.variables.sex,
				height = xPlayer.variables.height,
				description = ('%s %s'):format(firstname, lastname)
            }
            exports['ox_inventory']:AddItem(src, v, 1, metadata)
        end
    end
end)