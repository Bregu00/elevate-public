local allActions = require('config.commands').actions

local function DrawText3D(x, y, z, text, type)
    z = z + allActions[type].drawText.z
    local mainEmote = allActions[type].drawText
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.30, 0.30)
        SetTextFont(mainEmote.font or 0)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 200
        DrawRect(_x, _y + 0.0120, 0.0 + factor, mainEmote.rect, mainEmote.color.r, mainEmote.color.g, mainEmote.color.b,
            100)
    end
end

return DrawText3D
