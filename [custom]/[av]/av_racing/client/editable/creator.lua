creatorObjectLeft = nil
creatorObjectRight = nil
CreatorData = {
    RaceName = nil,
    RaceDescription = nil,
    Checkpoints = {},
    TireDistance = 3.0,
}
local creatorBlips = {}
inCreator = false
local creatorModel = creatorModel
local leftRotation = 0.0
local rightRotation = 0.0
local count = 0

CreateThread(function()
    if Config.CustomCheckpoints and Config.Models[Config.CustomCheckpoints] then
        local settings = Config.Models[Config.CustomCheckpoints]
        creatorModel = settings and settings["checkpoint"] or creatorModel
        if type(creatorModel) == "string" and creatorModel:match("bzzz_checkpoint_") then
            creatorModel = `bzzz_checkpoint_a`
        end
        if type(creatorModel) == "string" and creatorModel:match("bzzz_prop_light_tube_") then
            creatorModel = `bzzz_prop_light_tube_a`
        end
    end
end)

RegisterNetEvent("av_racing:createCircuit", function(name,description,type)
    if inCreator then return end
    local exist = lib.callback.await('av_racing:exists', false, name)
    if exist then
        TriggerEvent('av_laptop:notificationUI',Lang['duplicated_name'], "error", Lang['app_title'])
        return
    end
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerEvent("av_laptop:notificationUI", Lang['not_in_vehicle'], "error", Lang['app_title'])
        return
    end
    if GetPedVehicleSeat(PlayerPedId()) ~= -1 then
        TriggerEvent("av_laptop:notificationUI", Lang['not_driver'], "error", Lang['app_title'])
        return
    end
    CreatorData['RaceName'] = name
    CreatorData['RaceDescription'] = description
    CreatorData['RaceType'] = type
    inCreator = true
    TriggerEvent("av_laptop:close")
    Wait(200)
    clearAll()
    CreatorLoop()
end)

function CreatorLoop()
    DrawText()
    CreateThread(function()
        while inCreator do
            if IsControlJustPressed(0, Config.EditorKeys['add']['key']) or IsDisabledControlJustPressed(0, Config.EditorKeys['add']['key']) then
                local canAdd = true
                local coords = GetEntityCoords(cache.ped)
                local index = #CreatorData['Checkpoints']
                if index and index > 0 then
                    local info = CreatorData['Checkpoints'][index] and CreatorData['Checkpoints'][index]['coords']
                    local dist = #(coords - vector3(info['x'], info['y'], info['z']))
                    if dist and dist < 20 then
                        canAdd = false
                    end
                end
                if canAdd then
                    AddCheckpoint(creatorObjectLeft, creatorObjectRight)
                    DrawText()
                else
                    TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['checkpoint_distance'], 'error')
                end
            end
            if IsControlJustPressed(0, Config.EditorKeys['delete']['key']) or IsDisabledControlJustPressed(0, Config.EditorKeys['delete']['key']) then
                if CreatorData.Checkpoints and next(CreatorData.Checkpoints) then
                    DeleteCheckpoint()
                    DrawText()
                else
                    TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['no_checkpoint'],"error")
                end
            end

            if IsControlJustPressed(0, Config.EditorKeys['save']['key']) or IsDisabledControlJustPressed(0, Config.EditorKeys['save']['key']) then
                if CreatorData.Checkpoints and #CreatorData.Checkpoints >= Config.MinimumCheckpoints then
                    SaveRace()
                else
                    TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['not_enough_checkpoints'],"error")
                end
            end

            if IsControlJustPressed(0, Config.EditorKeys['distance']['key']['increase']) or IsDisabledControlJustPressed(0, Config.EditorKeys['distance']['key']['increase']) then
                if CreatorData.TireDistance < 30.0 then
                    CreatorData.TireDistance = CreatorData.TireDistance + 1.0
                else
                    TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['max_distance'],"error")
                end
            end
            if IsControlJustPressed(0, Config.EditorKeys['distance']['key']['decrease']) or IsDisabledControlJustPressed(0, Config.EditorKeys['distance']['key']['decrease']) then
                if CreatorData.TireDistance > 2.0 then
                    CreatorData.TireDistance = CreatorData.TireDistance - 1.0
                else
                    TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['min_distance'],"error")
                end
            end
            if IsControlJustPressed(0, Config.EditorKeys['rotate']['key']['decrease']) or IsDisabledControlJustPressed(0, Config.EditorKeys['rotate']['key']['decrease']) then
                leftRotation += 1
                rightRotation += 1
            end
            if IsControlJustPressed(0, Config.EditorKeys['rotate']['key']['increase']) or IsDisabledControlJustPressed(0, Config.EditorKeys['rotate']['key']['increase']) then
                leftRotation -= 1
                rightRotation -= 1
            end
            if IsControlJustPressed(0, Config.EditorKeys['reset']['key']) or IsDisabledControlJustPressed(0, Config.EditorKeys['reset']['key']) then
                leftRotation = 0.0
                rightRotation = 0.0
                local veh = GetVehiclePedIsIn(cache.ped, false)
                if veh and veh ~= 0 then
                    local rot = GetEntityRotation(veh)
                    if creatorObjectLeft and DoesEntityExist(creatorObjectLeft) then
                        SetEntityRotation(creatorObjectLeft, rot.x, rot.y, rot.z, 0, false)
                    end
                    if creatorObjectRight and DoesEntityExist(creatorObjectRight) then
                        SetEntityRotation(creatorObjectRight, rot.x, rot.y, rot.z, 0, false)
                    end
                end
            end
            if IsControlJustPressed(0, Config.EditorKeys['cancel']['key']) or IsDisabledControlJustPressed(0, Config.EditorKeys['cancel']['key']) then
                DeleteCreatorCheckpoints()
                cleanupObjects()
                inCreator = false
                CreatorData.RaceName = nil
                CreatorData.Checkpoints = {}
                lib.hideTextUI()
            end
            Wait(1)
        end
    end)
    CreateThread(function()
        lib.requestModel(creatorModel)
        leftRotation = 0.0
        rightRotation = 0.0
        while inCreator do
            local PlayerPed = PlayerPedId()
            local PlayerVeh = GetVehiclePedIsIn(PlayerPed)
            if creatorObjectLeft and creatorObjectRight ~= nil then
                cleanupObjects()
            end
            if PlayerVeh ~= 0 then
                local Offset = {
                    left = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, -CreatorData.TireDistance, 0.0, 0.0)).z
                    },
                    right = {
                        x = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).x,
                        y = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).y,
                        z = (GetOffsetFromEntityInWorldCoords(PlayerVeh, CreatorData.TireDistance, 0.0, 0.0)).z
                    }
                }
                creatorObjectLeft = CreateObjectNoOffset(creatorModel, Offset.left.x, Offset.left.y, Offset.left.z, false, false, false)
                creatorObjectRight = CreateObjectNoOffset(creatorModel, Offset.right.x, Offset.right.y, Offset.right.z, false, false, false)
                PlaceObjectOnGroundProperly(creatorObjectLeft)
                PlaceObjectOnGroundProperly(creatorObjectRight)
                SetEntityCollision(creatorObjectLeft, false, false)
                SetEntityCollision(creatorObjectRight, false, false)
                if count == 0 then
                    local rot = GetEntityRotation(PlayerVeh)
                    SetEntityRotation(creatorObjectLeft, rot.x, rot.y, rot.z, 0, false)
                    SetEntityRotation(creatorObjectRight, rot.x, rot.y, rot.z, 0, false)
                    count += 1
                end
                local leftRot = GetEntityRotation(creatorObjectLeft)
                local rightRot = GetEntityRotation(creatorObjectRight)
                SetEntityRotation(creatorObjectLeft, leftRot.x, leftRot.y, leftRot.z + leftRotation, 0, false)
                SetEntityRotation(creatorObjectRight, leftRot.x, leftRot.y, leftRot.z - rightRotation, 0, false)
            end
            Wait(1)
        end
        SetModelAsNoLongerNeeded(creatorModel)
    end)
    CreateThread(function()
        while inCreator do
            GetClosestCheckpoint()
            SetupPiles(creatorModel)
            Wait(1000)
        end
    end)
end