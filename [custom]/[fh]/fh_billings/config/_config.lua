local resourceName = GetCurrentResourceName()

Config = {}

Config.App = {
    name = "billing_app",
    label = "Faktura App",
    app_title = "Faktura",
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
