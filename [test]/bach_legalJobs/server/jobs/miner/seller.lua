local minerConfig = lib.load("shared.jobs.miner")

RegisterNetEvent("bach_legalJobs:sellItem", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then 
        return 
    end

    if not minerConfig["sellPrices"] then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Der opstod en fejl under salget. Kontakt venligst en administrator.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end
    
    if not minerConfig["sellPrices"][data.item] then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Dette item kan ikke sælges her.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end

    local item = exports.ox_inventory:GetItem(src, data.item, nil, true)
    
    if not item or item <= 0 then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Du har ikke " .. (data.label or data.item) .. " at sælge.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end

    TriggerClientEvent("bach_legalJobs:promptQuantity", src, {
        item = data.item,
        price = data.price,
        label = data.label,
        max = item,
        location = data.location
    })
end)

lib.callback.register("bach_legalJobs:confirmSale", function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end

    local quantity = tonumber(data.quantity)
    if not quantity or quantity <= 0 then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Ugyldig mængde angivet.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end

    local item = exports.ox_inventory:GetItem(src, data.item, nil, true)
    if not item or item < quantity then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Du har ikke nok " .. (data.label or data.item) .. " at sælge.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end

    local totalPrice = data.price * quantity

    if exports.ox_inventory:RemoveItem(src, data.item, quantity) then
        xPlayer.addMoney(totalPrice)
        
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Salg gennemført",
            description = "Du solgte " .. quantity .. "x " .. (data.label or data.item) .. " for " .. totalPrice .. ",-",
            type = "success",
            icon = "fas fa-dollar-sign",
        })
    else
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Der opstod et problem ved salget.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
    end
end)

lib.callback.register("bach_legalJobs:sellAllItems", function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if not minerConfig["sellPrices"] then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Der opstod en fejl under salget. Kontakt venligst en administrator.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end
    
    local totalEarned = 0
    local itemsSold = {}
    local premium = data.premium

    local inventory = exports.ox_inventory:GetInventoryItems(src)
    
    if not inventory then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Kunne ikke hente dit inventar.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
        return
    end

    for _, item in pairs(inventory) do
        local basePrice = minerConfig["sellPrices"][item.name]

        if basePrice and item.count > 0 then
            local price = basePrice

            if premium and minerConfig["premiumMultiplier"] and minerConfig["premiumMultiplier"][item.name] then
                price = math.floor(basePrice * minerConfig["premiumMultiplier"][item.name])
            end

            local saleAmount = price * item.count
            totalEarned = totalEarned + saleAmount

            table.insert(itemsSold, {
                name = item.label,
                count = item.count,
                price = saleAmount
            })

            exports.ox_inventory:RemoveItem(src, item.name, item.count)
        end
    end

    if totalEarned > 0 then
        xPlayer.addMoney(totalEarned)
        
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Bulk salg gennemført",
            description = "Du solgte flere materialer for i alt " .. totalEarned .. ",-",
            type = "success",
            icon = "fas fa-dollar-sign",
        })
    else
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Du har ingen sælgbare materialer.",
            type = "error",
            icon = "fas fa-dollar-sign",
        })
    end
end)

lib.callback.register("bach_legalJobs:getInventoryItem", function(source, itemName)
    return exports.ox_inventory:GetItem(source, itemName, nil, true)
end) 