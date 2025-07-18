local function GetJob()
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerData()
        if xPlayer then
            return xPlayer.job
        end
    elseif Config.Framework == 'qb' then
        local Player = Core.Functions.GetPlayerData()
        if Player then
            return Player.job
        end
    elseif Config.Framework == 'qbx' then
        local Player = Core.Functions.GetPlayerData()
        if Player then
            return Player.job
        end
    end
end

exports('GetJob', GetJob)