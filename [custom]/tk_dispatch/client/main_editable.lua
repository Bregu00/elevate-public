local doingProgress = false

local function StopProgress(ped, anim, obj, ptfx)
    if DoesEntityExist(obj) then DeleteEntity(obj) end

    if anim then
        ClearPedTasks(ped)
    end

    if ptfx then
        StopParticleFxLooped(ptfx, false)
    end

    doingProgress = false
end

function DoProgress(anim, duration)
    local ped = PlayerPedId()

    if doingProgress or IsPedInAnyVehicle(ped, true) or IsEntityDead(ped) or IsPedHandcuffed(ped) then return end
    doingProgress = true

    anim = type(anim) == 'table' and anim[math.random(#anim)] or anim

    if anim?.dict and not LoadDict(anim.dict) then return end

    duration = anim?.duration or duration or 5000
    local startTime = GetGameTimer()
    local controls = {20, 21, 30, 31, 32, 33, 34, 35, 24, 48, 257, 25, 263, 22, 44, 37, 288, 289, 170, 167, 318, 137, 36, 47, 264, 257, 266, 267, 268, 269, 140, 141, 142, 143, 75, 73}

    local obj, ptfx

    if anim?.prop?.model then
        if not LoadModel(anim.prop.model) then return end

        local pos = anim.prop.pos or vec3(0.0, 0.0, 0.0)
        local rot = anim.prop.rot or vec3(0.0, 0.0, 0.0)

        local pC = GetEntityCoords(ped)
        obj = CreateObject(anim.prop.model, pC.x, pC.y, pC.z + 0.2, true, true, true)
        AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, anim.prop.bone), pos, rot, true, true, false, true, 1, true)
    end

    if anim?.ptfx?.name then
        if not LoadPtfx(anim.ptfx.asset) then return end

        local offset = anim.ptfx.offset vec3(0.0, 0.0, 0.0)
        local rot = anim.ptfx.rot or vec3(0.0, 0.0, 0.0)
        local color = anim.ptfx.color or {r = 1.0, g = 1.0, b = 1.0}

        UseParticleFxAsset(anim.ptfx.asset)
        ptfx = StartNetworkedParticleFxLoopedOnEntityBone(anim.ptfx.name, obj, offset, rot, GetEntityBoneIndexByName(anim.ptfx.name, 'VFX'), anim.ptfx.scale, false, false, false)
        SetParticleFxLoopedColour(ptfx, color.r, color.g, color.b, false)
    end

    if anim?.scenario then
        TaskStartScenarioInPlace(ped, anim.scenario, 0, true)
    end

    while true do
        for _,v in pairs(controls) do DisableControlAction(0, v, true) end

        if anim?.dict and anim?.name and not IsEntityPlayingAnim(ped, anim.dict, anim.name, 3) then
            TaskPlayAnim(ped, anim.dict, anim.name, 2.0, 2.0, -1, anim.flag or 49, 0, false, false, false)
        end

        if IsDisabledControlJustPressed(0, 73) or IsEntityDead(ped) then
            StopProgress(ped, anim, obj, ptfx)
            return false
        end

        if startTime + duration < GetGameTimer() then
            StopProgress(ped, anim, obj, ptfx)
            return true
        end

        Wait(0)
    end
end

function Notify(text, notifyType)
    if Config.NotificationType == 'mythic' then
        exports['mythic_notify']:DoHudText(notifyType, text)
    else
        ShowNotification(text, notifyType)
    end
end

function DisplayHelpText(text)
    AddTextEntry('help_text', text)
    DisplayHelpTextThisFrame('help_text', false)
end

function ShowTextUI(text)
    if Config.UseOxLib then
        lib.showTextUI(text, {position = 'right-center'})
    else
        exports['qb-core']:DrawText(text, 'left')
    end
end

function HideTextUI()
    if Config.UseOxLib then
        lib.hideTextUI()
    else
        exports['qb-core']:HideText()
    end
end

function GetVehicleName(vehModel)
    vehModel = tonumber(vehModel)
    local make = GetLabelText(GetMakeNameFromVehicleModel(vehModel))
    local model = GetLabelText(GetDisplayNameFromVehicleModel(vehModel))
    return('%s %s'):format(make, model)
end

function PlayCallSound(data)
    if data.playSoundAll then
        PlaySoundFromEntity(-1, "Event_Start_Text", PlayerPedId(), "GTAO_FM_Events_Soundset", 0, 0)
    elseif data.playSound then
        PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
    end
end

function AddShootingAlert()
    AddCall({
        title = _U('shooting'),
        code = '10-11',
        priority = 'Prioritet 1',
        sound = true,
        jobs = Config.Alerts.shooting.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.shooting.coordsOffset,
        showLocation = true,
        showDirection = true,
        showGender = true,
        showWeapon = true,
        showVehicle = true,
        platePercentage = Config.Alerts.shooting.platePercentage,
        playSound = true,
        removeTime = Config.Alerts.shooting.removeTime,
        blip = {
            color = 3,
            sprite = 110,
            scale = 1.0,
            radius = 40.0,
        }
    })
    TriggerServerEvent('elevate_sheets:logtosheet', 'Skyderi', exports["visualz_zones"]:getZoneLabel((GetNameOfZone(GetEntityCoords(PlayerPedId())))))
end

function AddGunSeenAlert()
    AddCall({
        title = _U('gun_seen'),
        code = '10-11',
        priority = 'Prioritet 2',
        sound = true,
        jobs = Config.Alerts.gunSeen.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.gunSeen.coordsOffset,
        showLocation = true,
        showDirection = true,
        showGender = true,
        showWeapon = true,
        showVehicle = true,
        platePercentage = Config.Alerts.gunSeen.platePercentage,
        playSound = true,
        removeTime = Config.Alerts.gunSeen.removeTime,
        blip = {
            color = 3,
            sprite = 110,
            scale = 1.0,
            radius = 40.0,
        }
    })
end

function AddSpeedingAlert()
    AddCall({
        title = _U('speeding'),
        code = '10-11',
        priority = 'Prioritet 3',
        sound = true,
        jobs = Config.Alerts.speeding.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.speeding.coordsOffset,
        showLocation = true,
        showDirection = true,
        showVehicle = true,
        platePercentage = Config.Alerts.speeding.platePercentage,
        playSound = true,
        removeTime = Config.Alerts.speeding.removeTime,
        blip = {
            color = 3,
            sprite = 225,
            scale = 1.0,
        }
    })
end

function AddFightingAlert()
    AddCall({
        title = _U('fighting'),
        code = '10-10',
        priority = 'Prioritet 3',
        sound = true,
        jobs = Config.Alerts.fighting.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.fighting.coordsOffset,
        showLocation = true,
        showGender = true,
        playSound = true,
        removeTime = Config.Alerts.fighting.removeTime,
        blip = {
            color = 3,
            sprite = 311,
            scale = 1.0,
            radius = 40.0,
        }
    })
end

function AddVehicleStealingAlert()
    AddCall({
        title = _U('vehicle_stealing'),
        code = '10-35',
        priority = 'Prioritet 3',
        sound = true,
        jobs = Config.Alerts.vehStealing.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.vehStealing.coordsOffset,
        showLocation = true,
        showGender = true,
        showVehicle = true,
        platePercentage = Config.Alerts.vehStealing.platePercentage,
        playSound = true,
        removeTime = Config.Alerts.vehStealing.removeTime,
        blip = {
            color = 3,
            sprite = 225,
            scale = 1.0,
        }
    })
end

function AddInjuredPersonAlert()
    AddCall({
        title = _U('injured_person'),
        code = '10-69',
        priority = 'Prioritet 2',
        sound = true,
        jobs = Config.Alerts.injuredPerson.jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.injuredPerson.coordsOffset,
        showLocation = true,
        showGender = true,
        playSound = true,
        removeTime = Config.Alerts.injuredPerson.removeTime,
        blip = {
            color = 3,
            sprite = 153,
            scale = 1.0,
        }
    })
end

function AddPanicButtonAlert(jobs)
    if LocalPlayer.state.dead then return lib.notify({title = "Du er død og kan ikke bruge panic knap", type = "error"}) end
    for k,v in pairs(jobs) do
        if v == 'police' then
            jobs[#jobs+1] = 'ambulance'
            break
        elseif v == 'ambulance' then
            jobs[#jobs+1] = 'police'
            break
        end
    end

    AddCall({
        title = _U('panic_button'),
        code = 'PANIK',
        priority = 'Prioritet 1',
        sound = true,
        jobs = jobs,
        coords = globalCoords,
        coordsOffset = Config.Alerts.panicButton.coordsOffset,
        showLocation = true,
        showGender = true,
        showPerson = true,
        flash = true,
        playSoundAll = true,
        removeTime = Config.Alerts.panicButton.removeTime,
        blip = {
            color = 3,
            sprite = 58,
            scale = 1.0,
            flash = true,
        }
    })
end

if Config.Alerts?.call?.enable then
    local lastCall

    RegisterCommand('911', function(src, args, raw)
        if lastCall and lastCall + Config.Alerts.call.cooldown > GetGameTimer() then return end
        lastCall = GetGameTimer()

        local message = table.concat(args, ' ')
        AddCall({
            title = _U('call'),
            code = '10-67',
            priority = 'Prioritet 2',
            sound = true,
            jobs = Config.Alerts.call.jobs,
            coords = globalCoords,
            showLocation = true,
            showGender = true,
            showPerson = true,
            showNumber = true,
            message = message,
            removeTime = Config.Alerts.call.removeTime,
            blip = {
                color = 3,
                sprite = 280,
                scale = 1.0,
            }
        })
    end, false)
end