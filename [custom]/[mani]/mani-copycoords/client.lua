local CoordsBundle, Entities, Keybind = '', {}, nil

local function CreateVec4(coords, heading)
    local formattedX = string.format("%.2f", coords.x)
    local formattedY = string.format("%.2f", coords.y)
    local formattedZ = string.format("%.2f", (coords.z -1))
    local formattedHeading = string.format("%.2f", heading)

    local formattedString = ('vec4(%s, %s, %s, %s)'):format(formattedX, formattedY, formattedZ, formattedHeading)

    return formattedString
end

local function CreateVec3(coords)
    local formattedX = string.format("%.2f", coords.x)
    local formattedY = string.format("%.2f", coords.y)
    local formattedZ = string.format("%.2f", (coords.z -1))

    local formattedString = ('vec3(%s, %s, %s)'):format(formattedX, formattedY, formattedZ)

    return formattedString
end

RegisterCommand('coords', function()
    local playerPed = cache.ped
    local coords, heading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)
    local formattedString = CreateVec4(coords, heading)

    lib.setClipboard(formattedString)

    local CoordsEntity = nil

    if cache.vehicle then
        CoordsEntity = CreateVehicle(GetEntityModel(cache.vehicle), coords.x, coords.y, coords.z - 1, heading, true, true)
    else
        CoordsEntity = CreatePed(26, GetEntityModel(playerPed), coords.x, coords.y, coords.z - 1, heading, false, false)
        ClonePedToTarget(playerPed, CoordsEntity)
        SetBlockingOfNonTemporaryEvents(CoordsEntity, true)
    end

    SetEntityAlpha(CoordsEntity, 200)
    SetEntityCollision(CoordsEntity, false, false)
    FreezeEntityPosition(CoordsEntity, true)

    CreateThread(function()
        while #(GetEntityCoords(cache.ped) - coords) < 20.0 do Wait(2500) end
        DeleteEntity(CoordsEntity)
    end)
end)

RegisterCommand('coords3', function()
    local playerPed = cache.ped
    local coords = GetEntityCoords(playerPed)
    local formattedString = CreateVec3(coords)

    lib.setClipboard(formattedString)

    local CoordsEntity = nil

    if cache.vehicle then
        CoordsEntity = CreateVehicle(GetEntityModel(cache.vehicle), coords.x, coords.y, coords.z - 1, 0.0, true, true)
    else
        CoordsEntity = CreatePed(26, GetEntityModel(playerPed), coords.x, coords.y, coords.z - 1, 0.0, false, false)
        ClonePedToTarget(playerPed, CoordsEntity)
        SetBlockingOfNonTemporaryEvents(CoordsEntity, true)
    end

    SetEntityAlpha(CoordsEntity, 200)
    SetEntityCollision(CoordsEntity, false, false)
    FreezeEntityPosition(CoordsEntity, true)

    CreateThread(function()
        while #(GetEntityCoords(cache.ped) - coords) < 20.0 do Wait(2500) end
        DeleteEntity(CoordsEntity)
    end)
end)

RegisterCommand('v4bundle', function()
    local playerPed = cache.ped

    local disabled = Keybind.disabled

    if disabled then
        Keybind:disable(false)
        lib.showTextUI('[E] Tilføj coords')
    else
        Keybind:disable(true)
        lib.setClipboard(CoordsBundle)
        CoordsBundle = ''

        for i = 1, #Entities do
            DeleteEntity(Entities[i])
        end

        Entities = {}

        lib.hideTextUI()
        lib.notify({ title = 'Coords Tilføjet', type = 'success' })
    end
end)

CreateThread(function()
    Keybind = lib.addKeybind({
        name = 'CopyCoords_Bundle',
        description = 'press Enter to copy coords bundle',
        defaultKey = 'E',
        disabled = true,
        onPressed = function(self)
            local ped = cache.ped
            local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
            CoordsBundle = CoordsBundle .. CreateVec4(coords, heading) .. ', \t\n'

            local CoordsEntity = nil

            if cache.vehicle then
                CoordsEntity = CreateVehicle(GetEntityModel(cache.vehicle), coords.x, coords.y, coords.z - 1, heading, true, true)
            else
                CoordsEntity = CreatePed(26, GetEntityModel(ped), coords.x, coords.y, coords.z - 1, heading, false, false)
                ClonePedToTarget(ped, CoordsEntity)
                SetBlockingOfNonTemporaryEvents(CoordsEntity, true)
            end

            SetEntityAlpha(CoordsEntity, 200)
            SetEntityCollision(CoordsEntity, false, false)
            FreezeEntityPosition(CoordsEntity, true)

            Entities[#Entities + 1] = CoordsEntity

            lib.notify({ title = 'Coords Tilføjet', type = 'inform' })
        end,
    })
end)