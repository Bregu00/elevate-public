local function DoAction(src, cb)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            cb(memberSrc)
        end
        return #allMembers
    else
        cb(src)
    end
    return 1
end

exports('DoAction', DoAction)