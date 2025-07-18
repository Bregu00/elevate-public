local metadata, charIds = {}, {}

CreateThread(function()
    MySQL.prepare([[
        CREATE TABLE IF NOT EXISTS `mani_metadata` (
            `identifier` varchar(255) NOT NULL UNIQUE,
            `metadata` longtext NOT NULL,
            PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    Wait(500)

    MySQL.prepare([[
        SELECT * FROM `mani_metadata`;
    ]], {}, function(result)
        if result and next(result) then
            for i = 1, #result do
                metadata[result[i].identifier] = json.decode(result[i].metadata)
            end
        end
    end)

    Wait(500)

    if Config.Framework == 'esx' then
        RegisterNetEvent('esx:playerLoaded', function(src, xPlayer)
            local charId = xPlayer.getIdentifier()
            charIds[src] = charId
            metadata[charId] = metadata[charId] or {}
        end) 
    elseif Config.Framework == 'qb' or Config.Framework == 'qbx' then
        RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(src)
            local charId = GetPlayer(src).PlayerData.citizenid
            charIds[src] = charId
            metadata[charId] = metadata[charId] or {}
        end)
    end
end)

local function setMetaData(src, metaName, metaData)
    local charId = charIds[src]
    if not charId then return end
    metadata[charId][metaName] = metaData
end

exports('setMetaData', setMetaData)

local function addMetaData(src, metaName, amount)
    local charId = charIds[src]
    if not charId then return end
    metadata[charId][metaName] = metadata[charId][metaName] or 0
    metadata[charId][metaName] = metadata[charId][metaName] + amount
end

exports('addMetaData', addMetaData)

local function getMetaData(src, metaName, type)
    local charId = charIds[src]
    if not metadata[charId][metaName] then metadata[charId][metaName] = type == 'int' and 0 or type == 'string' and '' or type == 'table' and {} end
    return metadata[charId][metaName]
end

exports('getMetaData', getMetaData)

lib.callback.register('mani-bridge:server:getMetaData', function(src, metaName, type)
    return getMetaData(src, metaName, type)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local identifier = charIds[src]
    if not identifier then return end

    Wait(250) -- Waiting just in case other scripts are saving metadata when the player drops

    MySQL.Async.execute('REPLACE INTO `mani_metadata` (`identifier`, `metadata`) VALUES (@identifier, @metadata)', {
        ['@identifier'] = identifier,
        ['@metadata'] = json.encode(metadata[identifier]) or {},
    })
    lib.print.info('Metadata successfully saved on player: ' .. src)
end)