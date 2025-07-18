myPileModel = Config.CheckpointPileModel
local type = Config.CustomCheckpoints
local startModel = Config.StartAndFinishModel
local finishModel = Config.StartAndFinishModel

CreateThread(function()
    if Config.CustomCheckpoints and Config.Models[Config.CustomCheckpoints] then
        local settings = Config.Models[Config.CustomCheckpoints]
        startModel = settings and settings['start'] or Config.StartAndFinishModel
        finishModel = settings and settings['finish'] or Config.StartAndFinishModel
        dbug("startModel:", startModel, "finishModel:", finishModel)
    end
end)

function isClose(coords)
    local dist = #(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z))
    if dist > Config.JoinDistance then
        return false
    end
    return true
end

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle then
        for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
            if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
        end
    end
    return -2
end

function DeleteAllCheckpoints()
    if CreatorData then
        for k, v in pairs(CreatorData.Checkpoints) do
            local CurrentCheckpoint = CreatorData.Checkpoints[k]

            if CurrentCheckpoint then
                local LeftPile = CurrentCheckpoint.pileleft
                local RightPile = CurrentCheckpoint.pileright

                if LeftPile then
                    DeleteClosestObject(CurrentCheckpoint.offset.left, startModel)
                    DeleteClosestObject(CurrentCheckpoint.offset.left, finishModel)
                    DeleteClosestObject(CurrentCheckpoint.offset.left, myPileModel)
                    LeftPile = nil
                end
                if RightPile then
                    DeleteClosestObject(CurrentCheckpoint.offset.right, startModel)
                    DeleteClosestObject(CurrentCheckpoint.offset.right, finishModel)
                    DeleteClosestObject(CurrentCheckpoint.offset.right, myPileModel)
                    RightPile = nil
                end
            end
        end
    end
    if CurrentRaceData then
        for k, v in pairs(CurrentRaceData.Checkpoints) do
            local CurrentCheckpoint = CurrentRaceData.Checkpoints[k]

            if CurrentCheckpoint then
                local LeftPile = CurrentCheckpoint.pileleft
                local RightPile = CurrentCheckpoint.pileright

                if LeftPile then
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.left, finishModel)
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.left, startModel)
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.left, myPileModel)
                    LeftPile = nil
                end

                if RightPile then
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.right, finishModel)
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.right, startModel)
                    DeleteClosestObject(CurrentRaceData.Checkpoints[k].offset.right, myPileModel)
                    RightPile = nil
                end
            end
        end
    end
end

function AddCheckpoint(leftPile, rightPile)
    local PlayerPos = GetEntityCoords(cache.ped)
    local PlayerVeh = GetVehiclePedIsIn(cache.ped, false)
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
    local leftRot = GetEntityRotation(leftPile)
    local rightRot = GetEntityRotation(rightPile)
    CreatorData.Checkpoints[#CreatorData.Checkpoints + 1] = {
        coords = {
            x = PlayerPos.x,
            y = PlayerPos.y,
            z = PlayerPos.z
        },
        offset = Offset,
        rotation = {
            left = leftRot and leftRot.z or 0.0,
            right = rightRot and rightRot.z or 0.0,
        }
    }
    redrawBlips()
end

function DeleteCheckpoint()
    local NewCheckpoints = {}
    if RaceData.ClosestCheckpoint ~= 0 then
        local ClosestCheckpoint = CreatorData.Checkpoints[RaceData.ClosestCheckpoint]
        if ClosestCheckpoint then
            local Blip = ClosestCheckpoint.blip
            if Blip then
                RemoveBlip(Blip)
                Blip = nil
            end

            local PileLeft = ClosestCheckpoint.pileleft
            if PileLeft then
                DeleteClosestObject(ClosestCheckpoint.offset.left, finishModel)
                DeleteClosestObject(ClosestCheckpoint.offset.left, startModel)
                DeleteClosestObject(ClosestCheckpoint.offset.left, myPileModel)
                PileLeft = nil
            end

            local PileRight = ClosestCheckpoint.pileright
            if PileRight then
                DeleteClosestObject(ClosestCheckpoint.offset.right, finishModel)
                DeleteClosestObject(ClosestCheckpoint.offset.right, startModel)
                DeleteClosestObject(ClosestCheckpoint.offset.right, myPileModel)
                PileRight = nil
            end

            for id, data in pairs(CreatorData.Checkpoints) do
                if id ~= RaceData.ClosestCheckpoint then
                    NewCheckpoints[#NewCheckpoints + 1] = data
                end
            end
            CreatorData.Checkpoints = NewCheckpoints
        end
    end
end

function SaveRace()
    lib.hideTextUI()
    local RaceDistance = 0
    for k, v in pairs(CreatorData.Checkpoints) do
        if k + 1 <= #CreatorData.Checkpoints then
            local checkpointdistance = #(vector3(v.coords.x, v.coords.y, v.coords.z) - vector3(CreatorData.Checkpoints[k + 1].coords.x, CreatorData.Checkpoints[k + 1].coords.y, CreatorData.Checkpoints[k + 1].coords.z))
            RaceDistance = RaceDistance + checkpointdistance
        end
    end
    if Config.DistanceUnit == "KM" then
        RaceDistance = RaceDistance / 1000
    else
        RaceDistance = RaceDistance * 0.000621
    end
    CreatorData.RaceDistance = Round(RaceDistance,3)
    TriggerServerEvent("av_racing:createCircuit", CreatorData)
    DeleteCreatorCheckpoints()
    cleanupObjects()
    inCreator = false
    CreatorData.RaceName = nil
    CreatorData.RaceDescription = nil
    CreatorData.Checkpoints = {}
end

function Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

function redrawBlips()
    for id, CheckpointData in pairs(CreatorData.Checkpoints) do
        RemoveBlip(CheckpointData.blip)
        CheckpointData.blip = CreateCheckpointBlip(CheckpointData.coords, id)
    end
end

function CreateCheckpointBlip(coords, id)
    local Blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(Blip, 1)
    SetBlipDisplay(Blip, 4)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, favoriteBlip)
    ShowNumberOnBlip(Blip, id)
    SetBlipShowCone(Blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Lang['checkpoint'])
    EndTextCommandSetBlipName(Blip)
    return Blip
end

function DeleteCreatorCheckpoints()
    for id, _ in pairs(CreatorData.Checkpoints) do
        local CurrentCheckpoint = CreatorData.Checkpoints[id]
        local Blip = CurrentCheckpoint.blip
        if Blip then
            RemoveBlip(Blip)
            Blip = nil
        end
        if CurrentCheckpoint then
            local PileLeft = CurrentCheckpoint.pileleft
            if PileLeft then
                DeleteClosestObject(CurrentCheckpoint.offset.left, myPileModel)
                DeleteClosestObject(CurrentCheckpoint.offset.left, startModel)
                DeleteClosestObject(CurrentCheckpoint.offset.left, finishModel)
                PileLeft = nil
            end

            local PileRight = CurrentCheckpoint.pileright
            if PileRight then
                DeleteClosestObject(CurrentCheckpoint.offset.right, myPileModel)
                DeleteClosestObject(CurrentCheckpoint.offset.right, startModel)
                DeleteClosestObject(CurrentCheckpoint.offset.right, finishModel)
                PileRight = nil
            end
        end
    end
end

function GetClosestCheckpoint()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, _ in pairs(CreatorData.Checkpoints) do
        if current ~= nil then
            if #(pos -
                vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y,
                    CreatorData.Checkpoints[id].coords.z)) < dist then
                current = id
                dist = #(pos -
                           vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y,
                        CreatorData.Checkpoints[id].coords.z))
            end
        else
            dist = #(pos -
                       vector3(CreatorData.Checkpoints[id].coords.x, CreatorData.Checkpoints[id].coords.y,
                    CreatorData.Checkpoints[id].coords.z))
            current = id
        end
    end
    RaceData.ClosestCheckpoint = current
end

function SetupPiles(model)
    for k, v in pairs(CreatorData.Checkpoints) do
        if not CreatorData.Checkpoints[k].pileleft then
            CreatorData.Checkpoints[k].pileleft = CreatePile(v.offset.left, model or myPileModel, v.rotation and v.rotation.left or 0.0)
        end

        if not CreatorData.Checkpoints[k].pileright then
            CreatorData.Checkpoints[k].pileright = CreatePile(v.offset.right, model or myPileModel, v.rotation and v.rotation.right or 0.0)
        end
    end
end

function CreatePile(offset, model, rotation)
    ClearAreaOfObjects(offset.x, offset.y, offset.z, 50.0, 0)
    lib.requestModel(model)
    local Obj = CreateObject(model, offset.x, offset.y, offset.z, 0, 0, 0) -- CHANGE ONE OF THESE TO MAKE NETWORKED???
    PlaceObjectOnGroundProperly(Obj)
    PlaceObjectOnGroundProperly_2(Obj)
    SetEntityAsMissionEntity(Obj, 1, 1)
    SetEntityCollision(Obj,false,true)
    local _, _, normal = GetGroundZAndNormalFor_3dCoord(offset.x, offset.y, offset.z)
    SetEntityCoordsNoOffset(Obj, offset.x, offset.y, offset.z - (normal.z / 2), true, true, true)
    PlaceObjectOnGroundProperly(Obj)
    PlaceObjectOnGroundProperly_2(Obj)
    if rotation and tonumber(rotation) then
        local rot = GetEntityRotation(Obj)
        SetEntityRotation(Obj, rot.x, rot.y, rotation, 0, false)
    end
    return Obj
end

function DeleteClosestObject(coords, model)
    local Obj = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, model, 0, 0, 0)
    DeleteObject(Obj)
    ClearAreaOfObjects(coords.x, coords.y, coords.z, 50.0, 0)
end

function cleanupObjects()
    DeleteObject(creatorObjectLeft)
    DeleteObject(creatorObjectRight)
    creatorObjectLeft, creatorObjectRight = nil, nil
end

function doGPSForRace(started)
    ClearGpsMultiRoute()
    StartGpsMultiRoute(Config.Blips['Route']['color'], started , false)
    local limit = 0
    local lights = 0
    local blips = 0
    for k, v in pairs(CurrentRaceData.Checkpoints) do
        limit += 1
        if limit <= 3 then
            AddPointToGpsMultiRoute(CurrentRaceData.Checkpoints[k].coords.x,CurrentRaceData.Checkpoints[k].coords.y)
        end
        if started then
            ClearAreaOfObjects(v.offset.right.x, v.offset.right.y, v.offset.right.z, 50.0, 0)
            local notCheckpoint, type = isFinishOrStart(CurrentRaceData,k)
            if notCheckpoint then
                local model = startModel
                if type and type == "finish" then
                    model = finishModel
                end
                CurrentRaceData.Checkpoints[k].pileleft = CreatePile(v.offset.left, model)
                CurrentRaceData.Checkpoints[k].pileright = CreatePile(v.offset.right, model)
            else
                if lights < Config.LightPropsToRender then
                    CurrentRaceData.Checkpoints[k].pileleft = CreatePile(v.offset.left, myPileModel)
                    CurrentRaceData.Checkpoints[k].pileright = CreatePile(v.offset.right, myPileModel)
                    lights += 1
                end
            end
            if blips < Config.MaxBlipsRender then
                CurrentRaceData.Checkpoints[k].blip = CreateCheckpointBlip(v.coords, k)
                blips += 1
            end
        end
    end
    SetGpsMultiRouteRender(true)
    SetIgnoreSecondaryRouteNodes(true)
end

function isFinishOrStart(CurrentRaceData, checkpoint)
    if CurrentRaceData.TotalLaps == 0 then
        if checkpoint == 1 then
            return true, "start"
        elseif checkpoint == #CurrentRaceData.Checkpoints then
            return true, "finish"
        else
            return false
        end
    else
        if checkpoint == 1 then
            return true
        else
            return false
        end
    end
end

function getIndex(Positions)
    for k,v in pairs(Positions) do
        if v.identifier == CurrentRaceData.Identifier then return k end
    end
end

function showLoopParticle(dict, particleName, coords, scale, time)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Wait(0)
    end

    UseParticleFxAssetNextCall(dict)

    local particleHandle = StartParticleFxLoopedAtCoord(particleName, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0,
    scale, false, false, false)
    return particleHandle
end

function handleFlare (checkpoint)
    if CurrentRaceData.Checkpoints and CurrentRaceData.Checkpoints[checkpoint] then 
        local Size = 1.5 --scr_apartment_mp / scr_finders_package_flare
        local left = showLoopParticle('core', 'exp_grd_flare', CurrentRaceData.Checkpoints[checkpoint].offset.left, Size)
        local right = showLoopParticle('core', 'exp_grd_flare', CurrentRaceData.Checkpoints[checkpoint].offset.right, Size)
        SetParticleFxLoopedColour(left, 255, 255, 255, 0)
        SetParticleFxLoopedColour(right, 255, 255, 255, 0)
        SetTimeout(Config.FlareTime * 1000, function()
            StopParticleFxLooped(left, false)
            StopParticleFxLooped(right, false)
        end)
    end
end

function DoPilePfx()
    if CurrentRaceData.Checkpoints[CurrentRaceData.CurrentCheckpoint + 1] then
        handleFlare(CurrentRaceData.CurrentCheckpoint + 1)
    end
    if CurrentRaceData.CurrentCheckpoint == 1 then -- start
        handleFlare(CurrentRaceData.CurrentCheckpoint)
    end
    if CurrentRaceData.TotalLaps > 0 and CurrentRaceData.CurrentCheckpoint == #CurrentRaceData.Checkpoints then -- finish
        handleFlare(1)
        if CurrentRaceData.Lap ~= CurrentRaceData.TotalLaps then
            handleFlare(2)
        end
    end
end

function GetMaxDistance(OffsetCoords)
    local Distance = #(vector3(OffsetCoords.left.x, OffsetCoords.left.y, OffsetCoords.left.z) - vector3(OffsetCoords.right.x, OffsetCoords.right.y, OffsetCoords.right.z))
    local Retval = 12.5
    if Distance > 20.0 then
        Retval = 18.5
    end
    return Retval
end

function MilliToTime(milli)
    local milliseconds = milli % 1000;
    milliseconds = tostring(milliseconds)
    local seconds = math.floor((milli / 1000) % 60);
    local minutes = math.floor((milli / (60 * 1000)) % 60);
    if minutes < 10 then
        minutes = "0"..tostring(minutes);
    else
        minutes = tostring(minutes)
    end
    if seconds < 10 then
        seconds = "0"..tostring(seconds);
    else
        seconds = tostring(seconds)
    end
    return minutes..":"..seconds.."."..milliseconds;
end

function DeleteCurrentRaceCheckpoints()
    if not CurrentRaceData then return end
    dbug('DeleteCurrentRaceCheckpoints()')
    for k, v in pairs(CurrentRaceData.Checkpoints) do
        local CurrentCheckpoint = CurrentRaceData.Checkpoints[k]
        local Blip = CurrentCheckpoint.blip
        if Blip then
            RemoveBlip(Blip)
            Blip = nil
        end

        local PileLeft = CurrentCheckpoint.pileleft
        if PileLeft then
            DeleteClosestObject(CurrentCheckpoint.offset.left, startModel)
            DeleteClosestObject(CurrentCheckpoint.offset.left, finishModel)
            DeleteClosestObject(CurrentCheckpoint.offset.left, myPileModel)
            PileLeft = nil
        end

        local PileRight = CurrentCheckpoint.pileright
        if PileRight then
            DeleteClosestObject(CurrentCheckpoint.offset.right, startModel)
            DeleteClosestObject(CurrentCheckpoint.offset.right, finishModel)
            DeleteClosestObject(CurrentCheckpoint.offset.right, myPileModel)
            PileRight = nil
        end
    end
    CurrentRaceData = nil
end

function FinishRace()
    dbug("FinishRace()")
    ClearGpsMultiRoute()
    StartGpsMultiRoute(6, false , false)
    SetIgnoreSecondaryRouteNodes(false)
    DeleteCurrentRaceCheckpoints()
    EndGhostLoop()
    deleteZones()
end