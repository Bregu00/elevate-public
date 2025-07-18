local VehicleThief = {}
local acWebhook = exports['elevate-confidential']:fetch('ac_webhook')

VehicleThief.GetPoliceCount = function()
    return #ESX.GetExtendedPlayers('job', 'police')
end

VehicleThief.Log = function(src, msg, screenshot)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = screenshot,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,
        },
        discordTitle = msg,
        discordWebhook = ''
    })
end

VehicleThief.AcLog = function(src, msg)
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

VehicleThief.StaffLog = function(src, msg, screenshot)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "staff",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = screenshot,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = true,
        },
        discordTitle = msg,
        discordWebhook = 'https://discord.com/api/webhooks/1373150488937369682/jOTcT9NCFbavYBvuPkWfyz-a_ciiOj91i1JQ7QOpQFocWbbOXLUKHxr6RWAp2oBNAAlK?thread_id=1367633402521452594'
    })
end

return VehicleThief