local confirmed
local heading
local allProps = {}

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function DrawPropAxes(prop)
    local propForward, propRight, propUp, propCoords = GetEntityMatrix(prop)

    local propXAxisEnd = propCoords + propRight * 1.0
    local propYAxisEnd = propCoords + propForward * 1.0
    local propZAxisEnd = propCoords + propUp * 1.0

    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propXAxisEnd.x, propXAxisEnd.y, propXAxisEnd.z, 255, 0, 0, 255)
    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propYAxisEnd.x, propYAxisEnd.y, propYAxisEnd.z, 0, 255, 0, 255)
    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propZAxisEnd.x, propZAxisEnd.y, propZAxisEnd.z, 0, 0, 255, 255)
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local function DrawControlText(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function placeProp(prop, cb)
    prop = joaat(prop)
    heading = 0.0
    confirmed = false

    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(0)
    end

    local hit, coords, entity

    while not hit do
        hit, coords, entity = RayCastGamePlayCamera(1000.0)
        Wait(0)
    end

    prop = CreateObject(prop, coords.x, coords.y, coords.z, true, false, true)

    CreateThread(function()
        while not confirmed do
            hit, coords, entity = RayCastGamePlayCamera(1000.0)
            local ped = PlayerPedId()
            SetEntityCoordsNoOffset(prop, coords.x, coords.y, coords.z, false, false, false, true)
            FreezeEntityPosition(prop, true)
            SetEntityCollision(prop, false, false)
            SetEntityAlpha(prop, 100, false)
            DrawPropAxes(prop)
            Wait(0)

            if IsControlJustPressed(0, 181) then -- Scroll wheel up
                if IsControlPressed(0, 21) then
                    heading = heading + 10.0
                else
                    heading = heading + 1.0
                end
            elseif IsControlJustPressed(0, 180) then -- Scroll wheel down
                if IsControlPressed(0, 21) then
                    heading = heading - 10.0
                else
                    heading = heading - 1.0
                end
            end

            -- DrawControlText("Press Left Arrow Key to Rotate Left", 0.5, 0.85)
            -- DrawControlText("Press Right Arrow Key to Rotate Right", 0.5, 0.9)
            -- DrawControlText("Press E to Confirm Placement", 0.5, 0.95)
            
            if heading > 360.0 then
                heading = 0.0
            elseif heading < 0.0 then
                heading = 360.0
            end

            SetEntityHeading(prop, heading)

            if IsControlJustPressed(0, 38) then -- "E" key
                local distance = #(coords - GetEntityCoords(ped))
                if distance > 10.0 then
                    lib.notify({ title = "Prop Placement", description = "You are too far away from the prop.", type = "error" })
                    DeleteObject(prop)
                    confirmed = true
                    return
                end
                confirmed = true
                SetEntityAlpha(prop, 255, false)
                SetEntityCollision(prop, true, true)
                DeleteObject(prop)
                cb(coords, heading) -- returns coords and heading back to sctipt
            end
            if IsControlJustPressed(0, 177) then -- "Backspace" key
                DeleteObject(prop)
                confirmed = true
                return
            end
        end
    end)
end

exports("placeProp", placeProp)

-- Register a command to trigger the prop placing
-- RegisterCommand("placeprop", function()
--     placeProp(666561306)
-- end)

-- RegisterCommand("placeprop", function()
--     print("placing prop")
--     exports["ND_Police"]:placeProp(666561306, function(coords, heading)
--         print(coords, heading)
--     end)
-- end, false)



exports("useItem", function(item)
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer.job.name == "police" then
        lib.notify({ title = "Info", description = "Du skal være ansat i politiet for at bruge dette item.", type = "error" })
        return
    end
    local removedItem = lib.callback.await("ND_Police:server:removePropItem", false, item.name)
    if not removedItem then lib.notify({ title = "Info", description = "Du har ikke dette item.", type = "error" }) return end
    local prop = joaat(item.client.model)
    RequestModel(item.client.model)
    while not HasModelLoaded(item.client.model) do
        Wait(0)
    end
    exports["ND_Police"]:placeProp(prop, function(coords, heading)
        local entity = CreateObject(prop, coords.x, coords.y, coords.z, true, false, true)
        SetEntityHeading(entity, heading)
        FreezeEntityPosition(entity, item.client.freeze)
        SetEntityCollision(entity, true, true)
        SetEntityAlpha(entity, 255, false)
        local ent = Entity(entity)
        ent.state:set('policePickup', true, true)
        ent.state:set('policePickupItem', item.name, true)
    end)
end)


CreateThread(function()
    exports.ox_target:addGlobalObject({
        {
            icon = "fa-solid fa-box",
            label = "Saml op",
            onSelect = function(data)
                local xPlayer = ESX.GetPlayerData()
                if not xPlayer.job.name == "police" then
                    lib.notify({
                        title = "Info",
                        description = "Du skal være ansat i politiet for at samle dette op.",
                        type = "error"
                    })
                    return
                end
                local state = Entity(data.entity).state
                local netid = NetworkGetNetworkIdFromEntity(data.entity)
                local givenItem = lib.callback.await("ND_Police:server:addPropItem", false, state.policePickupItem, netid)
                if givenItem then
                    lib.notify({
                        title = "Info",
                        description = "Du har samlet. " .. state.policePickupItem,
                        type = "success"
                    })
                end
            end,
            canInteract = function(entity)
                local state = Entity(entity).state
                if state.policePickup then
                    return true
                end
                return false
            end
        }
    })
end)


-- CreateThread(function()
--     exports.ox_target:addGlobalObject({
--         {
--             icon = "fa-solid fa-box",
--             label = "Pickup prop",
--             canInteract = function(entity)
--                 -- for k, v in pairs(allProps) do
--                 --     if v.prop == entity then
--                 --         return true
--                 --     end
--                 -- end
--                 return true
--             end,
--             onSelect = function(data)
--                 SetEntityAsMissionEntity(data.entity, true, true)
--                 DeleteEntity(data.entity)
--                 for k, v in pairs(allProps) do
--                     if v.prop == data.entity then
--                         table.remove(allProps, k)
--                         local givenItem = lib.callback.await("ND_Police:server:addPropItem", false, v.item)
--                         if givenItem then
--                             lib.notify({
--                                 title = "Prop Pickup",
--                                 description = "You have picked up a prop.",
--                                 type = "success"
--                             })
--                         end
--                         break
--                     end
--                 end
--             end
--         }
--     })
-- end)
