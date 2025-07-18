function hasItem(item)
    return exports['ox_inventory']:GetItemCount(item) >= 1
end

function nearestPlayer()
    local playerPos = GetEntityCoords(cache.ped)
    local playerId, playerPed, playerCoords = lib.getClosestPlayer(playerPos, 2)
    return GetPlayerServerId(playerId), playerPed, playerCoords
end

function hasJob(jobs)
    local playerData = ESX.GetPlayerData()

    if type(jobs) == "table" then
        for index, jobName in pairs(jobs) do
            if playerData.job.name == jobName then return true end
        end
    else
        return playerData.job.name == jobs
    end

    return false
end