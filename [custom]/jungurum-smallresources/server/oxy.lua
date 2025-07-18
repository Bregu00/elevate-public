lib.callback.register("jungurum-smallresources:removeOxy", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.ox_inventory:RemoveItem(source, "oxy", 1)
end)

