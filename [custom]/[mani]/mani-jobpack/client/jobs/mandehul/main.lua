local Job = lib.load('shared.jobs.mandehul')
local CurrentJob, nozzle, rope, busy, KeyBinds = {}, nil, nil, false, {}

local function createBlip(coords, label, sprite, scale, color, shortRange)
	local blip = AddBlipForCoord(coords.xyz)
	SetBlipSprite(blip, sprite)
	SetBlipScale (blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, shortRange)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(label)
	EndTextCommandSetBlipName(blip)

	return blip
end

local function createEntityBlip(entity, label, sprite, scale, color, shortRange)
	local blip = AddBlipForEntity(CurrentJob['Vehicle'])
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, shortRange)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(label)
	EndTextCommandSetBlipName(blip)

	return blip
end

local function TakeNozzle(vehicle)
    local ped = cache.ped
    local model = GetHashKey('mani_manhole_nozzle')
    local trunkOffset = GetOffsetFromEntityInWorldCoords(vehicle, Job['VehicleOffsets'][GetEntityModel(vehicle)])
    local dict = 'move_weapon@jerrycan@generic'
    lib.requestAnimDict(dict)
    lib.requestModel(model)
    TaskPlayAnim(ped, dict, 'idle', 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    Wait(300)
    nozzle = exports['mani-bridge']:CreateObj(model, vec4(0, 0, 0, 0))
    AttachEntityToEntity(nozzle, ped, GetPedBoneIndex(ped, 0xDEAD),
        0.18, 0.20, 0.0,
        90.0, 0.0, 0.0,
        true, true, false, true, 1, true)
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do Wait(50) end
    rope = AddRope(trunkOffset.x, trunkOffset.y, trunkOffset.z, 0.0, 0.0, 0.0, 4.0, 3, 7.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not rope do Wait(50) end
    ActivatePhysics(rope)
    Wait(50)
    local nozzlePos = GetEntityCoords(nozzle)
    nozzlePos = GetOffsetFromEntityInWorldCoords(nozzle, 0.0, 0.0, 0.28)
    AttachEntitiesToRope(rope, vehicle, nozzle, trunkOffset.x, trunkOffset.y, trunkOffset.z, nozzlePos.x, nozzlePos.y, nozzlePos.z, false, false, nil, nil)

    lib.showTextUI('[E] Placer Slange', { alignIcon = 'center', icon = 'fa-solid fa-wrench' })

    lib.callback.await('mani-mandehul:server:toggleNozzle', false, CurrentJob['VehNetID'], true)

    KeyBinds['UseNozzle']:disable(false)
end

local function ReturnNozzle(vehicle)
    DeleteEntity(nozzle)
    RopeUnloadTextures()
    DeleteRope(rope)
    ClearPedTasks(cache.ped)
    nozzle, rope = nil, nil

    KeyBinds['UseNozzle']:disable(true)

    lib.hideTextUI()

    lib.callback.await('mani-mandehul:server:toggleNozzle', false, CurrentJob['VehNetID'], false)
end

local function PickupNozzle(entity)
    local ped = cache.ped
    local dict = 'move_weapon@jerrycan@generic'
    lib.requestAnimDict(dict)
    TaskPlayAnim(ped, dict, 'idle', 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    Wait(300)
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, 0xDEAD),
        0.18, 0.20, 0.0,
        90.0, 0.0, 0.0,
        true, true, false, true, 1, true)
    
    nozzle = entity
    KeyBinds['UseNozzle']:disable(false)

    local netId = CurrentJob['VehNetID']

    lib.showTextUI('[E] Placer Slange', { alignIcon = 'center', icon = 'fa-solid fa-wrench' })

    lib.callback.await('mani-mandehul:server:updatePump', false, netId, false)
end

local function PlaceNozzle(zone)
    busy = true

    exports["mani-bridge"]:CopyCoords(GetHashKey('mani_manhole_nozzle'), 10, function(coords)
        local zoneIndex = nil
        for i = 1, #CurrentJob['Zones'] do
            if CurrentJob['Zones'][i]:contains(coords.xyz) then
                zoneIndex = i
                break
            end
        end

        if not zoneIndex then
            lib.notify({ title = 'Der er ingen kloak her', type = 'error' })
        elseif CurrentJob['Manholes'][zoneIndex].state == 'closed' then
            lib.notify({ title = 'Denne kloak er lukket', type = 'error' })
        elseif CurrentJob['Manholes'][zoneIndex].state == 'open' then
            lib.notify({ title = 'Pumpen er placeret', type = 'success' })
            local vehicle = CurrentJob['Vehicle']

            lib.callback.await('mani-mandehul:server:updatePump', false, CurrentJob['VehNetID'], true, zoneIndex)
        end

        DetachEntity(nozzle, true, true)
        FreezeEntityPosition(nozzle, true)
        exports['mani-bridge']:TeleportEntity(nozzle, coords)
        ClearPedTasks(cache.ped)

        exports['ox_target']:addLocalEntity(nozzle, {
            label = 'Tag Slange',
            name = 'vanddrift_nozzle',
            icon = 'fa-solid fa-wrench',
            distance = 2.0,
            onSelect = function(data)
                PickupNozzle(data.entity)
            end
        })

        busy, nozzle = false, nil
        KeyBinds['UseNozzle']:disable(true)

        lib.hideTextUI()
    end, function()
        busy = false

        lib.hideTextUI()
    end)
end

local function pumpLocation()
    if cache.vehicle ~= CurrentJob['Vehicle'] or lib.progressActive() or busy then return end
    busy = true
    if lib.progressBar({
        duration = 12500,
        label = 'Pumper',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then
        local vehicle = CurrentJob['Vehicle']
    
        local state = Entity(vehicle).state

        local index = state.activeManhole

        lib.callback.await('mani-mandehul:server:pumpManhole', false, index)

        lib.hideTextUI()

        lib.callback.await('mani-mandehul:server:updatePump', false, CurrentJob['VehNetID'], false)
    end
    busy = false
end

RegisterNetEvent('mani-mandehul:client:stopMission', function()
    if not next(CurrentJob) then return end

    local fixedManholes = 0

    for i = 1, #CurrentJob['Locations'] do
        RemoveBlip(CurrentJob['Blips'][i])
        CurrentJob['Zones'][i]:remove()
        if CurrentJob['Manholes'][i].state == 'fixed' then
            fixedManholes = fixedManholes + 1
        end
    end

    lib.hideTextUI()

    CurrentJob = {}
end)

RegisterNetEvent('mani-mandehul:client:pumpManhole', function(index)
    if not next(CurrentJob) then return end
    if CurrentJob['Manholes'][index].state == 'fixed' then return end
    CurrentJob['Manholes'][index].state = 'fixed'
    RemoveBlip(CurrentJob['Blips'][index])

    local fixedManholes = 0

    local playerCoords = GetEntityCoords(cache.ped)
      
    local closestManhole = nil
    local closestDistance = nil

    for i = 1, #CurrentJob['Locations'] do
        if CurrentJob['Manholes'][i].state == 'fixed' then
            fixedManholes = fixedManholes + 1
        elseif not closestDistance then
            closestDistance = #(CurrentJob['Locations'][i] - playerCoords)
            closestManhole = i
        else
            local distance = #(CurrentJob['Locations'][i] - playerCoords)
            if distance < closestDistance then
                closestDistance = distance
                closestManhole = i
            end
        end
    end

    if fixedManholes == #CurrentJob['Locations'] then
        lib.notify({ title = 'Job Færdiggjort', type = 'success' })
        SetNewWaypoint(Job['Locations']['JobLocation'].xy)
    elseif closestManhole then
        SetBlipRoute(CurrentJob['Blips'][closestManhole], true)
        SetBlipRouteColour(CurrentJob['Blips'][closestManhole], 3)
    end
end)

RegisterNetEvent('mani-mandehul:client:openManhole', function(index)
    if not next(CurrentJob) then return end
    CurrentJob['Manholes'][index].state = 'open'
end)

RegisterNetEvent('mani-mandehul:client:syncStart', function(TeamJob)
    CurrentJob = TeamJob
    local closestDistance, closestManhole = nil, nil
    local playerCoords = GetEntityCoords(cache.ped)

    CreateThread(function()
        CurrentJob['Blips'] = {}
        CurrentJob['Zones'] = {}
        CurrentJob['Manholes'] = {}
        for i = 1, #CurrentJob['Locations'] do
            CurrentJob['Blips'][i] = createBlip(CurrentJob['Locations'][i], Job['Blip']['Drift']['name'], Job['Blip']['Drift']['sprite'], Job['Blip']['Drift']['scale'], Job['Blip']['Drift']['color'])
            CurrentJob['Manholes'][i] = { state = 'closed' }
            CurrentJob['Zones'][i] = lib.zones.box({
                coords = vec3(CurrentJob['Locations'][i].x, CurrentJob['Locations'][i].y, CurrentJob['Locations'][i].z - 0.5),
                size = vec3(2, 2, 2),
                debug = Job['Debug'],
                debugColour = vec4(51, 54, 92, 50.0),
                onEnter = function()
                    if CurrentJob['Manholes'][i].state == 'closed' then
                        lib.showTextUI('[E] Åben Kloak', { alignIcon = 'center', icon = 'fa-solid fa-wrench' })
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                inside = function()
                    if IsControlJustReleased(0, 38) and CurrentJob['Manholes'][i].state == 'closed' then
                        if nozzle or lib.progressActive() or busy then return lib.notify({ title = 'Du har hænderne fyldt', type = 'error' }) end
                        if lib.progressBar({
                            duration = 5000,
                            label = 'Åbner manhole',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                            },
                            anim = {
                                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                                clip = 'machinic_loop_mechandplayer',
                                flag = 0
                            },
                        }) then
                            lib.callback.await('mani-mandehul:server:openManhole', false, i)
                            lib.hideTextUI()
                        end
                    end
                end,
            })

            if not closestDistance then
                closestDistance = #(CurrentJob['Locations'][i] - playerCoords)
                closestManhole = i
            else
                local distance = #(CurrentJob['Locations'][i] - playerCoords)
                if distance < closestDistance then
                    closestDistance = distance
                    closestManhole = i
                end
            end
        end

        while not NetworkDoesNetworkIdExist(CurrentJob['VehNetID']) do Wait(100) end
        CurrentJob['Vehicle'] = NetworkGetEntityFromNetworkId(CurrentJob['VehNetID'])

        exports['mani-keys']:GiveKey(CurrentJob['Vehicle'], true)

        exports['ox_target']:addLocalEntity(CurrentJob['Vehicle'], {
            {
                name = 'takeNozzle',
                label = 'Tag Slange',
                icon = 'fa-solid fa-wrench',
                distance = 1.5,
                canInteract = function(entity)
                    local state = Entity(entity).state
                    return state and not state.usingRope and CurrentJob['Vehicle'] == entity
                end,
                onSelect = function(data)
                    TakeNozzle(data.entity)
                end
            },
            {
                name = 'ReturnNozzle',
                label = 'Lig Slange',
                icon = 'fa-solid fa-wrench',
                distance = 1.5,
                canInteract = function(entity)
                    return nozzle and CurrentJob['Vehicle'] == entity
                end,
                onSelect = function(data)
                    ReturnNozzle(data.entity)
                end
            },
        })
    
        CurrentJob['Blips'][#CurrentJob['Blips'] + 1] = createEntityBlip(CurrentJob['Vehicle'], Job['Blip']['Vehicle']['name'], Job['Blip']['Vehicle']['sprite'], Job['Blip']['Vehicle']['scale'], Job['Blip']['Vehicle']['color'])

        SetBlipRoute(CurrentJob['Blips'][closestManhole], true)
        SetBlipRouteColour(CurrentJob['Blips'][closestManhole], 3)
    end)
end)

local function startJob(model, tier)
    CreateThread(function()
        CurrentJob['Vehicle'], CurrentJob['VehNetID'] = exports['mani-bridge']:CreateVeh(Job['Locations']['VehicleSpawn'], model, Job['Jobs'][tier]['Props'] or nil)
        CurrentJob['Tier'] = tier
        CurrentJob['Locations'] = {}

        local LocationAmount = math.random(Job['Jobs'][tier]['Locations']['min'], Job['Jobs'][tier]['Locations']['max'])
        local UsedLocations = {}
        for i = 1, LocationAmount do
            local Index = math.random(1, #Job['Locations']['Drift'])
            while UsedLocations[Index] do
                Index = math.random(1, #Job['Locations']['Drift'])
            end
            UsedLocations[Index] = true
            CurrentJob['Locations'][#CurrentJob['Locations'] + 1] = Job['Locations']['Drift'][Index]
        end

        local state = Entity(CurrentJob['Vehicle']).state
        state:set('vehLocked', false, true)

        local teamMemberAmount = lib.callback.await('mani-mandehul:server:startMission', false, CurrentJob)
        if not teamMemberAmount then
            lib.notify({ title = ('I er for mange i dit team, max (%s)'):format(Job['MaxMember']), type = 'error' })
            CurrentJob = {}
            return
        end
    end)
end

local function getLevel(playerXP)
    local level = nil
    local nextLevel = nil
    local levelXP = nil
    local nextLevelXP = nil

    for i = 1, #Job['Jobs'] do
        local v = Job['Jobs'][i]
        local nextV = Job['Jobs'][i + 1]
        if playerXP >= v['RequiredXP'] and nextV and playerXP < nextV['RequiredXP'] then
            level = i
            nextLevel = i + 1
            levelXP = playerXP - v['RequiredXP']
            nextLevelXP = nextV['RequiredXP'] - v['RequiredXP']
            break
        end
    end

    return level, nextLevel, levelXP, nextLevelXP
end

local function createMenu()
    local playerXP = lib.callback.await('mani-mandehul:server:getXP', false)
    local level, nextLevel, levelXP, nextLevelXP = getLevel(playerXP)

    local options = {
        {
            title = ('Level [%s]'):format(level or 'MAX'),
            colorScheme = 'blue.3',
            progress = not level and 100 or (levelXP / nextLevelXP) * 100,
        }
    }

    if not next(CurrentJob) then
        for i = 1, #Job['Jobs'] do
            local v = Job['Jobs'][i]
            options[#options + 1] = {
                title = v['Label'],
                description = ('%s til %s Lokationer'):format(v['Locations']['min'], v['Locations']['max']),
                icon = 'fa-solid fa-truck-droplet',
                disabled = playerXP < v['RequiredXP'],
                onSelect = function()
                    if next(CurrentJob) then lib.notify({ title = 'Du er allerede igang med et job', type = 'error' }) return end
                    startJob(v['Vehicle'], i)
                end
            }
        end
    else
        options[#options + 1] = {
            title = 'Afslut Job',
            description = 'Afslut dit job',
            icon = 'fa-solid fa-receipt',
            onSelect = function()
                lib.callback.await('mani-mandehul:server:stopMission', false, CurrentJob)
            end
        }
    end

    lib.registerContext({
        id = 'mandehul_menu',
        title = 'Mandehul Jobs',
        options = options
    })

    lib.showContext('mandehul_menu')
end

CreateThread(function()
    local bData = Job['Blip']['Job']
    createBlip(Job['Locations']['JobLocation'].xyz, bData.name, bData.sprite, bData.scale, bData.color, true)

    local pedModel = Job['PedModel']
    lib.requestModel(pedModel)
    local npc = nil
    local npcCoords = Job['Locations']['JobLocation']

    SetInterval(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - vec3(npcCoords))
        
        if distance < 150 then
            if not DoesEntityExist(npc) then
                npc = CreatePed(4, pedModel, npcCoords.x, npcCoords.y, npcCoords.z, npcCoords.w, false, false)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                TaskStartScenarioInPlace(npc, "WORLD_HUMAN_GUARD_STAND", 0, true)
                SetBlockingOfNonTemporaryEvents(npc, true)

                exports['ox_target']:addLocalEntity(npc, {
                    {
                        name = 'legaljobs_vanddrift', 
                        label = 'Mandehul Job',
                        icon = 'fa-solid fa-truck-droplet',
                        distance = 1.5,
                        onSelect = function(entity)
                            createMenu()
                        end
                    }
                })
            end
        else
            if DoesEntityExist(npc) then
                exports['ox_target']:removeLocalEntity(npc)
                DeleteEntity(npc)
            end
        end
    end, 1000)
end)

AddStateBagChangeHandler('pumpActive' , nil, function(bagName, key, value)
	local entity = GetEntityFromStateBagName(bagName)
	if entity == 0 or not next(CurrentJob) or CurrentJob['Vehicle'] ~= entity then return end
    
    KeyBinds['Pump']:disable(not value)
    if value and cache.vehicle == entity then
        lib.showTextUI('[Y] Pump', { alignIcon = 'center', icon = 'fa-solid fa-wrench' })
    end
end)

CreateThread(function()
    KeyBinds['UseNozzle'] = lib.addKeybind({
        name = 'useNozzle',
        description = 'Place Manhole Nozzle',
        defaultKey = 'E',
        disabled = true,
        onPressed = function(self)
            if not nozzle then return lib.notify({ title = 'Du mangler en pumpe', type = 'error' })
            elseif lib.progressActive() or busy then return end

            PlaceNozzle()
        end
    })

    KeyBinds['Pump'] = lib.addKeybind({
        name = 'pump',
        description = 'Use Manhole Pump',
        defaultKey = 'Y',
        disabled = true,
        onPressed = function(self)
            pumpLocation()
        end
    })
end)

CreateThread(function()
    lib.onCache('vehicle', function(vehicle, oldVeh)
        if not vehicle and not oldVeh or not next(CurrentJob) or CurrentJob['Vehicle'] ~= vehicle then return end

        if vehicle and not oldVeh then
            local vehState = Entity(vehicle).state
            if vehState.pumpActive then
                lib.showTextUI('[Y] Pump', { alignIcon = 'center', icon = 'fa-solid fa-wrench' })
            end
        elseif oldVeh and not vehicle then
            lib.hideTextUI()
        end
    end)
end)
