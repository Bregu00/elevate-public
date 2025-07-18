if Config.Garage ~= 'standalone' then
    return
end

function TriggerHouseUpdateGarage()
    return
end

CreateThread(function()
    local isTextUI = false

    while true do
        local waitTime = 1500
        local ped = cache.ped
        local pos = GetEntityCoords(ped)
        if CurrentHouse ~= nil and CurrentHouseData.haskey and Config.Houses and Config.Houses[CurrentHouse] and Config.Houses[CurrentHouse].garage then
            local dist = GetDistanceBetweenCoords(pos, Config.Houses[CurrentHouse].garage.x, Config.Houses[CurrentHouse].garage.y, Config.Houses[CurrentHouse].garage.z, true)
            if dist < 10.0 then
                waitTime = 0
                local vehicle = GetVehiclePedIsIn(ped, false)
                if vehicle and vehicle ~= 0 then
                    DrawMarker(25, Config.Houses[CurrentHouse].garage.x, Config.Houses[CurrentHouse].garage.y, Config.Houses[CurrentHouse].garage.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 0, 255, 255, 100, false, true, 2, false, nil, nil, false)
                else
                    DrawMarker(36, Config.Houses[CurrentHouse].garage.x, Config.Houses[CurrentHouse].garage.y, Config.Houses[CurrentHouse].garage.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
                if dist < 2.0 then
                    if Config.Houses[CurrentHouse].garage and Config.Houses[CurrentHouse].garage.x and Config.Houses[CurrentHouse].garage.y and Config.Houses[CurrentHouse].garage.z then
                        if vehicle and vehicle ~= 0 then
                            if not isTextUI then
                                lib.showTextUI("Tryk [E] for at parkere dit Køretøj i Garagen.", { icon = 'square-parking' })
                                isTextUI = true
                            end
                            if IsControlJustPressed(0, Keys['E']) or IsDisabledControlJustPressed(0, Keys['E']) then
                                TriggerEvent("elevate_garage:parkVehicle", vehicle, "privatHus")
                            end
                        else
                            if not isTextUI then
                                lib.showTextUI("Tryk [E] for at tage et Køretøj ud af Garagen.", { icon = 'square-parking' })
                                isTextUI = true
                            end
                            if IsControlJustPressed(0, Keys['E']) or IsDisabledControlJustPressed(0, Keys['E']) then
                                TriggerEvent("elevate_garage:openGarage", "privatHus", true)
                            end
                        end
                    end
                elseif isTextUI then
                    lib.hideTextUI()
                    isTextUI = false
                end
            elseif isTextUI then
                lib.hideTextUI()
                isTextUI = false
            end
        elseif isTextUI then
            lib.hideTextUI()
            isTextUI = false
        end
        Wait(waitTime)
    end
end)