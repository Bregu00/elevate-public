ESX.RegisterServerCallback('esx_dmvschool:canYouPay', function(source, cb, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, 'Ingen xPlayer')
        return
    end

	local status = "Ingen aktiv frakendelse"
    local player = xPlayer.identifier

    if not Config.Prices[type] then
        cb(false, 'Ukendt Licensetype')
        return
    end

    local bankMoney = xPlayer.getAccount('bank').money or 0

    MySQL.Async.fetchScalar('SELECT id FROM population WHERE steamid = @steamid', {
        ['@steamid'] = player
    }, function(id)
        if not id then
            if bankMoney >= Config.Prices[type] then
                if exports["fh_accountclose"]:isAccountLocked(source) then
                    cb(false, 'Din konto er låst')
                    return
                end
                xPlayer.removeAccountMoney('bank', Config.Prices[type], "DMV Purchase")
                TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', Config.Prices[type]))
                cb(true)
            else
                cb(false, 'Du har ikke nok penge')
            end
        end

        MySQL.Async.fetchAll('SELECT status FROM population_cases WHERE pid = @pid AND dato >= DATE(NOW()) - INTERVAL 3 DAY', {
            ['@pid'] = id
        }, function(result)
            if not result then
            else
                for _, row in ipairs(result) do
                    if row.status == "Ubetinget frakendelse" then
                        status = row.status
						print(status)
						cb(false, 'Du har en ubetinget frakendelse')
						return	
                    end
                end
            end

            if bankMoney >= Config.Prices[type] then
                if exports["fh_accountclose"]:isAccountLocked(source) then
                    cb(false, 'Din konto er låst')
                    return
                end
                xPlayer.removeAccountMoney('bank', Config.Prices[type], "DMV Purchase")
                TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', Config.Prices[type]))
                cb(true)
            else
                cb(false, 'Du har ikke nok penge')
            end
        end)
    end)
end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local source = source

	TriggerEvent('esx_license:addLicense', source, type, function()
		TriggerEvent('esx_license:getLicenses', source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
		end)
	end)
end)
