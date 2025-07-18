local netids = {}

lib.callback.register("elevate-oxyHeist:server:startOxy", function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    print(json.encode(Config.Locations))
    if #Config.Locations == 0 then
        return false, "Der er ingen ledige steder at starte en oxy mission."
    end
    if not xPlayer.job.isgang then
        return false, "Du skal være bandemedlem for at starte denne mission."
    end
    local locationsint = math.random(1, #Config.Locations)
    local localConfig = Config.Locations[locationsint]
    local guardType = math.random(1, #Config.GuardPeds)
    Config.Locations[locationsint] = nil
    local int = 1
    for i = 1, #Config.Locations do
        if Config.Locations[i] then
            Config.Locations[int] = Config.Locations[i]
            int = int + 1
        end
    end
    for i = int, #Config.Locations do
        Config.Locations[i] = nil
    end
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)
    local teamMembers = isInTeam and exports['st_teams']:getTeamFromSource(src).getAllMembers() or { { source = src } }
    local inArea, spawned = false, false
    exports['jungurum-lib']:addBlipWithRoute(src, {
        blipTable = 'oxyMission',
        coords = localConfig.boatCoords.coords.xyz,
        color = 24,
        sprite = 427,
        scale = 1.0
    })
    CreateThread(function()
        while not inArea do
            for i = 1, #teamMembers do
                local playerCoords = GetEntityCoords(GetPlayerPed(teamMembers[i].source))
                local distance = #(playerCoords - localConfig.boatCoords.coords.xyz)
                
                if distance < 250 then
                    if not spawned then
                        spawned = true
                        TriggerClientEvent('elevate-oxyHeist:client:createGuards', teamMembers[i].source, localConfig.guardCoords, localConfig, guardType)
                    end
                    if distance < 50 then
                        inArea = true
                        exports['jungurum-lib']:removeBlips(teamMembers[i].source, 'oxyMission')
                    end
                end
            end
            Wait(2500)
        end
    end)
    return true, "Mission started"
end)
-- RegisterNetEvent('elevate-oxyHeist:server:startOxy', function()
--     local src = source
--     local xPlayer = ESX.GetPlayerFromId(src)
--     if #Config.Locations == 0 then
--         TriggerClientEvent('ox_lib:notify', src, {title = "Der er ingen ledige steder at starte en oxy mission.", type = "error"})
--         return false
--     end
--     if xPlayer.job.isgang then
--         local locationsint = math.random(1, #Config.Locations)
--         local localConfig = Config.Locations[locationsint]
--         local guardType = math.random(1, #Config.GuardPeds)
--         Config.Locations[locationsint] = nil
--         local isInTeam = exports['st_teams']:IsPlayerInTeam(src)
--         local teamMembers = isInTeam and exports['st_teams']:getTeamFromSource(src).getAllMembers() or { { source = src } }
--         local inArea, spawned = false, false
--         exports['jungurum-lib']:addBlipWithRoute(src, {
--             blipTable = 'oxyMission',
--             coords = localConfig.boatCoords.coords.xyz,
--             color = 24,
--             sprite = 427,
--             scale = 1.0
--         })
--         while not inArea do
--             for i = 1, #teamMembers do
--                 local playerCoords = GetEntityCoords(GetPlayerPed(teamMembers[i].source))
--                 local distance = #(playerCoords - localConfig.boatCoords.coords.xyz)
                
--                 if distance < 250 then
--                     if not spawned then
--                         spawned = true
--                         TriggerClientEvent('elevate-oxyHeist:client:createGuards', teamMembers[i].source, localConfig.guardCoords, localConfig, guardType)
--                     end
--                     if distance < 50 then
--                         inArea = true
--                         exports['jungurum-lib']:removeBlips(teamMembers[i].source, 'oxyMission')
--                     end
--                 end
--             end
--         Wait(2500)
--     end
--     else
--         TriggerClientEvent('ox_lib:notify', src, {title = "Du skal være leder af banden for at starte denne mission.", type = "error"})
--     end
-- end)


RegisterNetEvent('elevate-oxyHeist:server:sellOxy', function(netid)
    local src = source
    if netids[netid] then return end
    netids[netid] = true
    local ent = NetworkGetEntityFromNetworkId(netid)
    local state = Entity(ent).state
    if not state.isSeller then return end
    if not DoesEntityExist(ent) then return end
    local count = exports.ox_inventory:GetItemCount(src, "oxy")
    if count < 0 then return end
    local success, response = exports.ox_inventory:RemoveItem(src, "oxy", count)
    if not success then return end
    local success2, response2 = exports.ox_inventory:AddItem(src, "black_money", Config.OxyPrice * count)
    if not success2 then return end
    exports['onl_logsender']:SendLog(src, "Har solgt " .. count .. " Oxy piller og modtaget " .. Config.OxyPrice * count .. " Sorte penge", {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = false,
        },
        discordTitle = "Har solgt " .. count .. " Oxy piller og modtaget " .. Config.OxyPrice * count .. " Sorte penge",
        discordWebhook = "https://discord.com/api/webhooks/1350250799153807360/3R4p_6FQD4h-kfgANabjHbtO9iaLRSRV34kDTD1_xp97nyleDss6o3fZo7MJyYkanIgu?thread_id=1350250544643440732"
    })
    state:set("isSeller", false, true)
end)

RegisterNetEvent('elevate-oxyHeist:server:npcLootReward', function(netid)
    local src = source
    if netids[netid] then return end
    netids[netid] = true
    local ent = NetworkGetEntityFromNetworkId(netid)
    local state = Entity(ent).state
    if not state.oxylootable then return end
    if not DoesEntityExist(ent) then return end
    local count = math.random(10, 30)
    if exports.ox_inventory:AddItem(src, "oxy", count) then
        exports['onl_logsender']:SendLog(src, "Har looted " .. count .. " oxy piller fra en npc på oxyHeist", {
            labels = {
                job = "logs",
                discordId = true,
                steamId = true,
                license = true,
                playerJob = true,
                jobGrade = true,
                playerName = true,
                screenshot = false,
                money = true,
                black_money = true,
                bank = true,
                coords = true,
                radio = false,
            },
            discordTitle = "Har looted " .. count .. " oxy piller fra en npc på oxyHeist",
            discordWebhook = "https://discord.com/api/webhooks/1350250799153807360/3R4p_6FQD4h-kfgANabjHbtO9iaLRSRV34kDTD1_xp97nyleDss6o3fZo7MJyYkanIgu?thread_id=1350250544643440732"
        })
        state:set("oxylootable", false, true)
    end
end)

