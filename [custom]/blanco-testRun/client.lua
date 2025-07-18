RegisterCommand("+listEntitiesMenu", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerData()
    print(xPlayer.group)
    if xPlayer.group == 'user' then
        lib.notify({
            title = "Advarsel",
            description = "Du har ikke adgang til denne kommando.",
            type = "error"
        })
        return
    end
    local entities = GetGamePool('CNetObject')
    local options = {
        {
            title = "Fjern alle?",
            description = "Fjerner alle, men bliver oprettet igen hvis et script har en thread hvor entities bliver lavet hele tiden (Dårligt for serveren).",
            onSelect = function()
                for _, entity in ipairs(entities) do
                    if DoesEntityExist(entity) then
                        DeleteEntity(entity)
                    end
                end
                lib.hideContext(true) 
            end
        }
    }

    for i, entity in ipairs(entities) do
        local x, y, z = table.unpack(GetEntityCoords(entity))
        local entityScript = GetEntityScript(entity) or "Spiller?" 
        table.insert(options, {
            title = "Entity ID: " .. entity .. ", Script: " .. entityScript,
            description = string.format("Lok.: %.2f, %.2f, %.2f", x, y, z),
            onSelect = function()
                local playerPed = GetPlayerPed(-1)
                if DoesEntityExist(entity) then 
                    DeleteEntity(entity)
                end
            end
        })
    end

    lib.registerContext({
        id = 'entityListMenu',
        title = 'Entitiess',
        options = options,
        canClose = true,
    })

    lib.showContext('entityListMenu')
end, false)