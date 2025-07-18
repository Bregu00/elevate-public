local objects = {}
local spawningObject = false
CreateThread(function()
    local pedModel = GetHashKey(Config.StartPed.model)

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(50)
    end
    
    local oxyNPC = nil

    SetInterval(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, Config.StartPed.coords.x, Config.StartPed.coords.y, Config.StartPed.coords.z)
        
        if distance < 150 then
            if not DoesEntityExist(oxyNPC) then
                oxyNPC = CreatePed(4, pedModel, Config.StartPed.coords.x, Config.StartPed.coords.y, Config.StartPed.coords.z -1, Config.StartPed.coords.w, false, false)
                FreezeEntityPosition(oxyNPC, true)
                SetEntityInvincible(oxyNPC, true)
                TaskStartScenarioInPlace(oxyNPC, "WORLD_HUMAN_GUARD_STAND", 0, true)
                SetBlockingOfNonTemporaryEvents(oxyNPC, true)

                exports['ox_target']:addLocalEntity(oxyNPC, {
                    {
                        name = 'oxyNPC', 
                        label = 'Start Oxy Heist',
                        icon = 'fas fa-box',
                        distance = 5.5,
                        onSelect = function(entity)
                            local cooldowns = exports['jungurum-lib']:GetGangCooldown()
                            if cooldowns and cooldowns['oxyMission'] and cooldowns['oxyMission'].active then return lib.notify({title = "Der er aktiv bande cooldown på dette.", type = "error"}) end
                            
                            local result, reason = lib.callback.await('elevate-oxyHeist:server:startOxy', false)
                            if not result then
                                lib.notify({title = reason, type = "error"})
                            else
                                exports['jungurum-lib']:SetGangCooldown('oxyMission', Config.Hours(24))
                                lib.notify({title = reason, type = "success"})
                            end
                        end,
                        canInteract = function()
                            local xPlayer = ESX.GetPlayerData()
                            return xPlayer.job.isgang and (xPlayer.job.grade >= 1)
                        end
                    },
                })
            end
        else
            if DoesEntityExist(oxyNPC) then
                exports['ox_target']:removeLocalEntity(oxyNPC)
                DeleteEntity(oxyNPC)
            end
        end
    end, 3000)
end)


RegisterNetEvent('elevate-oxyHeist:client:createGuards', function(guards, Mission, guardType)
    AddRelationshipGroup('GUARD_GROUP')
    local guardGroup = GetHashKey('GUARD_GROUP')
    lib.requestModel(Config.GuardPeds[guardType])
    lib.requestModel(GetHashKey("cs_martinmadrazo"))

    CreateThread(function()
        local seller = CreatePed(26, GetHashKey("cs_martinmadrazo"), Mission.oxySellerCoords.coords.xyz, Mission.oxySellerCoords.coords.w, true, true)
        while not DoesEntityExist(seller) do Wait(100) end
        while not NetworkGetEntityIsNetworked(seller) do
            NetworkRegisterEntityAsNetworked(seller);
            Wait(0);
        end

        local networkID = NetworkGetNetworkIdFromEntity(seller)
        while not NetworkDoesEntityExistWithNetworkId(networkID) do
            Wait(100);
        end

        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetEntityAsMissionEntity(seller, true, true)
        SetEntityVisible(seller, true)
        FreezeEntityPosition(seller, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        SetEntityInvincible(seller, true)
        SetEntityAlpha(seller, 255, false)

        Entity(seller).state:set('isSeller', true, true)
        objects[#objects + 1] = seller

        for guard = 1, #guards do
            while spawningObject do Wait(100); end
            spawningObject = true

            local guard = guards[guard]
            local npc, netId = nil, nil
            npc = CreatePed(26, Config.GuardPeds[guardType], guard.xyz, guard.w, true, true)
            while not DoesEntityExist(npc) do Wait(100) end
            GiveWeaponToPed(npc, GetHashKey('WEAPON_ASSAULTRIFLE'), 255, false, false)

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
            SetPedCombatAttributes(npc, 46, true)
            SetPedFleeAttributes(npc, 0, false)
            SetPedAsEnemy(npc, true)
            SetPedArmour(npc, 100)
            SetEntityHealth(npc, 350)
            SetPedAccuracy(npc, 90)
            SetPedCombatAbility(npc, 2)
            SetPedCombatMovement(npc, 2)
            SetPedCombatRange(npc, 2)
            SetPedAlertness(npc, 3)
            SetPedDropsWeaponsWhenDead(npc, false)
            
            Entity(npc).state:set('oxylootable', true, true)

            objects[#objects + 1] = npc
    
            Wait(100)
            spawningObject = false
        end

        SetModelAsNoLongerNeeded(Config.GuardPeds[guardType])
    end)

    SetRelationshipBetweenGroups(5, guardGroup, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(0, guardGroup, guardGroup)
end)


CreateThread(function()
    exports.ox_target:addGlobalPed({
        {
            name = 'npcLoot',
            label = 'Loot Vagt',
            icon = 'fas fa-box',
            distance = 2.5,
            onSelect = function(data)
                local state = Entity(data.entity).state
                ExecuteCommand("e kneel3")
                if lib.progressBar({
                    duration = 2000,
                    label = 'Looter Vagt',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                }) then
                    ExecuteCommand("e c")
                    if not state.oxylootable then return end
                    TriggerServerEvent("elevate-oxyHeist:server:npcLootReward", NetworkGetNetworkIdFromEntity(data.entity))
                else
                    ExecuteCommand("e c")
                    return
                end
            end,
            canInteract = function(entity)
                local state = Entity(entity).state
                if state.oxylootable then
                    return true
                end
            end
        },
        {
            name = 'npcSell',
            label = 'Sell Oxy',
            icon = 'fas fa-box',
            distance = 2.5,
            onSelect = function(data)
                local state = Entity(data.entity).state
                ExecuteCommand("e argue")
                if lib.progressBar({
                    duration = 2000,
                    label = 'Sælger oxy',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                }) then 
                    ExecuteCommand("e c")
                    if not state.isSeller then return end
                    TriggerServerEvent("elevate-oxyHeist:server:sellOxy", NetworkGetNetworkIdFromEntity(data.entity))
                else 
                    ExecuteCommand("e c")
                    return
                end
            end,
            canInteract = function(entity)
                local state = Entity(entity).state
                if state.isSeller then
                    return true
                end
            end
        },
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