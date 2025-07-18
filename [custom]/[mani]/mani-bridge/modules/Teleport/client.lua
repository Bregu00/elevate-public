local function TeleportEntity(entity, coords, transition)
    if transition then
        SwitchOutPlayer(entity, 0, 1)
	    Wait(2500)
    end

    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(entity) do
            Wait(0)
        end

        SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(entity, coords.w or coords.heading or 0.0)
    end

    if transition then
        Wait(2500)
        SwitchInPlayer(entity)
    end
end

exports('TeleportEntity', TeleportEntity)