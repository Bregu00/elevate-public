local mainserver = GetConvar("mainserver", false)

if not mainserver then return end

RegisterServerEvent("jungurum-smallresources:server:kickAFK", function()
    DropPlayer(source, Config.AFK.msgKickAss)
end)

local function KickAllPlayers()
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        DropPlayer(xPlayers[i], 'Serveren genstarter - Forventes tilbage indenfor 3 minutter.')
    end
end

CreateThread(function()
    for i = 1, #Config.ResetTimes do
        local v = Config.ResetTimes[i]
        lib.cron.new(('%s %s * * *'):format(v.minute, v.hour), KickAllPlayers)
    end
end)