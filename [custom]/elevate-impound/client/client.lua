local Config = lib.load('config')


CreateThread(function()

    for i = 1, #Config.policeImpounds do
        local v = Config.policeImpounds[i]
        local pedModel = GetHashKey(v.ped)

        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(50)
        end
        
        local impoundNPC = nil

        SetInterval(function()
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, v.coords.x, v.coords.y, v.coords.z)
            
            if distance < 150 then
                if not DoesEntityExist(impoundNPC) then
                    impoundNPC = CreatePed(4, pedModel, v.coords.x, v.coords.y, v.coords.z -1, v.coords.w, false, false)
                    FreezeEntityPosition(impoundNPC, true)
                    SetEntityInvincible(impoundNPC, true)
                    TaskStartScenarioInPlace(impoundNPC, "WORLD_HUMAN_GUARD_STAND", 0, true)
                    SetBlockingOfNonTemporaryEvents(impoundNPC, true)

                    exports['ox_target']:addLocalEntity(impoundNPC, {
                        {
                            name = 'impoundNPC', 
                            label = 'Åbent opbevaring',
                            icon = 'fas fa-car',
                            distance = 5.5,
                            onSelect = function(entity)
                                OpenPoliceImpound()
                            end,
                        },
                    })
                end
            else
                if DoesEntityExist(impoundNPC) then
                    exports['ox_target']:removeLocalEntity(impoundNPC)
                    DeleteEntity(impoundNPC)
                end
            end
        end, 3000)
    end
end)

function OpenPoliceImpound()
    local impoundedVehicles = lib.callback.await('elevate-impound:server:getImpoundedVehicles', false, LocalPlayer.state.job.name)
    SendNUIMessage({
        action = 'openMenu',
        data = {
            setVisible = true,
            impoundedVehicles = impoundedVehicles ~= nil and impoundedVehicles or {}, -- Hvis der ikke er nogen biler, så send en tom tabel
            job = LocalPlayer.state.job.name
        }
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('hideUI', function(_, cb)
    cb({})
    SetNuiFocus(false, false)
end)

RegisterNUICallback('releaseVehicle', function(data, cb)
    ESX.TriggerServerCallback('elevate-impound:server:releaseVehicle', function(success)
        if success then
            lib.notify({
                title = 'Bilen er blevet frigivet',
                description = 'Bilen er blevet frigivet fra opbevaring',
                type = 'success'
            })
            cb(true) -- true for at fjerne fra ui table false for ikke at fjerne bilen.
        else
            lib.notify({
                title = 'Fejl',
                description = 'Bilen kunne ikke frigives',
                type = 'error'
            })
        end

    end, data.Plate, LocalPlayer.state.job.name)
end)

function impoundVehicle(vehicle, plate, reason, length, priceProcent, isPoliceImpound, vehicleProps)
    ESX.TriggerServerCallback('elevate-impound:server:impoundVehicle', function(success, msg)
        lib.notify({
            title = 'Beslaglæning',
            description = msg,
            type = 'success',
            duration = 10000
        })
    end, { vehicle = vehicle, plate = plate, release_time = length, priceProcent = priceProcent, reason = reason, vehicledata = vehicleProps, isPoliceImpound = isPoliceImpound })
end

function CreateInputMenu()
    local input = lib.inputDialog('Beslaglæggelses muligheder', {
        {type = 'textarea', label = 'Grundlag', description = 'Grundlag for impound af køretøj', required = true},
        {type = 'checkbox', label = 'Politi opbevaring', required = false, default = false},
        {type = 'slider', label = 'Tid', description = 'Hvor lang tid skal bilen opbevares i dage', required = true, min = 1, max = 14, default = 3},
        {type = 'slider', label = 'Pris', description = 'Hvor mange procenter af bilen salgs pris skal kræves?', required = true, min = 0, max = 10, default = 0},
    })
    if not input then return false end
    if not input[1] then return false end
    if not input[3] then return false end
    if not input[4] then return false end
    return input
end


CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        {
            label = "Beslaglæg køretøj",
            icon = "fa-solid fa-car",
            distance = 2,
            onSelect = function(data)
                local menu = CreateInputMenu()
                if not menu then return end
                local reason = menu[1]
                local isPoliceImpound = menu[2]
                local length = menu[3]
                local priceProcent = menu[4]
                local plate = GetVehicleNumberPlateText(data.entity)

                ExecuteCommand("e inspect3")
                if lib.progressBar({
                    duration = 5000,
                    label = 'Beslaglægger køretøj',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                })
                then
                    local netId = NetworkGetNetworkIdFromEntity(data.entity)
                    impoundVehicle(netId, plate, reason, length, priceProcent, isPoliceImpound, lib.getVehicleProperties(data.entity))
                    ExecuteCommand("e c")
                else
                    ExecuteCommand("e c")
                    ESX.ShowNotification("Du afbrødw handlingen")
                end
            end,
            canInteract = function(data)
                local xPlayer = ESX.GetPlayerData()
                return xPlayer.job.name == "police"
            end,
        },
        {
            label = "Oplås køretøj",
            icon = "fa-solid fa-car",
            distance = 2,
            onSelect = function(data)
                ExecuteCommand("e weld")
                if lib.progressBar({
                    duration = 5000,
                    label = 'Oplåser køretøj',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                    },
                })
                then
                    local state = Entity(data.entity).state
                    state:set('vehLocked', false, true)
                    ExecuteCommand("e c")
                else
                    ExecuteCommand("e c")
                    ESX.ShowNotification("Du afbrød handlingen")
                end
                
            end,
            canInteract = function(data)
                local xPlayer = ESX.GetPlayerData()
                return xPlayer.job.name == "police"
            end,
        },
    })
end)