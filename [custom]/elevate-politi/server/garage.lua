RegisterNetEvent("elevate-politi:server:addItem", function(plate)
    local src = source
    for k, v in pairs(Config.TrunkItems) do
        exports['ox_inventory']:AddItem("trunk" .. plate, v.item, v.amount, v.metadata)
    end
end)