Citizen.CreateThread(function()
    -- This notification is currently used for /streamermode only.
    Config.ShowNotification = function(title, content)
        TriggerEvent('chat:addMessage', {args = {title, content}})
    end
end)

if(IsDuplicityVersion()) then
    -- Server-side Interact-Sound Events
    RegisterNetEvent('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
        Play3DEntity(clientNetId, -1, nil, soundFile, soundVolume, nil, true)
    end)

    RegisterNetEvent('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
        Play3DEntity(source, -1, nil, soundFile, soundVolume, nil, true)
    end)

    RegisterNetEvent('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
        Play3DEntity(-1, -1, nil, soundFile, soundVolume, nil, true)
    end)

    RegisterNetEvent('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
        Play3DEntity(-1, source, maxDistance, soundFile, soundVolume, nil, true)
    end)

    -- Server-side XSound exports
    exports('PlayUrl', function(source, name, url, volume, loop)
        Play3DEntity(source, -1, nil, url, volume, loop)
    end)

    exports('PlayUrlPos', function(source, name, url, volume, coords, loop)
        Play3DPos(source, name, coords, nil, url, volume, loop)
    end)

    exports('Position', function(source, name, coords)
        modifySound(source, name, "position", coords)
    end)

    exports('Distance', function(source, name, newDistance)
        modifySound(source, name, "distance", newDistance)
    end)

    exports('Destroy', function(source, name)
        destroySound(source, name)
    end)

    exports('Pause', function(source, name)
        modifySound(source, name, "paused", true)
    end)

    exports('Resume', function(source, name)
        modifySound(source, name, "paused", false)
    end)

    exports('setVolume', function(source, name, newVolume)
        modifySound(source, name, "volume", newVolume)
    end)

    exports('setVolumeMax', function(source, name, newVolume)
        modifySound(source, name, "volume", newVolume)
    end)

    exports('setTimeStamp', function(source, name, time)
        modifySound(source, name, "timeStamp", time)
    end)

    exports('setSoundURL', function(source, name, url)
        modifySound(source, name, "url", url)
    end)

    exports('repeatSound', function(source, name)
        replaySound(source, name)
    end)

    exports('destroyOnFinish', function(source, name, bool)
        modifySound(source, name, "destroyOnFinish", bool)
    end)

    exports('setSoundLoop', function(name, bool)
        modifySound(source, name, "loop", bool)
    end)

    exports('setSoundDynamic', function(source, name, bool)
        return true
    end)

    exports('fadeOut', function(source, name, time)
        modifySound(source, name, "volume", 0.0, time)
    end)

    exports('fadeIn', function(source, name, time, volume)
        modifySound(source, name, "volume", volume, time)
    end)
else
    -- Client-side Interact-Sound Events
    RegisterNetEvent('InteractSound_SV:PlayOnOne', function(soundFile, soundVolume)
        Play3DEntity(-1, nil, soundFile, soundVolume, nil, nil, nil, true)
    end)

    RegisterNetEvent('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
        Play3DEntity(-1, nil, soundFile, soundVolume, nil, nil, nil, true)
    end)

    RegisterNetEvent('InteractSound_SV:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
        Play3DEntity(playerNetId, maxDistance, soundFile, soundVolume, nil, nil, nil, true)
    end)

    -- Client-side XSound exports
    exports('PlayUrl', function(name, url, volume, loop, options)
        Play3DEntity(-1, nil, url, volume, loop)
    end)

    exports('PlayUrlPos', function(name, url, volume, coords, loop, options)
        Play3DPos(name, coords, nil, url, volume, loop)
    end)

    exports('Position', function(name, coords)
        modifySound(name, "position", coords)
    end)

    exports('Distance', function(name, newDistance)
        modifySound(name, "distance", newDistance)
    end)

    exports('Destroy', function(name)
        destroySound(name)
    end)

    exports('Pause', function(name)
        modifySound(name, "paused", true)
    end)

    exports('Resume', function(name)
        modifySound(name, "paused", false)
    end)

    exports('setVolume', function(name, newVolume)
        modifySound(name, "volume", newVolume)
    end)

    exports('setVolumeMax', function(name, newVolume)
        modifySound(name, "volume", newVolume)
    end)

    exports('setTimeStamp', function(name, time)
        modifySound(name, "timeStamp", time)
    end)

    exports('setSoundURL', function(name, url)
        modifySound(name, "url", url)
    end)

    exports('repeatSound', function(name)
        replaySound(name)
    end)

    exports('destroyOnFinish', function(name, bool)
        modifySound(name, "destroyOnFinish", bool)
    end)

    exports('setSoundLoop', function(name, bool)
        modifySound(name, "loop", bool)
    end)

    exports('setSoundDynamic', function(name, bool)
        return true
    end)

    exports('fadeOut', function(name, time)
        modifySound(name, "volume", 0.0, time)
    end)

    exports('fadeIn', function(name, time, volume)
        modifySound(name, "volume", volume, time)
    end)

    exports("onPlayStart", function(soundId, callback)
        addEventListener(soundId, "onPlay", callback)
    end)

    exports("onPlayEnd", function(soundId, callback)
        addEventListener(soundId, "onFinished", callback)
    end)
    
    exports("onLoading", function(soundId, callback)
        addEventListener(soundId, "onCreated", callback)
    end)
    
    exports("onPlayPause", function(soundId, callback)
        addEventListener(soundId, "onPause", callback)
    end)

    exports("onPlayResume", function(soundId, callback)
        addEventListener(soundId, "onResume", callback)
    end)

    exports("soundExists", function(soundId)
        return getSoundIndex(soundId) ~= nil
    end)

    exports("isPaused", function(soundId)
        return getSoundData(soundId, "paused")
    end)

    exports("isPlaying", function(soundId)
        return getSoundData(soundId, "playing")
    end)

    exports("isLooped", function(soundId)
        return getSoundData(soundId, "loop")
    end)

    exports("getDistance", function(soundId)
        return getSoundData(soundId, "distance")
    end)
    
    exports("getVolume", function(soundId)
        return getSoundData(soundId, "volume")
    end)
    
    exports("getPosition", function(soundId)
        return getSoundData(soundId, "position")
    end)
    
    exports("isDynamic", function(soundId)
        return true
    end)
    
    exports("getTimeStamp", function(soundId)
        return getSoundData(soundId, "timeStamp")
    end)
        
    exports("getMaxDuration", function(soundId)
        return getSoundData(soundId, "duration")
    end)
        
    exports("getLink", function(soundId)
        return getSoundData(soundId, "url")
    end)
        
    exports("getAllAudioInfo", function()
        return playingSounds
    end)
        
    exports("isPlayerCloseToAnySound", function()
        return isCloseToSound
    end)
        
    exports("getInfo", function(soundId)
        return getSound(soundId)
    end)
end