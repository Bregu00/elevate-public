function CanCreateTracks(src) -- Player can create new tracks
    local permission = false
    local crew = exports['av_racing']:getCrew(src)
    if crew and crew.name ~= nil and crew.isBoss then
        permission = true
    end
    return permission
end

function CanCreateRaces(src) -- Player can create new events (races)
    local permission = false
    local crew = exports['av_racing']:getCrew(src)
    if crew and crew.name ~= nil then
        permission = true
    end
    return permission
end

function CanDeleteTracks(src) -- Player can delete tracks
    local permission = false
    local crew = exports['av_racing']:getCrew(src)
    if crew and crew.name ~= nil and crew.isBoss then
        permission = true
    end
    return permission
end

function AdminCrew(src) -- Used for /admin:racing command (create, setboss and delete crews)
    local permission = false
    permission = exports['av_laptop']:getPermission(src,Config.AdminLevel)
    print(permission)
    return permission
end