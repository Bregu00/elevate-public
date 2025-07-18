ESX = exports["es_extended"]:getSharedObject()

local adminGroups = {
    ['mod'] = true,
    ['admin'] = true,
    ['god'] = true
}

local perms = {}

ESX.RegisterServerCallback('esx_chatforadmin:GetGroup', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    if player then
        cb(player.getGroup() or "user")
    else
        cb("user")
    end
end)

RegisterCommand('ooc', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (xPlayer.getGroup() == 'admin') or (xPlayer.getGroup() == 'god') then
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(66, 138, 245, 1); color: rgba(255, 255, 255, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-globe" style="color: rgba(255, 255, 255, 1);"></i> <span style="color: white; font-weight: bold;">Staff @</span> {0}</span><span style="color: white; font-weight: bold;">: </span>{1}</div>',
            args = {playerName, msg, source}
        })
    end
end, false)

RegisterCommand('report', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = GetPlayerName(source)
    local message = table.concat(args, " ")

    for _, playerID in ipairs(ESX.GetPlayers()) do
        local targetPlayer = ESX.GetPlayerFromId(playerID)
        if targetPlayer and adminGroups[targetPlayer.getGroup()] and targetPlayer.getMeta('staffDisable') == "true" then
            TriggerClientEvent("fh_rpchat:SendReportToAdmin", playerID, source, playerName, message)
        end
    end

    if not (xPlayer.getMeta('staffDisable') == nil) or (xPlayer.getMeta('staffDisable') == "true") then return end
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(237, 252, 244, 1); color: rgba(0, 0, 0, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-exclamation-triangle fa-lg" style="color: rgba(255, 0, 0, 1);"></i> <span style="color: black; font-weight: bold;">REPORT</span> <span style="color: black; font-weight: bold;">@</span><span style="color: red; font-weight: bold;">{0}</span> <span style="color: black; font-weight: bold;">- ID:</span> <span style="color: green; font-weight: bold;">{2}</span><span style="font-weight: bold;">:</span> <span style="color: black; font-weight: bold;">{1}</span></div>',
        args = {playerName, message, source}
    })
end, false)

RegisterCommand('rr', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] and tonumber(args[1]) then
        local targetID = tonumber(args[1])
        local targetPlayer = ESX.GetPlayerFromId(targetID)

        if not targetPlayer then
            TriggerClientEvent('ox_lib:notify', source, {description = 'Den spiller er ikke online!', type = 'error'})
            return
        end

        table.remove(args, 1)
        local message = table.concat(args, " ")
        if targetPlayer and xPlayer.getGroup() ~= 'user' then
            if targetID ~= source then
                TriggerClientEvent('chat:addMessage', targetID, {
                    template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(237, 252, 244, 1); color: rgba(0, 0, 0, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-exclamation-triangle fa-lg" style="color: rgba(255, 0, 0, 1);"></i> <span style="color: black; font-weight: bold;">REPORT SVAR</span> <span style="color: black; font-weight: bold;">@</span><span style="color: red; font-weight: bold;">{0}</span> <span style="color: black; font-weight: bold;">- ID:</span> <span style="color: green; font-weight: bold;">{2}</span><span style="font-weight: bold;">:</span> <span style="color: black; font-weight: bold;">{1}</span></div>',
                    args = {GetPlayerName(source), message, source}
                })
            end
            for _, playerID in ipairs(ESX.GetPlayers()) do
                local targetPlayer = ESX.GetPlayerFromId(playerID)
                if not targetPlayer then return end
                if adminGroups[targetPlayer.getGroup()] and targetPlayer.getMeta('staffDisable') == "true" and playerID ~= targetID then
                    TriggerClientEvent('chat:addMessage', playerID, {
                        template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(237, 252, 244, 1); color: rgba(0, 0, 0, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-exclamation-triangle fa-lg" style="color: rgba(255, 0, 0, 1);"></i> <span style="color: black; font-weight: bold;">REPORT SVAR</span> <span style="color: black; font-weight: bold;">@</span><span style="color: red; font-weight: bold;">{0}</span> <span style="color: black; font-weight: bold;">- ID:</span> <span style="color: green; font-weight: bold;">{2}</span><span style="font-weight: bold;">:</span> <span style="color: black; font-weight: bold;">{1}</span></div>',
                        args = {GetPlayerName(source), message, source}
                    })
                end
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {description = 'Du har ikke adgang til dette!', type = 'error'})
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {description = 'Du mangler at skrive et ID!', type = 'error'})
    end
end, false)

RegisterNetEvent("sendtoownplayer")
AddEventHandler("sendtoownplayer", function(name, message)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.getMeta('staffDisable') == "true" then return end
    if xPlayer and xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(237, 252, 244, 1); color: rgba(0, 0, 0, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-exclamation-triangle fa-lg" style="color: rgba(255, 0, 0, 1);"></i> <span style="color: black; font-weight: bold;">REPORT SVAR</span> <span style="color: black; font-weight: bold;">@</span><span style="color: red; font-weight: bold;">{0}</span> <span style="color: black; font-weight: bold;">- ID:</span> <span style="color: green; font-weight: bold;">{2}</span><span style="font-weight: bold;">:</span> <span style="color: black; font-weight: bold;">{1}</span></div>',
            args = {name, message, source}
        })
    end
end)

RegisterCommand('togglereports', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and adminGroups[xPlayer.getGroup()] then
        local currentState = xPlayer.getMeta('staffDisable') == "true"
        xPlayer.setMeta('staffDisable', currentState and "false" or "true")
        TriggerClientEvent('ox_lib:notify', source, {
            description = currentState and 'Reports fjernet!' or 'Reports tilføjet!',
            type = currentState and 'error' or 'success',
        })
    end
end, false)
