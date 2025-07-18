function useCD(source,item,info)
    dbug('useCD, item: ', item.name)
    local canUse = true
    if Config.Discman then
        canUse = exports['av_laptop']:hasItem(source,Config.Discman)
    end
    if not canUse then
        TriggerClientEvent('av_laptop:notification',source,Lang['app_title'],Lang['needs_discman'], 'error')
        return
    end
    local metadata, slot = exports['av_laptop']:getMetadata(item,info)
    local songs = metadata['songs']
    if songs then
        TriggerClientEvent('av_music:playCD', source, songs)
    else
        TriggerClientEvent('av_laptop:notification',source,Lang['app_title'],Lang['blank'], 'error')
    end
end

