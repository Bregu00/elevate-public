local Config, Dealer = lib.load('config'), lib.load('open.cl_util')

local function OpenContainer(data)
    local container = data.entity

    if Config.ItemConfig['AngleGrinder'].Remove then
        local success = lib.callback.await('mani-weaponsdealer:server:openContainer', false)
        if not success then lib.notify({ title = 'Du mangler en Vinkelsliber', type = 'error' }) return end
    end

    exports['mani-bridge']:OpenContainer(container, function()
        local crateCords = GetOffsetFromEntityInWorldCoords(container, 0.0, 0.5, 0.0)
        local crate = exports['mani-bridge']:CreateObj(GetHashKey('xm3_prop_xm3_crate_01a'), vec4(crateCords.x, crateCords.y, crateCords.z, GetEntityHeading(container)))

        PlaceObjectOnGroundProperly(crate)
        FreezeEntityPosition(crate, true)
        Dealer.AddObject(crate)
        Dealer.AddTimeout(crate, Config.Missions[1].Cooldown - 5 * 1000 * 60)

        exports['mani-bridge']:AddLocalEntityTarget(crate, {
            name = 'mani_weaponsDealerCrate', 
            label = 'Åben Kasse?',
            icon = 'fa-solid fa-box-open',
            distance = 1.5,
            onSelect = function(data)
                exports['mani-bridge']:OpenCrate(crate, function()
                    exports['mani-bridge']:RemoveLocalEntityTarget(crate)
                    lib.callback.await('mani-weaponsdealer:server:openCrate', false, NetworkGetNetworkIdFromEntity(crate))

                    lib.notify({ title = 'Aflever Materialerne', type = 'inform' })
                end)
            end
        })
    end)
end

CreateThread(function()
    exports['ox_target']:addModel('tr_prop_tr_container_01a', {
        label = 'Åben Container',
        name = 'gangMission_container',
        icon = 'fa-solid fa-box-open',
        items = 'angle_grinder',
        distance = 2,
        canInteract = function(entity)
            local state = Entity(entity).state.GangMission
            return state and state == LocalPlayer.state.job.name
        end,
        onSelect = OpenContainer
    })
end)

local function ConfiscatedContainerStart()
    local Location, msg = lib.callback.await('mani-weaponsdealer:server:verifyContainerStart', false)
    if not Location then lib.notify({ title = msg, type = 'error' }) return end

    lib.notify({ title = 'Kør til lokationen', type = 'inform' })

    local Cooldown = Config.Missions[1].Cooldown - 5 * 1000 * 60

    CreateThread(function()
        while #(Location.Prop.xyz - GetEntityCoords(cache.ped)) > 300 do Wait(250) end

        local prop = exports['mani-bridge']:CreateObj(GetHashKey('tr_prop_tr_container_01a'), Location.Prop)

        PlaceObjectOnGroundProperly(prop)
        Entity(prop).state:set('GangMission', LocalPlayer.state.job.name, true)
        FreezeEntityPosition(prop, true)
        Dealer.AddObject(prop)
        Dealer.AddTimeout(prop, Cooldown)
    
        local propCords = GetEntityCoords(prop)
        local propHeading = GetEntityHeading(prop)
    
        local colPop = exports['mani-bridge']:CreateObj(GetHashKey('prop_ld_container'), vec4(propCords.x, propCords.y, propCords.z + 1.4, propHeading), true)
        SetEntityCollision(colPop, true, true)
        FreezeEntityPosition(colPop, true)
        Dealer.AddObject(colPop)
        Dealer.AddTimeout(colPop, Cooldown)

        Dealer.CreateGuards(Location.Guards, 'G_M_M_CartelGoons_01', Cooldown)
    end)
end

return ConfiscatedContainerStart