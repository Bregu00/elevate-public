Config = Config or {}
Core = nil
Config.Framework = false

CreateThread(function()
    if Config.Framework then return end
    if GetResourceState("qbx_core") ~= "missing" then
        Config.Framework = "qbox"
        Core = qbx
        Config.Identifier = "license2"
        print([[^3If using Qbox uncomment the import in fxmanifest.lua line 14 and restart server.
^7Remove this print in config/_framework.lua line 11-12 ^7]])
        return
    end
    if GetResourceState("qb-core") ~= "missing" then
        Config.Framework = "qb"
        Core = exports['qb-core']:GetCoreObject()
        return
    end
    if GetResourceState("es_extended") ~= "missing" then
        Config.Framework = "esx"
        Core = exports['es_extended']:getSharedObject()
        return
    end
end)
