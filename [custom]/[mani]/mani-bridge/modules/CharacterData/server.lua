function GetPlayer(src)
    if Config.Framework == 'esx' then
        return Core.GetPlayerFromId(src)
    elseif Config.Framework == 'qb' then
        return Core.Functions.GetPlayer(src)
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetPlayer', GetPlayer)

local function GetGender(src)
    local PlayerData = GetPlayer(src)
    if Config.Framework == 'esx' then
        return PlayerData.get("sex") or "Male"
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        return PlayerData.PlayerData.charinfo.gender == 0 and 'Male' or 'Female'
    else
        -- ADD CUSTOM FRAMEWORK SUPPORT HERE
    end
end

exports('GetGender', GetGender)

lib.callback.register('mani-bridge:server:getGender', function(src)
    return GetGender(src)
end)