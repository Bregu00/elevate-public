local drugPrice, kemiPrice = lib.callback.await('mani-drugmissions:server:getPrices', false)

local spawningObject = false
local doorLocks = {}

local zones = {}
local objects = {}

CreateThread(function()
    for i = 1, #Config.DrugMission['drugTypes'] do
        Config.DrugMission['drugTypes'][i].label = Config.DrugMission['drugTypes'][i].label .. ' - ' .. drugPrice[Config.DrugMission['drugTypes'][i].value] .. ' DKK'
    end
end)

local function exitOffice(Mission)
    local ped = cache.ped
    DoScreenFadeOut(500)
    Wait(500)
    FreezeEntityPosition(ped, true)

    exports['mani-bridge']:TeleportEntity(ped, Mission.entrance)

    if DoesEntityExist(Mission['Shell']) then
        DeleteEntity(Mission['Shell'])
    end

    Wait(500)
    FreezeEntityPosition(ped, false)
    Wait(500)
    DoScreenFadeIn(500)

    exports['ox_target']:removeZone(zones['exitOffice'])

    CreateThread(function()
        local playerCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - Mission.entrance.xyz)
        while distance <= 100.0 do
            Wait(100)
            playerCoords = GetEntityCoords(ped)
            distance = #(playerCoords - Mission.entrance.xyz)
        end
        
        for i = 1, #objects do
            if DoesEntityExist(objects[i]) then
                DeleteObject(objects[i])
                table.remove(objects, i)
            end
        end
    end)
end

local function createDoc(Mission, shellCoords)
    local docOffset = Config.Offsets['DocumentSpawns'][math.random(1, #Config.Offsets['DocumentSpawns'])]
    local docCoords = vec4(shellCoords.x + docOffset.x, shellCoords.y + docOffset.y, shellCoords.z + docOffset.z, docOffset.w)

    local propModel = GetHashKey('hei_prop_heist_docs_01')
    lib.requestModel(propModel)

    CreateThread(function()
        while spawningObject do Wait(100); end
        spawningObject = true

        local prop = CreateObjectNoOffset(propModel, docCoords, true, true, false)

        while not DoesEntityExist(prop) do Wait(100) end

        SetEntityHeading(prop, docCoords.w)

        while not NetworkGetEntityIsNetworked(prop) do
            NetworkRegisterEntityAsNetworked(prop);
            Wait(0);
        end

        local networkID = NetworkGetNetworkIdFromEntity(prop)
        while not NetworkDoesEntityExistWithNetworkId(networkID) do
            Wait(100);
        end

        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)

        SetEntityAsMissionEntity(prop, true, true)
        SetEntityVisible(prop, true)

        local netProp = NetworkGetEntityFromNetworkId(networkID)
        while not DoesEntityExist(netProp) do Wait(100) end
        networkID = NetworkGetNetworkIdFromEntity(netProp)

        exports['ox_target']:addEntity(networkID, {
            {
                label = 'Tag Dokument',
                icon = 'fas fa-file-alt',
                onSelect = function(entity)
                    lib.notify({ title = 'Modtaget information', type = 'info' })
                    TriggerServerEvent('mani-drugmissions:server:collectDocument', networkID, Mission)
                end,
                distance = 1.5
            },
        })

        lib.callback.await('mani-drugmissions:server:registerDocument', false, networkID, Mission)
        
        Wait(100)
        spawningObject = false
    end)

    SetModelAsNoLongerNeeded(propModel)
end

local function enterOffice(Mission)
    if not doorLocks[Mission.id] then lib.notify({ title = 'Døren er låst', type = 'error' }) return end
    local playerPed = cache.ped
    local shell = GetHashKey('mani_office_a')
    local shellCoords = vec3(Mission.entrance.x, Mission.entrance.y, Mission.entrance.z + 1000)
    local offset = Config.Offsets
    
    DoScreenFadeOut(500)
    Wait(500)
    FreezeEntityPosition(playerPed, true)

    lib.requestModel(shell)

    Mission['Shell'] = CreateObject(shell, shellCoords, false, false, false)
    FreezeEntityPosition(Mission['Shell'], true)

    local exitCoords = vec4(shellCoords.x + offset['Exit'].x, shellCoords.y + offset['Exit'].y, shellCoords.z + offset['Exit'].z, offset['Exit'].w)
    exports['mani-bridge']:TeleportEntity(playerPed, vec4(exitCoords.x, exitCoords.y, exitCoords.z - 1, exitCoords.w))

    local netId = lib.callback.await('mani-drugmissions:server:verifyDocument', false, Mission.id)
    if not netId then
        createDoc(Mission, shellCoords)
    else
        exports['ox_target']:addEntity(netId, {
            {
                label = 'Tag Dokument',
                icon = 'fas fa-file-alt',
                onSelect = function(entity)
                    lib.notify({ title = 'Modtaget information', type = 'info' })
                    TriggerServerEvent('mani-drugmissions:server:collectDocument', netId, Mission)
                end,
                distance = 1.5
            },
        })
    end

    while not DoesEntityExist(Mission['Shell']) do
        Wait(50)
    end

    FreezeEntityPosition(playerPed, false)

    Wait(500)
    DoScreenFadeIn(500)

    zones['exitOffice'] = exports['ox_target']:addBoxZone({
        coords = exitCoords.xyz,
        size = vec3(1.0, 1.0, 3.0),
        rotation = offset['Exit'].w,
        debug = Config.Debug,
        debugColour = vec4(51, 54, 92, 50.0),
        distance = 1.5,
        options = {
            {
                name = 'exitDrugMissionOffice',
                onSelect = function()
                    exitOffice(Mission)
                end,
                icon = 'fas fa-door-open',
                label = 'Udgang',
            }
        },
    })

    SetModelAsNoLongerNeeded(shell)
end

local function lootGuard(ped)
    if lib.progressBar({
        duration = Config.npcGuards['lootDuration'],
        label = 'Looter vagt',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            flag = 1,
            dict = 'amb@medic@standing@kneel@base',
            clip = 'base'
        },
    }) then
        local state = Entity(ped).state
        if not state and state.lootable then return end
        lib.callback.await('mani-drugmissions:server:lootGuard', false, PedToNet(ped), state.isKeyHolder)
    end
end

RegisterNetEvent('mani-drugmissions:toggleLockEntrance', function(Mission)
    doorLocks[Mission.id] = not doorLocks[Mission.id]
end)

local function unlockEntrance(Mission)
    TriggerServerEvent('mani-drugmissions:server:toggleLockEntrance', Mission)
end

RegisterNetEvent('mani-drugmissions:client:syncMission', function(Mission)
    CreateThread(function()
        if zones['entrance'] then
            exports['ox_target']:removeZone(zones['entrance'])
        end
    
        zones['entrance'] = exports['ox_target']:addBoxZone({
            coords = Mission.entrance.xyz,
            size = vec3(1.0, 1.0, 3.0),
            rotation = Mission.entrance.w,
            debug = Config.Debug,
            debugColour = vec4(51, 54, 92, 50.0),
            distance = 1.5,
            options = {
                {
                    name = 'enterDrugMissionOffice',
                    onSelect = function()
                        enterOffice(Mission)
                    end,
                    icon = 'fas fa-door-open',
                    label = 'Indgang',
                },
                {
                    items = 'office_key',
                    name = 'enterDrugMissionOfficeUnlock',
                    onSelect = function()
                        unlockEntrance(Mission)
                        lib.notify({ title = doorLocks[Mission.id] and 'Døren blev låst' or 'Døren blev låst op', type = 'success' })
                    end,
                    icon = 'fa-solid fa-lock-open',
                    label = 'Lås op/Lås',
                },
            },
        })
    end)
end)

RegisterNetEvent('mani-drugmissions:syncDocumentTarget', function(netId, serverEntId, Mission)
    while not NetworkDoesNetworkIdExist(netId) do
        Wait(25)
    end

    local prop = NetToObj(netId)

    while not DoesEntityExist(prop) do
        Wait(25)
    end

    local zone = exports['ox_target']:addLocalEntity(prop, {
        name = 'drugMissionDocument', 
        label = 'Tag Dokument',
        icon = 'fas fa-file-alt',
        distance = 1.5,
        onSelect = function(entity)
            lib.notify({ title = 'Modtaget information', type = 'info' })
            TriggerServerEvent('mani-drugmissions:server:collectDocument', serverEntId, netId, Mission)
        end,
    })
    table.insert(zones, zone)

    lib.showTextUI('Find dokument', { icon = 'fas fa-file-alt' })
end)

RegisterNetEvent('mani-drugmissions:spawnFlare', function(coords, vehicleCoords)
    CreateThread(function()
        local ped = cache.ped
        local startTime = GetGameTimer()
        local timeout = 15 * 60 * 1000  -- 15 minutes in milliseconds
        
        while #(GetEntityCoords(ped) - vehicleCoords) > 250.0 do
            if GetGameTimer() - startTime > timeout then
                return
            end
            Wait(2000)
        end

        local waterHeight = GetWaterHeight(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        
        local flareModel = GetHashKey('prop_flare_01')
        RequestModel(flareModel)
        while not HasModelLoaded(flareModel) do
            Wait(25)
        end

        local flareProp = CreateObject(flareModel, 
            vehicleCoords.x, vehicleCoords.y, waterHeight, 
            false, false, false)

        SetEntityCollision(flareProp, false, false)
        SetEntityNoCollisionEntity(flareProp, ped, true)
        SetEntityCompletelyDisableCollision(flareProp, false, false)
        SetObjectPhysicsParams(flareProp, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        SetEntityAsMissionEntity(flareProp, true, true)
        NetworkRegisterEntityAsNetworked(flareProp)

        local particleDict = "core"
        RequestNamedPtfxAsset(particleDict)
        while not HasNamedPtfxAssetLoaded(particleDict) do
            Wait(25)
        end
        UseParticleFxAssetNextCall(particleDict)

        local ptfx = StartNetworkedParticleFxLoopedOnEntity("exp_grd_flare", flareProp, 0.0, 0.0, 0.05, 0.0, 0.0, 0.0, 1.5, false, false, false)

        UseParticleFxAssetNextCall(particleDict)
        local smokePtfx = StartNetworkedParticleFxLoopedOnEntity("proj_grenade_smoke", flareProp, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 2.5, false, false, false)
        
        Wait(timeout)
        if DoesEntityExist(flareProp) then
            StopParticleFxLooped(ptfx, 0)
            StopParticleFxLooped(smokePtfx, 0)
            DeleteObject(flareProp)
        end
    end)
end)

RegisterNetEvent('mani-drugmissions:client:createGuards', function(guards, Mission)
    AddRelationshipGroup('GUARD_GROUP')
    local guardGroup = GetHashKey('GUARD_GROUP')
    local keyHolderGuard = guards[math.random(1, #guards)]
    
    lib.requestModel(Config.DrugMission.npcModels['keyholder'])
    lib.requestModel(Config.DrugMission.npcModels['default'])

    CreateThread(function()
        for guard = 1, #guards do
            while spawningObject do Wait(100); end
            spawningObject = true

            local guard = guards[guard]
            local npc, netId = nil, nil
            local isKeyHolder = guard == keyHolderGuard
    
            if isKeyHolder then
                npc = CreatePed(26, Config.DrugMission.npcModels['keyholder'], guard.xyz, guard.w, true, true)
                while not DoesEntityExist(npc) do Wait(100) end
                GiveWeaponToPed(npc, GetHashKey('WEAPON_GUSENBERG'), 255, false, false)
            else
                npc = CreatePed(26, Config.DrugMission.npcModels['default'], guard.xyz, guard.w, true, true)
                while not DoesEntityExist(npc) do Wait(100) end
                GiveWeaponToPed(npc, GetHashKey('WEAPON_ASSAULTRIFLE'), 255, false, false)
            end

            while not NetworkGetEntityIsNetworked(npc) do
                NetworkRegisterEntityAsNetworked(npc);
                Wait(0);
            end

            local networkID = NetworkGetNetworkIdFromEntity(npc)
            while not NetworkDoesEntityExistWithNetworkId(networkID) do
                Wait(100);
            end
    
            SetNetworkIdCanMigrate(networkID, true)
            SetNetworkIdExistsOnAllMachines(networkID, true)

            SetEntityAsMissionEntity(npc, true, true)
            SetEntityVisible(npc, true)
    
            SetPedCanSwitchWeapon(npc, true)
            SetPedDropsWeaponsWhenDead(npc, false)
            SetPedFleeAttributes(npc, 0, false)

            local netPed = NetworkGetEntityFromNetworkId(networkID)
            while not DoesEntityExist(netPed) do Wait(100) end
            networkID = NetworkGetNetworkIdFromEntity(netPed)
    
            SetPedRelationshipGroupHash(npc, guardGroup)
    
            if Config.npcPresets[Mission.npcPreset] then
                Config.npcPresets[Mission.npcPreset](npc)
            end
    
            Entity(npc).state:set('lootable', true, true)
            Entity(npc).state:set('isKeyHolder', isKeyHolder, true)

            objects[#objects + 1] = npc
    
            Wait(100)
            spawningObject = false
        end

        SetModelAsNoLongerNeeded(Config.DrugMission.npcModels['keyholder'])
        SetModelAsNoLongerNeeded(Config.DrugMission.npcModels['default'])
    end)

    SetRelationshipBetweenGroups(5, guardGroup, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(0, guardGroup, guardGroup)
end)

local function startMission(drug, amount)
    local cooldowns = exports['jungurum-lib']:GetGangCooldown()
    if cooldowns and cooldowns['drugMission'] and cooldowns['drugMission'].active then return end
    local getMissions = lib.callback.await('mani-drugmissions:server:getMissions', false, drug, amount)
    if not getMissions then lib.notify({ title = 'Du har ikke penge nok', type = 'error' }) return end
    local index = math.random(1, #getMissions)
    local Mission = getMissions[index]
    exports['jungurum-lib']:SetGangCooldown('drugMission', Config.Hours(12))
    exports['jungurum-lib']:runTeamEvent({
            { event = 'mani-drugmissions:updateTextUI', args = { text = 'Kør til lokationen', options = { icon = 'fas fa-map-marker-alt' }}},
            { event = 'jungurum-lib:addBlipWithRoute', args = { blipTable = 'drugMission', coords = vec3(Mission.coords.xyz), color = 33, sprite = 514, scale = 1.0 }}
    })
    Mission['drug'] = drug
    Mission['amount'] = amount
    Mission['index'] = index
    Mission['id'] = math.random(1, 10000)
    TriggerServerEvent('mani-drugmissions:server:setupGuardMission', Mission.guardLocations, Mission)
end

function drugPopup()
    local input = lib.inputDialog('Bestil Stof', {
        {type = 'select', label = 'Vælg Stof', options = Config.DrugMission['drugTypes'], icon = 'fas fa-cannabis', required = true, searchable = true},
        {type = 'number', label = 'Mængde', default = Config.DrugMission.orderLimit.max, icon = 'fas fa-box-open', min = Config.DrugMission.orderLimit.min, max = Config.DrugMission.orderLimit.max, required = true},
    })
    if not input then return end
    local drug = input[1]
    local amount = input[2]
    startMission(drug, amount)
end


-- Kemi Mission

local function startKemiMission(amount)
    local cooldowns = exports['jungurum-lib']:GetGangCooldown()
    if cooldowns and cooldowns['kemiMission'] and cooldowns['kemiMission'].active then return end
    local getMissions = lib.callback.await('mani-drugmissions:server:getKemiMissions', false, amount)
    if not getMissions then lib.notify({ title = 'Du har ikke penge nok', type = 'error' }) return end
    local index = math.random(1, #getMissions)
    local Mission = getMissions[index]
    exports['jungurum-lib']:SetGangCooldown('kemiMission', Config.Hours(12))
    exports['jungurum-lib']:runTeamEvent({
            { event = 'mani-drugmissions:updateTextUI', args = { text = 'Kør til lokationen', options = { icon = 'fas fa-map-marker-alt' }}},
            { event = 'jungurum-lib:addBlipWithRoute', args = { blipTable = 'drugMission', coords = vec3(Mission.coords.xyz), color = 33, sprite = 514, scale = 1.0 }}
    })
    Mission['drug'] = Config.DrugMission.kemiItem
    Mission['amount'] = amount
    Mission['index'] = index
    Mission['id'] = math.random(1, 10000)
    TriggerServerEvent('mani-drugmissions:server:setupGuardMission', Mission.guardLocations, Mission)
end

function kemiPopup()
    local input = lib.inputDialog(('Bestil Kemi - %s DKK'):format(kemiPrice), {
        {type = 'number', label = 'Mængde', default = 20, icon = 'fas fa-box-open', min = Config.DrugMission['kemiAmount'].min, max = Config.DrugMission['kemiAmount'].max, required = true},
    })
    if not input then return end
    local amount = input[1]
    startKemiMission(amount)
end

CreateThread(function()
    exports['ox_target']:addGlobalPed({
        label = 'Loot Vagt',
        name = 'drugMissionGuards',
        icon = 'fas fa-search',
        distance = 1.5,
        canInteract = function(ped)
            local state = Entity(ped).state
            return state and state.lootable
        end,
        onSelect = function(data)
            lootGuard(data.entity)
        end
    })
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
	if not objects then return end
	for i = 1, #objects do
        if DoesEntityExist(objects[i]) then
            DeleteEntity(objects[i])
        end
	end
end)