-- Initialize config(s)
local sh_config = require 'config.shared'

-- Display a notification
--- @param message string
--- @param type string
function ShowNotification(message, type)
    if sh_config.setup.notify == 'ox_lib' then
        lib.notify({ description = message, type = type, position = 'top', icon = 'fas fa-store' })
    elseif sh_config.setup.notify == 'esx' then
        ESX.ShowNotification(message)
    elseif sh_config.setup.notify == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif sh_config.setup.notify == 'okok' then
        exports['okokNotify']:Alert('Convenience Store', message, 5000, type, false)
    elseif sh_config.setup.notify == 'sd-notify' then
        exports['sd-notify']:Notify('Convenience Store', message, type)
    elseif sh_config.setup.notify == 'wasabi_notify' then
        exports.wasabi_notify:notify('Convenience Store', message, 5000, type, false, 'fas fa-store')
    elseif sh_config.setup.notify == 'custom' then
        -- Add custom notification export/event here
    end
end

-- Display a notification from server
--- @param message string
--- @param type string
RegisterNetEvent('lation_247robbery:Notify', function(message, type)
    ShowNotification(message, type)
end)

-- Display a minigame
--- @param data table
function Minigame(data)
    if lib.skillCheck(data.difficulty, data.inputs) then
        return true
    end
    return false
end

-- Display a progress bar
--- @param data table
function ProgressBar(data)
    if sh_config.setup.progress == 'ox_lib' then
        -- Want to use ox_lib's progress circle instead of bar?
        -- Change "progressBar" to "progressCircle" below & done!
        if lib.progressBar({
            label = data.label,
            duration = data.duration,
            position = data.position or 'bottom',
            useWhileDead = data.useWhileDead,
            canCancel = data.canCancel,
            disable = data.disable,
            anim = {
                dict = data.anim.dict or nil,
                clip = data.anim.clip or nil,
                flag = data.anim.flag or nil
            },
            prop = {
                model = data.prop.model or nil,
                bone = data.prop.bone or nil,
                pos = data.prop.pos or nil,
                rot = data.prop.rot or nil
            }
        }) then
            return true
        end
        return false
    elseif sh_config.setup.progress == 'qbcore' then
        local p = promise.new()
        QBCore.Functions.Progressbar(data.label, data.label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = false,
            disableCombat = data.disable.combat
        }, {
            animDict = data.anim.dict or nil,
            anim = data.anim.clip or nil,
            flags = data.anim.flag or nil
        }, {
            model = data.prop.model or nil,
            bone = data.prop.bone or nil,
            coords = data.prop.pos or nil,
            rotation = data.prop.rot or nil
        }, {},
        function()
            p:resolve(true)
        end,
        function()
            p:resolve(false)
        end)
        return Citizen.Await(p)
    else
        -- Add 'custom' progress bar here
    end
end

-- Send police dispatch message
--- @param data table data.coords, data.street
function PoliceDispatch(data)
    if not data then print('^1[ERROR]: Failed to retrieve dispatch data, cannot proceed^0') return end

    local playerData = exports.tk_dispatch:getPlayerData()
    exports['tk_dispatch']:addCall({
        title = "Butiks Røveri",
        code = 'Røveri',
        priority = 'Prioritet 2',
        coords = data.coords,
        message = ('En %s røver en butik'):format(playerData.gender),
        showLocation = true,
        showGender = true,
        color = 'green',
        flash = true,
        playSound = true,
        removeTime = 1000 * 60 * 5, -- will be removed after 10 minutes
        showTime = 7500, -- will be shown on screen (as notification) for 10 seconds
        blip = {
            color = 1,
            sprite = 59,
            scale = 1.0,
        },
        jobs = {'police'}
    })
end

-- Add circle target zones
--- @param data table
function AddCircleZone(data)
    if sh_config.setup.interact == 'ox_target' then
        exports.ox_target:addSphereZone(data)
    elseif sh_config.setup.interact == 'qb-target' then
        exports['qb-target']:AddCircleZone(data.name, data.coords, data.radius, {
            name = data.name,
            debugPoly = sh_config.setup.debug}, {
            options = data.options,
            distance = 2,
        })
    elseif sh_config.setup.interact == 'interact' then
        exports.interact:AddInteraction({
            coords = data.coords,
            interactDst = 2.0,
            id = data.name,
            options = data.options
        })
    elseif sh_config.setup.interact == 'custom' then
        -- Add support for a custom target system here
    else
        print('^1[ERROR]: No interaction system was detected - please visit config/shared "setup" section^0')
    end
end