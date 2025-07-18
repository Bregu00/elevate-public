-- Add any server-side logic here if needed
-- For example, you could add permission checks or logging

-- Example of how to add permission check (uncomment and modify as needed)
--[[
ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('pvp', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    -- Add your permission check here
    if xPlayer.getGroup() == 'admin' then
        -- Allow command
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'You do not have permission to use this command',
            type = 'error'
        })
    end
end, false)
--]] 

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('pvplort:giveWeapon')
AddEventHandler('pvplort:giveWeapon', function(weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        -- Add the weapon as an item
        xPlayer.addInventoryItem(weaponName, 1)
        
        -- Notify the player
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Weapon Given',
            description = 'You received a ' .. weaponName,
            type = 'success'
        })
    end
end)

RegisterNetEvent('pvplort:giveAmmoAndAttachments')
AddEventHandler('pvplort:giveAmmoAndAttachments', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        -- Give ammo
        xPlayer.addInventoryItem('ammo', 9999)
        xPlayer.addInventoryItem('ammo2', 9999)
        
        -- Give attachments
        xPlayer.addInventoryItem('clip', 20)
        xPlayer.addInventoryItem('silencer', 20)
        
        -- Notify the player
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Items Given',
            description = 'You received ammo and attachments',
            type = 'success'
        })
    end
end)

RegisterNetEvent('pvplort:revivePlayer')
AddEventHandler('pvplort:revivePlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        -- Trigger the ars_ambulancejob heal event with revive flag
        TriggerClientEvent('ars_ambulancejob:healPlayer', source, {revive = true})
        
        -- Notify the player
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Revive',
            description = 'You have been revived',
            type = 'success'
        })
    end
end) 