local lastActions = {}

local Drugs = lib.load('sv_util')

lib.callback.register('mani-drugs:server:giveItem', function(source, item, amount, removeItems)
    local src = source
    
    if not Config.Marker[item] and not Config.Omdanner[item] then
        local logMessage = ('[%s] %s mistænkelig adfærd - Forsøgte at farme %s'):format(src, GetPlayerName(src), item)
        Drugs.AcLog(src, logMessage)
        exports["av_blackmarket"]:fg_BanPlayer(src, logMessage, true)
        return
    end

    local ConfigData = Config.Marker[item] or Config.Omdanner[item]

    if ConfigData.amount < amount then
        local logMessage = ('[%s] %s mistænkelig adfærd - Forsøgt at farme %sx %s'):format(src, GetPlayerName(src), amount, item)
        Drugs.AcLog(src, logMessage)
        exports["av_blackmarket"]:fg_BanPlayer(src, logMessage, true)
        return
    end

    local timeToDo = (ConfigData.farmTime or ConfigData.omdanTime) - 1000

    if lastActions[src] and lastActions[src].time + timeToDo / 1000 > os.time() then
        local ping = GetPlayerPing(src)
        local logMessage = ('[CHEAT] [%s] %s Forsøg på at farme/spawne %s hurtigere end muligt (Ping: %s)'):format(src, GetPlayerName(src), item, tostring(ping))
        Drugs.AcLog(src, logMessage)
        return
    end

    lastActions[src] = { item = item, time = os.time() }

    if Config.Omdanner[item] then
        for item, amount in pairs(Config.Omdanner[item].requires) do
            if not exports['ox_inventory']:RemoveItem(src, item, amount) then
                return
            end
        end
    end
    
    exports['ox_inventory']:AddItem(src, item, amount)

    return true
end)

lib.callback.register('mani-drugs:server:hasRecipe', function(src, recipe)
    for item, amount in pairs(recipe) do
        local count = exports.ox_inventory:Search(src, 'count', item)
        if count < amount then
            return false, item
        end
    end
    return true
end)