local Dealer, Config = {}, lib.load('config')

local Webhook, ACWebhook = exports['elevate-confidential']:fetch('weapondealer_webhook'), exports['elevate-confidential']:fetch('ac_webhook')

function Dealer.Log(src, msg, file)
    exports['onl_logsender']:SendLog(src, msg, {
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
        fileContent = file and file.content or false,
        fileName = file and file.name or false,
        discordTitle = msg,
        discordWebhook = ('%s?thread_id=1367117800212135987'):format(Webhook)
    })
end

function Dealer.ACLog(src, msg)
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
        discordWebhook = ACWebhook
    })
end

CreateThread(function()
    local ammoItem = {
        ['Handguns'] = 'ammo',
        ['Shotguns'] = 'ammo2'
    }

    for category, weapons in pairs(Config.Stock) do
        for weapon, data in pairs(weapons) do
            if ammoItem[category] then
                ESX.RegisterUsableItem(data.Item, function(source)
                    if not exports['ox_inventory']:RemoveItem(source, data.Item, 1) then return end
                    exports['ox_inventory']:AddItem(source, weapon, 1)
                    exports['ox_inventory']:AddItem(source, ammoItem[category], 30)
                end)
            end
        end
    end
end)

return Dealer