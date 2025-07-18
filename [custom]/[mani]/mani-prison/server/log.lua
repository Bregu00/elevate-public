---@param data { src = number, action = string, targetSrc = number, time = number }
function log(data)
    local src = data.src
    local action = data.action
    local targetSrc = data.targetSrc
    local time = data.time

    local logMsg = action == 'Jailed' and ('%s %s %s %s Minutes'):format(GetPlayerName(src), action, GetPlayerName(targetSrc), time) or ('%s %s %s'):format(GetPlayerName(src), action, GetPlayerName(targetSrc))
    exports['onl_logsender']:SendLog(src, logMsg, {
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
        discordTitle = logMsg,
        discordWebhook = ''
    })
end