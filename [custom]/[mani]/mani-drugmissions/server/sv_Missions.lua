local drugPrice, lastActions, looted = {}, {}, {}
local kemiPrice = math.random(Config.DrugMission['kemiPrice'].min, Config.DrugMission['kemiPrice'].max)
local acWebhook = exports['elevate-confidential']:fetch('ac_webhook')
local webhook = ''

CreateThread(function()
    for i = 1, #Config.DrugMission['drugTypes'] do
        local drug = Config.DrugMission['drugTypes'][i]
        drugPrice[drug.value] = math.random(drug.price.min, drug.price.max)
    end
end)

local lootedProps, docSpawned = {}, {}

local function acBan(src, msg)
    exports['onl_logsender']:SendLog(src, msg, {
        labels = {
            job = "alerts",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = true,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = false,
        },
        discordTitle = msg,
        discordWebhook = acWebhook
    })
    exports["av_blackmarket"]:fg_BanPlayer(src, msg, true)
end

local function log(src, msg)
    exports['onl_logsender']:SendLog(src, msg, {
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
        discordTitle = msg,
        discordWebhook = webhook
    })
end

lib.callback.register('mani-drugmissions:server:getPrices', function(source)
    return drugPrice, kemiPrice
end)

lib.callback.register('mani-drugmissions:server:getMissions', function(source, drug, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local moneyAmount = drugPrice[drug] * amount
    if xPlayer.getAccount('black_money').money >= moneyAmount then
        xPlayer.removeAccountMoney("black_money", moneyAmount)
    elseif xPlayer.getAccount('money').money >= moneyAmount then
        xPlayer.removeMoney(moneyAmount)
    elseif xPlayer.getAccount('bank').money >= moneyAmount then
        if exports['fh_accountclose']:isAccountLocked(source) then return false end
        xPlayer.removeAccountMoney('bank', moneyAmount)
    else
        return false
    end

    return Config.DrugMission['shootUpLocations']
end)

RegisterNetEvent('mani-drugmissions:server:setupGuardMission', function(guards, Mission)
    local src = source
    if Config.DrugMission['shootUpLocations'][Mission.index] then table.remove(Config.DrugMission['shootUpLocations'], Mission.index) end
    local pedModel = GetHashKey(Config.DrugMission.npcModels['default'])
    local keyHolderModel = GetHashKey(Config.DrugMission.npcModels['keyholder'])

    log(src, ('[%s] %s Har bestilt %sx %s'):format(src, GetPlayerName(src), Mission.amount, Mission.drug))

    local keyHolderGuard = guards[math.random(1, #guards)]

    local createdPeds = {}
    
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)
    local teamMembers = isInTeam and exports['st_teams']:getTeamFromSource(src).getAllMembers() or { { source = src } }
    local inArea, spawned = false, false

    while not inArea do
        for i = 1, #teamMembers do
            local playerCoords = GetEntityCoords(GetPlayerPed(teamMembers[i].source))
            local distance = #(playerCoords - Mission.coords.xyz)
            if distance < 250 then
                if not spawned then
                    spawned = true
                    TriggerClientEvent('mani-drugmissions:client:createGuards', teamMembers[i].source, guards, Mission)
                    for member = 1, #teamMembers do
                        local memberSrc = teamMembers[member].source
                        TriggerClientEvent('mani-drugmissions:client:syncMission', memberSrc, Mission)
                    end
                end
                if distance < 50 then
                    inArea = true
                    exports['jungurum-lib']:removeBlips(src, 'drugMission')
                end
            end
        end
        Wait(2500)
    end
end)

lib.callback.register('mani-drugmissions:server:lootGuard', function(source, guard, isKeyHolder)
    local src = source
    local givenItem = false
    local timeToDo = (Config.npcGuards['lootDuration'] - 750) / 1000

    if lastActions[src] and lastActions[src].event == 'loot' and lastActions[src].time + timeToDo > os.time() then
        local logMessage = ('[CHEAT] [%s] %s Forsøgte at spawne et køretøj med stoffer hurtigere end muligt | %s Sekundter'):format(src, GetPlayerName(src), tostring(os.time() - lastActions[src].time))
        acBan(src, logMessage)
        return
    end

    if looted[guard] then return end
    looted[guard] = true
    local npc = NetworkGetEntityFromNetworkId(guard)
    local state = Entity(npc).state
    if not state and state.lootable then return end
    state:set('lootable', false, true)

    if isKeyHolder then
        log(src, ('[%s] %s lootede en vagt | Modtog office_key'):format(src, GetPlayerName(src)))
        exports['ox_inventory']:AddItem(src, 'office_key', 1)
        givenItem = true
    end

    for i = 1, #Config.npcGuards['loot'] do
        local item = Config.npcGuards['loot'][i]
        local chance = math.random(1, 100)
        if chance <= item.chance then
            if type(item.amount) == 'table' then item.amount = math.random(item.amount.min, item.amount.max) end
            exports['ox_inventory']:AddItem(src, item.item, item.amount)
            log(src, ('[%s] %s lootede en vagt | Modtog %sx %s'):format(src, GetPlayerName(src), item.amount, item.item))
            givenItem = true
        end
    end

    if not givenItem then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Du fandt ingenting', type = 'error' })
    end

    lastActions[src] = { time = os.time(), event = 'loot' }
end)

-- RegisterNetEvent('mani-drugmissions:server:setupDocument', function(Mission)
--     local src = source

--     if not docSpawned[Mission.id] then
--         docSpawned[Mission.id] = true

--         local randomLocation = Mission.documentCoords[math.random(1, #Mission.documentCoords)]
    
--         local prop = CreateObject(GetHashKey('hei_prop_heist_docs_01'), randomLocation.xyz, true, true, false)
    
--         while not DoesEntityExist(prop) do
--             Wait(50)
--         end
        
--         spawnedEntities[Mission.id] = spawnedEntities[Mission.id] or {}
--         table.insert(spawnedEntities[Mission.id], prop)
    
--         SetEntityHeading(prop, randomLocation.w)
--         FreezeEntityPosition(prop, true)
    
--         local netId = NetworkGetNetworkIdFromEntity(prop)

--         TriggerClientEvent('mani-drugmissions:syncDocumentTarget', src, netId, prop, Mission)
--     end
-- end)

RegisterNetEvent('mani-drugmissions:server:collectDocument', function(netId, Mission)
    local src = source
    if lootedProps[netId] then return end
    lootedProps[netId] = true
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return end

    DeleteEntity(entity)

    local vehicleModel = GetHashKey('sultan')
    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)
    local teamMembers = isInTeam and exports['st_teams']:getTeamFromSource(src).getAllMembers() or { { source = src } }
    local inArea, spawned = false, false
    local index = math.random(1, #Config.DrugMission['stashCarLocations'])
    local randomStashLocation = Config.DrugMission['stashCarLocations'][index]
    table.remove(Config.DrugMission['stashCarLocations'], index)
    exports['jungurum-lib']:addBlipWithRoute(src, {
        blipTable = 'drugMission',
        coords = vec3(randomStashLocation.xyz),
        color = 33,
        sprite = 225,
        scale = 1.0
    })

    local timeToDo = 900

    if lastActions[src] and lastActions[src].event == 'car' and lastActions[src].time + timeToDo > os.time() then
        local logMessage = ('[CHEAT] [%s] %s Forsøgte at spawne et køretøj med stoffer hurtigere end muligt | %s Sekundter'):format(src, GetPlayerName(src), tostring(os.time() - lastActions[src].time))
        acBan(src, logMessage)
        return
    end

    lastActions[src] = { time = os.time(), event = 'car' }

    for i = 1, #teamMembers do
        TriggerClientEvent('jungurum:lib:updateTextUI', teamMembers[i].source, { text = 'Kør til lokationen', options = { icon = 'fas fa-map-marker-alt' }})
    end

    local playerPeds = {}

    while not inArea do
        for i = 1, #teamMembers do
            if not playerPeds[teamMembers[i].source] then playerPeds[teamMembers[i].source] = GetPlayerPed(teamMembers[i].source) end
            local playerCoords = GetEntityCoords(playerPeds[teamMembers[i].source])
            local distance = #(playerCoords - randomStashLocation.xyz)
            if distance < 250 then
                if not spawned then
                    spawned = true
                    local vehicle = CreateVehicle(vehicleModel, randomStashLocation.x, randomStashLocation.y, randomStashLocation.z, randomStashLocation.w, true, false)

                    while not DoesEntityExist(vehicle) do
                        Wait(25)
                    end

                    local vehicleCoords = GetEntityCoords(vehicle)

                    local plate = GetVehicleNumberPlateText(vehicle)

                    log(src, ('[%s] %s har modtaget en lokation på en stash vehicle | Modtog %sx %s'):format(src, GetPlayerName(src), Mission.amount, Mission.drug))
                    exports['ox_inventory']:AddItem("trunk" .. plate, Mission.drug, Mission.amount)
                    CreateThread(function()
                        for i = 1, #teamMembers do
                            local memberSrc = teamMembers[i].source
                            TriggerClientEvent('mani-drugmissions:spawnFlare', memberSrc, randomStashLocation, vehicleCoords)
                        end
                    end)
                end
                if distance < 50 then
                    exports['jungurum-lib']:removeBlips(src, 'drugMission')
                    exports['jungurum-lib']:hideTextUI(src)
                    inArea = true
                end
            end
        end
        Wait(2000)
    end
end)

lib.callback.register('mani-drugmissions:server:registerDocument', function(source, networkID, Mission)
    if docSpawned[Mission.id] then DeleteEntity(NetworkGetEntityFromNetworkId(networkID)) return end
    docSpawned[Mission.id] = networkID
end)

lib.callback.register('mani-drugmissions:server:verifyDocument', function(source, MissionId)
    return docSpawned[MissionId] or false
end)

RegisterNetEvent('mani-drugmissions:server:toggleLockEntrance', function(Mission)
    local src = source

    local isInTeam = exports['st_teams']:IsPlayerInTeam(src)
    
    if isInTeam then
        local team = exports['st_teams']:getTeamFromSource(src)
        local allMembers = team.getAllMembers()
        for i = 1, #allMembers do
            local memberSrc = allMembers[i].source
            TriggerClientEvent('mani-drugmissions:toggleLockEntrance', memberSrc, Mission)
        end
    else
        TriggerClientEvent('mani-drugmissions:toggleLockEntrance', src, Mission)
    end
end)



-- KEMI HEIST



lib.callback.register('mani-drugmissions:server:getKemiMissions', function(source, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local moneyAmount = kemiPrice * amount
    if xPlayer.getAccount('black_money').money >= moneyAmount then
        xPlayer.removeAccountMoney("black_money", moneyAmount)
    elseif xPlayer.getAccount('money').money >= moneyAmount then
        xPlayer.removeMoney(moneyAmount)
    elseif xPlayer.getAccount('bank').money >= moneyAmount then
        if exports['fh_accountclose']:isAccountLocked(source) then return false end
        xPlayer.removeAccountMoney('bank', moneyAmount)
    else
        return false
    end
    return Config.DrugMission['shootUpLocations']
end)