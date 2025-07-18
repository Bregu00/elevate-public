local radioOpen, currentEntity = false, nil

local function OpenRadio(entity)
    if entity == 0 and not cache.vehicle then return end
    radioOpen = true
    currentEntity = (entity ~= 0 and entity) or cache.vehicle

    local soundId = NetworkGetNetworkIdFromEntity(currentEntity)
    local data = {}
    if soundId then
        data = exports["xsound"]:getSound(soundId) or {}
    end

    SendNUIMessage({
        action = 'setVisible',
        data = {
            visible = true,
            url = data.url or '',
            playing = data.playing or false,
            volume = data.volume or 0.5,
            currentTime = data.timeStamp or 0,
            duration = data.duration or 0,
        }
    })
    SetNuiFocus(true, true)

    CreateThread(function()
        while radioOpen do
            if soundId then
                local sound = exports["xsound"]:getSound(soundId) or {}

                SendNUIMessage({
                    action = 'updateMusic',
                    data = {
                        url = sound.url or '',
                        playing = sound.playing or false,
                        volume = sound.volume or 0.5,
                        currentTime = sound.timeStamp or 0,
                        duration = sound.duration or 0,
                    }
                })
            end
            Wait(1000)
        end
    end)
end

RegisterCommand('radio', OpenRadio)

local function CloseRadio()
    radioOpen = false
    currentEntity = nil
    SendNUIMessage({
        action = 'setVisible',
        data = { visible = false }
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function(data, cb)
    CloseRadio()
    cb('ok')
end)

RegisterNUICallback('setVolume', function(data, cb)
    lib.callback.await('mani-music:server:setVolume', false, {
        networkId = NetworkGetNetworkIdFromEntity(currentEntity),
        volume = data.volume,
    })
    cb({})
end)

RegisterNUICallback('seekTo', function(data, cb)
    lib.callback.await('mani-music:server:seekTo', false, {
        networkId = NetworkGetNetworkIdFromEntity(currentEntity),
        time = data.time,
    })
    cb({})
end)

RegisterNUICallback('togglePlay', function(data, cb)
    local netId = NetworkGetNetworkIdFromEntity(currentEntity)
    local sound = exports["xsound"]:getSound(netId) or {}
    lib.callback.await('mani-music:server:togglePlay', false, {
        networkId = netId,
        timeStamp = sound.timeStamp or 0,
    })
    cb('ok')
end)

RegisterNUICallback('playUrl', function(data, cb)
    local volume = 1
    local netId = NetworkGetNetworkIdFromEntity(currentEntity)
    local soundData = lib.callback.await('mani-music:server:addSong', false, {
        networkId = netId,
        urlLink = data.url,
        volume = 0.5,
    })

    if not soundData then
        lib.notify({ title = 'Du gør dette for hurtigt', type = 'error' })
        cb({})
        return
    end

    cb({
        playing = true,
        volume = soundData.volume,
        currentTime = 0,
        duration = soundData.duration,
    })
end)

CreateThread(function()
    lib.onCache('vehicle', function(vehicle, oldVehicle)
        if oldVehicle and radioOpen then
            radioOpen = false
            SendNUIMessage({
                action = 'setVisible',
                data = {
                    visible = false,
                }
            })
            SetNuiFocus(false, false)
        end
    end)
end)

local function useBoombox(data)
    if doingSomething then return end
    lib.showTextUI('[E] Placer Boombox', { alignIcon = 'center', icon = 'fa-solid fa-radio' })
    local doingSomething = true
    exports["mani-bridge"]:CopyCoords(GetHashKey('prop_boombox_01'), 10, function(coords)
        local entity = exports['mani-bridge']:CreateObj(GetHashKey('prop_boombox_01'), coords)
        FreezeEntityPosition(entity, true)
        Entity(entity).state:set('boombox', true, true)

        lib.callback.await('mani-music:server:removeBoombox', false)

        doingSomething = false
        lib.hideTextUI()
    end, function()
        doingSomething = false
        lib.hideTextUI()
    end, 0.2)
end

exports('useBoombox', useBoombox)

CreateThread(function()
    exports['ox_target']:addModel(GetHashKey('prop_boombox_01'), {
        {
            label = 'Brug Boombox',
            icon = 'fa-solid fa-radio',
            distance = 2.0,
            canInteract = function(entity)
                return Entity(entity).state.boombox
            end,
            onSelect = function(data)
                OpenRadio(data.entity)
            end
        },
        {
            label = 'Tag Boombox',
            icon = 'fa-solid fa-trash',
            distance = 2.0,
            canInteract = function(entity)
                return Entity(entity).state.boombox
            end,
            onSelect = function(data)
                lib.callback.await('mani-music:server:takeBoombox', false, NetworkGetNetworkIdFromEntity(data.entity))
            end
        },
    })
end)