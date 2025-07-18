local jobs = {}
local jobNames = {}
local bossMenu = {}
local allJobs = {}
local allGrades = {}
local identifiers = {}
local function getAllPlayerJobs()
    local playerJobs = MySQL.query.await('SELECT * FROM `lunar_multijob`')
    local accounts = MySQL.query.await('SELECT * FROM `lunar_multijob_accounts`')
    allJobs = MySQL.query.await('SELECT * FROM `jobs`')
    allGrades = MySQL.query.await('SELECT * FROM `job_grades`')
    jobs = {}
    bossMenu = {}
    for k, v in pairs(allJobs) do
        if not jobNames[v.name] then
            jobNames[v.name] = {}
        end
        jobNames[v.name] = v
        jobNames[v.name].grades = {}
        for _, grade in pairs(allGrades) do
            if grade.job_name == v.name then
                jobNames[v.name].grades[grade.grade] = grade
            end
        end
    end
    for k, v in pairs(playerJobs) do
        if not jobs[v.identifier] then
            jobs[v.identifier] = {}
        end
        table.insert(jobs[v.identifier], v)
    end
    for k, v in pairs(jobs) do
        for i = 1, #v do
            local job = v[i]
            if not bossMenu[job.name] then
                bossMenu[job.name] = {}
            end
            if not bossMenu[job.name].workers then
                bossMenu[job.name].workers = {}
            end
            if not bossMenu[job.name].workers[k] then
                bossMenu[job.name].workers[k] = {}
            end
            bossMenu[job.name].workers[k] = {
                identifier = job.identifier,
                playerName = exports["jungurum-smallresources"]:getFullName(job.identifier) and exports["jungurum-smallresources"]:getFullName(job.identifier).fullname or job.identifier,
                jobName = job.name,
                jobLabel = jobNames[job.name] and jobNames[job.name].label or job.name,
                jobGrade = job.grade,
                total = job.total,
                jobGradeLabel = jobNames[job.name] and jobNames[job.name].grades[job.grade] and jobNames[job.name].grades[job.grade].label or job.grade,
            }
        end
    end
    for i = 1, #accounts do
        if not bossMenu[accounts[i].name] then
            bossMenu[accounts[i].name] = {}
        end
        bossMenu[accounts[i].name].account = accounts[i].balance or 0
        bossMenu[accounts[i].name].webhook = accounts[i].webhook or nil
        bossMenu[accounts[i].name].logo = accounts[i].logo or nil
        bossMenu[accounts[i].name].income = accounts[i].income or nil
    end
end

exports("getAllPlayerJobs", getAllPlayerJobs)

CreateThread(function()
    getAllPlayerJobs()
end)

local function getPlayerJobs(identifier)
    if jobs[identifier] then
        return jobs[identifier]
    else
        return nil
    end
end

AddEventHandler('esx:playerLoaded', function (playerId, xPlayer, isNew)
    if xPlayer then
        local identifier = xPlayer.identifier
        if not identifiers[playerId] then
            identifiers[playerId] = identifier
        end
    end
end)

lib.callback.register("elevate-multijob:server:getJobs", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            local jobList = {}
            for _, job in pairs(playerJobs) do
                local jobName = job.name
                local jobGrade = job.grade
                local jobLabel = jobNames[jobName] and jobNames[jobName].label or jobName
                local jobGradeLabel = jobNames[jobName] and jobNames[jobName].grades[jobGrade] and jobNames[jobName].grades[jobGrade].label or jobGrade
                local jobActive = job.active
                table.insert(jobList, {
                    job_name = jobName,
                    grade = jobGrade,
                    job_label = jobLabel,
                    job_grade_label = jobGradeLabel,
                    total = job.total,
                    job_active = jobActive,
                })
            end
            return jobList
        else
            return nil
        end
    end
end)

lib.callback.register("elevate-multijob:server:changeWebhook", function(source, webhook)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.job.grade_name ~= "boss" then return false end
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == xPlayer.job.name then
                        MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `webhook` = @webhook WHERE `name` = @jobName', {
                            ['@webhook'] = webhook,
                            ['@jobName'] = job.name,
                        })
                        bossMenu[job.name].webhook = webhook
                        return true
                    end
                end
            end
        end
    end
    return false
end)

lib.callback.register("elevate-multijob:server:changeLogo", function(source, logo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.job.grade_name ~= "boss" then return false end
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == xPlayer.job.name then
                        MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `logo` = @logo WHERE `name` = @jobName', {
                            ['@logo'] = logo,
                            ['@jobName'] = job.name,
                        })
                        bossMenu[job.name].logo = logo
                        return true
                    end
                end
            end
        end
    end
    return false
end)

lib.callback.register("elevate-multijob:server:setJob", function(source, jobName, active)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        local tempActive = active == 1 and 0 or 1
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == jobName then
                        MySQL.update.await('UPDATE `lunar_multijob` SET `active` = @active WHERE `identifier` = @identifier AND `name` = @jobName', {
                            ['@identifier'] = identifier,
                            ['@jobName'] = jobName,
                            ['@active'] = tempActive
                        })
                        if (jobName ~= xPlayer.job.name) then
                            xPlayer.setJob(jobName, job.grade)
                        elseif (jobName == xPlayer.job.name) then
                            xPlayer.setJob('unemployed', 0)
                        end
                        jobs[xPlayer.identifier][i].active = tempActive
                        return true
                    end
                end
            end
        end
    end
    return false
end)


lib.callback.register("elevate-multijob:server:getPossibleGrades", function(source, job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local jobData = playerJobs[i]
                    if jobData.name == job then
                        local grades = {}
                        for k, v in pairs(jobNames[job].grades) do
                            table.insert(grades, {
                                value = k,
                                label = v.label,
                            })
                        end
                        return grades
                    end
                end
            end
        end
    end
end)


lib.callback.register("elevate-multijob:server:changeGrade", function(source, identifier, jobName, grade)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.grade_name ~= "boss" then return false end
    local playerJobs = getPlayerJobs(identifier)
    if playerJobs then
        for i = 1, #playerJobs do
            if playerJobs[i] ~= nil then
                local job = playerJobs[i]
                if job.name == jobName then
                    MySQL.update.await('UPDATE `lunar_multijob` SET `grade` = @grade WHERE `identifier` = @identifier AND `name` = @jobName', {
                        ['@identifier'] = identifier,
                        ['@jobName'] = jobName,
                        ['@grade'] = grade
                    })
                    MySQL.update.await('UPDATE `users` SET `job_grade` = @grade WHERE `identifier` = @identifier AND `job` = @jobName', {
                        ['@identifier'] = identifier,
                        ['@jobName'] = jobName,
                        ['@grade'] = grade
                    })
                    if xTarget then xTarget.setJob(jobName, grade) end
                    jobs[identifier][i].grade = grade
                    bossMenu[job.name].workers[identifier].jobGrade = grade
                    bossMenu[job.name].workers[identifier].jobGradeLabel = jobNames[jobName] and jobNames[jobName].grades[grade] and jobNames[jobName].grades[grade].label or grade
                    return true
                end
            end
        end
    end
    return false
end)


lib.callback.register("elevate-multijob:server:removeJob", function(source, jobName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == jobName then
                        MySQL.update.await('DELETE FROM `lunar_multijob` WHERE `identifier` = @identifier AND `name` = @jobName', {
                            ['@identifier'] = identifier,
                            ['@jobName'] = jobName,
                        })
                        xPlayer.setJob('unemployed', 0)
                        jobs[xPlayer.identifier][i] = nil
                        bossMenu[job.name].workers[identifier] = nil
                        return true
                    end
                end
            end
        end
    end
    return false
end)

lib.callback.register("elevate-multijob:server:getJobBossMenu", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if not bossMenu[xPlayer.job.name] then return nil end
        return bossMenu[xPlayer.job.name]
    end
    return nil
end)

lib.callback.register("elevate-multijob:server:removeWorker", function(source, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    if xPlayer.job.grade_name ~= "boss" then return false end
    local playerJobs = getPlayerJobs(identifier)
    if playerJobs then
        for i = 1, #playerJobs do
            if playerJobs[i] ~= nil then
                local job = playerJobs[i]
                if job.name == xPlayer.job.name then
                    MySQL.update.await('DELETE FROM `lunar_multijob` WHERE `identifier` = @identifier AND `name` = @jobName', {
                        ['@identifier'] = identifier,
                        ['@jobName'] = job.name,
                    })
                    jobs[identifier][i] = nil
                    bossMenu[job.name].workers[identifier] = nil
                    if xTarget and (xTarget.job.name == xPlayer.job.name) then
                        xTarget.setJob('unemployed', 0)
                    end
                    if not xTarget then
                        local currentJob = MySQL.query.await('SELECT `job` FROM `users` WHERE `identifier` = @identifier', {
                            ['@identifier'] = identifier
                        })
                        if currentJob[1] and (currentJob[1].job == xPlayer.job.name) then
                            MySQL.update.await('UPDATE `users` SET `job` = @jobName, `job_grade` = @grade WHERE `identifier` = @identifier', {
                                ['@identifier'] = identifier,
                                ['@jobName'] = 'unemployed',
                                ['@grade'] = 0
                            })
                        end
                    end
                    return true
                end
            end
        end
    end
end)


lib.callback.register("elevate-multijob:server:getClosestPlayers", function(source)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local tempPlayers = lib.getNearbyPlayers(coords, 3, true)
    local players = {}
    for i = 1, #tempPlayers do
        local player = tempPlayers[i]
        -- if player.id ~= src then
            local xTarget = ESX.GetPlayerFromId(player.id)
            players[i] = {
                id = player.id,
                identifier = xTarget.identifier,
                name = exports["jungurum-smallresources"]:getFullName(xTarget.identifier) and exports["jungurum-smallresources"]:getFullName(xTarget.identifier).fullname or xTarget.identifier,
                job = xTarget.job.name,
                grade = xTarget.job.grade,
            }
        -- end
    end
    return players
end)


lib.callback.register("elevate-multijob:server:hireWorker", function(source, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    if xPlayer.job.grade_name ~= "boss" then return false end
    MySQL.insert.await('INSERT INTO `lunar_multijob` (`identifier`, `name`, `grade`, `active`) VALUES (@identifier, @name, @grade, @active)', {
        ['@identifier'] = identifier,
        ['@name'] = xPlayer.job.name,
        ['@grade'] = 0,
        ['@active'] = 1
    })
    local newWorker = {
        identifier = identifier,
        playerName = exports["jungurum-smallresources"]:getFullName(identifier) and exports["jungurum-smallresources"]:getFullName(identifier).fullname or identifier,
        jobName = xPlayer.job.name,
        jobLabel = jobNames[xPlayer.job.name] and jobNames[xPlayer.job.name].label or xPlayer.job.name,
        jobGrade = 0,
        total = 0,
        jobGradeLabel = jobNames[xPlayer.job.name] and jobNames[xPlayer.job.name].grades[0] and jobNames[xPlayer.job.name].grades[0].label or 0,
    }
    bossMenu[xPlayer.job.name].workers[identifier] = newWorker
    local jobData = {
        identifier = identifier,
        name = xPlayer.job.name,
        grade = 0,
        total = 0,
        active = 1
    }
    xTarget.setJob(xPlayer.job.name, 0)
    table.insert(jobs[identifier], jobData)
    return true
end)

lib.callback.register("elevate-multijob:server:withdrawMoney", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.grade_name ~= "boss" then return false end
    if not bossMenu[xPlayer.job.name].webhook then return false, TriggerClientEvent('ox_lib:notify', source, {title = "Ingen webhook sat", type = "error"}) end
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == xPlayer.job.name then
                        if bossMenu[job.name].account >= amount then
                            bossMenu[job.name].account = bossMenu[job.name].account - amount
                            MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `balance` = `balance` - @amount WHERE `name` = @jobName', {
                                ['@amount'] = amount,
                                ['@jobName'] = job.name,
                            })
                            xPlayer.addMoney(amount)
                            sendLog(source, "Withdrawn money: " .. ESX.Math.GroupDigits(amount) .. " from job: " .. job.name .. " after: " .. ESX.Math.GroupDigits(bossMenu[job.name].account) .. " before: " .. ESX.Math.GroupDigits((bossMenu[job.name].account + amount)))
                            exports['fh_bossmenu']:AddIncome(xPlayer.getJob().name, { amount = amount, type = "expense" }, xPlayer.getJob().label)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end)


lib.callback.register("elevate-multijob:server:depositMoney", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.grade_name ~= "boss" then return false end
    if not bossMenu[xPlayer.job.name].webhook then return false, TriggerClientEvent('ox_lib:notify', source, {title = "Ingen webhook sat", type = "error"}) end
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == xPlayer.job.name then
                        if xPlayer.getAccount('money').money >= amount then
                            bossMenu[job.name].account = bossMenu[job.name].account + amount
                            MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `balance` = `balance` + @amount WHERE `name` = @jobName', {
                                ['@amount'] = amount,
                                ['@jobName'] = job.name,
                            })
                            xPlayer.removeMoney(amount)
                            sendLog(source, "Deposited money: " .. ESX.Math.GroupDigits(amount) .. " to job: " .. job.name .. " after: " .. ESX.Math.GroupDigits(bossMenu[job.name].account) .. " before: " .. ESX.Math.GroupDigits((bossMenu[job.name].account - amount)))
                            exports['fh_bossmenu']:AddIncome(xPlayer.getJob().name, { amount = amount, type = "income" }, xPlayer.getJob().label)
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end)



function sendLog(source, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Send player specific log
    local webhookMessage = string.format("Player %s performed action: %s", xPlayer.getName(), message)
    PerformHttpRequest(bossMenu[xPlayer.job.name].webhook, function(err, text, headers) end, 'POST', json.encode({content = webhookMessage}), {['Content-Type'] = 'application/json'})
    -- Send log to onl_logsender
    exports.onl_logsender:SendLog(source, message, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,

        },
        discordTitle = "elevate-multijob",
        discordWebhook = "https://discord.com/api/webhooks/1373843880025395221/dMmMudSdV68lMpCY3e-1LnTppX2q14ia09r39N03vmGVmnXW2yM4MD2aXLVdvpKuOxcw?thread_id=1373843861910323230" -- Another webhook
    })
end

exports('updateJobIncome', function(jobName, data)
    if not jobName or not (bossMenu[jobName]) then return false end
    bossMenu[jobName].income = data
    return true
end)

exports("getCompanyData", function(job)
    if bossMenu[job] then
        return bossMenu[job]
    else
        return nil
    end
end)

exports("getAccountBalance", function(job)
    if bossMenu[job] then
        return bossMenu[job].account
    else
        return 0
    end
end)

exports("addAccountBalance", function(jobName, amount)
    if bossMenu[jobName] then
        bossMenu[jobName].account = bossMenu[jobName].account + amount
        MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `balance` = `balance` + @amount WHERE `name` = @jobName', {
            ['@amount'] = amount,
            ['@jobName'] = jobName,
        })
    end
end)

exports("removeAccountBalance", function(jobName, amount)
    if bossMenu[jobName] then
        bossMenu[jobName].account = bossMenu[jobName].account - amount
        MySQL.update.await('UPDATE `lunar_multijob_accounts` SET `balance` = `balance` - @amount WHERE `name` = @jobName', {
            ['@amount'] = amount,
            ['@jobName'] = jobName,
        })
    end
end)

exports("getWebhook", function(job)
    if bossMenu[job] then
        return {
            webhook = bossMenu[job].webhook,
            logo = bossMenu[job].logo
        }
    else
        return nil
    end
end)

RegisterServerEvent('esx:setJob')
AddEventHandler('esx:setJob', function(source, job)
    if not job or not next(job) then return end
    if job.name == "unemployed" then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local identifier = xPlayer.identifier
        local jobName = job.name
        local jobGrade = job.grade

        -- Ensure jobs[identifier] is initialized
        jobs[identifier] = jobs[identifier] or {}

        local jobData = {
            identifier = identifier,
            name = jobName,
            grade = jobGrade,
            active = 1
        }

        local existingJob = nil

        -- Check if the job already exists
        for i = 1, #jobs[identifier] do
            if jobs[identifier][i] then
                if jobs[identifier][i].name == jobName then
                    existingJob = jobs[identifier][i]
                    break
                end
            end
        end

        if existingJob then
            -- Update the job grade if it has changed
            if existingJob.grade ~= jobGrade then
                MySQL.update.await('UPDATE `lunar_multijob` SET `grade` = @grade WHERE `identifier` = @identifier AND `name` = @jobName', {
                    ['@identifier'] = identifier,
                    ['@jobName'] = jobName,
                    ['@grade'] = jobGrade
                })
                existingJob.grade = jobGrade
                bossMenu[jobName].workers[identifier].jobGrade = jobGrade
                bossMenu[jobName].workers[identifier].jobGradeLabel = jobNames[jobName] and jobNames[jobName].grades[jobGrade] and jobNames[jobName].grades[jobGrade].label or jobGrade
            end
        else
            -- Check if job exists in database and add if needed
            local tempPlayerJob = MySQL.query.await('SELECT * FROM `lunar_multijob` WHERE `identifier` = @identifier AND `name` = @jobName', {
                ['@identifier'] = identifier,
                ['@jobName'] = jobName
            })

            if not tempPlayerJob[1] then
                MySQL.insert.await('INSERT INTO `lunar_multijob` (`identifier`, `name`, `grade`, `active`) VALUES (@identifier, @name, @grade, @active)', {
                    ['@identifier'] = identifier,
                    ['@name'] = jobName,
                    ['@grade'] = jobGrade,
                    ['@active'] = 1
                })
            end

            -- Add job to jobs[identifier] if it doesn't exist
            local jobExists = false
            for i = 1, #jobs[identifier] do
                if jobs[identifier][i] then
                    if jobs[identifier][i].name == jobName then
                        jobExists = true
                        break
                    end
                end
            end

            if not jobExists then
                table.insert(jobs[identifier], jobData)
            end
        end

        for i = 1, #jobs[identifier] do
            if jobs[identifier][i] then
                if jobs[identifier][i].name == jobName then
                    jobs[identifier][i].active = 1
                    break
                end
            end
        end

        -- Update the bossMenu cache
        if not bossMenu[jobName] then
            bossMenu[jobName] = { workers = {}, account = 0, webhook = nil }
        end

        bossMenu[jobName].workers[identifier] = {
            identifier = identifier,
            playerName = exports["jungurum-smallresources"]:getFullName(identifier) and exports["jungurum-smallresources"]:getFullName(identifier).fullname or identifier,
            jobName = jobName,
            jobLabel = jobNames[jobName] and jobNames[jobName].label or jobName,
            jobGrade = jobGrade,
            total = 1, -- You can adjust this based on your logic
            jobGradeLabel = jobNames[jobName] and jobNames[jobName].grades[jobGrade] and jobNames[jobName].grades[jobGrade].label or jobGrade,
        }
    end
end)


RegisterCommand("checkTime", function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local identifier = xPlayer.identifier
        local playerJobs = getPlayerJobs(identifier)
        if playerJobs then
            for i = 1, #playerJobs do
                if playerJobs[i] ~= nil then
                    local job = playerJobs[i]
                    if job.name == xPlayer.job.name then
                        TriggerClientEvent('ox_lib:notify', src, {title = "Job: " .. job.name .. ", Total Time: " .. job.total, type = "error"})
                    end
                end
            end
        end
    end
end, false)

AddEventHandler('playerDropped', function()
    local playerId = source
    local esxIdentifier = identifiers[playerId]
    if jobs[esxIdentifier] then
        for _, job in ipairs(jobs[esxIdentifier]) do
            -- Save the total time to the database
            MySQL.update.await('UPDATE `lunar_multijob` SET `total` = @total WHERE `identifier` = @identifier AND `name` = @jobName', {
                ['@total'] = job.total,
                ['@identifier'] = esxIdentifier,
                ['@jobName'] = job.name,
            })
        end
    end
end)

-- RegisterCommand("saveTime", function(source)
--     local playerId = source
--     local esxIdentifier = ESX.GetPlayerFromId(playerId).identifier -- Get ESX identifier (e.g., char1:license:...)
--     if jobs[esxIdentifier] then
--         for _, job in ipairs(jobs[esxIdentifier]) do
--             -- Save the total time to the database
--             MySQL.update.await('UPDATE `lunar_multijob` SET `total` = @total WHERE `identifier` = @identifier AND `name` = @jobName', {
--                 ['@total'] = job.total,
--                 ['@identifier'] = esxIdentifier,
--                 ['@jobName'] = job.name,
--             })
--         end
--     end
-- end, false)


CreateThread(function()
    while true do
        for esxIdentifier, playerJobs in pairs(jobs) do
            local xPlayer = ESX.GetPlayerFromIdentifier(esxIdentifier)
            if xPlayer then
                if playerJobs then
                    for key, job in ipairs(playerJobs) do
                        if job then
                            if job.name == xPlayer.job.name then
                                if not jobs[esxIdentifier][key].total then
                                    jobs[esxIdentifier][key].total = 0
                                end
                                if not bossMenu[job.name].workers[esxIdentifier].total then
                                    bossMenu[job.name].workers[esxIdentifier].total = 0
                                end
                                -- print("Added 60 seconds to job " .. job.name  .. " for " .. esxIdentifier)
                                bossMenu[job.name].workers[esxIdentifier].total = bossMenu[job.name].workers[esxIdentifier].total + 60
                                jobs[esxIdentifier][key].total = jobs[esxIdentifier][key].total + 60
                            end
                        end
                    end
                end
            end
        end
        Wait(60000) -- Wait 1 minutes (60,000 milliseconds)
    end
end)