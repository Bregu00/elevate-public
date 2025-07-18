local Config = lib.load('shared/config')

RegisterNetEvent('mani-radio:server:updateMetadata', function(slot, data)
    local src = source
    local channel = tonumber(data.channel)
    local previousChannels = data.previousChannels
    local isPowered = data.isPowered
    local item = exports['ox_inventory']:GetSlot(src, slot)
    exports['ox_inventory']:SetMetadata(src, slot, { description = 'Radio Channel: ' .. channel, channel = channel, isPowered = isPowered, previousChannels = previousChannels })
end)

lib.callback.register('mani-radio:server:getMetaData', function(source, slot)
    local src = source
    local item = exports['ox_inventory']:GetSlot(src, slot)
    if item.name ~= Config.RadioItem then return false end
    return item.metadata -- example -> { channel = 14.26, isPowered = true, previousChannels = { { value = 14.26, label = 'Ch 14.26' }, { value = 92.26, label = 'Ch 92.26' } }
end)

CreateThread(function()
    if Config.Framework == 'qb' then -- QB Is weird
        RegisterNetEvent('hospital:server:SetLaststandStatus', function(isDead)
            TriggerClientEvent('mani-radio:client:onPlayerDeath', source, isDead)
        end)
    end
end)