---@param data { name = string, amount = number }
---@param source string
function Log(source, data)
    local logMsg = ('%s Crafted %sx %s'):format(GetPlayerName(source), data.amount, data.name)
    exports['onl_logsender']:SendLog(source, logMsg, {
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
        discordTitle = logMsg,
        discordWebhook = ""
    })
end