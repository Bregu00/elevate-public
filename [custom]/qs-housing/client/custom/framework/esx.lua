if Config.Framework ~= 'esx' then
    return
end

ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    PlayerData = GetPlayerData()
    Debug('init playerData')
end)

RegisterNetEvent('esx:setJob', function(jobData)
    PlayerData.job = jobData
end)
local allKeyholderBlips = {}
local function setupKeyholderBlips(playerData)
    local houses = lib.callback.await("houses:server:getHouseBlipInfo", false, playerData.identifier)

    if not houses then return end
    for i = 1, #houses do
        local house = houses[i]
        local coords = json.decode(house.coords)

        allKeyholderBlips[i] = AddBlipForCoord(coords.enter.x, coords.enter.y, coords.enter.z)
        SetBlipSprite(allKeyholderBlips[i], 40)
        SetBlipScale(allKeyholderBlips[i], 0.5)
        SetBlipColour(allKeyholderBlips[i], 3)
        SetBlipAsShortRange(allKeyholderBlips[i], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Hus du har nøgler til')
        EndTextCommandSetBlipName(allKeyholderBlips[i])
    end
end

local toggleBlip = false
local allHouseBlips = {}
local houseMarkers = {}
local DRAW_DISTANCE = 50.0 -- Distance to draw the marker
local TEXT_DISTANCE = 10.0 -- Distance to display the text
local INTERACT_DISTANCE = 3.0 -- Distance to interact with the marker

RegisterCommand("toggleHouseBlips", function()
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer.job or xPlayer.job.name ~= 'realestateagent' then
        return
    end
    if toggleBlip then
        toggleBlip = false
        DeleteBlipsAndMarkers()
        return
    end
    toggleBlip = true
    local houses = lib.callback.await("houses:server:getAllHouses", false)
    for k, v in pairs(houses) do
        local house = v
        local coords = json.decode(house.coords)
        local garageCoords = json.decode(house.garage) or nil
        -- Add blip
        allHouseBlips[k] = AddBlipForCoord(coords.enter.x, coords.enter.y, coords.enter.z)
        SetBlipSprite(allHouseBlips[k], 40)
        SetBlipScale(allHouseBlips[k], 0.6)
        SetBlipColour(allHouseBlips[k], 3)
        SetBlipAsShortRange(allHouseBlips[k], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(house.label)
        EndTextCommandSetBlipName(allHouseBlips[k])
        
        -- Store marker data
        houseMarkers[k] = { coords = coords.enter, garageCoords = garageCoords, label = house.label, house = house}
    end
end)

Citizen.CreateThread(function()
    while true do
        if toggleBlip then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for key, house in pairs(houseMarkers) do
                local coords = house.coords
                local garageCoords = house.garageCoords
                local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
                local garageDistance = garageCoords and #(playerCoords - vector3(garageCoords.x, garageCoords.y, garageCoords.z)) or nil
                if distance < DRAW_DISTANCE then
                    -- Draw marker
                    DrawMarker(
                        20, -- Marker type (cylinder)
                        coords.x, coords.y, coords.z, -- Position
                        0.0, 0.0, 0.0, -- Direction
                        0.0, 0.0, 0.0, -- Rotation
                        1.0, 1.0, 1.0, -- Scale
                        0, 255, 0, 150, -- RGBA color
                        false, -- Bob up and down
                        true, -- Face camera
                        2, -- P19
                        nil, nil, false -- Texture dictionary, name, draw on entity
                    )
                end

                if garageCoords and garageDistance < DRAW_DISTANCE then
                    -- Draw marker
                    DrawMarker(
                        36, -- Marker type (cylinder)
                        garageCoords.x, garageCoords.y, garageCoords.z, -- Position
                        0.0, 0.0, 0.0, -- Direction
                        0.0, 0.0, 0.0, -- Rotation
                        1.0, 1.0, 1.0, -- Scale
                        0, 255, 0, 150, -- RGBA color
                        false, -- Bob up and down
                        true, -- Face camera
                        2, -- P19
                        nil, nil, false -- Texture dictionary, name, draw on entity
                    )

                    -- Draw line from coords to garageCoords
                    DrawLine(coords.x, coords.y, coords.z, garageCoords.x, garageCoords.y, garageCoords.z, 255, 0, 0, 255)

                    -- Calculate midpoint
                    local midX = (coords.x + garageCoords.x) / 2
                    local midY = (coords.y + garageCoords.y) / 2
                    local midZ = (coords.z  + garageCoords.z) / 2

                    -- Draw text at midpoint
                    Draw3DText(midX, midY, midZ, "Garage")
                end
                
                if distance < TEXT_DISTANCE then
                    -- Draw text
                    Draw3DText(
                        coords.x, coords.y, coords.z + 1.0, -- Position slightly above the marker
                        "Tryk [H] for hus information"
                    )

                end
                if distance < INTERACT_DISTANCE and IsControlJustReleased(0, 74) then -- 'H' key (default code: 74)
                    local houseInfo = lib.callback.await("houses:server:getHouseInfo", false, house.house.name) or {}
                    local xPlayer = lib.callback.await("housing:server:getOwnerInfo", false, houseInfo.owner) or {}
                    local agent = lib.callback.await("housing:server:getOwnerInfo", false, house.house.creator) or {}
                    local phoneNumber = lib.callback.await("housing:server:getPhoneNumber", false, houseInfo.owner) or 88888888
                    local name = (xPlayer.firstname and xPlayer.lastname) and (xPlayer.firstname .. ' ' .. xPlayer.lastname) or 'Unknown'
                    local agentName = (agent.firstname and agent.lastname) and (agent.firstname .. ' ' .. agent.lastname) or 'Unknown'
                    local houseName = house.house.name or 'Unknown'
                    local houseLabel = house.house.label or 'Unknown'
                    local housePrice = house.house.price or 'Unknown'
                    local houseOwned = house.house.owned or 'Unknown'
                    lib.registerContext({
                        id = 'HouseInfoMenu',
                        title = 'Ejer information',
                        options = {
                            {
                                title = "Hus Navn: " .. houseName,
                                description = "Hus Label: " .. houseLabel,
                            },
                            {
                                title = "Ejer Navn: " .. name,
                                description = "Ejer TLF Nummer: " .. tostring(phoneNumber),
                            },
                            {
                                title = "Pris: " .. housePrice,
                                description = "Ejendomsmægler: " .. agentName,
                            },
                        }
                    })
                    lib.showContext('HouseInfoMenu')
                end
            end
        end
        Wait(0)
    end
end)

function Draw3DText(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DeleteBlipsAndMarkers()
    -- Remove all blips
    for _, blip in pairs(allHouseBlips) do
        RemoveBlip(blip)
    end
    allHouseBlips = {}
    
    -- Clear marker data
    houseMarkers = {}
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    PlayerData = playerData
    IsLoggedIn = true
    Wait(2500)
    TriggerServerCallback('qb-houses:GetInside', function(currentHouse)
        Debug('qb-houses:GetInside', currentHouse)
        if currentHouse and currentHouse ~= 'nil' and currentHouse ~= '' then
            Wait(100)
            TriggerEvent('qb-houses:client:LastLocationHouse', currentHouse)
        end
    end)
    setupKeyholderBlips(playerData)
end)

RegisterNetEvent('esx:playerLogout')
AddEventHandler('esx:playerLogout', function()
    IsLoggedIn = false
    CurrentHouseData = {}
    DeleteBlipsAndMarkers()
    DeleteBlips()
end)

function TriggerServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function GetPlayerData()
    return ESX.GetPlayerData()
end

function GetIdentifier()
    return GetPlayerData().identifier
end

function GetJobName()
    return PlayerData?.job?.name or 'unemployed'
end

function GetPlayers()
    return ESX.Game.GetPlayers()
end

function GetVehicleProperties(vehicle)
    return ESX.Game.GetVehicleProperties(vehicle)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local texts = {}
if GetResourceState('qs-textui') == 'started' then
    function DrawText3D(x, y, z, text, id, key)
        local _id = id
        if not texts[_id] then
            CreateThread(function()
                texts[_id] = 5
                while texts[_id] > 0 do
                    texts[_id] = texts[_id] - 1
                    Wait(0)
                end
                texts[_id] = nil
                exports['qs-textui']:DeleteDrawText3D(id)
                Debug('Deleted text', id)
            end)
            TriggerEvent('textui:DrawText3D', x, y, z, text, id, key)
        end
        texts[_id] = 5
    end
else
    function DrawText3D(x, y, z, text)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        SetDrawOrigin(x, y, z, 0)
        DrawText(0.0, 0.0)
        local factor = text:len() / 370
        DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
        ClearDrawOrigin()
    end
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = text:len() / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DrawTextBoard(x, y, z, text)
    SetTextScale(0.45, 0.45)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(0, 0, 0, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawGenericText(text)
    SetTextColour(186, 186, 186, 255)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(0.40, 0.00)
end

function Notification(msg, type)
    if GetResourceState('qs-interface') == 'started' then
        if type == 'inform' then
            exports['qs-interface']:AddNotify(msg, 'Inform', 2500, 'fa-solid fa-file')
        elseif type == 'error' then
            exports['qs-interface']:AddNotify(msg, 'Error', 2500, 'fas fa-bug')
        elseif type == 'success' then
            exports['qs-interface']:AddNotify(msg, 'Success', 2500, 'fas fa-thumbs-up')
        end
        return
    end

    if type == 'inform' then
        lib.notify({
            title = 'Housing',
            description = msg,
            type = 'inform'
        })
    elseif type == 'error' then
        lib.notify({
            title = 'Housing',
            description = msg,
            type = 'error'
        })
    elseif type == 'success' then
        lib.notify({
            title = 'Housing',
            description = msg,
            type = 'success'
        })
    end
end

function ToggleHud(bool)
    if bool then
        Debug('Event to show the hud [client/custom/framework/esx.lua line 177]')
        -- DisplayRadar(false) -- You can enable or disable mini-map here
        if GetResourceState('qs-interface') == 'started' then
            exports['qs-interface']:ToggleHud(false)
        end
    else
        Debug('Event to hide the hud [client/custom/framework/esx.lua line 177]')
        -- DisplayRadar(true) -- You can enable or disable mini-map here
        if GetResourceState('qs-interface') == 'started' then
            exports['qs-interface']:ToggleHud(true)
        end
    end
end
