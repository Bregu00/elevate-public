local webhook = "https://discord.com/api/webhooks/1353885912165126266/KSDBV2QMZzaZCrmVIrdlEwpPSrZaP24WfLVOfUsLu7_N_3stjoXf_8JQyN9aSSK72hbq"

RegisterServerEvent("onl_custombankheist:giveItem")
AddEventHandler("onl_custombankheist:giveItem", function(itemname, count)
    local src = source
    exports["av_blackmarket"]:fg_BanPlayer(src,"FAKE TRIGGER - giveItem", true)
    exports['onl_logsender']:SendLog(src, 'FAKE TRIGGER - giveItem', {
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
            radio = true,

        },
        discordTitle = 'FAKE TRIGGER - giveItem',
        discordWebhook = webhook
    })
end)

RegisterServerEvent("onl_custombankheist:giveMoney")
AddEventHandler("onl_custombankheist:giveMoney", function(itemname, count)
    local src = source
    exports["av_blackmarket"]:fg_BanPlayer(src,"FAKE TRIGGER - giveMoney", true)
    exports['onl_logsender']:SendLog(src, 'FAKE TRIGGER - giveMoney', {
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
            radio = true,

        },
        discordTitle = 'FAKE TRIGGER - giveMoney',
        discordWebhook = webhook
    })
end)

RegisterServerEvent("onl_custombankheist:giveVehicle")
AddEventHandler("onl_custombankheist:giveVehicle", function(itemname, count)
    local src = source
    exports["av_blackmarket"]:fg_BanPlayer(src,"FAKE TRIGGER - giveVehicle", true)
    exports['onl_logsender']:SendLog(src, 'FAKE TRIGGER - giveVehicle', {
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
            radio = true,

        },
        discordTitle = 'FAKE TRIGGER - giveVehicle',
        discordWebhook = webhook
    })
end)

RegisterServerEvent("onl_custombankheist:addReward")
AddEventHandler("onl_custombankheist:addReward", function(Amount)
    local src = source
    exports["av_blackmarket"]:fg_BanPlayer(src,"FAKE TRIGGER - addReward", true)
    exports['onl_logsender']:SendLog(src, 'FAKE TRIGGER - addReward', {
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
            radio = true,

        },
        discordTitle = 'FAKE TRIGGER - addReward',
        discordWebhook = webhook
    })
end)
