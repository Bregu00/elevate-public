local Job = lib.load('shared.jobs.mandehul')
local RecentEvents = {}
local acWebhook = exports['elevate-confidential']:fetch('ac_webhook')

local function Log(src, msg)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,

        },
        discordTitle = msg,
        discordWebhook = ""
    })
end

local function AntiCheatLog(src, msg)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = true,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,

        },
        discordTitle = msg,
        discordWebhook = acWebhook
    })
end

lib.callback.register('mani-mandehul:server:getXP', function(src)
    return exports['mani-bridge']:getMetaData(src, 'MandeHul_XP', 'int')
end)

lib.callback.register('mani-mandehul:server:startMission', function(src, CurrentJob)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()

        if #allMembers > Job['MaxMember'] then
            local vehicle = NetworkGetEntityFromNetworkId(CurrentJob['VehNetID'])
            while not DoesEntityExist(vehicle) do Wait(100) end
            DeleteEntity(vehicle)
            return false
        end

        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('mani-mandehul:client:syncStart', memberSrc, CurrentJob)
        end
        return true
    else
        TriggerClientEvent('mani-mandehul:client:syncStart', src, CurrentJob)
    end
    return true
end)

lib.callback.register('mani-mandehul:server:pumpManhole', function(src, index)
    exports['mani-bridge']:DoAction(src, function(memberSrc)
        TriggerClientEvent('mani-mandehul:client:pumpManhole', memberSrc, index)
    end)
end)

lib.callback.register('mani-mandehul:server:openManhole', function(src, index)
    exports['mani-bridge']:DoAction(src, function(memberSrc)
        TriggerClientEvent('mani-mandehul:client:openManhole', memberSrc, index)
    end)
end)

lib.callback.register('mani-mandehul:server:stopMission', function(src, CurrentJob)
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)

    local fixedManholes = 0

    for i = 1, #CurrentJob['Locations'] do
        if CurrentJob['Manholes'][i].state == 'fixed' then
            fixedManholes = fixedManholes + 1
        end
    end

    local jobLocation = Job['Locations']['JobLocation']

    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local distance = #(playerCoords - jobLocation.xyz)
    
    if distance > 10 then
        local msg = ('[Mulig Cheater] - Spiller [%s] - %s | Afsluttet Job Imens Spilleren Er For Langt Væk | %s'):format(src, GetPlayerName(src), distance)
        AntiCheatLog(src, msg)
        return
    end

    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        local memberCount = #allMembers
        if memberCount > Job['MaxMember'] then memberCount = Job['MaxMember'] end
        local receivedMoney = (Job['Jobs'][CurrentJob['Tier']].MoneyReward * (100 + (Job['TeamBonus'] * (memberCount - 1))) / 100) * fixedManholes


        for i = 1, memberCount do
            local memberSrc = allMembers[i].source
            
            if fixedManholes > 0 then
                if RecentEvents[memberSrc] and RecentEvents[memberSrc] + 60 > os.time() then
                    local msg = ('[Mulig Cheater] - Spiller [%s] - %s | Afsluttet Job Indenfor %s Sekunder'):format(memberSrc, GetPlayerName(memberSrc), os.time() - RecentEvents[memberSrc])
                    AntiCheatLog(memberSrc, msg)
                    return
                end
            
                RecentEvents[memberSrc] = os.time()

                exports['mani-bridge']:addMetaData(memberSrc, 'MandeHul_XP', Job['XPGain'] * fixedManholes)

                exports['mani-bridge']:AddMoney(memberSrc, 'bank', receivedMoney)
                
                Log(memberSrc, ('[%s] %s fik %sx Kontanter | Færdiggjorde Mandehul Job (%s) Ruter'):format(memberSrc, GetPlayerName(memberSrc), receivedMoney, fixedManholes))
            end

            TriggerClientEvent('mani-mandehul:client:stopMission', memberSrc)

            Wait(150)
        end
    else
        if fixedManholes > 0 then
            if RecentEvents[src] and RecentEvents[src] + 60 > os.time() then
                local msg = ('[Mulig Cheater] - Spiller [%s] - %s | Afsluttet Job Indenfor %s Sekunder'):format(src, GetPlayerName(src), os.time() - RecentEvents[src])
                AntiCheatLog(src, msg)
                return
            end
        
            RecentEvents[src] = os.time()

            local receivedMoney = Job['Jobs'][CurrentJob['Tier']].MoneyReward * fixedManholes
            exports['mani-bridge']:AddMoney(src, 'bank', receivedMoney)
            exports['mani-bridge']:addMetaData(src, 'MandeHul_XP', Job['XPGain'] * fixedManholes)
            Log(src, ('[%s] %s fik %sx Kontanter | Færdiggjorde Mandehul Job (%s) Ruter'):format(src, GetPlayerName(src), receivedMoney, fixedManholes))
        end

        TriggerClientEvent('mani-mandehul:client:stopMission', src)
    end

    local vehicle = NetworkGetEntityFromNetworkId(CurrentJob['VehNetID'])
    while not DoesEntityExist(vehicle) do Wait(100) end
    DeleteEntity(vehicle)
end)

lib.callback.register('mani-mandehul:server:toggleNozzle', function(src, netId, toggle)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    while not DoesEntityExist(vehicle) do Wait(100) end

    FreezeEntityPosition(vehicle, toggle)

    local state = Entity(vehicle).state
    state:set('usingRope', toggle, true)
end)

lib.callback.register('mani-mandehul:server:updatePump', function(src, netId, toggle, zoneIndex)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    while not DoesEntityExist(vehicle) do Wait(100) end
    local state = Entity(vehicle).state
    state:set('pumpActive', toggle, true)

    if zoneIndex then
        state:set('activeManhole', zoneIndex, true)
    end
end)