local cooldowns = {}

local function startGangCooldown(gang, misType, time)
    time = time / 1000
    -- print(time)
    if not cooldowns[gang] then cooldowns[gang] = {} end
    if not cooldowns[gang][misType] then cooldowns[gang][misType] = {} end
    cooldowns[gang][misType] = { active = true, expiring = os.time() + time }
    SetTimeout(Config.Seconds(time), function()
        cooldowns[gang][misType] = { active = false }
    end)
end

lib.callback.register('jungurum-lib:server:getGangCooldown', function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.getJob()
    if job.isgang then
        return cooldowns[job.name] or false, true
    end
    return false, false
end)

lib.callback.register('jungurum-lib:server:setGangCooldown', function(source, misType, time)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.getJob()
    if job.isgang then
        startGangCooldown(job.name, misType, time)
        return true, true
    end
    return false, false
end)

lib.callback.register('jungurum-lib:server:GetAllGangCooldowns', function(source, gang)
    return cooldowns[gang] or {}, os.time()
end)