local ESX = nil
local Labs = {}
local packing = false
local inprogress = false
local inprogresspacking = false
local currentlabdrug = nil
local zones = {}
local currentLab = nil
keypad = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
	    Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    TriggerEvent('syn_labs:reloadLabs')
end)

RegisterNetEvent('syn_labs:reloadLabs')
AddEventHandler('syn_labs:reloadLabs', function(info)
    if info ~= nil then
        local obj = GetClosestObjectOfType(info[1].positionx, info[1].positiony, info[1].positionz, 3.0, GetHashKey("hei_prop_hei_keypad_03"), false, false, false)
        if DoesEntityExist(obj) then
            NetworkRequestControlOfEntity(obj)
            SetEntityAsMissionEntity(obj)
            DeleteObject(obj)
        end
    end
    ESX.TriggerServerCallback('elm_druglab:getLabs', function(result)
        Labs = result
    end)
end)

RegisterNetEvent("elm_druglab:client:fullSync", function(result)
    Labs = result
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local function TogglePak()
    local playerPed = cache.ped
    if packing then
        packing = false
        ClearPedTasks(playerPed)
        SetEntityCollision(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        lib.cancelProgress()
        lib.hideTextUI()
    else
        packing = true
        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
        FreezeEntityPosition(playerPed, true)
        SetEntityCollision(playerPed, false, false)
        lib.showTextUI('[E] Stop', { alignIcon = 'center', icon = 'box' })
        CreateThread(function()
            while packing do
                Wait(0)
                if lib.progressBar({
                    duration = Config.PackTime,
                    label = 'Pakker',
                    useWhileDead = false,
                    allowCuffed = false,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                        sprint = true,
                    }
                }) then
                    local newPlayerped = cache.ped
                    if playerPed ~= newPlayerped or not IsPedUsingScenario(newPlayerped, 'PROP_HUMAN_BUM_BIN') then
                        packing = false
                        ClearPedTasks(newPlayerped)
                        SetEntityCollision(newPlayerped, true, true)
                        FreezeEntityPosition(playerPed, false)
                        lib.hideTextUI()
                        return
                    end
                    local givenItem, message = lib.callback.await('elm_druglab:server:packDrug', false, currentlabdrug, currentLab)

                    if not givenItem then
                        lib.notify({ title = message, type = 'error' })
                        packing = false
                        ClearPedTasks(playerPed)
                        SetEntityCollision(playerPed, true, true)
                        FreezeEntityPosition(playerPed, false)
                        lib.hideTextUI()
                        return
                    end
                end
            end
            SetEntityCollision(playerPed, true, true)
            FreezeEntityPosition(playerPed, false)
        end)
    end
end

CreateThread(function()
	SetInterval(function()
        local position = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(Labs) do
            local afstand = GetDistanceBetweenCoords(position.x, position.y, position.z, v.positionx, v.positiony, v.positionz, false)
            if afstand < 5 then
                local haskeypadspawned = GetClosestObjectOfType(v.positionx, v.positiony, v.positionz, 3.0, GetHashKey("hei_prop_hei_keypad_03"), false, false, false)
                if DoesEntityExist(haskeypadspawned) == false then
                    keypad = CreateObject('hei_prop_hei_keypad_03', v.positionx, v.positiony, v.positionz, false, true, false)
                    FreezeEntityPosition(keypad, true)
                    local roll, pitch, yaw = v.rotationx, v.rotationy, v.rotationz
                    SetEntityRotation(keypad, roll, pitch, yaw, 2, true)
                    exports.qtarget:AddTargetModel('hei_prop_hei_keypad_03', {
                        options = {
                            {
                                icon = "fas fa-tablet",
                                label = "Indtast kode",
                                action = function(entity)
                                    if checkPin(v.pin) then
                                        local gammelpos = GetEntityCoords(PlayerPedId(-1))
                                        spawnLab(ConfigClient.Shells[v.type].obj, v.entryx, v.entryy, v.entryz-30.0)
                                        insideLab = true
                                        TriggerServerEvent("elm_druglab:logenter", v.type, v.gang)
                                        DoScreenFadeOut(800)
                                        while not IsScreenFadedOut() do
                                            Wait(0)
                                        end
                                        Citizen.Wait(1000)
                                        if v.type == "weed" then
                                            SetEntityCoords(PlayerPedId(-1), v.doorx, v.doory, v.doorz-24.0)
                                        else   
                                            SetEntityCoords(PlayerPedId(-1), v.doorx, v.doory, v.doorz-26.0)
                                            SetEntityHeading(PlayerPedId(-1), 90)
                                        end
                                        DoScreenFadeIn(1250)

                                        currentlabdrug = v.type
                                        currentLab = v.id

                                        zones[1] = exports['ox_target']:addBoxZone({
                                            coords = vector3(v.doorx, v.doory, v.doorz - 25.0),
                                            size = vec3(2.0, 2.0, 4.0),
                                            debug = false,
                                            distance = 2.0,
                                            options = {
                                                {
                                                    name = 'druglabs_exit',
                                                    onSelect = function()
                                                        local PlayerPed = PlayerPedId()
                                                        local spillerpos = GetEntityCoords(PlayerPed)
                                                        currentlabdrug = nil
                                                        FreezeEntityPosition(PlayerPed, true)
                                                        lib.hideTextUI()
                                                        ExitAnim(spillerpos.x, spillerpos.y, spillerpos.z)
                                                        lib.progressBar({label = "Forlader", duration = 850, position = 'bottom', canCancel = false,})
                                                        DoScreenFadeOut(800)
                                                        while not IsScreenFadedOut() do
                                                            Wait(0)
                                                        end
                                                        Citizen.Wait(1000)
                                                        SetEntityCoords(PlayerPed, gammelpos)
                                                        DoScreenFadeIn(1250)
                                                        FreezeEntityPosition(PlayerPed, false)
                                                        despawnLab()
                                                        insideLab = false
                                                        currentLab = nil
                                                    end,
                                                    icon = 'fas fa-door-open',
                                                    label = 'Udgang',
                                                }
                                            },
                                        })
                                        zones[2] = exports['ox_target']:addBoxZone({
                                            coords = vector3(v.pakx, v.paky, v.pakz - 25.0),
                                            size = vec3(2.0, 2.0, 4.0),
                                            debug = false,
                                            distance = 2.0,
                                            options = {
                                                {
                                                    name = 'druglabs_pal',
                                                    onSelect = function()
                                                        TogglePak()
                                                        CreateThread(function()
                                                            while packing do
                                                                if IsControlJustPressed(0, 38) then
                                                                    TogglePak()
                                                                    break
                                                                end
                                                                Wait(1)
                                                            end
                                                        end)
                                                    end,
                                                    icon = 'fas fa-boxes-packing',
                                                    label = 'Pak',
                                                }
                                            },
                                        })
                                        zones[3] = exports['ox_target']:addBoxZone({
                                            coords = vector3(v.kemix, v.kemiy, v.kemiz - 25.0),
                                            size = vec3(2.0, 2.0, 4.0),
                                            debug = false,
                                            distance = 2.0,
                                            options = {
                                                {
                                                    name = 'druglabs_kemi',
                                                    onSelect = function()
                                                        exports.ox_inventory:openInventory('stash', {id="druglab" .. v.id})
                                                    end,
                                                    icon = 'fas fa-boxes-packing',
                                                    label = 'Kemi beholdning',
                                                }
                                            },
                                        })
                                    end
                                end
                            }
                        },
                        distance = 2.0
                    })
                end
            else
                keypad = nil
                local obj = GetClosestObjectOfType(v.positionx, v.positiony, v.positionz, 3.0, GetHashKey("hei_prop_hei_keypad_03"), false, false, false)
                if DoesEntityExist(obj) then
                    NetworkRequestControlOfEntity(obj)
                    SetEntityAsMissionEntity(obj)
                    DeleteObject(obj)
                end
            end
        end
	end, 1000)
end)


function checkPin(pincode)
    local input = lib.inputDialog('Dialog title', {
        {type = 'input', label = 'Password', description = 'Enter password', icon = 'hashtag', password = true},
    })
    if not input then return end
    if not input[1] then return end
    return tonumber(input[1]) == tonumber(pincode)
end

RegisterNetEvent('elm_druglabs:createshell')
AddEventHandler('elm_druglabs:createshell', function(object, gang, label, pin, keypaddata)
    local spillerpos = GetEntityCoords(PlayerPedId())
    local shell = CreateObject(ConfigClient.Shells[object].obj, spillerpos.x, spillerpos.y, spillerpos.z - 50.0, false, false)
    FreezeEntityPosition(shell, true)
    SetEntityHeading(shell, 0.0)
    local info = {}
    table.insert(info, {
        name = gang,
        pin = pin,
        shellpos = GetEntityCoords(shell),
        entrypos = spillerpos,
        door = (GetEntityCoords(shell)+ConfigClient.Shells[object].door),
        pak = (GetEntityCoords(shell)+ConfigClient.Shells[object].pak),
        kemi_inv = (GetEntityCoords(shell)+ConfigClient.Shells[object].kemi_inv),
        process = (GetEntityCoords(shell)+ConfigClient.Shells[object].process),
        rotationx = keypaddata.rotation.x,
        rotationy = keypaddata.rotation.y,
        rotationz = keypaddata.rotation.z,
        positionx = keypaddata.position.x,
        positiony = keypaddata.position.y,
        positionz = keypaddata.position.z,
        handle = keypaddata.handle
    })
    TriggerServerEvent('elm_druglab:opretLab', object, json.encode(info), gang, label, pin)
    DeleteEntity(shell)
    Wait(500)
    TriggerEvent("syn_labs:reloadLabs")
end)

---------

local spawnedLabs = nil
local insideLab = false

function spawnLab(obj, x, y, z)
    local ped = GetPlayerPed(-1)
    RequestModel(obj)
    while not HasModelLoaded(obj) do
        Wait(1)
    end

    local lab = CreateObject(obj, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(lab)
    FreezeEntityPosition(lab, true)
    SetEntityHeading(lab, 0.0)
    SetEntityCollision(lab, true, true)
    SetEntityAsMissionEntity(lab, true, true)
    SetModelAsNoLongerNeeded(lab)
    spawnedLabs = lab
end

function despawnLab()
    if DoesEntityExist(spawnedLabs) then
        DeleteEntity(spawnedLabs)
    end
    for i = 1, #zones do
        exports["ox_target"]:removeZone(zones[i])
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function ExitAnim(x,y,z)
    ClearPedSecondaryTask(GetPlayerPed(-1))
    loadAnimDict( "anim@heists@keycard@" ) 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    ClearPedTasks(GetPlayerPed(-1))
    RequestScriptAudioBank('dlc_oxdoorlock/oxdoorlock', false)
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, 'door_bolt', x, y, z, 'DLC_OXDOORLOCK_SET', false, 0, false)
    ReleaseSoundId(soundId)
    ReleaseNamedScriptAudioBank('dlc_oxdoorlock/oxdoorlock')
end

exports("kemibox", function(data)
    local slot = data.slot
    lib.callback.await("elm_lab:server:handleKemiBox", false, slot)
end)