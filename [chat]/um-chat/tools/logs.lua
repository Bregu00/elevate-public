RegisterNetEvent('um-chat:server:logs:addLogs', function(src, type, command, colorType)
    local xPlayer = ESX.GetPlayerFromId(src)
    exports.onl_logsender:SendLog(src, xPlayer.getName() .. " just typed /" .. type .. " " .. command, {
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
            radio = false,

        },
        discordTitle = xPlayer.getName() .. " skrev /" .. type .. " " .. command,
        discordWebhook = "" -- Another webhook
    })
end)
