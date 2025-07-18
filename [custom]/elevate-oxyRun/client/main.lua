ESX = exports['es_extended']:getSharedObject()
local JobStarted = false
local givenBoxesCount = 0
local grabboxes = false
local holding = false
local prop = nil
local PickUpZone = nil
local startPoint = nil
local MeetPoint = nil
local EndPoint = nil
local driversent = false
local Buyersdelivered = 0
local InZone = false
local OnCooldown = false
function Notify(text, status)
    if Config.Notifications == "ox" then
        lib.notify({
            title = "Oxy Job",
            description = text,
            type = status,
            duration = 7500
        })
    elseif Config.Notifications == "mythic_notify" then
        exports['mythic_notify']:SendAlert(status, text, 7500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
    elseif Config.Notifications == "esx" then
        ESX.ShowNotification(text)
    end
end
function Email(sender, subject, message)
    if Config.Phone == "qbphone" then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = sender,
            subject = subject,
            message = message,
            button = {}
        })
    elseif Config.Phone == "roadphone" then
        local data = {
            sender = sender,
            subject = subject,
            message = message
        }
        exports['roadphone']:sendMail(data)
    end
end
function Callpolice()
    local chance = math.random(1, 100)
    if chance <= Config.CallCopsChance then
        if Config.PoliceDispatch == "ps-dispatch" then
            exports['ps-dispatch']:DrugSale()
        elseif Config.PoliceDispatch == "core_dispatch" then
            exports['core_dispatch']:sendDrugSellAlert()
        elseif Config.PoliceDispatch == "qs-dispatch" then
            exports['qs-dispatch']:DrugSale()
        elseif Config.PoliceDispatch == "none" then
            print("Ingen Dispatch sat op.")
        else
            print("Config.PoliceDispatch Ikke Understøttet")
        end
    end
end
local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end
RegisterNetEvent('dynyx_oxyrun:start', function()
    local checkcops = lib.callback.await('dynyx_oxyrun:CheckCops', false)
    if checkcops >= Config.MinCops then
        if not OnCooldown then
            if JobStarted then
                Notify("Du har allerede startet et job.")
                return
            end
            JobStarted = true
            exports.ox_inventory:Progress({
                duration = 3500,
                label = "Taler med Bossen",
                useWhileDead = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                    mouse = false,
                },
                anim = {
                    dict = "rcmjosh1",
                    clip = "idle",
                    flags = -1,
                }
            }, function(cancel)
                if not cancel then
                    TriggerServerEvent('dynyx_oxyrun:Pay')
                else
                    JobStarted = false
                end
            end)
        else
            Notify("Du har lige lavet et job, kom tilbage senere.")
        end
    else
        Notify("Der er ikke nok betjente, kom tilbage senere.")
    end
end)
RegisterNetEvent('dynyx_oxyrun:startjob', function()
    OnCooldown = true
    TriggerServerEvent('dynyx-oxyrun:StartCooldown')
    if Config.SendEmails then
        Notify("Jeg har tilføjet dig til listen. En email vil blive sendt, når vi har et job klar til dig.")
    else
        Notify("Jeg har tilføjet dig til listen. Jeg lader dig vide, når jeg har et job klar til dig.")
    end
    Wait(Config.WaitListTimer * 1000)
    if Config.SendEmails then
        Email("Ukendt Transportør", "Boss Mand", "Yo, jeg hører, at du leder efter nogle stoffer, jeg har sendt dig en placering til din GPS, gå derhen og hent pakkerne og lever dem til køberne.")
    else
    Notify("Jeg har sendt dig en placering til din GPS, gå derhen og hent pakkerne og lever dem til køberne.")
end
local Ped = Config.Peds[math.random(1, #Config.Peds)]
local PickUpCoords = Config.PickUpLocations[math.random(1, #Config.PickUpLocations)]
PickUpBlip = AddBlipForCoord(PickUpCoords.x, PickUpCoords.y, PickUpCoords.z)
SetBlipSprite(PickUpBlip, 1)
SetBlipColour(PickUpBlip, 15)
SetBlipRoute(PickUpBlip, true)
PedHash = GetHashKey(Ped)
RequestModel(PedHash)
while not HasModelLoaded(PedHash) do
    Citizen.Wait(1)
end
if HasModelLoaded(PedHash) then
    PickUpPed = CreatePed(1, PedHash, PickUpCoords.x, PickUpCoords.y, PickUpCoords.z - 1.0, PickUpCoords.w, false, true)
    boxprop = CreateObject(`prop_cs_cardbox_01`, 0, 0, 0, false, true, true)
    FreezeEntityPosition(PickUpPed, true)
    SetEntityInvincible(PickUpPed, true)
    SetPedKeepTask(PickUpPed, true)
    SetBlockingOfNonTemporaryEvents(PickUpPed, true)
    AttachEntityToEntity(boxprop, PickUpPed, GetPedBoneIndex(PickUpPed, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 0, true)
    LoadAnimDict('anim@heists@box_carry@')
    TaskPlayAnim(PickUpPed, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
        local GrabPackageTarget = exports.ox_target:addSphereZone({
            coords = vec3(PickUpCoords.x, PickUpCoords.y, PickUpCoords.z),
            radius = 1,
            debug = false,
            options = {
                {
                    onSelect = function()
                        TriggerEvent('dynyx_oxyrun:GrabPackage')
                    end,
                    icon = 'fas fa-box',
                    label = "Tag Pakker",
                }
            }
        })
        PickUpZone = GrabPackageTarget
    end
    grabboxes = true
end)
function holdbox()
    if not holding then
        holding = true
        LoadAnimDict("anim@heists@box_carry@")
        local Player = PlayerPedId()
        if not HasModelLoaded("prop_cs_cardbox_01") then
            while not HasModelLoaded(GetHashKey("prop_cs_cardbox_01")) do
                RequestModel(GetHashKey("prop_cs_cardbox_01"))
                Wait(10)
            end
        end
        prop = CreateObject("prop_cs_cardbox_01", 0, 0, 0, false, true, true)
        AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded("prop_cs_cardbox_01")
        TaskPlayAnim(Player, "anim@heists@box_carry@", "idle", 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    
        CreateThread(function()
            while holding do
                Wait(1000)
                if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) and holding then
                    holding = false
                    DeleteEntity(prop)
                end
            end
        end)
    else
        holding = false
        DeleteEntity(prop)
        ClearPedSecondaryTask(PlayerPedId())
    end
end
RegisterNetEvent('dynyx_oxyrun:startdelivery', function()
    local Deliverycoords = Config.PedDrivers[math.random(1, #Config.PedDrivers)]
    startPoint = Deliverycoords.info.startPoint
    MeetPoint = Deliverycoords.info.MeetPoint
    EndPoint = Deliverycoords.info.DespawnPoint
    DeliveryBlip = AddBlipForCoord(Deliverycoords.info.MeetPoint.x, Deliverycoords.info.MeetPoint.y, Deliverycoords.info.MeetPoint.z)
    SetBlipSprite(DeliveryBlip, 1)
    SetBlipColour(DeliveryBlip, 15)
    SetBlipRoute(DeliveryBlip, true)
    DropZone = BoxZone:Create(vector3(MeetPoint.x, MeetPoint.y, MeetPoint.z), 25.0, 25.0, {
        name = "InZoneArea",
        heading = 0,
        minZ = MeetPoint.z -10,
        maxZ = MeetPoint.z +5,
        debugPoly = false
    })
    DropZone:onPlayerInOut(function(isPointInside)
        if isPointInside and not InZone then
            InZone = true
            RemoveBlip(DeliveryBlip)
            Notify("Vent her, og vent på at køberne ankommer.")
            TriggerEvent('dynyx_oxyrun:SendBuyer')
        end
    end)
end)

RegisterNetEvent('dynyx_oxyrun:SendBuyer', function()
    if Buyersdelivered == Config.Deliveries then
        TriggerEvent('dynyx_oxyrun:EndJob')
        lib.showTextUI("Kunder" .. ': FÆRDIG', {
            position = "left-center",
            borderRadius = 0,
            icon = 'check',
            iconColor = "white",
            style = {
                backgroundColor = 'green',
                color = 'white'
            }
        })
        Wait(4000)
        lib.hideTextUI()
        if Config.SendEmails then
            Email("Ukendt Transportør", "Boss Mand", "Godt arbejde! Du har leveret alle pakkerne, kom tilbage til mig, når du vil have mere arbejde.")
        else
            Notify("Godt arbejde! Du har leveret alle pakkerne, kom tilbage til mig, når du vil have mere arbejde.", "success")
        end
        return
    end
    if not driversent then
        driversent = true
        lib.showTextUI("Kunder" .. ': ' ..Buyersdelivered.. '/' .. Config.Deliveries, {
            position = "left-center",
            borderRadius = 0,
            icon = 'box',
            iconColor = "white",
            style = {
                backgroundColor = 'orange',
                color = 'white'
            }
        })
        local Cars = Config.OxyVehicles[math.random(1, #Config.OxyVehicles)]
        local Ped = Config.Peds[math.random(1, #Config.Peds)]
    
        VehicleHash = GetHashKey(Cars)
        PedHash = GetHashKey(Ped)
    
        RequestModel(VehicleHash)
        while not HasModelLoaded(VehicleHash) do
        Wait(0)
        end
        
        RequestModel(PedHash)
        while not HasModelLoaded(PedHash) do
        Wait(0)
        end
        if HasModelLoaded(VehicleHash) and HasModelLoaded(PedHash) then
            oxybuyerveh = CreateVehicle(VehicleHash, startPoint.x, startPoint.y, startPoint.z, startPoint.w, true, false)
            SetVehicleEngineOn(oxybuyerveh, true, true)
            RollDownWindows(oxybuyerveh)
            buyerped = CreatePedInsideVehicle(oxybuyerveh, 6, PedHash, -1, true, false)
            SetPedCanBeDraggedOut(buyerped, false)
            SetEntityAsMissionEntity(oxybuyerveh, true, true)
            SetVehicleEngineOn(oxybuyerveh, true, true, false)
            Wait(3000)
            TaskVehicleDriveToCoordLongrange(buyerped, oxybuyerveh, MeetPoint.x, MeetPoint.y, MeetPoint.z, 7.5, 39, 4.0)
            exports.ox_target:addLocalEntity(oxybuyerveh, {
                label = "Aflever Pakke",
                onSelect = function()
                    TriggerEvent('dynyx_oxyrun:HandPackage')
                end,
            })
        end
    end    
end)
function BuyerAnimation()
    LoadAnimDict("mp_common")
    local Player = PlayerPedId()
    if not HasModelLoaded("hei_prop_pill_bag_01") then
        while not HasModelLoaded(GetHashKey("hei_prop_pill_bag_01")) do
            RequestModel(GetHashKey("hei_prop_pill_bag_01"))
            Wait(10)
        end
    end
    pillprop = CreateObject("hei_prop_pill_bag_01", 0, 0, 0, false, true, true)
    AttachEntityToEntity(pillprop, Player, GetPedBoneIndex(Player, 57005), 0.12, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded("hei_prop_pill_bag_01")
    TaskPlayAnim(Player, "mp_common", "givetake1_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
    DeleteEntity(prop)
    Wait(1500)
    DeleteEntity(pillprop)
    ClearPedSecondaryTask(Player)
end
RegisterNetEvent('dynyx_oxyrun:HandPackage', function()
    if holding and JobStarted then
        holding = false
        if Buyersdelivered < Config.Deliveries then
            driversent = false
            Callpolice()
            BuyerAnimation()
            Buyersdelivered = Buyersdelivered + 1
            TriggerServerEvent("dynyx_oxyrun:GetOxy")
            Notify("Godt arbejde, den næste kunde er på vej.")
            lib.showTextUI("Kunder" .. ': ' ..Buyersdelivered.. '/' .. Config.Deliveries, {
                position = "left-center",
                borderRadius = 0,
                icon = 'box',
                iconColor = "white",
                style = {
                    backgroundColor = 'orange',
                    color = 'white'
                }
            })
            exports.ox_target:removeLocalEntity(oxybuyerveh)
            TaskVehicleDriveToCoordLongrange(buyerped, oxybuyerveh, EndPoint.x, EndPoint.y, EndPoint.z, 7.5, 39, 4.0) -- Fordi du satte EndJob, så EndPoint =nil så fejl
            Wait(Config.WaitUntilNextBuyer * 1000)
            DeleteEntity(oxybuyerveh)
            DeleteEntity(buyerped)
            Wait(500)
            TriggerEvent("dynyx_oxyrun:SendBuyer")
            return
        end
    else
        Notify("Du holder ikke pakken i hånden.", "error")
    end
end)
RegisterNetEvent('dynyx_oxyrun:EndJob', function()
    JobStarted = false
    givenBoxesCount = 0
    grabboxes = false
    PickUpZone = nil
    startPoint = nil
    MeetPoint = nil
    EndPoint = nil
    driversent = false
    Buyersdelivered = 0
    InZone = false
    DropZone:destroy()
    Wait(Config.Cooldown * 1000)
    OnCooldown = false
end)
RegisterNetEvent('dynyx_oxyrun:GrabPackage', function()
    if grabboxes then
        if givenBoxesCount < Config.Deliveries then
            givenBoxesCount = givenBoxesCount + 1
            holdbox()
            TriggerServerEvent('dynyx_oxyrun:GivePackage')
            lib.showTextUI("Pakker" .. ': ' ..givenBoxesCount.. '/' .. Config.Deliveries, {
                position = "left-center",
                borderRadius = 0,
                icon = 'box',
                iconColor = "white",
                style = {
                    backgroundColor = 'green',
                    color = 'white'
                }
            })
            return
        end
        if givenBoxesCount == Config.Deliveries then
            lib.hideTextUI()
            exports.ox_target:removeZone(PickUpZone)
            RemoveBlip(PickUpBlip)
            DeleteEntity(boxprop)
            ClearPedTasks(PickUpPed)
            SetPedAsNoLongerNeeded(PickUpPed)
            grabboxes = false
            Notify("Jeg har sendt dig GPS'en, hvor du skal møde kunderne.")
            TriggerEvent('dynyx_oxyrun:startdelivery')
            return
        end
    end
end)
CreateThread(function()
    local Ped = Config.Peds[math.random(1, #Config.Peds)]
    local SelectedCoords = Config.BossCoords[math.random(1, #Config.BossCoords)]
    PedHash = GetHashKey(Ped)
    RequestModel(PedHash)
    while not HasModelLoaded(PedHash) do
        Citizen.Wait(1)
    end
    if HasModelLoaded(PedHash) then
        local OxyBoss = CreatePed(1, PedHash, SelectedCoords.x, SelectedCoords.y, SelectedCoords.z - 1.0, SelectedCoords.w, false, true)
        FreezeEntityPosition(OxyBoss, true)
        SetEntityInvincible(OxyBoss, true)
        TaskStartScenarioInPlace(OxyBoss, "CODE_HUMAN_CROSS_ROAD_WAIT", 0, true)
        SetBlockingOfNonTemporaryEvents(OxyBoss, true)
        exports.ox_target:addSphereZone({
            coords = vec3(SelectedCoords.x, SelectedCoords.y, SelectedCoords.z),
            radius = 1,
            debug = false,
            options = {
                {
                    onSelect = function()
                        TriggerEvent('dynyx_oxyrun:start')
                    end,
                    icon = 'fas fa-person',
                    label = "Tal med Bossen",
                }
            }
        })
    end
end)
exports('oxycarry', function()
    holdbox()
end)
