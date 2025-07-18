QBCore, ESX = nil, nil
-- PlayerJob = {}
PlayerInfo = {}
dna = nil
fingerprint = nil

if Config.Framework == "qb" then
    QBCore = exports[Config.FrameworkTriggers["qb"].ResourceName]:GetCoreObject()
elseif Config.Framework == "esx" then
    local status, errorMsg = pcall(function() ESX = exports[Config.FrameworkTriggers["esx"].ResourceName]:getSharedObject() end)
    if (ESX == nil) then
        while ESX == nil do
            Wait(100)
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        end
    end
end

function PopulateData()
    if Config.Framework == "qb" then
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
        PlayerGang = PlayerData.gang
        PlayerInfo = {
            job = PlayerData.job.name,
            grade = PlayerData.job.grade.level,
            identifier = PlayerData.citizenid,
        }
        PlayerData = nil
    elseif Config.Framework == "esx" then
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        PlayerData = ESX.GetPlayerData()
        PlayerInfo = {
            job = PlayerData.job.name,
            grade = PlayerData.job.grade,
            identifier = PlayerData.identifier,
        }
        PlayerData = nil
    end
    SetupUI()
    dna, fingerprint = lib.callback.await("snipe-evidence:server:playerLoaded", false)
end


RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].PlayerLoaded)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].PlayerLoaded, function()
    PopulateData()
end)

RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].PlayerUnload)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].PlayerUnload, function()
    PlayerInfo = nil
end)

RegisterNetEvent(Config.FrameworkTriggers[Config.Framework].OnJobUpdate)
AddEventHandler(Config.FrameworkTriggers[Config.Framework].OnJobUpdate, function(job)
    PlayerInfo.job = job.name
    if Config.Framework == "qb" then
        PlayerInfo.grade = job.grade.level
    elseif Config.Framework == "esx" then
        PlayerInfo.grade = job.grade
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Wait(1000)
        PopulateData()
    end
end)