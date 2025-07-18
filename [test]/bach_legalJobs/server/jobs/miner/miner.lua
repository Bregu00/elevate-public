local minerConfig = lib.load("shared.jobs.miner")

exports.ox_inventory:RegisterShop("miner_shop", {
    name = minerConfig["shopLocation"].name,
    inventory = minerConfig["shopLocation"].inventory,
    locations = minerConfig["shopLocation"].locations,
    groups = {
        miner = 0,
    },
})

lib.callback.register("bach_legalJobs:giveMinedItems", function(source, totalReward)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then

        return false
    end

    for item, count in pairs(totalReward) do
        if item and count and count > 0 then
            xPlayer.addInventoryItem(item, count)
        end
    end

    return true
end)

lib.callback.register("bach_legalJobs:damageTool", function(source, tool)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if tool == "pickaxe" then
        xPlayer.removeInventoryItem("pickaxe", 1)
    end

    if tool == "hammer" then
        xPlayer.removeInventoryItem("hammer", 1)
    end

    return true
end)
