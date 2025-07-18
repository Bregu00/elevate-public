Config = Config or {}
Config.GiveItems = false -- Give starter items (or not)
Config.StarterItems = { -- Character starting items
    {
        name = 'phone',
        amount = 1
    },
    {
        name = 'id_card',
        amount = 1,
        metadata = function(source)
            local info = {}
            if Config.Framework == "qbox" and GetResourceState('qbx_idcard') == "started" then
                info = exports.qbx_idcard:GetMetaLicense(source, {'id_card'})
            end
            if Config.Framework == "qb" and Core then
                local Player = Core.Functions.GetPlayer(source)
                if Player and Player.PlayerData then
                    info.citizenid = Player.PlayerData.citizenid
                    info.firstname = Player.PlayerData.charinfo.firstname
                    info.lastname = Player.PlayerData.charinfo.lastname
                    info.birthdate = Player.PlayerData.charinfo.birthdate
                    info.gender = Player.PlayerData.charinfo.gender
                    info.nationality = Player.PlayerData.charinfo.nationality
                end
            end
            return info
        end
    },
    {
        name = 'driver_license',
        amount = 1,
        metadata = function(source)
            local info = {}
            if Config.Framework == "qbox" and GetResourceState('qbx_idcard') == "started" then
                info = exports.qbx_idcard:GetMetaLicense(source, {'driver_license'})
            end
            if Config.Framework == "qb" then
                local Player = Core.Functions.GetPlayer(source)
                if Player and Player.PlayerData then
                    info.firstname = Player.PlayerData.charinfo.firstname
                    info.lastname = Player.PlayerData.charinfo.lastname
                    info.birthdate = Player.PlayerData.charinfo.birthdate
                end
            end
            return info
        end
    },
}