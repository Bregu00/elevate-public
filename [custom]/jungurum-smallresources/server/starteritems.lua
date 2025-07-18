AddEventHandler('esx:playerLoaded', function(source, xPlayer, isNew)
    if isNew then
        Wait(250)
        for i = 1, #Config.starterItems do
            local item = Config.starterItems[i].name
            local amount = Config.starterItems[i].amount
            exports.ox_inventory:AddItem(source, item, amount)
        end
        exports['jsfour-idcard']:CreateMetaLicense(source, 'id')
    end
end)



AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steamID = nil

    for _, id in pairs(identifiers) do
        if string.find(id, "steam:") then
            steamID = id
            break
        end
    end

    if not steamID then
        deferrals.defer()
        deferrals.update("Steam er ikke åbent! Åbn Steam og prøv igen.")
        Citizen.Wait(7000) 
        deferrals.done("Du skal have Steam åbent for at spille på serveren.")
    else
        deferrals.done()
    end
end)