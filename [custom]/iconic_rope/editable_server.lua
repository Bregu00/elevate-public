RegisterNetEvent('rope:removeItem')
AddEventHandler('rope:removeItem', function(rope)
    local src = source
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)

        xPlayer.removeInventoryItem(Config.Item, 1)
    elseif Config.Framework == 'QBCORE' then
        local xPlayer QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.RemoveItem(Config.Item, 1)
    elseif Config.Framework == 'QBOX' then
        local xPlayer = exports.qbx_core:GetPlayer(src)
        exports.qbx_core:RemoveItem(src, Config.Item, 1)
    end
end)

RegisterNetEvent('rope:addItem')
AddEventHandler('rope:addItem', function(rope)
    local src = source
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)

        xPlayer.addInventoryItem(Config.Item, 1)
    elseif Config.Framework == 'QBCORE' then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddItem(Config.Item, 1)
    elseif Config.Framework == 'QBOX' then
        local xPlayer = exports.qbx_core:GetPlayer(src)
        exports.qbx_core:AddItem(src, Config.Item, 1)
    end
end)

CreateThread(function ()
    if Config.Inventory == 'qb-inventory' then
        QBCore = exports['qb-core']:GetCoreObject()

        QBCore.Functions.CreateUseableItem(Config.Item, function(source, item)
            TriggerClientEvent('iconic:rope:useItem', source)
        end)
    elseif Config.Inventory == 'esx' then
        ESX = exports["es_extended"]:getSharedObject()

        ESX.RegisterUsableItem(Config.Item, function(playerId)
            TriggerClientEvent('iconic:rope:useItem', playerId)
        end)
    elseif Config.Inventory == 'qbox' then
        exports.qbx_core:CreateUseableItem(Config.Item, function(playerId)
            TriggerClientEvent('iconic:rope:useItem', playerId)
        end)
    end
end)