RegisterCommand("regninger", function()
    local xPlayer = ESX.GetPlayerData()
    local fines = lib.callback.await("jungurum-smallresources:server:getFines", false)
    local formattedFines = FormatFines(fines)
    if (xPlayer.job.isgang ~= true) and (xPlayer.group == "user") then
        if not formattedFines[xPlayer.job.name] then
            lib.notify({
                title = "Regning",
                description = "Dit firma har ingen ubetalte regninger.",
                type = "error",
            })
            return
        end
        local options = {}
        for k, v in pairs(formattedFines[xPlayer.job.name]) do
            table.insert(options, {
                title = v.label,
                description = v.name .. " | " .. v.senderName,
                onSelect = function()
                    if not (xPlayer.job.grade_name == "boss") then 
                        lib.notify({
                            title = "Regning",
                            description = "Du har ikke tilladelse til at fjerne denne regning.",
                            type = "error",
                        })
                        return
                    end
                    local removed = lib.callback.await("jungurum-smallresources:server:removeFine", false, v.id)
                    if removed then
                        lib.notify({
                            title = "Regning",
                            description = "Du har fjernet en regning",
                            type = "success",
                        })
                    end
                end,
            })
            lib.registerContext({
                id = "companyFines",
                title = "Regninger",
                options = options,
            })
            lib.showContext("companyFines")
        end
        return
    elseif xPlayer.group ~= "user" then
        local options = {}
        for k, v in pairs(formattedFines) do
            table.insert(options, {
                title = k,
                onSelect = function()
                    local options2 = {}
                    for k2, v2 in pairs(formattedFines[k]) do
                        table.insert(options2, {
                            title = v2.label,
                            description = v2.name .. " | " .. v2.senderName,
                            onSelect = function()
                                local removed = lib.callback.await("jungurum-smallresources:server:removeFine", false, v2.id)
                                if removed then
                                    lib.notify({
                                        title = "Regning",
                                        description = "Du har fjernet en regning",
                                        type = "success",
                                    })
                                end
                            end,
                        })
                    end
                    lib.registerContext({
                        id = "companyFines2",
                        title = "Regninger " .. k,
                        options = options2,
                    })
                    lib.showContext("companyFines2")
                end,
            })
            lib.registerContext({
                id = "adminFines",
                title = "Admin Regninger",
                options = options,
            })
            lib.showContext("adminFines")
        end
        return
    end
end, false)


function FormatFines(fines)
    if fines then
        local tempFines = {}
        for i = 1, #fines do
            local cuttedTarget = fines[i].target:match("_(%w+)")
            if not tempFines[cuttedTarget] then tempFines[cuttedTarget] = {} end
            table.insert(tempFines[cuttedTarget], {
                id = fines[i].id,
                identifier = fines[i].identifier,
                name = fines[i].name,
                senderName = fines[i].senderName,
                sender = fines[i].sender,
                target = cuttedTarget,
                label = fines[i].label,
                amount = fines[i].amount,
                time = fines[i].time,
            })
        end
        return tempFines
    end
end