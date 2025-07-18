local function HasJob(src, job)
    if Config.Framework == 'esx' then
        local xPlayer = Core.GetPlayerFromId(src)
        if xPlayer then
            if type(job) == "table" then
                for i = 1, #job do
                    if job[i] == xPlayer.job.name then
                        return true
                    end
                end
            else
                if xPlayer.job.name == job then
                    return true
                end
            end
        end
    elseif Config.Framework == 'qb' then
        local Player = Core.Functions.GetPlayer(src)
        if Player then
            local jobName = Player.PlayerData.job.name
            if type(job) == "table" then
                for i = 1, #job do
                    if job[i] == playerJob then
                        return true
                    end
                end
            else
                if playerJob == job then
                    return true
                end
            end
        end
    elseif Config.Framework == 'qbx' then
        local Player = exports['qbx_core']:GetPlayer(src)
        if Player then
            local playerJob = Player.PlayerData.job.name
            if type(job) == "table" then
                for i = 1, #job do
                    if job[i] == playerJob then
                        return true
                    end
                end
            else
                if playerJob == job then
                    return true
                end
            end
        end
    end
    return false
end

exports('HasJob', HasJob)