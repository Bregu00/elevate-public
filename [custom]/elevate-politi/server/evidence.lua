lib.callback.register('elevate-politi:server:verifyStash', function(source, id)
    local invId = Config.EvidenceOptions['InventoryPrefix'] .. id
    if not exports.ox_inventory:GetInventory(invId, false) then
        exports['ox_inventory']:RegisterStash(invId, Config.EvidenceOptions['Label'], 100, 5000000)
    end
    return true
end)