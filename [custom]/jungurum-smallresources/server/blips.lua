local blips = {}

local function log(src, msg)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "staff",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = false,
            black_money = false,
            bank = false,
            coords = false,
            radio = false,

        },
        discordTitle = msg,
        discordWebhook = "https://discord.com/api/webhooks/1349306669980586037/pruJtbcgxnN5PpfD-Q1TwfLPNIlOeFpylRh2KS6fMUMqZ33tmG51h-gylmfJg3XtQq1D?thread_id=1349306180400320523"
    })
end

lib.callback.register('elevate_blips:getBlips', function()
    return blips
end)

lib.addCommand('opretBlip', {
    help = 'Opretter en blip',
    restricted = { 'group.mod', 'group.admin', 'group.god' }
}, function(source, args, raw)
    local blipInfo = lib.callback.await('elevate_blips:client:getBlipInput', source)
    if not blipInfo then return end
    local label = blipInfo[1]
    local logo = blipInfo[2]
    local color = blipInfo[3]
    local xPlayer = ESX.GetPlayerFromId(source)
    local coord = xPlayer.getCoords()


    local insertId = MySQL.Sync.insert([[
        INSERT INTO elevate_blips (label, logo, color, coords)
        VALUES (@label, @logo, @color, @coords)
    ]], {
        ['@label'] = label,
        ['@logo'] = logo,
        ['@color'] = color,
        ['@coords'] = json.encode({ x = coord.x, y = coord.y, z = coord.z }),
    })

    blips[#blips + 1] = {
        id = insertId,
        label = label,
        logo = logo,
        color = color,
        coord = vec3(coord.x, coord.y, coord.z)
    }

    TriggerClientEvent('elevate_blips:addBlip', -1, {
        id = insertId,
        label = label,
        logo = logo,
        color = color,
        coord = vec3(coord.x, coord.y, coord.z)
    })

    log(source, ('[%s] Oprettet Blip - %s'):format(GetPlayerName(source), label))
end)

CreateThread(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM elevate_blips")
    for i = 1, #result do
        local v = result[i]
        local coords = json.decode(v.coords)
        blips[#blips + 1] = {
            id = v.id,
            label = v.label,
            logo = v.logo,
            color = v.color,
            coord = vec3(coords.x, coords.y, coords.z)
        }
    end
end)

lib.callback.register('elevate_blips:server:removeBlip', function(source, index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not Config.adminGroups[xPlayer.group] then return end

    local blip = blips[index]
    MySQL.Sync.execute('DELETE FROM elevate_blips WHERE id = ?', { blip.id })
    table.remove(blips, index)
    TriggerClientEvent('elevate_blips:client:removeBlip', -1, index)

    log(source, ('[%s] Fjernet Blip - %s'):format(GetPlayerName(source), blip.label))
end)

lib.callback.register('elevate_blips:server:editBlip', function(source, index, input)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not Config.adminGroups[xPlayer.group] then return end

    local blip = blips[index]

    blip.label = input[1] ~= '' and input[1] or blip.label
    blip.logo = input[2] or blip.logo
    blip.color = input[3] or blip.color

    MySQL.Sync.execute([[
        UPDATE elevate_blips
        SET label = @label, logo = @logo, color = @color
        WHERE id = @id
    ]], {
        ['@label'] = blip.label,
        ['@logo'] = blip.logo,
        ['@color'] = blip.color,
        ['@id'] = blip.id
    })

    TriggerClientEvent('elevate_blips:client:editBlip', -1, index, blip)

    log(source, ('[%s] Ændrede Blip - %s'):format(GetPlayerName(source), blip.label))
end)