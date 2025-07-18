local taxiConfig = lib.load("shared.jobs.taxi")

lib.callback.register("bach_taxijob:checkDeposit", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    return xPlayer.getMoney() >= amount
end)

lib.callback.register("bach_taxijob:payDeposit", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if xPlayer.getMoney() < amount then
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Taxaservice",
            description = "Du har ikke råd til depositummet",
            type = "error",
            icon = "fas fa-taxi",
        })
        return false
    end

    xPlayer.removeMoney(amount)

    return true
end)

lib.callback.register("bach_taxijob:returnDeposit", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    xPlayer.addMoney(amount)

    return true
end)

lib.callback.register("bach_taxijob:processPayment", function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    xPlayer.addMoney(amount)

    return true
end)

lib.callback.register("bach_taxijob:getOnlinePlayers", function(source)
    return #ESX.GetExtendedPlayers()
end)

lib.callback.register("bach_taxijob:updateStats", function(source, stats)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    local distance = stats.distance or 0
    local fare = stats.fare or 0

    return true
end)

RegisterNetEvent("bach_taxijob:payDeposit", function(amount)
    local src = source
    print("Modder man 69")
end)

RegisterNetEvent("bach_taxijob:returnDeposit", function(amount)
    local src = source
    print("Modder man 69")
end)

RegisterNetEvent("bach_taxijob:processPayment", function(amount)
    local src = source
    print("Modder man 69")
end)
