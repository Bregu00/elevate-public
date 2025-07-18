--[[
    Configurable company system, you can create multiple files
    and adapt them to your company system, these are the ones we recommend
    that we bring by default, but you can integrate others.

    Enable Config.Debug to be able to see the log inside Debug.
]]

if Config.Society ~= 'esx_society' then
    return
end

function AddMoneyToSociety(src, societyName, societyPaid)
    local xPlayer = ESX.GetPlayerFromId(src)
    exports['elevate-multijob']:addAccountBalance(societyName, societyPaid)
    exports['fh_bossmenu']:AddIncome(societyName, { amount = societyPaid, description = "Hus salg", type = "income" }, xPlayer.getName())
    return true
end