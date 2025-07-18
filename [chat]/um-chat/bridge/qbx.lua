local selectedFramework = require('config.chat').framework

if selectedFramework ~= 'qbox' then return end

local function mergeName(firstname, lastname)
    return firstname .. ' ' .. lastname
end

function GetPlayerFirstName(src)
    local Player = exports.qbx_core:GetPlayer(src)
    return Player and mergeName(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
end

function GetPlayerJobsInfo(src)
    local Player = exports.qbx_core:GetPlayer(src)
    return {
        grade = Player.PlayerData.job.grade.name or 'none',
        callsign = Player.PlayerData.metadata.callsign or 'none',
    }
end

function GetFrameworkPlayersJob(src, job)
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    if Player.PlayerData.job.name ~= job then return end

    return exports.qbx_core:GetQBPlayers()
end
