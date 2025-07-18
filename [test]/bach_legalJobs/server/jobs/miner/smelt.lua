
lib.callback.register("bach_legalJobs:smeltItems", function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return false
    end

    local hasItem = exports.ox_inventory:GetItem(src, data.input.item, nil, true)

    if not hasItem or hasItem < data.input.amount then
        TriggerClientEvent("ox_lib:notify", src, {
            description = "Du har ikke nok materialer til at smelte.",
            type = "error",
            icon = "fas fa-fire",
        })
        return false
    end

    if exports.ox_inventory:RemoveItem(src, data.input.item, data.input.amount) then
        
        if exports.ox_inventory:AddItem(src, data.output.item, data.output.amount) then
            return true
        else
            
            exports.ox_inventory:AddItem(src, data.input.item, data.input.amount)
            TriggerClientEvent("ox_lib:notify", src, {
                description = "Der var ikke plads i din inventory til de smeltede materialer.",
                type = "error",
                icon = "fas fa-fire",
            })
            return false
        end
    end

    return false
end)

lib.callback.register("bach_legalJobs:smeltItemsPartialLoss", function(source, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return false
    end

    local hasItem = exports.ox_inventory:GetItem(src, data.input.item, nil, true)

    if not hasItem or hasItem < data.input.amount then
        return false
    end

    local itemLabel = exports.ox_inventory:Items()[data.input.item].label or data.input.item

    local keepAmount = data.input.amount - data.lossAmount
    if keepAmount < 0 then
        keepAmount = 0
    end

    if exports.ox_inventory:RemoveItem(src, data.input.item, data.input.amount) then
        
        if keepAmount > 0 then
            exports.ox_inventory:AddItem(src, data.input.item, keepAmount)
        end

        TriggerClientEvent("ox_lib:notify", src, {
            description = "Du mistede " .. data.lossAmount .. "x " .. itemLabel .. " i smelteprocessen.",
            type = "error",
            icon = "fas fa-fire",
        })

        return true
    end

    return false
end)
