local localConfig = nil

RegisterNetEvent("high_3dsounds:receiveSafeConfig", function(config)
    localConfig = config
end)

Citizen.CreateThread(function()
    while localConfig==nil do Wait(50) end
    if localConfig.Addons then
        local calanMuzikler = {}
        local musicOn = false
    
        local ESX = nil
    
        CreateThread(function ()
            while ESX == nil do
                Wait(50)
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            end
        end)
    
    
        -- Müzik çalma
        exports('Cal', function(link, mp3)
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local serverId = GetPlayerServerId(PlayerId())
            local muzikAdi = tostring(serverId)
    
            if musicOn then
                TriggerServerEvent("muzik-durdur", muzikAdi)
                musicOn = false
            end
    
            if #calanMuzikler <= 99 then
                if mp3 then
                    TriggerServerEvent("muzik-cal", pos, muzikAdi, "phone-ring/" .. link, serverId, true)
                else
                    TriggerServerEvent("muzik-cal", pos, muzikAdi, "https://www.youtube.com/watch?v=" .. link, serverId, false)
                end
                musicOn = true
            else
                ESX.ShowNotification("Fazla kişi youtube uygulamasını kullandığı için açtığınız videonun sesini yakındaki kişiler duyamıyor", "error")
            end
        end)
    
        RegisterNetEvent('client-muzik-cal')
        AddEventHandler('client-muzik-cal', function(pos, muzikAdi, link, serverId, mp3)
            if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
                calanMuzikler[muzikAdi] = {}
                calanMuzikler[muzikAdi]["duraklat"] = false
                calanMuzikler[muzikAdi]["serverId"] = serverId
                calanMuzikler[muzikAdi]["mp3"] = mp3
    
                if mp3 then
                    Play3DPos(muzikAdi, pos, 10, link, 0.2)
                else
                    Play3DPos(muzikAdi, pos, 15, link, 0.25)
                end
            end
        end)
    
        -- Müzik durdurma
        exports('Durdur', function(link)
            if musicOn then
                musicOn = false
                TriggerServerEvent("muzik-durdur", tostring(GetPlayerServerId(PlayerId())))
            end
        end)
    
        RegisterNetEvent('client-muzik-durdur')
        AddEventHandler('client-muzik-durdur', function(muzikAdi)
            if GetPlayerServerId(PlayerId()) ~= muzikAdi then
                calanMuzikler[muzikAdi] = nil
                destroySound(muzikAdi)
            end
        end)
    
        -- Müzik duraklatma
        exports('Duraklat', function(link)
            local myId = tostring(GetPlayerServerId(PlayerId()))
            TriggerServerEvent("muzik-duraklat", myId)
        end)
    
        RegisterNetEvent('client-muzik-duraklat')
        AddEventHandler('client-muzik-duraklat', function(muzikAdi)
            if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
                if calanMuzikler[muzikAdi]["duraklat"] == false then
                    calanMuzikler[muzikAdi]["duraklat"] = true
                    modifySound(muzikAdi, "paused", true)
                end
            end
        end)
    
        -- Müzik duraklatma
        exports('Devamet', function(link)
            local myId = tostring(GetPlayerServerId(PlayerId()))
            TriggerServerEvent("muzik-devamet", myId)
        end)
    
        RegisterNetEvent('client-muzik-devamet')
        AddEventHandler('client-muzik-devamet', function(muzikAdi)
            if tostring(GetPlayerServerId(PlayerId())) ~= muzikAdi then
                if calanMuzikler[muzikAdi]["duraklat"] == true then
                    calanMuzikler[muzikAdi]["duraklat"] = false
                    modifySound(muzikAdi, "paused", false)
                end
            end
        end)
    
        -- Müzik Konum güncelleme
        local time = 100
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(time)
    
                for x, y in pairs(calanMuzikler) do
                    local player = GetPlayerFromServerId(calanMuzikler[x]["serverId"])
                    if player ~= -1 then
                        local ped = GetPlayerPed(player)
                        local kordinat = GetEntityCoords(ped)
                        local benimKordinat = GetEntityCoords(PlayerPedId())
    
                        local mesafe = #(benimKordinat - kordinat)
                        if mesafe < 200 then
                            time = 100
                            modifySound(x, "position", kordinat)
                            if calanMuzikler[x]["mp3"] then
                                if IsPedInAnyVehicle(ped, true) == 1 then
                                    local vehicle = GetVehiclePedIsIn(ped, false)
                                    if GetEntitySpeed(vehicle) * 3.6 > 200.0 then
                                        modifySound(x, "distance", 140)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 150.0 then
                                        modifySound(x, "distance", 125)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 110.0 then
                                        modifySound(x, "distance", 100)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 90.0 then
                                        modifySound(x, "distance", 80)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 60.0 then
                                        modifySound(x, "distance", 65)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 30.0 then
                                        modifySound(x, "distance", 40)
                                    else
                                        modifySound(x, "distance", 25)
                                    end
                                else
                                    modifySound(x, "distance", 10)
                                end
                            else
                                if IsPedInAnyVehicle(ped, true) == 1 then
                                    local vehicle = GetVehiclePedIsIn(ped, false)
                                    if GetEntitySpeed(vehicle) * 3.6 > 200.0 then
                                        modifySound(x, "distance", 140)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 150.0 then
                                        modifySound(x, "distance", 125)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 110.0 then
                                        modifySound(x, "distance", 100)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 90.0 then
                                        modifySound(x, "distance", 80)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 60.0 then
                                        modifySound(x, "distance", 65)
                                    elseif GetEntitySpeed(vehicle) * 3.6 > 30.0 then
                                        modifySound(x, "distance", 40)
                                    else
                                        modifySound(x, "distance", 25)
                                    end
                                else
                                    modifySound(x, "distance", 15)
                                end
                            end
    
                        else
                            time = 2000
                            modifySound(x, "position", kordinat)
                        end
                    else
                        local muzikAdi = tostring(calanMuzikler[x]["serverId"])
                        calanMuzikler[muzikAdi] = nil
                        destroySound(muzikAdi)
                    end
                end
            end
        end)
    end
end)