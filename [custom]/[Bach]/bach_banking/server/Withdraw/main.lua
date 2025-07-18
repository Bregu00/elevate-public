local ESX = exports["es_extended"]:getSharedObject()

lib.callback.register("withdrawMoney", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return false, "Du har ikke nogen telefon"
    end

    local bankAccount = xPlayer.getAccount("bank")
    if bankAccount.money < amount then
        return false, "Du har ikke nok penge på din konto"
    end

    if exports["fh_accountclose"]:isAccountLocked(source, true) then return false, "Din konto er låst. Domstolen har lukket din konto." end

    xPlayer.removeAccountMoney("bank", amount)
    Wait(500)
    xPlayer.addMoney(amount)

    local logMsg = "Har hævet " .. amount .. " KR fra sin konto"

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
        discordTitle = "Banking",
        discordWebhook = "",
    })

    return true, "Du har hævet " .. amount .. " fra din konto"
end)

