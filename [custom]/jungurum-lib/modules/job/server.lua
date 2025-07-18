local jobCounts, playerJobs = {}, {}

local function getPlayerJob(player)
    return playerJobs[player] or nil
end

local function updateJobCount(player, oldJob, newJob)
    if oldJob and oldJob ~= newJob then
        jobCounts[oldJob] = (jobCounts[oldJob] or 0) - 1
        if jobCounts[oldJob] <= 0 then
            jobCounts[oldJob] = nil
        end
    end
    if newJob then
        jobCounts[newJob] = (jobCounts[newJob] or 0) + 1
    end
end

local function getJobCount(jobName)
    return jobCounts[jobName] or 0
end

RegisterNetEvent('esx:setJob', function(playerId, job, lastJob)
    local oldJob = lastJob.name
    local newJob = job.name
    updateJobCount(playerId, oldJob, newJob)
    playerJobs[playerId] = newJob
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    local job = playerJobs[playerId]
    if job then
        updateJobCount(playerId, job, nil)
    end
end)

lib.addCommand('jobCount', {
    help = 'Få online spillere på specifikt job',
    params = {
        {
            name = 'job',
            type = 'jobName',
            help = 'Job Navn',
        },
    },
    restricted = { 'group.admin', 'group.god' }
}, function(source, args, raw)
    local jobName = args.job:lower()

    if not jobName then
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'Server', 'Usage: /jobCount <jobname>' }
        })
        return
    end

    local count = getJobCount(jobName)

    TriggerClientEvent('ox_lib:notify', source, { title = 'Elevate', description = ('%s Online: %s'):format(jobName, tostring(count)) })
end)

exports("getJobCount", getJobCount)