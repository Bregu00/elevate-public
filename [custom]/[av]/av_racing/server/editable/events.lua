local usingQuasar = GetResourceState('qs-smartphone-pro') == 'started'

RegisterServerEvent("av_racing:createCircuit", function(data)
    local src = source
    if not CanCreateTracks(src) then return end -- Just an extra check
    local createdby = exports['av_laptop']:getIdentifier(src)
    local identifier = string.lower(data.RaceName)
    identifier = string.gsub(identifier, "%s+", "")
    local checkpoints = json.encode(data['Checkpoints'])
    MySQL.insert('INSERT INTO av_racing (name, identifier, checkpoints, createdby, distance, description, type) VALUES (?, ?, ?, ?, ?, ?, ?)', 
    {data.RaceName, identifier, checkpoints, createdby, data["RaceDistance"], data["RaceDescription"], data['RaceType']}, function(saved)
        if saved then
            TriggerClientEvent('av_laptop:notification',src,Lang['app_title'],Lang['saved'])
        end
    end)
end)

RegisterServerEvent('av_racing:updateProfile', function(data)
    local src = source
    local identifier = exports['av_laptop']:getIdentifier(src)
    dbug('updateProfile: ', json.encode(data))
    MySQL.update.await('UPDATE av_racing_profiles SET name = ?, photo = ?, settings = ? WHERE identifier = ?', {data['name'], data['photo'], json.encode(data['settings']), identifier})
    TriggerClientEvent('av_laptop:notificationUI',src,Lang['app_title'], Lang['profile_updated'],'success')
end)

RegisterServerEvent('av_racing:sendMessage', function(raceId, message)
    dbug("av_racing:sendMessage", raceId, message)
    if not raceId or not message or string.len(message) < 1 then return end
    dbug("sending message...")
    local event = allEvents[raceId]
    if event and (event['racers'] and next(event['racers'])) then
        dbug("event found...")
        local title = event['title']
        for k, v in pairs(event['racers']) do
            local identifier = v['identifier']
            local playerId = exports['av_laptop']:getSourceByIdentifier(identifier)
            dbug("id: ", playerId, "identifier: ", identifier)
            if playerId and identifier then
                if usingQuasar then
                    dbug("using quasar phone..")
                    local meta = exports['qs-smartphone-pro']:getMetaFromSource(tonumber(playerId))
                    if meta and meta['phoneNumber'] then
                        dbug("sent msg to "..meta['phoneNumber'])
                        exports['qs-smartphone-pro']:sendNewMessageFromApp(tonumber(playerId), tonumber(meta['phoneNumber']), message, title)
                    end
                else
                    dbug("sent msg to player using normal notification")
                    TriggerClientEvent('av_laptop:notification', tonumber(playerId), title, message, 'inform')
                end
            end
        end
        dbug("msg sent to all online racers...")
    else
        dbug("couldn't send message, event not found or is empty")
    end
end)