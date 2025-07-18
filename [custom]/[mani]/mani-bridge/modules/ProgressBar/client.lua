local function Progress(data)
    if Config.oxOptions.ProgressBar ~= false then
        if Config.oxOptions.ProgressBar == 'bar' then
            return lib.progressBar(data)
        elseif Config.oxOptions.ProgressBar == 'circle' then
            return lib.progressCircle(data)
        end
    elseif Config.Framework == 'esx' then
        Core.Progressbar(data.label, data.duration,{
            FreezePlayer = data.disable.move, 
            onFinish = function()
                return true
            end,
            onCancel = function()
                return false
            end
        })
    elseif Config.Framework == 'qb' then
        Core.Functions.Progressbar(data.name, data.label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = data.disable.mouse,
            disableCombat = data.disable.combat,
            }, {}, {}, {},
            function()
                return true
            end,
            function()
                return false
        end)
    end
end

exports('Progress', Progress)

local function progressActive()
    if Config.oxOptions.ProgressBar ~= false then
        return lib.progressActive()
    else
        return false -- add custom progress active check
    end
end

exports('progressActive', progressActive)







local function progressBar(data, completed, cancelled) -- Depricated - Gonna remove later
    if Config.oxOptions.ProgressBar ~= false then
        if Config.oxOptions.ProgressBar == 'bar' then
            if lib.progressBar({
                duration = data.duration,  
                label = data.label,      
                useWhileDead = data.useWhileDead,
                allowSwimming = data.allowSwimming, 
                canCancel = data.canCancel,  
                disable = data.disable 
            }) then 
                completed()
            else 
                cancelled()
            end
        elseif Config.oxOptions.ProgressBar == 'circle' then
            if lib.progressCircle({
                duration = data.duration,  
                label = data.label,      
                useWhileDead = data.useWhileDead,
                allowSwimming = data.allowSwimming, 
                canCancel = data.canCancel,  
                disable = data.disable 
            }) then 
                completed()
            else 
                cancelled()
            end
        end
    elseif Config.Framework == 'esx' then
        Core.Progressbar(data.label, data.duration,{
            FreezePlayer = data.disable.move, 
            onFinish = function()
                completed()
        end, onCancel = function()
                cancelled()
        end
        })
    elseif Config.Framework == 'qb' then
        Core.Functions.Progressbar(data.name, data.label, data.duration, data.useWhileDead, data.canCancel, {
            disableMovement = data.disable.move,
            disableCarMovement = data.disable.car,
            disableMouse = data.disable.mouse,
            disableCombat = data.disable.combat,
            }, {}, {}, {}, function()
                completed()
            end, function()
                cancelled()
        end)
    end
end

exports('progressBar', progressBar)