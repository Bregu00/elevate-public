local resourceName = GetCurrentResourceName()

Config = {}

Config.Debug = true

Config.App = {
    name = "boss_menu",
    label = "Boss Menu",
    resource = resourceName,
    icon = resourceName..'/icon.png',
    isEnabled = function()
        local xPlayer = ESX.GetPlayerData()
        if xPlayer.job.isgang then
            return false
        end

        if not (xPlayer.job.name == "unemployed") then
            return true
        end

        return false
    end
}