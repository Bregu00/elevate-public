local blips = {}

local function createBlip(data)
    local blip = AddBlipForCoord(data.coord.xyz)
    SetBlipSprite(blip, data.logo)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.5)
    SetBlipColour(blip, data.color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.label)
    EndTextCommandSetBlipName(blip)
    return blip
end

RegisterNetEvent('elevate_blips:addBlip', function(data)
    local blip = createBlip(data)
    data.blip = blip
    table.insert(blips, data)
end)

RegisterNetEvent('elevate_blips:client:removeBlip', function(index)
    local blip = blips[index]
    RemoveBlip(blip.blip)
    table.remove(blips, index)
end)

RegisterNetEvent('elevate_blips:client:editBlip', function(index, blip)
    local clBlip = blips[index]
    clBlip.label = blip.label
    clBlip.logo = blip.logo
    clBlip.color = blip.color
    SetBlipSprite(clBlip.blip, blip.logo)
    SetBlipColour(clBlip.blip, blip.color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.label)
    EndTextCommandSetBlipName(clBlip.blip)
end)

CreateThread(function()
    blips = lib.callback.await('elevate_blips:getBlips', false)
    for i = 1, #blips do
        blips[i].blip = createBlip(blips[i])
    end
end)

lib.callback.register('elevate_blips:client:getBlipInput', function()
    return lib.inputDialog('Blip Detaljer', {
        {type = 'input', label = 'Label', description = 'Label for blip', required = true, min = 1, max = 16},
        {type = 'number', label = 'Logo', description = 'Logo for blip', icon = 'hashtag', required = true},
        {type = 'number', label = 'Farve', description = 'Farve for blip', icon = 'hashtag', required = true},
    })
end)

local function manageBlip(index)
    local blip = blips[index]
    local options = {
        {
            title = 'Fjern Blip',
            description = blip.label,
            icon = 'fa-solid fa-location-pin',
            onSelect = function()
                lib.callback.await('elevate_blips:server:removeBlip', false, index)
            end
        },
        {
            title = 'Ændre Blip',
            description = blip.label,
            icon = 'fa-solid fa-location-pin',
            onSelect = function()
                local input = lib.inputDialog('Blip Detaljer', {
                    {type = 'input', label = 'Label', description = 'Label for blip', min = 1, max = 16},
                    {type = 'number', label = 'Logo', description = 'Logo for blip', icon = 'hashtag'},
                    {type = 'number', label = 'Farve', description = 'Farve for blip', icon = 'hashtag'},
                })
                if not input then return end
                lib.callback.await('elevate_blips:server:editBlip', false, index, input)
            end
        },
    }

    lib.registerContext({
        id = 'admin_blips_manage',
        title = 'Elevate Blips - Manage',
        menu = 'admin_blips_manage',
        options = options
    })

    lib.showContext('admin_blips_manage')
end

RegisterCommand('admin:blips', function(source, args, raw)
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer then return end
    if not Config.adminGroups[xPlayer.group] then return end

    local options = {}

    for i = 1, #blips do
        local coords = blips[i].coord
        local zone = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
        options[i] = {
            title = blips[i].label,
            description = ('Manage Blip - %s'):format(zone),
            icon = 'fa-solid fa-location-pin',
            onSelect = function()
                manageBlip(i)
            end
        }
    end

    lib.registerContext({
        id = 'admin_blips',
        title = 'Elevate Blips',
        menu = 'admin_blips',
        options = options
    })

    lib.showContext('admin_blips')
end, false)