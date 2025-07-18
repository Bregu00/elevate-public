
local ESX = exports['es_extended']:getSharedObject()

local Accounts = {
    ['bank'] =  true,
    ['crypto'] = true
}

RegisterCommand(Config.RefundCommand, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local charid = xPlayer.getIdentifier()
    if not xPlayer then return TriggerClientEvent("esx:showNotification", source, Config.PlayerDataNotFound) end
    MySQL.Async.fetchAll('SELECT * FROM refunds WHERE identifier = @identifier AND given = @given', {
        ['@identifier'] = charid,
        ['@given'] = 0
    }, function(results)
        if results and #results > 0 then
            for i = 1, #results do
                local itemsData = results[i].items

                itemsData = itemsData:gsub("'", '"')
                local items = json.decode(itemsData)
                if items and next(items) then
                    for itemName, amount in pairs(items) do
                        amount = tonumber(amount) or 0
                        if amount > 0 then
                            if Accounts[itemName] then
                                xPlayer.addAccountMoney(itemName, amount)
                            else
                                xPlayer.addInventoryItem(itemName, amount)
                            end
                        else
                            TriggerClientEvent("esx:showNotification", source, Config.InvalidAmountFound)
                        end
                    end
                else
                    TriggerClientEvent("esx:showNotification", source, Config.InvalidDataFound)
                end
                MySQL.Async.execute('UPDATE refunds SET given = @given WHERE id = @id', {
                    ['@given'] = 1,
                    ['@id'] = results[i].id
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        if i == #results then
                            TriggerClientEvent("esx:showNotification", source, Config.CodeFoundMessage)
                        end
                    else
                        TriggerClientEvent("esx:showNotification", source, Config.CodeNotFoundMessage)
                    end
                end)
            end
        else
            TriggerClientEvent("esx:showNotification", source, Config.CodeNotFoundMessage)
        end
    end)
end, false)