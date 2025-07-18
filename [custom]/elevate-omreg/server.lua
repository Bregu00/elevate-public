local webhook = "https://discord.com/api/webhooks/1362268802003505244/JszubKwiihbFkub1qId7ytmjuSo4jN-ZV0b3iHx-UTHuCJqH2COkJfU_qvZsGtYBJPG1"

local function log(title, content, fileName, playerData, targetData)
    local boundary = "----FiveMBoundary" .. os.time()

    local ped = GetPlayerPed(playerData.source)
    local coords = GetEntityCoords(ped)

    -- Embed body
    local embed = {
        title = playerData.character,
        description = ('### %s'):format(title),
        color = 5793266, -- Blue
        fields = {
            { name = "Player name", value = ('```%s```'):format(playerData.getName() or "N/A"), inline = true },
            { name = "Server ID", value = ('```%s```'):format(playerData.source or "N/A"), inline = true },
            { name = "Discord", value = ('```%s```'):format(GetPlayerIdentifierByType(playerData.source, "discord") or "N/A"), inline = true },

            { name = "Steam", value = ('```%s```'):format(GetPlayerIdentifierByType(playerData.source, "steam") or "N/A"), inline = true },
            { name = "License", value = ('```%s```'):format(GetPlayerIdentifierByType(playerData.source, "license") or "N/A"), inline = true },
            { name = "Job", value = ('```%s```'):format(playerData.getJob().name or "Unemployed"), inline = true },

            { name = "Grade", value = ('```%s```'):format(tostring(playerData.getJob().grade or "N/A")), inline = true },
            { name = "Character", value = ('```%s```'):format(playerData.getName() or "N/A"), inline = true },
            { name = "Cash", value = ('```%s```'):format(ESX.Math.GroupDigits(playerData.getMoney() or 0)), inline = true },

            { name = "Bank", value = ('```%s```'):format(ESX.Math.GroupDigits(playerData.getAccount('bank').money or 0)), inline = true },
            { name = "Black Money", value = ('```%s```'):format(ESX.Math.GroupDigits(playerData.getAccount('black_money').money or 0)), inline = true },
            { name = "Coords", value = ('```%s```'):format(string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z) or "Unknown"), inline = true },
        },
        footer = {
            text = "🕒 Logged at " .. os.date("!%Y-%m-%d %H:%M:%S UTC") .. " • Today at " .. os.date("%H:%M"),
        }
    }

    local payload = json.encode({
        embeds = { embed },
        username = "Elevate Omreg",
        avatar_url = "https://files.fivemerr.com/images/38f43d70-39b6-432f-8bd7-3f65557e5833.png"
    })

    local body = ""
    -- Payload
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. 'Content-Disposition: form-data; name="payload_json"\r\n\r\n'
    body = body .. payload .. "\r\n"

    -- File
    body = body .. "--" .. boundary .. "\r\n"
    body = body .. 'Content-Disposition: form-data; name="file"; filename="' .. fileName .. '"\r\n'
    body = body .. "Content-Type: text/plain\r\n\r\n"
    body = body .. content .. "\r\n"
    body = body .. "--" .. boundary .. "--"

    PerformHttpRequest(webhook, function(err, text, headers)
        if err ~= 204 then
            print("[Log] Failed to upload embed. Status: " .. tostring(err))
        end
    end, "POST", body, {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary
    })
end

lib.callback.register('elevate-omreg:server:transferVehicle', function(src, vehiclePlate, modelHash, targetSrc)
    local dbVehicle = MySQL.query.await('SELECT `owner`, `leased` FROM `owned_vehicles` WHERE `plate` = ?', {
        vehiclePlate
    })

    if exports["fh_accountclose"]:isAccountLocked(targetSrc, true) then return false, "Personens konto er låst." end
    if exports["fh_accountclose"]:isAccountLocked(src, true) then return false, "Din konto er låst." end
    -- if exports["fh_accountclose"]:isAccountLocked(recipient, true) then return false, "Din konto er låst. Domstolen har lukket din konto." end

    if not next(dbVehicle) then return false, 'Dette køretøj er meldt stjålet' end
    local vehicle = dbVehicle[1]
    if vehicle.leased and vehicle.leased ~= 0 then return false, 'Dette køretøj er leased' end
    local xPlayer = ESX.GetPlayerFromId(src)
    if vehicle.owner ~= xPlayer.getIdentifier() then return false, 'Dette er ikke dit køretøj' end
    local vehData = exports['jungurum-lib']:getVehicleFromHash(modelHash)
    if not vehData then return false, 'Dette køretøj eksisterer ikke.' end
    local xTarget = ESX.GetPlayerFromId(targetSrc)
    if not xTarget then return false, 'Personen du forsøger at sælge til er ikke tilstede' end
    local price = math.floor(vehData.price * Config.transferPercentage / 100)
    if xTarget.getAccount('bank').money < price then return false, "Personen havde ikke " .. ESX.Math.GroupDigits(price) .. "DKK" end
    local alert = lib.callback.await('elevate-omreg:client:openAlert', targetSrc, "Vil du modtage: " .. vehData.model .. " | " .. vehiclePlate .. " for et gebyr på " .. ESX.Math.GroupDigits(price) .. "DKK", nil, true, true)
    if not alert then return false, "Personen ønskede ikke at modtag denne bil." end

    MySQL.update.await('UPDATE owned_vehicles SET owner = ? WHERE plate = ?', {
        xTarget.getIdentifier(),
        vehiclePlate
    })

    xTarget.removeAccountMoney("bank", price)

    TriggerClientEvent('ox_lib:notify', targetSrc, {title = "Du har lige modtaget en bil og betalt " .. ESX.Math.GroupDigits(price) .. "DKK i omregistrering", duration = 10000})

    local trunk = exports['ox_inventory']:GetInventoryItems(('trunk%s'):format(vehiclePlate), false)
    local glove = exports['ox_inventory']:GetInventoryItems(('glove%s'):format(vehiclePlate), false)
    local trunk = not next(trunk) and 'empty' or trunk
    local glove = not next(glove) and 'empty' or glove

    log(('[%s - %s] Transfered a vehicle to [%s - %s]'):format(GetPlayerName(src), src, GetPlayerName(targetSrc), targetSrc), ('Trunk: %s\nGlove: %s'):format(json.encode(trunk), json.encode(glove)), ('%s | %s.txt'):format(vehData.model, vehiclePlate), xPlayer, xTarget)
    
    return true, "Køretøjet er blevet omregistreret til " .. xTarget.getName()
end)