if Config.Framework ~= 'standalone' then return end

local callbacks = {}
local allJobs = {}

function GetPlayerFromId(playerId)
    return playerId
end

function GetIdentifier(playerId)
    return GetPlayerIdentifierByType(playerId, 'license')
end

function IsOnDuty(playerId)
    return true
end

function GetJobName(playerId) -- currently how it works is it will return the first job it finds in the discord roles, you are free to change this yourself to fit your needs
    local roles = exports.Badger_Discord_API:GetDiscordRoles(playerId)

    for _,v in pairs(roles) do
        if allJobs[v] then
            return v
        end
    end

    return
end

function GetGradeId()
    return 99
end

function GetCharName(identifier)
    return
end

function RegisterCallback(eventName, callback)
	callbacks[eventName] = callback
end

RegisterNetEvent('tk_dispatch:triggerServerCallback', function(eventName, requestId, invoker, ...)
	if not callbacks[eventName] then
		error('Server callback %s invoked by %s not registered'):format(eventName, invoker)
	end

	local source = source

	callbacks[eventName](source, function(...)
		TriggerClientEvent('tk_dispatch:serverCallback', source, requestId, invoker, ...)
	end, ...)
end)

RegisterCallback('tk_dispatch:getDiscordRoles', function(src, cb)
    cb(exports.Badger_Discord_API:GetDiscordRoles(src))
end)

CreateThread(function()
    for _,data in pairs(Config.Dispatch) do
        for k in pairs(data.jobs) do
            allJobs[k] = true
        end
    end

    frameworkLoaded = true
end)