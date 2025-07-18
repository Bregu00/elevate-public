QBCore, ESX = nil, nil
disabled = false

if Config.Framework == "qb" then
    TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
    if QBCore == nil then
        QBCore = exports[Config.FrameworkTriggers["qb"].ResourceName]:GetCoreObject()
    end
    Config.JobAccounts = true
elseif Config.Framework == "esx" then
    local status, errorMsg = pcall(function() ESX = exports[Config.FrameworkTriggers["esx"].ResourceName]:getSharedObject() end)
    -- ESX = exports[Config.FrameworkTriggers["esx"].ResourceName]:getSharedObject()
    if (ESX == nil) then
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
else
    print("Framework not found")
    disabled = true
end

function GetPlayerFrameworkIdentifier(id)
    if Config.Framework == "qb" then
        local Player = QBCore.Functions.GetPlayer(id)
        if not Player then
            return
        end
        return Player.PlayerData.citizenid
    elseif Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(id)
        if not xPlayer then
            return
        end
        return xPlayer.identifier
    end
end

function CanAccess(id)
    if Config.Framework == "qb" then
        local Player = QBCore.Functions.GetPlayer(id)
        local job = Player.PlayerData.job.name
        if Config.Jobs[job] then
            return true
        end
        return false
    elseif Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(id)
        local job = xPlayer.job.name
        if Config.Jobs[job] then
            return true
        end
    end
    return false
end