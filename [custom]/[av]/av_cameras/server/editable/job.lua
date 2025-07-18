function getPermission(source,job)
    if GetResourceState('av_business') == "started" then
        local permissions = exports['av_business']:getPermissions(source,job)
        if permissions['isBoss'] or permissions['cameras'] then
            return true
        end
    end
    return false
end