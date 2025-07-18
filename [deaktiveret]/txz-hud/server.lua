ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('elevate_hud:getplayer:info', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb(nil)
        return
    end

    local bank = xPlayer.getAccount("bank").money
    local money = xPlayer.getAccount(Config.Money).money
    local black_money = xPlayer.getAccount(Config.blackMoney).money
    local job = xPlayer.getJob()

    cb({
        bank = bank,
        money = money,
        black_money = black_money,
        job = job.label,
        grade = job.grade_label,
        playerid = source
    })
end)

RegisterNetEvent('elevate_hud:requestTotalPlayers', function()
    local totalPlayers = #GetPlayers()
    TriggerClientEvent('elevate_hud:sendTotalPlayers', source, totalPlayers)
end)