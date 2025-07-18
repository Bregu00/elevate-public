local Drugs = {}
local webhook = exports['elevate-confidential']:fetch('ac_webhook')

function Drugs.AcLog(src, message)
    exports['onl_logsender']:SendLog(src, message, {
        labels = {
            job = "alerts",
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
            radio = false,
        },
        discordTitle = message,
        discordWebhook = webhook
    })
end

return Drugs