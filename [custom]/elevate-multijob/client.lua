RegisterCommand("jobs", function()
    local jobs = lib.callback.await("elevate-multijob:server:getJobs", false)
    if not jobs then 
        lib.notify({
            title = "Fejl",
            description = "Du har ingen jobs.",
            type = "error"
        })
        return
    end
    local options = {}
    for i = 1, #jobs do
        local job = jobs[i]
        local jobName = job.job_name
        local jobLabel = job.job_label
        local jobGrade = job.grade
        local total = job.total
        if job.total == nil then
            total = formatTime(tonumber(0))
        end
        local jobGradeLabel = job.job_grade_label
        local jobLabelWithGrade = string.format("%s - %s", jobLabel, jobGradeLabel)
        
        table.insert(options, {
            title = jobLabelWithGrade,
            description = "Job: " .. jobName .. "\nGrade: " .. jobGrade .. "\nTotal Time: " .. formatTime(tonumber(total) or 0),
            icon = "briefcase",
            onSelect = function()
                lib.registerContext({
                    id = jobName,
                    title = jobLabelWithGrade,
                    options = {
                        {
                            title = "Toggle",
                            description = "Toggle your job: " .. jobLabelWithGrade,
                            icon = "fa-toggle-on",
                            onSelect = function()
                                local jobset = lib.callback.await("elevate-multijob:server:setJob", false, jobName, job.job_active)
                                if jobset then
                                    local newActive = job.job_active == 1 and 0 or 1
                                    jobs[i].job_active = newActive
                                    lib.notify({
                                        title = "Job Toggled",
                                        description = "You have toggled your job: " .. jobLabelWithGrade,
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Error",
                                        description = "Failed to toggle your job.",
                                        type = "error"
                                    })
                                end
                                lib.showContext(jobName)
                            end
                        },
                        {
                            title = "Fjern",
                            description = "Fjern: " .. jobLabelWithGrade,
                            icon = "fa-xmark",
                            onSelect = function()
                                local jobset = lib.callback.await("elevate-multijob:server:removeJob", false, jobName)
                                if jobset then
                                    jobs[i] = nil
                                    lib.notify({
                                        title = "Job fjernet",
                                        description = "Du har fjernet: " .. jobLabelWithGrade,
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Fejl",
                                        description = "Fjernelse af job fejlede.",
                                        type = "error"
                                    })
                                end
                            end
                        }
                    }
                })
                lib.showContext(jobName)
            end
        })
    end
    lib.registerContext({
        id = 'myJobs',
        title = 'Mine Jobs',
        options = options
    })
    lib.showContext('myJobs')
end, false)


RegisterCommand("bossmenu", function()
    local xPlayer = ESX.GetPlayerData()
    if not (xPlayer.job.grade_name == "boss") then
        lib.notify({
            title = "Fejl",
            description = "Du er ikke boss.",
            type = "error"
        })
        return
    end
    local bossmenu = lib.callback.await("elevate-multijob:server:getJobBossMenu", false)
    if not bossmenu then
        lib.notify({
            title = "Fejl",
            description = "Du har ingen jobs.",
            type = "error"
        })
        return
    end
    local options = {
        {
            title = "Konto håndtering",
            icon = "fa-building-columns",
            onSelect = function()
                local options = {
                    {
                        title = "Kontostand: " .. ESX.Math.GroupDigits(bossmenu.account or 0),
                        icon = "fa-money-bill",
                        readOnly = true,
                    },
                    {
                        title = "Hæv",
                        icon = "fa-minus",
                        onSelect = function()
                            local amount = lib.inputDialog("Hæv penge", {
                                { type = "number", label = "Beløb" , required = true, placeholder = "Indtast beløb"}
                            })
                            if amount and amount[1] then
                                local withdraw = lib.callback.await("elevate-multijob:server:withdrawMoney", false, amount[1])
                                if withdraw then
                                    lib.notify({
                                        title = "Penge hævet",
                                        description = "Du har hævet: " .. ESX.Math.GroupDigits(amount[1]) .. "DKK",
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Fejl",
                                        description = "Hævning fejlede.",
                                        type = "error"
                                    })
                                end
                            end
                        end
                    },
                    {
                        title = "Indsæt",
                        icon = "fa-plus",
                        onSelect = function()
                            local amount = lib.inputDialog("Indsæt penge", {
                                { type = "number", label = "Beløb" , required = true, placeholder = "Indtast beløb"}
                            })
                            if amount and amount[1] then
                                local deposit = lib.callback.await("elevate-multijob:server:depositMoney", false, amount[1])
                                if deposit then
                                    lib.notify({
                                        title = "Penge Indsat",
                                        description = "Du har indsat: " .. ESX.Math.GroupDigits(amount[1]) .. "DKK",
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Fejl",
                                        description = "indsætning fejlede.",
                                        type = "error"
                                    })
                                end
                            end
                        end
                    },
                    {
                        title = "Sæt webhook",
                        icon = "fa-address-book",
                        onSelect = function()
                            local webhook = lib.inputDialog("Sæt webhook", {
                                { type = "input", label = "Webhook URL" , required = true, placeholder = "Indtast webhook URL"}
                            })
                            if webhook and webhook[1] then
                                local setWebhook = lib.callback.await("elevate-multijob:server:changeWebhook", false, webhook[1])
                                if setWebhook then
                                    lib.notify({
                                        title = "Webhook sat",
                                        description = "Du har sat en webhook.",
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Fejl",
                                        description = "Opsætning af webhook fejlede.",
                                        type = "error"
                                    })
                                end
                            end
                        end
                    }
                }
                lib.registerContext({
                    id = 'moneyWorks',
                    title = 'Konto',
                    options = options
                })
                lib.showContext('moneyWorks')
            end
        },
        {
            title = "Medarbejder håndtering",
            icon = "fa-user",
            onSelect = function()
                lib.showContext('bossMenuWorkers')
            end
        },
        {
            title = "Hyr medarbejder",
            icon = "fa-user",
            onSelect = function()
                local closetPlayers = lib.callback.await("elevate-multijob:server:getClosestPlayers", false)
                local options = {}
                for k, v in pairs(closetPlayers) do
                    table.insert(options, {
                        title = v.name,
                        icon = "fa-user",
                        onSelect = function()
                            local hireWorker = lib.callback.await("elevate-multijob:server:hireWorker", false, v.identifier)
                            if hireWorker then
                                lib.notify({
                                    title = "Medarbejder ansat",
                                    description = "Du har ansat: " .. v.name,
                                    type = "success"
                                })
                            else
                                lib.notify({
                                    title = "Fejl",
                                    description = "Ansættelse af medarbejder fejlede.",
                                    type = "error"
                                })
                            end
                        end
                    })
                end
                lib.registerContext({
                    id = 'hireWorker',
                    title = 'Ansæt medarbejder',
                    options = options
                })
                lib.showContext('hireWorker')
            end
        }
    }
    local workers = {}
    for k, v in pairs(bossmenu.workers) do
        table.insert(workers, {
            title = v.playerName,
            description = "Job: " .. v.jobLabel .. "\nGrade: " .. v.jobGradeLabel .. "\nTotal Time: " .. formatTime(tonumber(v.total) or 0),
            icon = "fa-user",
            onSelect = function()
                local options = {
                    {
                        title = "Ændre Rangering",
                        icon = "fa-person",
                        onSelect = function()
                            local possibleGrades = lib.callback.await("elevate-multijob:server:getPossibleGrades", false, v.jobName)
                            local changeGradeInput = lib.inputDialog("Ændre Rangering", {
                                { type = "select", label = "Rangering", options = possibleGrades, required = true, placeholder = "Vælg rangering" }
                            })
                            if changeGradeInput then
                                local changeGrade = lib.callback.await("elevate-multijob:server:changeGrade", false, v.identifier, xPlayer.job.name, changeGradeInput[1])
                                if changeGrade then
                                    lib.notify({
                                        title = "Medarbejder rangering ændret",
                                        description = "Du har ændret på: " .. v.playerName,
                                        type = "success"
                                    })
                                else
                                    lib.notify({
                                        title = "Fejl",
                                        description = "Ændring af medarbejder fejlede.",
                                        type = "error"
                                    })
                                end
                            end
                        end
                    },
                    {
                        title = "Slet",
                        icon = "fa-xmark",
                        onSelect = function()
                            local removeWorker = lib.callback.await("elevate-multijob:server:removeWorker", false, v.identifier)
                            if removeWorker then
                                lib.notify({
                                    title = "Medarbejder fjernet",
                                    description = "Du har fjernet: " .. v.playerName,
                                    type = "success"
                                })
                            else
                                lib.notify({
                                    title = "Fejl",
                                    description = "Fjernelse af medarbejder fejlede.",
                                    type = "error"
                                })
                            end
                        end
                    }
                }
                lib.registerContext({
                    id = 'worker' .. v.identifier,
                    title = v.playerName,
                    options = options
                })
                lib.showContext('worker' .. v.identifier)
            end
        })
    end
    lib.registerContext({
        id = 'bossMenuWorkers',
        title = 'Medarbejdere',
        options = workers
    })
    lib.registerContext({
        id = 'bossMenu',
        title = 'Boss Menu',
        options = options
    })
    lib.showContext('bossMenu')
end, false)


function formatTime(totalSeconds)
    local days = math.floor(totalSeconds / 86400)
    local hours = math.floor((totalSeconds % 86400) / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60
    return string.format("%d Days %d Hours %d Minutes %d Seconds", days, hours, minutes, seconds)
end