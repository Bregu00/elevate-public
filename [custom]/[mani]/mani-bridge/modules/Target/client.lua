local function FormatTable(options)
    if Config.Target == 'qb' then
        return {
            type = 'client',
            icon = options.icon,
            label = options.label,
            item = options.item,
            action = function(entity)
                options.onSelect({ entity = entity })
            end,
            canInteract = function(entity, distance)
                return options.canInteract(entity, distance)
            end,
            job = options.groups,
            gang = options.groups,
        }
    end
end

local function AddTargetModel(models, options)
    if Config.Target == 'ox' then
        exports['ox_target']:addModel(models, options)
    elseif Config.Target == 'qb' then
        local FormattedOptions = {}
        if next(options) then
            for i = 1, #options do FormattedOptions[i] = FormatTable(options[i]) end
        else
            FormattedOptions = { { FormatTable(options) } }
        end
        exports['qb-target']:AddTargetModel(models, {
            options = FormattedOptions,
            distance = FormattedOptions[1].distance
        })
    end
end

exports('AddTargetModel', AddTargetModel)

local function AddBoxTarget(parameters)
    if Config.Target == 'ox' then
        exports['ox_target']:addBoxZone(parameters)
    elseif Config.Target == 'qb' then
        local FormattedOptions = {}
        if next(parameters.options) then
            for i = 1, #parameters.options do FormattedOptions[i] = FormatTable(parameters.options[i]) end
        else
            FormattedOptions = { { FormatTable(parameters.options) } }
        end
        exports['qb-target']:AddBoxZone(parameters.name, parameters.coords.xyz, parameters.size.x, parameters.size.y, {
            name = parameters.name,
            heading = parameters.coords.w,
            debugPoly = parameters.debug,
            minZ = parameters.coords.z - (parameters.size.z / 2),
            maxZ = parameters.coords.z + (parameters.size.z / 2)
        }, {
            options = FormattedOptions,
            distance = FormattedOptions[1].distance
        })
    end
end

exports('AddBoxTarget', AddBoxTarget)

local function AddLocalEntityTarget(entity, options)
    if Config.Target == 'ox' then
        exports['ox_target']:addLocalEntity(entity, options)
    elseif Config.Target == 'qb' then
        local FormattedOptions = {}
        if next(options) then
            for i = 1, #options do FormattedOptions[i] = FormatTable(options[i]) end
        else
            FormattedOptions = { { FormatTable(options) } }
        end
        exports['qb-target']:AddTargetEntity(entity, {
            options = FormattedOptions,
            distance = FormattedOptions[1].distance
        })
    end
end

exports('AddLocalEntityTarget', AddLocalEntityTarget)

local function AddGlobalVehicleTarget(options)
    if Config.Target == 'ox' then
        exports['ox_target']:addGlobalVehicle(options)
    elseif Config.Target == 'qb' then
        local FormattedOptions = {}
        if next(options) then
            for i = 1, #options do FormattedOptions[i] = FormatTable(options[i]) end
        else
            FormattedOptions = { { FormatTable(options) } }
        end
        exports['qb-target']:AddGlobalVehicle({
            options = FormattedOptions,
            distance = FormattedOptions[1].distance
        })
    end
end

exports('AddGlobalVehicleTarget', AddGlobalVehicleTarget)

local function RemoveTargetZone(id)
    if Config.Target == 'ox' then
        exports['ox_target']:removeZone(id)
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveZone(id)
    end
end

exports('RemoveTargetZone', RemoveTargetZone)

local function RemoveTargetModel(models, optionNames)
    if Config.Target == 'ox' then
        exports['ox_target']:removeModel(models, optionNames)
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveModel(models, optionNames)
    end
end

exports('RemoveTargetModel', RemoveTargetModel)

local function RemoveLocalEntityTarget(entity)
    if Config.Target == 'ox' then
        exports['ox_target']:removeLocalEntity(entity)
    elseif Config.Target == 'qb' then
        exports['qb-target']:RemoveTargetModel(entity)
    end
end

exports('RemoveLocalEntityTarget', RemoveLocalEntityTarget)