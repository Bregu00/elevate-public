   local KeyBind, PressingE = nil, false

local function CopyCoords(model, maxDistance, cb, error, zOffset)
    lib.requestModel(model)

    PressingE = false

    CreateThread(function()
        Wait(500)
        KeyBind:disable(false)
    end)

    CreateThread(function()
        local ped = cache.ped
        local playerCoords = GetEntityCoords(ped)
        local viewEntity = CreateObject(model, playerCoords.xyz, true, false, false)
        SetEntityCollision(viewEntity, false, false)
        local heading = 0.0
        local hit, _, coords = nil, nil, nil

        CreateThread(function()
            while true do
                hit, _, coords = lib.raycast.fromCamera(1, 4, maxDistance)
                playerCoords = GetEntityCoords(ped)
        
                if hit then
                    SetEntityCoords(viewEntity, coords.x, coords.y, coords.z + (zOffset or 0), 0.0, 0.0, 0.0, false)
                    SetEntityHeading(viewEntity, heading)
                    SetEntityDrawOutline(viewEntity, true)
                    SetEntityDrawOutlineColor(viewEntity, 255, 255, 0, 255)
                end

                if IsControlPressed(0, 14) then
                    heading = heading + 15
                elseif IsControlPressed(0, 15) then
                    heading = heading - 15
                elseif PressingE and #(playerCoords - coords) < maxDistance then
                    PressingE = false
                    if DoesEntityExist(viewEntity) then DeleteEntity(viewEntity) end
                    cb(vec4(coords.x, coords.y, coords.z + (zOffset or 0), heading))
                    KeyBind:disable(true)
                    break
                end

                Wait(0)
            end
        end)
    end)    
end

exports('CopyCoords', CopyCoords)

CreateThread(function()
    KeyBind = lib.addKeybind({
        name = 'interact_ray',
        description = 'Place Prop',
        defaultKey = 'E',
        disabled = true,
        onPressed = function(self)
            PressingE = true
        end,
        onReleased = function(self)
            PressingE = false
        end
    })
end)