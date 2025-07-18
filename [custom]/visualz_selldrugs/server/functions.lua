-- Server side function
function SellDrugEvent(source, drug, price, amount, zone)
  local xPlayer = ESX.GetPlayerFromId(source)
  exports["visualz_zones"]:AddPoints(xPlayer, zone, price * amount, drug, amount)
  exports.onl_logsender:SendLog(source, xPlayer.getName() .. " har solgt " .. amount .. " " .. drug .. " i zonen " .. zone .. " for " .. price * amount .. " kr", {
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
    discordTitle = xPlayer.getName() .. " har solgt " .. amount .. " " .. drug .. " i zonen " .. zone,
    discordWebhook = "https://discord.com/api/webhooks/1354715699125162024/xLNe30jpcsYSYv00CdKyK8xO7As_JdWzG7gJOMrnwx6ATSEHvUl35vnLr534qVFUBgGz?thread_id=1354715666246271097" 
})
end

-- Server side function
function CustomAlert(source, zone, drug)
  -- Lav din egene alert her

  -- local xPlayer = ESX.GetPlayerFromId(source)
  -- local message = "Der er en der sælger stoffer i " .. zone .. "!"
  -- exports['visualz_opkaldsliste']:AddCall(nil, message, "police", xPlayer.getCoords(true))
end
