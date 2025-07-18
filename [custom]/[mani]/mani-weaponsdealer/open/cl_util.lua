

local Dealer, Objects, Timeouts, Config = {}, {}, {}, lib.load('config')

function Dealer.AddTimeout(Entity, Timeout)
    if not Timeouts[Timeout] then
        Timeouts[Timeout] = {}
        SetTimeout(Timeout, function()
            for i = 1, #Timeouts[Timeout] do
                if DoesEntityExist(Timeouts[Timeout][i]) then
                    DeleteEntity(Timeouts[Timeout][i])
                end
            end
            Timeouts[Timeout] = nil
        end)
    end

    Timeouts[Timeout][#Timeouts[Timeout] + 1] = Entity
end

function Dealer.AddObject(object)
    Objects[#Objects + 1] = object
end

function Dealer.RemoveObjects()
    for i = 1, #Objects do
        if DoesEntityExist(Objects[i]) then
            DeleteEntity(Objects[i])
        end
    end

    Objects = {}
end

function Dealer.CreateGuards(Coords, Model, Timeout)
    if Config.Debug then return end
    CreateThread(function()
        AddRelationshipGroup('GUARD_GROUP')
        local guardGroup = GetHashKey('GUARD_GROUP')

        for Guard = 1, #Coords do
            local npc = exports['mani-bridge']:CreateNPC(GetHashKey(Model), Coords[Guard])

            Dealer.AddObject(npc)

            Config.GuardPreset(npc)

            SetPedRelationshipGroupHash(npc, guardGroup)

            if Timeout then
                Dealer.AddTimeout(npc, Timeout)
            end
        end

        SetRelationshipBetweenGroups(5, guardGroup, GetHashKey('PLAYER'))
        SetRelationshipBetweenGroups(0, guardGroup, guardGroup)
    end)
end

function Dealer.CreateBlip(location, Icon, String, Shortrange)
    local blip = AddBlipForCoord(location.xyz)
    SetBlipSprite(blip, Icon)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, not Shortrange)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(String)
    EndTextCommandSetBlipName(blip)

    return blip
end

function Dealer.CreateRadiusBlip(location)
    local blip = AddBlipForRadius(location.xyz , 150.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 32)
    SetBlipAlpha (blip, 128)

    return blip
end

function Dealer.CreateBlipForMission(Coords, Icon, String)
    local Blip = Dealer.CreateBlip(Coords, Icon, String)
    local RadiusBlip = Dealer.CreateRadiusBlip(Coords)

    CreateThread(function()
        while #(GetEntityCoords(cache.ped) - Coords.xyz) > 50 and DoesBlipExist(Blip) and DoesBlipExist(RadiusBlip) do Wait(2500) end

        RemoveBlip(Blip)
        RemoveBlip(RadiusBlip)
    end)

    CreateThread(function()
        Wait(20 * 1000 * 60)

        if DoesBlipExist(Blip) then RemoveBlip(Blip) end
        if DoesBlipExist(RadiusBlip) then RemoveBlip(RadiusBlip) end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
	if not Objects then return end
	for i = 1, #Objects do
        if DoesEntityExist(Objects[i]) then
            DeleteEntity(Objects[i])
        end
	end
end)

return Dealer