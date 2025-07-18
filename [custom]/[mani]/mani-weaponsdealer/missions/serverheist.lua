local Config, Dealer = lib.load('config'), lib.load('open.cl_util')

local Blips, IntTargets = {}, {}

local NumberBlips = {
    502,
    503,
    504,
    505,
    506,
    507,
    508,
    509,
    510,
    511
}

local function ServerHeistStart()
    local success, msg = lib.callback.await('mani-weaponsdealer:server:verifyServerStart', false)
    if not success then lib.notify({ title = msg, type = 'error' }) return end

    lib.notify({ title = 'Kør til lokationen', type = 'inform' })
end

local function ExitServerHeist(MissionData)
    local ped = cache.ped

    FreezeEntityPosition(ped, true)

    DoScreenFadeOut(1000)

    Wait(1000)

    exports['mani-bridge']:TeleportEntity(ped, MissionData.Location.Entrance.Ext)

    Wait(1000)

    for i = 1, #Blips do
        RemoveBlip(Blips[i])
    end

    Blips = {}

    for i = 1, #IntTargets do
        exports['ox_target']:removeZone(IntTargets[i])
    end

    IntTargets = {}

    DoScreenFadeIn(1000)

    FreezeEntityPosition(ped, false)
end

local function HackServer(index)
    local success, error = lib.callback.await('mani-weaponsdealer:server:verifyServerHack', false, index)
    if not success then lib.notify({ title = error, type = 'error' }) return end

    exports['mani-bridge']:HackPhone(function(cb)
        exports['varhack']:OpenHackingGame(function(success)
            cb(success)
        end, 6, 4)
    end, function(success)
        if success then
            lib.callback.await('mani-weaponsdealer:server:hackedServer', false, index)
        else
            lib.notify({ title = 'Du fejlede', type = 'error' })
        end
    end)
end

local function EnterServerHeist(MissionData)
    local ped = cache.ped

    local State, InteriorData, error = lib.callback.await('mani-weaponsdealer:server:getServerHeistData', false)
    if error then lib.notify({ title = error, type = 'error' }) return end

    FreezeEntityPosition(ped, true)

    DoScreenFadeOut(1000)

    Wait(1000)

    exports['mani-bridge']:TeleportEntity(ped, MissionData.Location.Entrance.Int)

    Wait(1000)

    FreezeEntityPosition(ped, false)

    if State then Dealer.CreateGuards(MissionData.Location.Guards, 'U_M_M_JewelSec_01', MissionData.Cooldown - 5 * 1000 * 60) end

    CreateThread(function()
        for i = 1, #InteriorData.Locations do
            Blips[#Blips + 1] = Dealer.CreateBlip(InteriorData.Locations[i].Coords.xyz, NumberBlips[i], 'Hack', true)
    
            IntTargets[#IntTargets + 1] = exports['ox_target']:addBoxZone({
                coords = InteriorData.Locations[i].Coords.xyz,
                name = ('gangMission_serverHeist_server#%s'):format(i),
                size = vec3(1, 1, 2),
                rotation = InteriorData.Locations[i].Coords.w,
                debug = Config.Debug,
                debugColour = vec4(51, 54, 92, 50.0),
                items = MissionData.HackingItem,
                options = {
                    label = 'Hack',
                    icon = 'fa-solid fa-mobile-screen',
                    distance = 2,
                    onSelect = function()
                        HackServer(i)
                    end
                }
            })
        end
    end)

    IntTargets[#IntTargets + 1] = exports['ox_target']:addBoxZone({
        coords = vec3(MissionData.Location.Entrance.Int.xy, MissionData.Location.Entrance.Int.z + 1.0),
        name = 'gangMission_serverHeist_exit',
        size = vec3(3, 3, 2),
        rotation = MissionData.Location.Entrance.Int.w,
        debug = Config.Debug,
        debugColour = vec4(51, 54, 92, 50.0),
        options = {
            label = 'Gå ud',
            icon = 'fa-solid fa-door-open',
            distance = 2,
            onSelect = function()
                ExitServerHeist(MissionData)
            end
        }
    })

    DoScreenFadeIn(1000)
end

RegisterNetEvent('mani-weaponsdealer:client:StartServerHeist', function()
    local MissionData = Config.Missions[3]

    local Coords = vec4(MissionData.Location.Entrance.Ext.xy, MissionData.Location.Entrance.Ext.z + 1.0, MissionData.Location.Entrance.Ext.w)

    Dealer.CreateBlipForMission(Coords.xyz, 456, 'Server Farm')

    exports['ox_target']:addBoxZone({
        coords = Coords.xyz,
        name = 'gangMission_serverHeist_entrance',
        size = vec3(1, 1, 2),
        rotation = Coords.w,
        debug = Config.Debug,
        debugColour = vec4(51, 54, 92, 50.0),
        options = {
            label = 'Gå ind',
            icon = 'fa-solid fa-door-open',
            distance = 2,
            onSelect = function()
                EnterServerHeist(MissionData)
            end
        }
    })
end)

return ServerHeistStart