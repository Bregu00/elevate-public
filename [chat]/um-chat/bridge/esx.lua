local selectedFramework = require('config.chat').framework

if selectedFramework ~= 'es_extended' then return end

local ESX = nil

CreateThread(function()
    local state = GetResourceState(selectedFramework)
    if state ~= 'missing' then
        local timeout = 0
        while state ~= 'started' and timeout <= 100 do
            timeout += 1
            state = GetResourceState(selectedFramework)
            Wait(0)
        end
        if state == 'started' then
            ESX = exports['es_extended']:getSharedObject()
        end
        print('^2 Framework started: ' .. selectedFramework)
        return
    else
        warn('Framework not found: ' .. selectedFramework)
    end
end)

function GetPlayerFirstName(src)
    local xPlayer = ESX?.GetPlayerFromId(src)
    return xPlayer and xPlayer.getName()
end

function GetPlayerJobsInfo(src)
    local xPlayer = ESX?.GetPlayerFromId(src)
    if not xPlayer then return end
    return {
        grade = xPlayer.job.grade_label or 'none',
        callsign = 'none',
    }
end

function GetFrameworkPlayersJob(src, job)
    local xPlayer = ESX?.GetPlayerFromId(src)
    if not xPlayer then return end

    if xPlayer.job.name ~= job then return end

    return ESX?.GetExtendedPlayers('job', job)
end
