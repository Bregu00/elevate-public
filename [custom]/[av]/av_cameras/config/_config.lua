-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
Config = {}
Config.Debug = false
Config.HostingService = 'fivemanage' -- "fivemanage" or "fivemerr" // add your token in server/editable/token.lua
Config.VehicleThumbnail = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/QsUBHkb.jpeg" -- Used as thumbnail for vehicles in Camera App
Config.App = {
    name = "cameras",
    label = "CamPro", -- You can rename the app by editing this field
    isEnabled = function()
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end