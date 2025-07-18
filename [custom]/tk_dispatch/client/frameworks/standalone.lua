if Config.Framework ~= 'standalone' then return end

local requestId = 0
local requests = {}
local allJobs = {}

function TriggerCallback(eventName, callback, ...)
	requests[requestId] = callback

	TriggerServerEvent('tk_dispatch:triggerServerCallback', eventName, requestId, GetInvokingResource() or 'unknown', ...)

	requestId += 1
end

RegisterNetEvent('tk_dispatch:serverCallback', function(id, invoker, ...)
	if not requests[id] then
		return error('Server Callback with requestId %s called by %s does not exist'):format(id, invoker)
	end

	requests[id](...)
	requests[id] = nil
end)

CreateThread(function()
    frameworkLoaded = true
end)

function GetCharName()
    return
end

function GetPhoneNumber()
    return
end

function GetGender()
    return GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` and _U('female') or _U('male')
end

function IsDead()
    return IsEntityDead(PlayerPedId())
end

function GetDiscordRoles()
    local p = promise.new()
    TriggerCallback('tk_dispatch:getDiscordRoles', function(roles)
        p:resolve(roles)
    end)
    return Citizen.Await(p)
end

function IsOnDuty()
    return true
end

function GetJobName() -- currently how it works is it will return the first job it finds in the discord roles, you are free to change this yourself to fit your needs
    local roles = GetDiscordRoles()

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

function GetItemAmount(item)
    return 0
end

function GetItemLabel(item)
    return item
end

CreateThread(function()
    for _,data in pairs(Config.Dispatch) do
        for k in pairs(data.jobs) do
            allJobs[k] = true
        end
    end

    frameworkLoaded = true
    PlayerLoaded()
end)