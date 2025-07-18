local hook = "https://discord.com/api/webhooks/1310277098488725544/yBCOZ_bacEuEpzopgt69l1v3ODPS05PJeyb9olGZnlPmWDHmud9jxEfpq1yxgYFXJbBl"

local function getIdentifier(type)
    local src = source
    local identifiers = GetNumPlayerIdentifiers(src)
    for i = 0, identifiers + 1 do
        if GetPlayerIdentifier(src, i) ~= nil then
            if string.match(GetPlayerIdentifier(src, i), type) then
                return(GetPlayerIdentifier(src, i))
            end
        end
    end
end

RegisterNetEvent("sb_laundering:server:launderMoney", function(moneyAmount, launderPercent, name, key)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if launderPercent > Config.locations[key].maxPercent then return end
    if not key then return end
    if not moneyAmount then return end
    local success, __ = exports.ox_inventory:RemoveItem(src, Config.blackMoneyItem, moneyAmount)
    if success then
        local success1, _ = exports.ox_inventory:AddItem(src, Config.moneyItem, moneyAmount - math.floor(moneyAmount * launderPercent / 100))
        if success1 then
            depositSocietyMoney(src, key, math.floor(moneyAmount * launderPercent / 100 * Config.locations[key].societyPercent / 100))
            TriggerClientEvent('ox_lib:notify', src, {
                title = "Du har vasket ".. ESX.Math.GroupDigits(moneyAmount) .. " til " .. launderPercent .. "% hvilket bliver " .. ESX.Math.GroupDigits(math.floor(moneyAmount - moneyAmount * launderPercent / 100)),
                duration = 10000,
            })
            exports.onl_logsender:SendLog(src, Config.locations[key].society .. " Laundered " .. ESX.Math.GroupDigits(moneyAmount), {
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
                    coords = false,
                    radio = false,
    
                },
                discordTitle = Config.locations[key].society .. " Laundered " .. ESX.Math.GroupDigits(moneyAmount),
                discordWebhook = "https://discord.com/api/webhooks/1344788597668184155/tAos9283G0KzvvIsIOw7zYzXum7Zag0DF5j_QDUwCi8nLCwtmlPHa90e6WnJ8C7YmFW-?thread_id=1344788547617423370" -- Another webhook
            })

            function urlencode(str)
                if str then
                    str = string.gsub(str, "\n", "\r\n")
                    str = string.gsub(str, "([^%w ])", function(c) 
                        return string.format("%%%02X", string.byte(c)) 
                    end)
                    str = string.gsub(str, " ", "+")
                end
                return str or ""
            end
            
            local option1 = urlencode(xPlayer.getJob().label or "Unknown Job")
            local option2 = urlencode(xPlayer.getName() or "Unknown Player")
            local option3 = urlencode(tostring(moneyAmount or 0))
            local option4 = urlencode(tostring(launderPercent or 0))
            local option5 = urlencode(tostring((launderPercent or 0) * (moneyAmount or 0) / 100))
            
            local url = "https://script.google.com/macros/s/AKfycbyk57oHQyLE7zv-aQNnpxEhXuf1gtpO38nQOb3ByF_TKRNOistTjOcYgN6Mlb71WZKzMA/exec"
            url = url .. "?option1=" .. option1 ..
                "&option2=" .. option2 ..
                "&option3=" .. option3 ..
                "&option4=" .. option4 ..
                "&option5=" .. option5
            
            PerformHttpRequest(url, function(statusCode, responseText, headers)
            end, "GET", "", {["User-Agent"] = "FiveM"})
        end
    end
end)

function depositSocietyMoney(src, key, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    exports['elevate-multijob']:addAccountBalance(Config.locations[key].society, amount)
    exports['fh_bossmenu']:AddIncome(Config.locations[key].society, { amount = amount, type = "income" }, xPlayer.getName())
    TriggerClientEvent('ox_lib:notify', src, {
        title = ESX.Math.GroupDigits(amount) .. " indsat på kontoen " .. Config.locations[key].society,
        duration = 10000,
    })
end