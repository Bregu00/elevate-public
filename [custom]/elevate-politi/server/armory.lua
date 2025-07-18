local webhook = "https://discord.com/api/webhooks/1355314787575402607/Mwe8mCDYVEyIl5oBW5eFaUYdXmY9LQlOHkhrBosIpNZ3pOC4xi1pwPlns4gbUEiwKTRm"

ESX.RegisterServerCallback("jungurum_polLocker:server:getAllLoadouts", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Identifier = xPlayer.getIdentifier()
    local loadouts = {}
    MySQL.Async.fetchAll("SELECT * FROM policeloadouts WHERE `char` = ?", {Identifier}, function(results)
        if results and #results > 0 then
            for k, v in pairs(results) do
                calculatePrice(function(totalPrice)
                    table.insert(loadouts, {
                        id = v.id,
                        name = v.name,
                        char = v.char,
                        data = json.decode(v.data),
                        totalPrice = totalPrice
                    })
                end, v.data)
            end
            cb(loadouts)
        else
            cb(false)
        end
    end)
end)

function calculatePrice(cb, items)
    local totalPrice = 0
    local newItems = json.decode(items)
    for k, v in pairs(newItems) do
        if type(v) == "table" then
            local item = v

            local itemPrice = (Config.Armory[string.lower(item.name)] and Config.Armory[string.lower(item.name)].price) or 0
            if itemPrice then
                totalPrice = totalPrice + (itemPrice * tonumber(item.count))
            else
            end
        end
    end
    return cb(totalPrice)
end

function checkIfArmory(cb, inventory)
    for k, v in pairs(inventory) do
        if not Config.Armory[string.lower(v.name)] then
            return cb(false)
        end
    end
    return cb(true)
end

ESX.RegisterServerCallback("jungurum_polLocker:server:createLoadout", function(source, cb, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Identifier = xPlayer.getIdentifier()
    local inventory = exports.ox_inventory:GetInventory(src, false).items
    checkIfArmory(function(hasOnlyArmoryItems)
        if hasOnlyArmoryItems then
            MySQL.Async.insert('INSERT INTO policeloadouts (`char`, `name`, `data`) VALUES (@char, @name, @data)',{ ['char'] = Identifier, ['name'] = name, ['data'] = json.encode(inventory)}, function(insertId)
                if insertId then
                    cb(true)
                end
            end)
        else
            cb(false)
        end
    end, inventory)
end)

ESX.RegisterServerCallback("jungurum_polLocker:server:removeLoadout", function(source, cb, id)
    local src = source
    MySQL.Async.execute('DELETE FROM policeloadouts WHERE id = @id', {
        ['@id'] = id
    }, function(affectedRows)
        if affectedRows > 0 then
            cb(true)
        end
    end)
end)

ESX.RegisterServerCallback("jungurum_polLocker:server:giveLoadout", function(source, cb, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Identifier = xPlayer.getIdentifier()

    local totalCost = 0
    for k, v in pairs(data) do
        if Config.Armory[string.lower(v.name)].price then
            totalCost = totalCost + (Config.Armory[string.lower(v.name)].price * v.count)
        end
    end

    local paymentType = nil

    if xPlayer.getAccount('money').money >= totalCost then
        paymentType = 'money'
    elseif xPlayer.getAccount('bank').money >= totalCost then
        paymentType = 'bank'
    else
        return cb(false)
    end

    for k, v in pairs(data) do
        if not exports.ox_inventory:CanCarryItem(src, v.name, v.count) then return cb(false) end
        if Config.Armory[string.lower(v.name)].price then
            xPlayer.removeAccountMoney(paymentType, Config.Armory[string.lower(v.name)].price * v.count)
        end
        exports.ox_inventory:AddItem(src, v.name, v.count, v.metadata, v.slot)
    end

    cb(true)
end)

local function formatArmoryItems(items)
    local reformatted = {}
    for weapon, data in pairs(items) do
        if data.slot then
            reformatted[data.slot] = { 
                name = weapon,
                price = Config.Armory[string.lower(weapon)].price,
                currency = "auto",
                metadata = data.metadata,
            }
        end
    end

    return reformatted
end

CreateThread(function()
    local formattedArmory = formatArmoryItems(Config.Armory)
    exports.ox_inventory:RegisterShop('policeShop', {
        name = 'Politi Armory',
        inventory = formattedArmory,
        groups = {
            police = 0
        },
    })
end)

exports.ox_inventory:registerHook('buyItem', function(payload)
    if payload.shopType == 'policeShop' then
        if payload.price > 0 then
            local src = payload.source
            local xPlayer = ESX.GetPlayerFromId(src)
            local itemName = payload.itemName
            local itemPrice = payload.price
            local itemCount = payload.count
            sendToDiscord("Købt af: " .. xPlayer.getName() .. "\n**Item:** " .. itemName .. "\n**Price:** " .. itemPrice .. "\n**Count:** " .. itemCount)
        end
    end
end)

function sendToDiscord(msg)
    local content = {
        {
            ["color"] = "16711680",
            ["title"] = "Politi Armory",
            ["description"] = msg,
            ["footer"] = {
                ["text"] = "Politi log"
            }
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Politi logs", embeds = content}), { ['Content-Type'] = 'application/json' })
end
