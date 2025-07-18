local nitroCooldown = nil
local nitroUIActive = false

lib.onCache('vehicle', function(vehicle)
    if vehicle and Entity(vehicle).state.nitro and (Entity(vehicle).state.nitro > 0) then
        if not nitroUIActive then
            nitroUIActive = true
            SendNUIMessage({
                type = 'showUI',
                show = true
            })
            SendNUIMessage({
                type = 'updateNitro',
                percentage = Entity(vehicle).state.nitro
            })
        end
    else
        if nitroUIActive then
            nitroUIActive = false
            SendNUIMessage({
                type = 'showUI',
                show = false
            })
        end
    end
end)

-- Target interaction
CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            icon = "fa-solid fa-gas-pump",
            label = "Install Nitro",
            items = "nitro",
            onSelect = function(data)
                local vehicle = data.entity
                if not Config.vehicles[GetEntityModel(vehicle)] then return lib.notify({ title = "Nitro", description = "Denne bil kan ikke have nitro!", type = "error" }) end
                if not Entity(vehicle).state.nitro or Entity(vehicle).state.nitro <= 0 then
                    local install = lib.callback.await('elevate-nitro:installNitro', false, NetworkGetNetworkIdFromEntity(vehicle))
                    if install then
                        lib.notify({ title = "Nitro", description = "Du har installeret nitro!", type = "success" })
                    end
                end
            end,
            canInteract = function(entity)
                if not entity then return false end
                if Entity(entity).state.nitro and Entity(entity).state.nitro > 0 then return false end
                return true
            end
        },
        {
            icon = "fa-solid fa-gas-pump",
            label = "Remove Nitro",
            onSelect = function(data)
                local vehicle = data.entity
                if Entity(vehicle).state.nitro and Entity(vehicle).state.nitro > 0 then
                    local remove = lib.callback.await('elevate-nitro:removeNitro', false, NetworkGetNetworkIdFromEntity(vehicle))
                    if remove then
                        lib.notify({ title = "Nitro", description = "Du har fjernet nitro!", type = "success" })
                    else
                        lib.notify({ title = "Nitro", description = "Der er ikke nitro i bilen!", type = "error" })
                    end
                end
            end,
            canInteract = function(entity)
                if not entity then return false end
                if not Entity(entity).state.nitro or Entity(entity).state.nitro <= 0 then return false end
                return true
            end
        },
    })
end)

-- Keybind
local nitroKeybind = lib.addKeybind({
    name = 'nitro',
    description = 'press CTRL to use nitro',
    defaultKey = 'LCONTROL',
    onPressed = function(self)
        local vehicle = cache.vehicle
        if not vehicle then return end
        if cache.seat ~= -1 then return end
        if not Entity(vehicle).state.nitro or Entity(vehicle).state.nitro <= 0 then return end
        if not nitroCooldown or GetGameTimer() - nitroCooldown >= Config.cooldownDuration then
            SetNitroBoostScreenEffectsEnabled(true)
            Entity(vehicle).state:set("usingNitro", true, true)
            CreateThread(function()
                while self.isPressed and (Entity(vehicle).state.nitro and Entity(vehicle).state.nitro > 0) do
                    local vehicle = cache.vehicle
                    if not vehicle then return end
                    local vehicleModel = GetEntityModel(vehicle)
                    local currentSpeed = GetEntitySpeed(vehicle)
                    local maximumSpeed = GetVehicleModelMaxSpeed(vehicleModel)
                    local multiplier = Config.torqueMultiplier * maximumSpeed / currentSpeed
                    SetVehicleCheatPowerIncrease(vehicle, multiplier)
                    Wait(5)
                end
                
                nitroCooldown = GetGameTimer()
            end)
            useNitro()
        end
    end,
    onReleased = function(self)
        SetNitroBoostScreenEffectsEnabled(false)
        local vehicle = cache.vehicle
        if not vehicle then return end
        local ent = Entity(vehicle)
        if not ent or type(ent) ~= "table" or not ent.state then return end
        ent.state:set("usingNitro", false, true)
    end
})


AddStateBagChangeHandler("usingNitro", nil, function(bagName, key, value) 
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    if value then
        startBoostLoop(entity)
    end
end)

AddStateBagChangeHandler("nitro", nil, function(bagName, key, value)
    local entity = GetEntityFromStateBagName(bagName)
    local ped = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(ped, false)
    if entity == 0 then return end
    if pedVehicle ~= entity then return end
    if Entity(entity).state.nitro and (Entity(entity).state.nitro > 0) then
        SendNUIMessage({
            type = 'updateNitro',
            percentage = value
        })
    end
end)

function startBoostLoop(vehicle)
    CreateThread(function()
        while Entity(vehicle).state.usingNitro and Entity(vehicle).state.nitro and (Entity(vehicle).state.nitro > 0) do
            if not IsVehicleStopped(vehicle) then
                SetVehicleBoostActive(vehicle, true)
                CreateVehicleExhaustBackfire(vehicle, 1.25)
                -- CreateVehicleLightTrail(vehicle, "exhaust", 1.25)
            end
            Wait(50)
        end
    end)
end

function useNitro()
    CreateThread(function()
        while nitroKeybind:isControlPressed() and (Entity(cache.vehicle).state.nitro and Entity(cache.vehicle).state.nitro > 0) do
            local vehicle = cache.vehicle
            if not vehicle then return end
            if Entity(vehicle).state.nitro then
                if Entity(vehicle).state.nitro > 0 then
                    Entity(vehicle).state:set("nitro", Entity(vehicle).state.nitro - 4, true)
                else
                    Entity(vehicle).state:set("nitro", nil, true)
                    nitroUIActive = false
                    SendNUIMessage({
                        type = 'showUI',
                        show = false
                    })
                    SendNUIMessage({
                        type = 'updateNitro',
                        percentage = 0
                    })
                    break
                end
            end
            Wait(Config.nitroUsageInterval)
        end
    end)
end

exports.ox_inventory:displayMetadata({
    nitro = 'Nitro'
})