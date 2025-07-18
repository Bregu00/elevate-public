local resourceName = GetCurrentResourceName()

Config = {}

Config.App = {
    name = "accountclose_app",
    label = "Konto Lukning",
    app_title = "Konto Lukning",
    resource = resourceName,
    icon = resourceName..'/icon.png',
    isEnabled = function()
        local xPlayer = ESX.GetPlayerData()
        if xPlayer.job.isgang then
            return false
        end

        if (xPlayer.job.name == "police" and xPlayer.job.grade_name == "boss") or xPlayer.job.name == "retten" then
            return true
        end

        return false
    end
}
