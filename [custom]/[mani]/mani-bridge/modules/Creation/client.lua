local Creating = false

local function CreateVeh(coords, model, props)
    while Creating do Wait(100) end
    Creating = true
    lib.requestModel(model)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
    while not DoesEntityExist(vehicle) do Wait(100) end

    while not NetworkGetEntityIsNetworked(vehicle) do
        NetworkRegisterEntityAsNetworked(vehicle);
        Wait(0)
    end

    local networkID = NetworkGetNetworkIdFromEntity(vehicle)
    while not NetworkDoesEntityExistWithNetworkId(networkID) do Wait(100) end

    SetNetworkIdCanMigrate(networkID, true)
    SetNetworkIdExistsOnAllMachines(networkID, true)

    SetEntityAsMissionEntity(vehicle, true, true)
    SetEntityVisible(vehicle, true)

    local netVeh = NetworkGetEntityFromNetworkId(networkID)
    while not DoesEntityExist(netVeh) do Wait(100) end
    networkID = NetworkGetNetworkIdFromEntity(netVeh)

    if props then lib.setVehicleProperties(vehicle, props) end

    Wait(100)
    Creating = false

    SetModelAsNoLongerNeeded(model)

    return netVeh, networkID
end

exports('CreateVeh', CreateVeh)

local function CreateObj(model, coords, hidden)
    while Creating do Wait(100) end
    Creating = true

    lib.requestModel(model)

    local object = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, true)
    SetEntityVisible(object, not hidden)
    SetEntityCollision(object, not hidden, true)
    while not DoesEntityExist(object) do Wait(100) end

    while not NetworkGetEntityIsNetworked(object) do
        NetworkRegisterEntityAsNetworked(object)
        Wait(0)
    end

    local networkID = NetworkGetNetworkIdFromEntity(object)
    while not NetworkDoesEntityExistWithNetworkId(networkID) do Wait(100) end

    SetNetworkIdCanMigrate(networkID, true)
    SetNetworkIdExistsOnAllMachines(networkID, true)

    SetEntityAsMissionEntity(object, true, true)
    SetEntityHeading(object, coords.w)

    local netObj = NetworkGetEntityFromNetworkId(networkID)
    while not DoesEntityExist(netObj) do Wait(100) end
    networkID = NetworkGetNetworkIdFromEntity(netObj)
    Wait(100)
    Creating = false

    SetModelAsNoLongerNeeded(model)

    return netObj, networkID
end

exports('CreateObj', CreateObj)

local function CreateNPC(model, coords, insideVehicle)
    while Creating do Wait(100) end
    Creating = true
    
    lib.requestModel(model)

    local npc = nil
    
    if insideVehicle and next(insideVehicle) then
        npc = CreatePedInsideVehicle(insideVehicle.entity, 26, model, insideVehicle.seat, true, true)
    else
        npc = CreatePed(26, model, coords.xyz, coords.w, true, true)
    end
    while not DoesEntityExist(npc) do Wait(100) end

    while not NetworkGetEntityIsNetworked(npc) do
        NetworkRegisterEntityAsNetworked(npc)
        Wait(0)
    end

    local networkID = NetworkGetNetworkIdFromEntity(npc)
    while not NetworkDoesEntityExistWithNetworkId(networkID) do
        Wait(100)
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

    Wait(100)
    Creating = false

    SetModelAsNoLongerNeeded(model)

    return netPed, networkID
end

exports('CreateNPC', CreateNPC)