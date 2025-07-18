local function log(source, message)
    exports.onl_logsender:SendLog(source, message, {
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
        discordTitle = message,
        discordWebhook = "https://discord.com/api/webhooks/1347407660118708266/fqSqvDOs0CFFxc846A1eaS4j9Pca-P-7Qrg8dfE7njaUXa8IH-uhb4RqjJThdESHXRAL?thread_id=1347407598957236305" -- Another webhook
    })
end

lib.callback.register("jungurum-zoneBlackmail:server:CheckCooldown", function(source, zone, ConfigZone, index, playerJob)
    local currentTime = os.time()
    local xPlayer = ESX.GetPlayerFromId(source)
    local cooldownInSeconds = ConfigZone.cooldown / 1000
    local zoneName = zone.zone .. index
    if zone.owner ~= playerJob then
        local gangCount = exports["jungurum-lib"]:getJobCount(zone.owner)
        if gangCount < Config.minGangMembers then return false, "Banden som ejer zonen er ikke nok i byen." end
    end
    local result = exports.oxmysql:executeSync("SELECT * FROM blackmail WHERE zone = ?", { zoneName })
    if result[1] then
        local timeRemaining = cooldownInSeconds - (currentTime - result[1].time)
        if timeRemaining > 0 then
            local hours = math.floor(timeRemaining / 3600)
            local minutes = math.floor((timeRemaining % 3600) / 60)
            local timeString = ""
            if hours > 0 then
                timeString = hours .. " timer"
                if minutes > 0 then
                    timeString = timeString .. " og " .. minutes .. " minutter"
                end
            else
                timeString = minutes .. " minutter"
            end
            return false, "Vent lidt! Cooldown: " .. timeString
        end
    end
    AlertGang(xPlayer, zone, zone.zone)
    return true
end)

ESX.RegisterServerCallback("jungurum-zoneBlackmail:server:RewardAndCoolDown", function(source, cb, zone, ConfigZone, index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local currentTime = os.time()
    local cooldownInSeconds = ConfigZone.cooldown / 1000
    local zoneName = zone.zone .. index
    exports.oxmysql:execute("SELECT * FROM blackmail WHERE zone = ?", {
        zoneName
    }, function(result)
        if not result[1] then
            exports.oxmysql:insert("INSERT INTO blackmail (zone, gangname, time) VALUES (?, ?, ?)", {
                zoneName, xPlayer.job.name, currentTime
            }, function(insertId)
                if insertId then
                    exports.ox_inventory:AddItem(src, "black_money", zone.points * ConfigZone.payoutMultiplier)
                    log(src, xPlayer.job.name .. " Just blackmailed a shop in " .. zone.zone .. " Owned by " .. zone.owner)
                    return cb(true, "Du blackmailede manden.")
                    
                end
            end)
        else
            if (currentTime - result[1].time) < cooldownInSeconds then return cb(false, "Der er coolcown.") end
            exports.oxmysql:execute("UPDATE blackmail SET gangname = ?, time = ? WHERE id = ?", {
                xPlayer.job.name, currentTime, result[1].id
            }, function(affectedRows)
                if affectedRows.affectedRows > 0 then
                    exports.ox_inventory:AddItem(src, "black_money", zone.points * ConfigZone.payoutMultiplier)
                    log(src, xPlayer.job.name .. " Just blackmailed a shop in " .. zone.zone .. " Owned by " .. zone.owner)
                    return cb(true, "Du blackmailede manden.")
                end
            end)
        end
    end)
end)

function AlertGang(xPlayer, zone, zoneName)
    if xPlayer.job.name == zone.owner then return end
    local xPlayers = ESX.GetExtendedPlayers('job', zone.owner)
    for _, tPlayer in pairs(xPlayers) do
        if tPlayer.job.name == zone.owner then
            if tPlayer.source then
                local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(tPlayer.source)
                if phoneNumber then
                    local message = 'En anden bande har blackmailed et firma i ' .. zoneName .. '!'
                    local coords = xPlayer.getCoords(true)
                    exports["lb-phone"]:SendMessage(Config.PhoneContactName, phoneNumber, message)
                    exports["lb-phone"]:SendCoords(Config.PhoneContactName, phoneNumber, vector2(coords.x, coords.y))
                end
            end
        end
    end
end


