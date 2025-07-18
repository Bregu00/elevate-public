lib.callback.register("ND_Police:server:addPropItem", function(source, item, netid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer.job.name == "police" then
        lib.notify({
            title = "Info",
            description = "Du skal være ansat i politiet for at samle dette op.",
            type = "error"
        })
        return false
    end

    local entity = NetworkGetEntityFromNetworkId(netid)
    DeleteEntity(entity)
    local succes = exports.ox_inventory:AddItem(src, item, 1)
    return succes
end)

lib.callback.register("ND_Police:server:removePropItem", function(source, item)
    local src = source
    local succes = exports.ox_inventory:RemoveItem(src, item, 1)
    return succes
end)