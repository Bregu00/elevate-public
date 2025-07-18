RegisterNetEvent("av_business:tray", function(data)
    local name = data['name']
    local label = data['label']
    if name and label then
        exports['av_laptop']:openStash(name, label, Config.TrayWeight, Config.TraySlots)
    end
end)

RegisterNetEvent("av_business:stash", function(data)
    local permissions = getPermissions()
    if permissions['isBoss'] or permissions['stashes'] then
        local name = data['name']
        local label = data['label']
        local weight = Config.StashWeight
        local slots = Config.StashSlots
        if data['zoneType'] == "tray" then
            weight = Config.TrayWeight
            slots = Config.TraySlots
        end
        if name and label then
            exports['av_laptop']:openStash(name, label, weight, slots)
        end
    else
        TriggerEvent("av_laptop:notification", Lang['app_title'], Lang['missing_permissions'], "error")
    end
end)