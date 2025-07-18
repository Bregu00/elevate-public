ESX = exports['es_extended']:getSharedObject()

function Notify(source, text, status)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Oxy Job',
        description = text,
        type = status
    })
end

lib.callback.register('dynyx_oxyrun:CheckCops', function(source)
    return (#ESX.GetExtendedPlayers('job', Config.PoliceJob))
end)

RegisterServerEvent('dynyx_oxyrun:GivePackage', function()
    local src = source
    exports.ox_inventory:AddItem(src, Config.OxyBoxItem, 1)
    exports.onl_logsender:SendLog(source, "Just recived a oxy box", {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = false,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = false,
            radio = false,

        },
        discordTitle = "Just recived a oxy box",
        discordWebhook = "https://discord.com/api/webhooks/1350250799153807360/3R4p_6FQD4h-kfgANabjHbtO9iaLRSRV34kDTD1_xp97nyleDss6o3fZo7MJyYkanIgu?thread_id=1350250544643440732" -- Another webhook
    })
end)

RegisterServerEvent('dynyx_oxyrun:Pay', function()
    local src = source
    local playerItems = exports.ox_inventory:GetInventoryItems(src)
    local item = exports.ox_inventory:GetItem(src, "money")

    if item.count >= Config.CostToStart then
        exports.ox_inventory:RemoveItem(src, "money", Config.CostToStart)
        TriggerClientEvent('dynyx_oxyrun:startjob', src)
    else
        Notify(src, "Du har ikke nok penge til at starte dette job", "error")
    end
    exports.onl_logsender:SendLog(source, "Just startet a oxy run", {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = false,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = false,
            radio = false,

        },
        discordTitle = "Just startet a oxy run",
        discordWebhook = "https://discord.com/api/webhooks/1350250799153807360/3R4p_6FQD4h-kfgANabjHbtO9iaLRSRV34kDTD1_xp97nyleDss6o3fZo7MJyYkanIgu?thread_id=1350250544643440732" -- Another webhook
    })
end)

RegisterServerEvent('dynyx_oxyrun:GetOxy', function()
    local src = source
    local OxyBoxItem = exports.ox_inventory:Search(src, 'count', Config.OxyBoxItem)
    local DirtyMoneyItem = exports.ox_inventory:Search(src, 'count', Config.DirtyMoneyItem)

    local chance = math.random(1, 100)

    if OxyBoxItem then
        exports.ox_inventory:RemoveItem(src, Config.OxyBoxItem, 1)
        if chance <= Config.ChanceOfOxy then
            exports.ox_inventory:AddItem(src, Config.OxyItem, math.random(Config.OxyMin, Config.OxyMax))

        elseif chance >= Config.SpecialRewardChance then
            local SpecialRewardItem = Config.SpecialReward[math.random(1, #Config.SpecialReward)]
            exports.ox_inventory:AddItem(src, SpecialRewardItem, math.random(Config.SpecialRewardAmtMin, Config.SpecialRewardAmtMax))

        elseif chance >= Config.ChanceofGivingMoney then
            exports.ox_inventory:AddItem(src, "money", math.random(Config.AmountOfMoneyMin, Config.AmountofMoneyMax))
        end

        if Config.WashMoney then
            if chance <= Config.WashMoneyChance then
                if DirtyMoneyItem then
                    if exports.ox_inventory:RemoveItem(src, Config.DirtyMoneyItem, Config.WashAmount) then
                        exports.ox_inventory:AddItem(src, "money", Config.WashAmount * math.random(Config.AmountPerDirtyMoneyMin, Config.AmountPerDirtyMoneyMax))
                    end
                end
            end
        end
    end
    exports.onl_logsender:SendLog(source, "Just delivered a oxy box", {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = false,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = false,
            radio = false,

        },
        discordTitle = "Just delivered a oxy box",
        discordWebhook = "https://discord.com/api/webhooks/1350250799153807360/3R4p_6FQD4h-kfgANabjHbtO9iaLRSRV34kDTD1_xp97nyleDss6o3fZo7MJyYkanIgu?thread_id=1350250544643440732" -- Another webhook
    })
end)
