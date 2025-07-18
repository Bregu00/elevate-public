local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local getAllGangRanks = {}

CreateThread(function()
    exports["ap_createjob"]:getAllGangRanks(function(result)
        for i = 1, #result do
            if result[i] then
                local gang = result[i]
                table.insert(getAllGangRanks, gang)
            end
        end
    end)
    while getAllGangRanks[1] == nil do Wait(1) end
end)

exports("refreshLabGangs", function()
    exports["ap_createjob"]:getAllGangRanks(function(result)
        getAllGangRanks = {}
        for i = 1, #result do
            if result[i] then
                local gang = result[i]
                table.insert(getAllGangRanks, gang)
            end
        end
    end)
    while getAllGangRanks[1] == nil do Wait(1) end
end)

local function log(source, message, screnshot)
    exports.onl_logsender:SendLog(source, message, {
        labels = {
            job = "staff",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = false,
            playerName = false,
            screenshot = screnshot,
            money = false,
            black_money = false,
            bank = false,
            coords = true,
            radio = false,

        },
        discordTitle = message,
        discordWebhook = ""
    })
end

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end

ESX.RegisterServerCallback('elm_druglab:getgangs', function(source, cb, id)
    local gangs = {} -- Define our table to use
    for k,v in pairs(getAllGangRanks) do
        table.insert(gangs, v)
    end
    cb(gangs)
end)

ESX.RegisterServerCallback('elm_druglab:getgangscreate', function(source, cb)
    MySQL.query('SELECT * FROM druglabs', function(result)
        local jobs = ESX.GetJobs()
        local gangscreated = {}
        if #result > 0 then
            for k,v in pairs(result) do
                for k2,v2 in pairs(getAllGangRanks) do
                    if v.gang ~= v2.name then
                        table.insert(gangscreated, v2)
                    end
                end
            end
        else
            for k, v in pairs(getAllGangRanks) do
                table.insert(gangscreated, v)
            end
        end
        cb(gangscreated)
    end)
end)

ESX.RegisterServerCallback('elm_druglab:getRegLabs', function(source, cb)
    local reglabs = {}
    MySQL.query('SELECT * FROM druglabs', function(result)
        for k, v in pairs(result) do
            table.insert(reglabs, v)
        end
        cb(reglabs)
    end)
end)

ESX.RegisterServerCallback('elm_druglab:changeStof', function(source, cb, stof, id)
    exports.oxmysql:execute('UPDATE druglabs SET `object` = ?, `timeupdated` = ? WHERE `id` = ?', {stof, os.date('%Y-%m-%d %H:%M:%S'), id})
    local xPlayer = ESX.GetPlayerFromId(source)
    log(source, "Labbet med " .. id .. " har fået skiftet stof til " .. stof)
    cb(true)
end)

ESX.RegisterServerCallback('elm_druglab:deleteLab', function(source, cb, id)
    if exports.oxmysql:execute('DELETE FROM druglabs WHERE `id` = ?', {id}) then
        cb(false)
    else
        log(source, "Labbet med id " .. id .. " er blevet fjernet")
        cb(true)
    end
end)

function getDiscord(source)
local discord  = false
  for k,v in pairs(GetPlayerIdentifiers(source))do
    if string.sub(v, 1, string.len("discord:")) == "discord:" then
        return(v)
    end   
  end
end