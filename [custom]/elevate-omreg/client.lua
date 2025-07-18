local insideZone = false

local function createBlip(coords, label, color, sprite)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

CreateThread(function()
    for i = 1, #Config.transferZones do
        local v = Config.transferZones[i]
        createBlip(vector3(v.coords.xyz), v.label, v.color, v.sprite)
        lib.zones.box({
            coords = vector3(v.coords.xyz),
            rotation = v.coords.w,
            size = v.size,
            name = v.name,
            label = v.label,
            onEnter = function()
                insideZone = true
            end,
            onExit = function()
                insideZone = false
            end,
            debug = Config.debug,
        })
    end
end)

local function getNearbyPlayers(playerCoords)
    local nearByPlayers = lib.getNearbyPlayers(playerCoords, 10, Config.debug)

    local newPlayerTable = {}

    for i = 1, #nearByPlayers do
        local serverId = GetPlayerServerId(nearByPlayers[i].id)
        newPlayerTable[#newPlayerTable + 1] = {value = serverId, label = GetPlayerName(nearByPlayers[i].id)}
    end
    return newPlayerTable
end

CreateThread(function()
    exports['ox_target']:addGlobalVehicle({
        {
            label = 'Omregistrer køretøj',
            name = 'vehicleTransfer',
            icon = 'fas fa-car',
            canInteract = function()
                return insideZone
            end,
            onSelect = function(entity)
                local playerCoords = GetEntityCoords(cache.ped)
                local vehiclePlate = GetVehicleNumberPlateText(entity.entity)
                local modelHash = GetEntityModel(entity.entity)

                local playerTable = getNearbyPlayers(playerCoords)
                if not playerTable or not next(playerTable) then return end

                local input = lib.inputDialog('Vælg Køber', {
                    {type = 'select', label = 'Spillere', options = playerTable, required = true,},
                })
                if not input then return end

                local success, message = lib.callback.await('elevate-omreg:server:transferVehicle', false, vehiclePlate, modelHash, input[1])
                lib.notify({ title = message, type = success and 'success' or 'error'})
            end,
        }
    })
end)

lib.callback.register('elevate-omreg:client:openAlert', function(title, underTitle, isCentered, canCancel)
    local alert = lib.alertDialog({
        header = title,
        content = underTitle,
        centered = isCentered,
        cancel = canCancel
    })
    if alert == 'confirm' then
        return true
    else
        return false
    end
end)