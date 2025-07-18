local selectedFramework = require('config.chat').framework

if selectedFramework ~= 'qb-core' then return end

local QBCore = nil

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
            QBCore = exports['qb-core']:GetCoreObject()
        end
        print('^2 Framework started: ' .. selectedFramework)
        return
    else
        warn('Framework not found: ' .. selectedFramework)
    end
end)


local function mergeName(firstname, lastname)
    return firstname .. ' ' .. lastname
end

function GetPlayerFirstName(src)
    local Player = QBCore?.Functions.GetPlayer(src)
    return Player and mergeName(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
end

function GetPlayerJobsInfo(src)
    local Player = QBCore?.Functions.GetPlayer(src)
    if not Player then return end
    return {
        grade = Player.PlayerData.job.grade.name or 'none',
        callsign = Player.PlayerData.metadata.callsign or 'none',
    }
end

function GetFrameworkPlayersJob(src, job)
    local Player = QBCore?.Functions.GetPlayer(src)
    if not Player then return end

    if Player.PlayerData.job.name ~= job then return end

    return QBCore?.Functions.GetQBPlayers()
end
