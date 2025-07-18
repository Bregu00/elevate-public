local Config = lib.load('shared/config')
local newJobTable = {}

CreateThread(function()
    if Config.Framework == 'qbx' then
        for job, _ in pairs(Config.EmergencyJobs) do
            table.insert(newJobTable, job)
        end
    end
end)

function hasEmergencyJob()
    if Config.Framework == 'esx' then
        local job = exports["es_extended"]:getSharedObject().GetPlayerData().job.name
        return Config.EmergencyJobs[job]
    elseif Config.Framework == 'qb' then
        local job = exports['qb-core']:GetPlayerData().job.name
        return Config.EmergencyJobs[job]
    elseif Config.Framework == 'qbx' then
        return exports['qbx_core']:HasGroup(newJobTable)
    end
end

function notify(title, icon, type)
    lib.notify({ title = title, icon = icon, type = type })
end

CreateThread(function()
    if Config.Framework == 'esx' then

        AddEventHandler('esx:onPlayerDeath', function() -- Kick player when died
            exports['mani-radio']:onDeath()
        end)

        RegisterNetEvent('esx:removeInventoryItem', function(item, count) -- Kick player when radioItem is removed
            if item ~= Config.RadioItem then return end

            Wait(500)

            local hasItem = exports['ox_inventory']:Search('slots', Config.RadioItem) -- Checks if the player still has a radio, other than the one they removed

            if not next(hasItem) then
                exports['mani-radio']:onDeath()
            end
        end)

    elseif Config.Framework == 'qb' then

        RegisterNetEvent('mani-radio:client:onPlayerDeath', function(isDead) -- Replace this event, if you dont use qbcore's default ambulancejob
            if isDead then
                exports['mani-radio']:onDeath()
            end
        end)

    elseif Config.Framework == 'qbx' then

        RegisterNetEvent('qbx_medical:client:onPlayerDied', function() -- Replace this event, if you dont use qbox's default ambulancejob
            exports['mani-radio']:onDeath()
        end)

    end
end)