--[[
    READ THE DOCS BEFORE USING THE SCRIPT FOR THE FIRST TIME
    https://docs.av-scripts.com/
    https://docs.av-scripts.com/
    https://docs.av-scripts.com/
]]

Config = {}
Config.Debug = false
Config.AdminLevel = "god" -- Admin level, used for permissions in APP, check the docs to customize server/framework/permissions.lua
Config.AdminPanelCommand = "admin:racing" -- Admin command used to open the admin menu
Config.ClassCommand = false -- Used to view the vehicle class, or change it to false to disable it
Config.TheUnderground = true -- Enable/Disable The Underground button
Config.App = {
    name = "racing",
    label = "Racing", -- You can rename the app by editing this field
    isEnabled = function()
        return exports['av_laptop']:hasItem('black_usb')
    end
}
Config.EditorKeys = {
    ['add'] = {Label = "7 - Add Checkpoint  \n", key = 161},
    ['distance'] = {Label = "] [ - Light Distance  \n", key = {decrease = 39, increase = 40}},
    ['delete'] = {Label = "8 - Delete Checkpoint  \n", key = 162},
    ['cancel'] = {Label = "9 - Cancel Editor  \n", key = 163},
    ['save'] = {Label = "E - Save Race  \n", key = 38},
    ['rotate'] = {Label = "Arrow Keys - Rotate Checkpoint  \n", key = {decrease = 174, increase = 175}},
    ['reset'] = {Label = "Arrow Up - Reset Rotation  \n", key = 172},
}
Config.DefaultProfile = { -- Default profile for new users
    photo = "",
    age = "18",
    nationality = "Unknown",
    lights = "violet", -- don't modify this
    blip = "violet",  -- don't modify this
    story = "",
    animation = "smoke", -- neds to match an animation from config/animations.lua
}
Config.TracksCategories = { -- Colors: https://mantine.dev/theming/colors/#default-colors
    -- Cops can only view/access the tracks and events with the "police" category
    {value = "bikes", label = "Bikes", color = "green.2", canUse = function() return not exports['av_laptop']:isCop() end},
    {value = "circuit", label = "Circuit", color = "violet.2", canUse = function() return not exports['av_laptop']:isCop() end},
    {value = "drag", label = "Drag", color = "orange.2", canUse = function() return not exports['av_laptop']:isCop() end},
    {value = "police", label = "Police", color = "blue.2", canUse = function() return exports['av_laptop']:isCop() end},
}
Config.MoneyAccounts = { -- Money accounts available when creating a new event
    {
        value = "money", -- account name ("cash" is used in qbcore, for esx use "money")
        label = "Cash", -- how the player will see it on APP and Discord
        canUse = function()
            return true
        end
    },
    {
        value = "crypto",
        label = "CRPTO",
        canUse = function()
            return not exports['av_laptop']:isCop() -- cops can't use this account for events
        end
    }
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end