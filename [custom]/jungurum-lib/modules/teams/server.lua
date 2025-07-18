local function removeBlips(src, blipTable)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('jungurum-lib:removeBlips', memberSrc, blipTable)
        end
    else
        TriggerClientEvent('jungurum-lib:removeBlips', src, blipTable)
    end
end

RegisterNetEvent('jungurum-lib:server:removeBlips', function(blipTable)
    local src = source
    removeBlips(src, blipTable)
end)

exports('removeBlips', removeBlips)

local function addBlipWithRoute(src, blipSettings)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('jungurum-lib:addBlipWithRoute', memberSrc, blipSettings)
        end
    else
        TriggerClientEvent('jungurum-lib:addBlipWithRoute', src, blipSettings)
    end
end

RegisterNetEvent('jungurum-lib:server:addBlipWithRoute', function(blipSettings)
    local src = source
    addBlipWithRoute(src, blipSettings)
end)

exports('addBlipWithRoute', addBlipWithRoute)

-- data = {
--     { event = 'nigger:nigger', args = {} }
-- }

local function runTeamEvent(src, data)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            if data[2] then
                for event = 1, #data do
                    TriggerClientEvent(data[event].event, memberSrc, data[event].args)
                end
            else
                TriggerClientEvent(data[1].event, memberSrc, data[1].args)
            end
        end
    else
        if data[2] then
            for event = 1, #data do
                TriggerClientEvent(data[event].event, src, data[event].args)
            end
        else
            TriggerClientEvent(data[1].event, src, data[1].args)
        end
    end
end

RegisterNetEvent('jungurum-lib:server:runTeamEvent', function(data)
    local src = source
    runTeamEvent(src, data)
end)

exports('runTeamEvent', runTeamEvent)

local function updateTextUI(src, data)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('jungurum-lib:updateTextUI', memberSrc, data)
        end
    else
        TriggerClientEvent('jungurum:lib:updateTextUI', src, data)
    end
end

RegisterNetEvent('jungurum-lib:server:updateTextUI', function(data)
    local src = source
    updateTextUI(src, data)
end)

exports('updateTextUI', updateTextUI)

local function hideTextUI(src)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('jungurum-lib:hideTextUI', memberSrc)
        end
    else
        TriggerClientEvent('jungurum:lib:hideTextUI', src)
    end
end

RegisterNetEvent('jungurum-lib:server:hideTextUI', function()
    local src = source
    hideTextUI(src)
end)

exports('hideTextUI', hideTextUI)