local function Notify(title, message, type, duration)
    if Config.oxOptions.Notify then
        lib.notify({ title = title or '', description = message or '', type = type or 'inform', duration = duration or 5000 })
    elseif Config.Framework == 'esx' then
        Core.ShowNotification(message or '')
    elseif Config.Framework == 'qb' then
        Core.Functions.Notify(message or '', type or 'info', duration or 5000)
    elseif Config.Framework == 'qbx' then
        exports['qbx_core']:Notify(message or '', type or 'inform', duration or 5000)
    elseif not Config.Framework then
        -- ADD YOUR OWN NOTIFICATION SYSTEM HERE
        print('ERROR: This server does not have a supported notification system.')
    end
end

exports('Notify', Notify)
RegisterNetEvent('mani-bridge:notify', Notify)