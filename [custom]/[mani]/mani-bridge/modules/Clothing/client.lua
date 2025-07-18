local function GetSkin(includeCharacter)
    if Config.Clothing == 'rcore' then
        return exports['rcore_clothing']:getPlayerSkin(includeCharacter)
    end
end

exports('GetSkin', GetSkin)

local function SetSkin(ped, skin)
    if Config.Clothing == 'rcore' then
        exports['rcore_clothing']:setPedSkin(ped, skin)
    end
end

exports('SetSkin', SetSkin)