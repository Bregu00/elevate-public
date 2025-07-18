-- Make sure to follow the laptop installation steps before using this or any other laptop app:
-- Make sure to follow the laptop installation steps before using this or any other laptop app:
-- https://docs.av-scripts.com/laptop-pack/av-laptop/installation

Config = {}
Config.Debug = false -- Used to show some prints in client and server console
Config.ZonesDebug = false -- It will show the zones debug
Config.Target = exports['av_laptop']:getTarget() -- No need to modify this, do it from av_laptop/config directly
Config.Command = "admin:business"  -- Used to open the admin menu
Config.AdminLevel = "god"    -- Permission level needed to use command
Config.BankLogs = 3 -- Logs from bank tab will be deleted after 3 days to reduce memory load
Config.Applications = 3 -- Job applications will be deleted after 3 days to reduce memory load
-- If true, the boss can fire itself or change its own grade level, if the player is just messing around and loses the grade u will need to give it back manually
Config.BossCanEditItself = false
Config.BankAccount = 'bank' -- Used for deposit/withdraw and receive bonus payments
Config.UnemployedJobName = "unemployed" -- If a player gets fired he will get this job

Config.App = {
    name = "business",
    label = "Business", -- You can rename the app by editing this field
    isEnabled = function()
        local job = exports['av_laptop']:getJob()
        if Config.BlacklistedJobs[job.name] == true then return false end
        if job.isgang == true then return false end
        return true
    end
}

Config.BlacklistedJobs = { -- jobs from this list won't be able to access the business app
    ["unemployed"] = true,
    ["slaughterer"] = true,
    ["fisherman"] = true,
    ["miner"] = true,
    ["lumberjack"] = true,
    ["fueler"] = true,
    ["reporter"] = true,
    ["tailor"] = true,
}

Config.NoCustomItems = { -- This jobs won't be able to access Menu tab and register new items
    ['police'] = true,
    ['ambulance'] = true,
    ['taxi'] = true,
}

-- For Logs and custom logs tutorial please check: https://docs.av-scripts.com/laptop-pack-v3/av-business/config-options/logs

Config.Logs = { -- This is shown in the settings tab in business app, value needs to match the key index from events.lua and jobs can be false or a table with allowed jobs to use this logs
    { value = "applications", label = "Applications",  description = "Receive an alert when a new application is submitted to your business.", jobs = false },
    { value = "cashier",      label = "Cashier",       description = "Receive an alert when someone pays at the cashiers.", jobs = false },
    { value = "rate",         label = "Rating",        description = "Receive an alert when someone rates your business.", jobs = false },
    { value = "duty",         label = "Duty",          description = "Receive an alert when your STAFF enters/leaves duty.", jobs = false },
    { value = "employee",     label = "Employees",     description = "Receive an alert when an employee gets modified.", jobs = false },
    { value = "bank",         label = "Bank Logs",     description = "Receive an alert when someone makes a deposit/withdraw.", jobs = false },
    { value = "items",        label = "Items",         description = "Receive an alert when someone add/edit/delete an item from your business.", jobs = false },
--    { value = "custom_log",   label = "Custom Log",    description = "Only the jobs from the jobs table can access this log.", jobs = {"police", "ambulance"} },
}

-- Controls used when creating a box zone: https://docs.fivem.net/docs/game-references/controls/
Config.Controls = {
    ['up'] = 172,
    ['down'] = 173,
    ['left'] = 174,
    ['right'] = 175,
}