RegisterServerEvent('av_boosting:updateProfile', function(data)
    local src = source
    local identifier = exports['av_laptop']:getIdentifier(src)
    local name = data['name']
    local photo = data['photo']
    if string.len(name) > Config.MaxUsernameCharacters then
        TriggerClientEvent('av_laptop:notificationUI',src,Lang['too_long'],'error',Lang['app_title'])
        return
    end
    local exists = MySQL.query.await('SELECT * FROM av_boosting WHERE name = ?', {
        name
    })
    if (exists and exists[1]) and (exists[1]['identifier'] ~= identifier) then
        TriggerClientEvent('av_laptop:notificationUI',src,Lang['already_registered'],'error',Lang['app_title'])
        return
    end
    MySQL.update.await('UPDATE av_boosting SET name = ?, photo = ? WHERE identifier = ?', {
        name, photo, identifier
    })
    TriggerClientEvent('av_laptop:notificationUI',src,Lang['profile_updated'],'success',Lang['app_title'])
end)