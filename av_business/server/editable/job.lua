-- On job update event catcher
-- When u use /setjob command or laptop hire button this will make sure to remove the player from his old job and add it to the new one

RegisterNetEvent("QBCore:Server:OnJobUpdate", function(source,job)
    if source and job then
        local jobName = job.name
        local identifier = exports['av_laptop']:getIdentifier(source)
        local found = false
        for k, v in pairs(allBusiness) do
            local employees = v['employees'] or {}
            for h, j in pairs(employees) do
                if employees[identifier] and k ~= jobName then
                    employees[identifier] = nil
                    found = true
                end
            end
        end
        if found then
            save("business")
        end
        if allBusiness[jobName] then
            allBusiness[jobName]['employees'] = allBusiness[jobName]['employees'] or {}
            if not allBusiness[jobName]['employees'][identifier] then
                allBusiness[jobName]['employees'][identifier] = {
                    identifier = identifier,
                    name = exports["av_laptop"]:getName(source),
                    image = "",
                    phone = "",
                    generated = 0,
                    lastSeen = "",
                    hours = 0,
                    permissions = {}
                }
                save("business")
            end
        end
    end
end)

RegisterNetEvent("esx:setJob", function(source,job)
    local src = source
    if src and job then
        local jobName = job.name
        local identifier = exports['av_laptop']:getIdentifier(src)
        local found = false
        for k, v in pairs(allBusiness) do
            local employees = v['employees'] or {}
            for h, j in pairs(employees) do
                if employees[identifier] and k ~= jobName then
                    employees[identifier] = nil
                    found = true
                end
            end
        end
        if found then
            save("business")
        end
        if allBusiness[jobName] then
            allBusiness[jobName]['employees'] = allBusiness[jobName]['employees'] or {}
            if not allBusiness[jobName]['employees'][identifier] then
                allBusiness[jobName]['employees'][identifier] = {
                    identifier = identifier,
                    name = exports["av_laptop"]:getName(src),
                    image = "",
                    phone = "",
                    generated = 0,
                    lastSeen = "",
                    hours = 0,
                    permissions = {}
                }
                save("business")
            end
        end
        exports['av_laptop']:savePlayer(src)
    end
end)

-- triggered after hired a new employee:
function playerHired(playerId,job)
--    print("playerHired()", playerId, job)
    local identifier = exports['av_laptop']:getIdentifier(playerId)
    if identifier then

    end
end

-- triggered after firing an employee if online
function playerFired(playerId,job)
--    print("playerFired", playerId, job)
    local identifier = exports['av_laptop']:getIdentifier(playerId)
    if identifier then

    end
end

-- triggered after firing an employee if online
function playerFiredOffline(identifier,job)
--   print("playerFiredOffline", identifier, job)
end