local cooldowns = {}

local globalDistance = 30.0

lib.callback.register('mani-music:server:addSong', function(src, data)
    local vehicle = NetworkGetEntityFromNetworkId(data.networkId)
    if not vehicle then return end
    if not DoesEntityExist(vehicle) then return end
    local state = Entity(vehicle).state
    local isVehicle = not state.boombox
    if isVehicle then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
        if vehicle ~= playerVehicle then return end
    end

    if cooldowns[data.networkId] then return false end

    CreateThread(function()
        cooldowns[data.networkId] = true
        SetTimeout(1000, function()
            cooldowns[data.networkId] = false
        end)
    end)

    local sound = exports["xsound"]:getSound(data.networkId)
    if sound then
        sound.destroy(-1)
    end

    local volume = state.musicvolume or data.volume

    local distance = globalDistance

    if volume < 0.25 then
        distance = globalDistance * ((0.25 - volume) * 100)
    end

    local sound = exports['xsound']:Play3DEntity(
        -1,
        data.networkId,
        distance,
        data.urlLink,
        volume,
        false
    )

    state:set('musicvolume', volume, true)
    state:set('isPlaying', true, true)

    return {
        volume = volume,
        duration = exports['xsound']:getSoundData(sound.id, 'duration'),
    }
end)

lib.callback.register('mani-music:server:setVolume', function(src, data)
    local vehicle = NetworkGetEntityFromNetworkId(data.networkId)
    if not vehicle then return end
    if not DoesEntityExist(vehicle) then return end

    local state = Entity(vehicle).state
    local isVehicle = not state.boombox

    if isVehicle then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
        if vehicle ~= playerVehicle then return end
    end

    local distance = globalDistance

    if data.volume < 0.25 then
        distance = globalDistance * ((0.25 - data.volume) * 100)
    end

    local sound = exports["xsound"]:getSound(data.networkId)
    if sound then
        sound.modify(-1, "volume", data.volume)
        sound.modify(-1, 'distance', distance)
        state:set('musicvolume', data.volume, true)
    end
end)

lib.callback.register('mani-music:server:seekTo', function(src, data)
    local vehicle = NetworkGetEntityFromNetworkId(data.networkId)
    if not vehicle then return end
    if not DoesEntityExist(vehicle) then return end

    local state = Entity(vehicle).state
    local isVehicle = not state.boombox

    if isVehicle then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
        if vehicle ~= playerVehicle then return end
    end

    local sound = exports["xsound"]:getSound(data.networkId)
    if sound then
        sound.modify(-1, "timeStamp", data.time)
    end
end)

lib.callback.register('mani-music:server:togglePlay', function(src, data)
    local vehicle = NetworkGetEntityFromNetworkId(data.networkId)
    if not vehicle then return end
    if not DoesEntityExist(vehicle) then return end

    local state = Entity(vehicle).state
    local isVehicle = not state.boombox

    if isVehicle then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
        if vehicle ~= playerVehicle then return end
    end

    local sound = exports["xsound"]:getSound(data.networkId)
    if sound then
        if state.isPlaying then
            sound.modify(-1, "paused", true)
            state:set('isPlaying', false, true)
        else
            local timeStamp = data.timeStamp

            local volume = sound.volume
            local url = sound.url

            sound.destroy(-1)

            local distance = globalDistance

            if volume < 0.25 then
                distance = globalDistance * ((0.25 - volume) * 100)
            end
            
            sound = exports['xsound']:Play3DEntity(
                -1,
                data.networkId,
                distance,
                url,
                volume,
                false
            )
            
            sound.modify(-1, "timeStamp", timeStamp)

            state:set('musicvolume', volume, true)
            state:set('isPlaying', true, true)
        end
    end
end)

lib.callback.register('mani-music:server:takeBoombox', function(src, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity then return end
    if not DoesEntityExist(entity) then return end
    local state = Entity(entity).state
    if not state.boombox then return end

    DeleteEntity(entity)
    exports['ox_inventory']:AddItem(src, 'boombox', 1)
end)

lib.callback.register('mani-music:server:removeBoombox', function(src)
    exports['ox_inventory']:RemoveItem(src, 'boombox', 1)
end)