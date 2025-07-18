local ESX = exports["es_extended"]:getSharedObject()
local playerLoaded, isRadioTalking, currentVoiceRange = false, false, 1

local state = {
    hunger = 0, thirst = 0, oxygen = 100, wasUnderwater = false,
    directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" },
    aspectRatios = {
        ["5:4"] = 1.25, ["4:3"] = 1.33, ["3:2"] = 1.5,
        ["5:3"] = 1.67, ["16:10"] = 1.6, ["16:9"] = 1.78, ["21:9"] = 2.33
    }
}

local function WaitUntilPlayerLoaded()
    while not playerLoaded do Wait(500) end
end

RegisterNetEvent('esx:playerLoaded', function() playerLoaded = true end)

AddEventHandler('esx_status:onTick', function(statusList)
    for _, s in ipairs(statusList) do
        if s.name == 'hunger' then state.hunger = s.percent
        elseif s.name == 'thirst' then state.thirst = s.percent end
    end
end)

local function GetAspectRatioLabel(ratio)
    if type(ratio) ~= 'number' then return '16:10' end
    local closest, smallestDiff = '16:10', math.huge
    for label, value in pairs(state.aspectRatios) do
        local diff = math.abs(ratio - value)
        if diff < smallestDiff then closest, smallestDiff = label, diff end
    end
    return closest
end

RegisterNetEvent('pma-voice:radioActive', function(s) isRadioTalking = s end)
RegisterNetEvent('pma-voice:setTalkingMode', function(m) currentVoiceRange = m end)

CreateThread(function()
    WaitUntilPlayerLoaded()
    local last = { talking = false, radio = false, range = 1 }
    while true do
        local isTalking = NetworkIsPlayerTalking(PlayerId())
        if isTalking ~= last.talking or isRadioTalking ~= last.radio or currentVoiceRange ~= last.range then
            SendNUIMessage({
                action = "talking",
                isTalking = isTalking,
                isRadioTalking = isRadioTalking,
                voiceRange = currentVoiceRange
            })
            last.talking, last.radio, last.range = isTalking, isRadioTalking, currentVoiceRange
        end
        Wait(250)
    end
end)

CreateThread(function()
    WaitUntilPlayerLoaded()
    while true do
        Wait(750)
        local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())
        local heading = (GetGameplayCamRot(2).z + 360) % 360
        local dir = state.directions[math.floor((heading + 22.5) / 45) % 8 + 1]
        local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)) or ""
        local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)) or ""
        local gameTime = string.format("%02d:%02d", GetClockHours(), GetClockMinutes())

        SendNUIMessage({
            action = "updateLocation",
            direction = dir,
            street = street,
            zone = zone,
            gameTime = gameTime 
        })
    end
end)

RegisterNetEvent('elevate_hud:sendTotalPlayers', function(total)
    if not playerLoaded then return end
    ESX.TriggerServerCallback('elevate_hud:getplayer:info', function(info)
        local ped = PlayerPedId()
        local ratio = GetAspectRatio(false)
        SendNUIMessage({
            action = "updateHUD",
            health = math.max(GetEntityHealth(ped) - 100, 0),
            armor = GetPedArmour(ped),
            hunger = state.hunger,
            thirst = state.thirst,
            aspectRatio = ratio,
            label = GetAspectRatioLabel(ratio),
            playerid = info.playerid,
            playersOnline = total,
            bank = info.bank,
            money = info.money,
            blackMoney = info.black_money,
            job = info.job,
            grade = info.grade
        })
    end)
end)

CreateThread(function()
    WaitUntilPlayerLoaded()
    local last = { fuel = -1, speed = -1, gear = "", inVeh = false }
    while true do
        local ped, inVeh = PlayerPedId(), IsPedInAnyVehicle(PlayerPedId(), false)
        if inVeh then
            local veh = GetVehiclePedIsIn(ped, false)
            local fuel, speed = GetVehicleFuelLevel(veh), math.floor(GetEntitySpeed(veh) * 3.6)
            local gear = GetVehicleCurrentGear(veh)
            gear = (gear == 0) and (GetEntitySpeedVector(veh, true).y < -0.5 and "R" or "N") or gear

            if fuel ~= last.fuel or speed ~= last.speed or gear ~= last.gear or not last.inVeh then
                SendNUIMessage({
                    action = "updateVehicleHUD",
                    fuelLevel = fuel, speed = speed, gear = gear, isInVehicle = true
                })
                last = { fuel = fuel, speed = speed, gear = gear, inVeh = true }
            end
        elseif last.inVeh then
            SendNUIMessage({ action = "updateVehicleHUD", isInVehicle = false })
            last.inVeh = false
        end
        Wait(200)
    end
end)

CreateThread(function()
    WaitUntilPlayerLoaded()
    while true do
        TriggerEvent('hud:client:LoadMap')
        TriggerServerEvent('elevate_hud:requestTotalPlayers')
        Wait(1000)
    end
end)

RegisterNetEvent('hud:client:LoadMap', function()
    CreateThread(function()
        WaitUntilPlayerLoaded()
        RequestStreamedTextureDict('squaremap', false)
        while not HasStreamedTextureDictLoaded('squaremap') do Wait(2500) end

        SetMinimapClipType(0)
        AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
        AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')

        local defaultAR, resX, resY = 1920 / 1080, GetActiveScreenResolution()
        local aspect = resX / resY
        local offset = (aspect > defaultAR) and (((defaultAR - aspect) / 3.6) - 0.008) or 0

        SetMinimapComponentPosition('minimap',      'L', 'B', 0.0 + offset, -0.035, 0.1638, 0.183)
        SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0 + offset,  0.012, 0.128,  0.20)
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + offset, 0.040, 0.262, 0.300)

        SetBlipAlpha(GetNorthRadarBlip(), 0)
        SetRadarZoom(1100)
        Citizen.InvokeNative(0x231C8F89D0539D8F, false)
    end)
end)

CreateThread(function()
    while not ESX.IsPlayerLoaded() do Wait(500) end
    Wait(2500)
    if not mapInitialized then
        SetRadarBigmapEnabled(true, false)
        Wait(2500)
        SetRadarBigmapEnabled(false, false)
        TriggerEvent('hud:client:LoadMap')
        mapInitialized = true
    end
end)

RegisterCommand(Config.Command, function()
    if playerLoaded then SendNUIMessage({ action = "toggleHUD" }) end
end, false)

RegisterKeyMapping(Config.Command, 'Toggle HUD', 'keyboard', Config.Keybind)