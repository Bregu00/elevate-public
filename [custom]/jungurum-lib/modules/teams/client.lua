local blips = {}

local function createBlip(coords, label, color, sprite)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- blipSettings = {
--     blipTable = drugMission,
--     coords = vec3(0, 0, 0),
--     color = 32,
--     sprite = 1,
--     scale = 1.0
-- }

RegisterNetEvent('jungurum-lib:addBlipWithRoute', function(blipSettings)
    local blip = createBlip(blipSettings.coords.xyz, blipSettings.label, blipSettings.color, blipSettings.sprite)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, blipSettings.color)
    SetBlipScale(blip, blipSettings.scale)
    if not blips[blipSettings.blipTable] then
        blips[blipSettings.blipTable] = {}
    end
    table.insert(blips[blipSettings.blipTable], blip)
end)

RegisterNetEvent('jungurum-lib:removeBlips', function(blipTable)
    if blips[blipTable] then
        for i = 1, #blips[blipTable] do
            RemoveBlip(blips[blipTable][i])
        end
    end
end)

RegisterNetEvent('jungurum:lib:updateTextUI', function(data)
    lib.showTextUI(data.text, data.options)
end)

RegisterNetEvent('jungurum:lib:hideTextUI', function()
    lib.hideTextUI()
end)

exports('addBlipWithRoute', function(blipSettings)
    TriggerServerEvent('jungurum-lib:server:addBlipWithRoute', blipSettings)
end)

exports('removeBlips', function(blipTable)
    TriggerServerEvent('jungurum-lib:server:removeBlips', blipTable)
end)

exports('runTeamEvent', function(data)
    TriggerServerEvent('jungurum-lib:server:runTeamEvent', data)
end)

exports('updateTextUI', function(data)
    TriggerServerEvent('jungurum-lib:server:updateTextUI', data)
end)

exports('hideTextUI', function()
    TriggerServerEvent('jungurum-lib:server:hideTextUI')
end)