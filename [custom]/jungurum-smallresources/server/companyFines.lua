local allUsers = {}
local done = false

lib.callback.register("jungurum-smallresources:server:getFines", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fines = MySQL.query.await("SELECT * FROM billing")
    if (fines) and (fines[1]) then
        for i = 1, #fines do
            fines[i].name = (allUsers[fines[i].identifier] and allUsers[fines[i].identifier].fullname) or fines[i].identifier
            fines[i].senderName = (allUsers[fines[i].sender] and allUsers[fines[i].sender].fullname) or fines[i].sender
        end
        return fines
    end
    return false
end)

lib.callback.register("jungurum-smallresources:server:removeFine", function(source, id)
    local success = MySQL.update.await("DELETE FROM billing WHERE id = @id", { ["@id"] = id }) > 0
    return success
end)

CreateThread(function()
    local tempUsers = MySQL.query.await("SELECT * FROM users")
    for i = 1, #tempUsers do
        local identifier = tempUsers[i].identifier
        if not allUsers[identifier] then
            allUsers[identifier] = {}
        end
        allUsers[identifier] = {
            id = tempUsers[i].id,
            identifier = identifier,
            firstname = tempUsers[i].firstname,
            lastname = tempUsers[i].lastname,
            fullname = tempUsers[i].firstname .. " " .. tempUsers[i].lastname,
        }
    end
    done = true
end)

exports("getFullName", function(identifier)
    while not done do
        Wait(100)
    end
    return allUsers[identifier]
end)