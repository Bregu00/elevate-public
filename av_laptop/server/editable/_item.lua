-- Triggered when u use item laptop
function useLaptop(source,item,info)
    local src = source
    local identifier = getIdentifier(src)
    local metadata, slot = getMetadata(item, info)
    metadata = metadata or {}
    slot = slot or 1
    dbug("^3[DEBUG]:^7 ".."open laptop", json.encode(metadata))
    if metadata and not metadata['serial'] then
        local info = {}
        local serial = lib.string.random('..............')
        info['serial'] = serial
        dbug("^3[DEBUG]:^7 ".."durability: ", metadata['durability'])
        info['durability'] = metadata['durability'] or 100
        info['password'] = false
        if info['durability'] > 100 then
            dbug("^3[DEBUG]:^7 ".."more than 100")
            info['durability'] = 100
        end
        allDevices[serial] = os.time()
        setItemMetadata(src, Config.LaptopItem, slot, info)
        TriggerClientEvent("av_laptop:openUI", src, info, slot, true)
    else
        if metadata['serial'] == identifier then
            metadata['serial'] = lib.string.random('..............')
            setItemMetadata(src, Config.LaptopItem, slot, metadata)
        end
        allDevices[metadata['serial']] = os.time()
        TriggerClientEvent("av_laptop:openUI", src, metadata, slot, true)
    end
end

-- Triggered when item is used on ox_inv
AddEventHandler('ox_inventory:usedItem', function(playerId, name, slotId, metadata) 
    if name == Config.LaptopItem then
        local identifier = getIdentifier(playerId)
        local slot = slotId
        metadata = metadata or {}
        if metadata and not metadata['serial'] then
            local info = {}
            local serial = lib.string.random('..............')
            info['serial'] = serial
            dbug("^3[DEBUG]:^7 ".."durability: ", metadata['durability'])
            info['durability'] = metadata['durability'] or 100
            info['password'] = false
            if info['durability'] > 100 then
                dbug("^3[DEBUG]:^7 ".."more than 100")
                info['durability'] = 100
            end
            allDevices[serial] = os.time()
            setItemMetadata(playerId, Config.LaptopItem, slot, info)
            TriggerClientEvent("av_laptop:openUI", playerId, info, slot, true)
        else
            if metadata['serial'] == identifier then
                metadata['serial'] = lib.string.random('..............')
                setItemMetadata(playerId, Config.LaptopItem, slot, metadata)
            end
            allDevices[metadata['serial']] = os.time()
            TriggerClientEvent("av_laptop:openUI", playerId, metadata, slot, true)
        end
    end
end)