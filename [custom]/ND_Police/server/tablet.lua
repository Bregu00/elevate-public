RegisterNetEvent('elevate_police:RegisterPlayerInDatabase')
AddEventHandler('elevate_police:RegisterPlayerInDatabase', function(playerId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local name = xPlayer.getName()
    local dob = xPlayer.get('dateofbirth') or 'Unknown'
    local height = xPlayer.get('height') or 180
    local sex = xPlayer.get('sex') == 'm' and 'Mand' or 'Kvinde'

    local phoneResult = MySQL.Sync.fetchAll('SELECT phone_number FROM phone_phones WHERE id = @identifier', {
        ['@identifier'] = identifier
    })

    local phone_number = phoneResult[1] and phoneResult[1].phone_number or 0
    local fingerprint = 0
    local note = ''

    local existingUser = MySQL.Sync.fetchAll("SELECT id FROM population WHERE steamid = @steamid", {
        ['@steamid'] = identifier
    })

    if #existingUser > 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'Personen er allerede oprettet i databasen!',
            type = 'success',
            duration = 10000,
        })
        return
    end

    TriggerClientEvent('ox_lib:notify', source, {
        description = 'Oprettede personen i databasen!',
        type = 'success',
        duration = 10000,
    })

    MySQL.Async.execute(
        "INSERT INTO population (steamid, name, dob, height, sex, phone_number, fingerprint, note) VALUES (@steamid, @name, @dob, @height, @sex, @phone_number, @fingerprint, @note)",
        {
            ['@steamid'] = identifier,
            ['@name'] = name,
            ['@dob'] = dob,
            ['@height'] = height,
            ['@sex'] = sex,
            ['@phone_number'] = phone_number,
            ['@fingerprint'] = fingerprint,
            ['@note'] = note
        },
        function(rowsChanged)
            if rowsChanged > 0 then
                print('Player ' .. name .. ' (' .. identifier .. ') successfully registered in the database.')
            else
                print('Failed to register player ' .. name .. ' (' .. identifier .. ').')
            end
        end
    )
end)

AddEventHandler('playerDropped', function(reason, resourceName, clientDropReason)
    if ESX.GetPlayerFromId(source).job.name == 'police' then
        local identifier = GetPlayerIdentifiers(source)[1]
        MySQL.Async.execute('UPDATE el_users SET isOnDuty = 0 WHERE steamid = @steamid', {
            ['@steamid'] = identifier
        })

        MySQL.Async.execute('UPDATE el_users SET patrol_id = @patrolId, patrol_category = @patrolCategory, patrol_task = @patrol_task WHERE steamid = @identifier', {
            ['@patrolId'] = '',
            ['@patrolCategory'] = '',
            ['@patrol_task'] = '',
            ['@identifier'] = GetPlayerIdentifiers(source)[1]
        })    
    end
end)

RegisterNetEvent('elevate_police:isOnDuty')
AddEventHandler('elevate_police:isOnDuty', function(value)
    if not source then return end
    if not ESX.GetPlayerFromId(source).job.name == 'police' then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    if value then
        MySQL.Async.execute('UPDATE el_users SET isOnDuty = 1 WHERE steamid = @steamid', {
            ['@steamid'] = identifier
        })
    else
        MySQL.Async.execute('UPDATE el_users SET isOnDuty = 0 WHERE steamid = @steamid', {
            ['@steamid'] = identifier
        })
    end
end)

lib.callback.register('elevate_police:setPatrolId', function(source, patrolId, category, unitNumber)
    if not ESX.GetPlayerFromId(source).job.name == 'police' then return nil end

    local currentCategory = MySQL.Sync.fetchScalar('SELECT patrol_category FROM el_users WHERE steamid = @identifier', {
        ['@identifier'] = GetPlayerIdentifiers(source)[1]
    })

    if category then currentCategory = category end
    if unitNumber then patrolId = unitNumber end
    
    MySQL.Async.execute('UPDATE el_users SET patrol_id = @patrolId, patrol_category = @patrolCategory WHERE steamid = @identifier', {
        ['@patrolId'] = patrolId or '',
        ['@identifier'] = GetPlayerIdentifiers(source)[1],
        ['@patrolCategory'] = currentCategory == '' and 'betjent' or currentCategory
    })

    if not currentCategory then 
        category = 'Bravo'
        currentCategory = 'betjent'
    end
    if currentCategory == '' then 
        category = 'Bravo'
        currentCategory = 'betjent'
    end
    if currentCategory == 'betjent' then category = 'Bravo' end
    if currentCategory == 'romeo' then category = 'Romeo' end
    if currentCategory == 'mc' then category = 'Mike' end
    if currentCategory == 'civil' then category = 'Mike-Kilo' end
    if currentCategory == 'nsk' then category = 'Kilo' end
    if currentCategory == 'lima' then category = 'Lima' end
    if currentCategory == 'helikopter' then category = 'Foxtrot' end
    if currentCategory == 'razzia' then category = 'Bravo' end
    if currentCategory == 'training' then category = 'Bravo' end

    TriggerClientEvent('ox_lib:notify', source, {
        title = '[' .. category .. '] - ' .. patrolId,
        type = 'success',
        duration = 10000,
    })

    return { category = category, currentCategory = currentCategory }
end)

RegisterNetEvent('elevate_police:removePatrolId')
AddEventHandler('elevate_police:removePatrolId', function()
    if not ESX.GetPlayerFromId(source).job.name == 'police' then return end
    MySQL.query('SELECT `patrol_id` FROM `el_users` WHERE `steamid` = ?', {
        GetPlayerIdentifiers(source)[1]
    }, function(response)
        if response and next(response) then
            MySQL.update('UPDATE el_users SET patrol_id = ?, patrol_category = ? WHERE patrol_id = ?', {
                '', '', response[1].patrol_id
            })
        end
    end)
end)

SetHttpHandler(function(request, response)
    local path = request.path
    local apiKey = request.headers['X-API-Key']
    local validApiKey = "JlpG06eY0kzDujLrG7K1yXW5JLbacAXK8tbCoyfi7vvg2QDgsS3N4LZw0eZ25Jra8npdSQxI2iPKl82K6g1GObVJRSdKBjkXBQdMhlXwvzhA7yqhllJmsBvcpw9zKz7U"

    if not apiKey or apiKey ~= validApiKey then
        response.writeHead(401, { ['Content-Type'] = 'application/json' })
        response.send(json.encode({ error = "Unauthorized: Invalid or missing API key" }))
        return
    end

    if request.method == 'POST' and path == '/removeLicense' then
        local charId = request.headers.playerId
        local licenseType = request.headers.licenseType
        if licenseType == 'all' then
            licenseTypesRemove = { 'drive', 'drive_bike', 'drive_truck' }
            for _, licenseType in ipairs(licenseTypesRemove) do
                exports["esx_license"]:RemoveLicense(charId, licenseType, function(success)
                end)
            end
        else
            exports["esx_license"]:RemoveLicense(charId, licenseType, function(success)
            end)
        end

        response.writeHead(200, { ['Content-Type'] = 'application/json' })
        response.send(json.encode({ message = "Licenses processed", licenseTypes = licenseTypes }))
    elseif request.method == 'GET' and path:match("^/charid=") then
        local charId = path:match("^/charid=(.+)")
        if charId then
            exports["esx_license"]:GetLicenses(charId, function(licenses)
                response.writeHead(200, { ['Content-Type'] = 'application/json' })
                response.send(json.encode({ message = "Licenses", licenses = licenses }))
            end)
        else
            response.writeHead(400, { ['Content-Type'] = 'application/json' })
            response.send(json.encode({ error = "Invalid Character ID" }))
        end
    else
        response.writeHead(404, { ['Content-Type'] = 'application/json' })
        response.send(json.encode({ error = "Endpoint not found" }))
    end
end)
