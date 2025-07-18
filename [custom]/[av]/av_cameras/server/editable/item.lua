function useCamera(source,item,info)
    local name = item and item.name or info and info.name
    dbug('useCamera, item: ', name)
    if (not photoToken and not videoToken) or (photoToken == "" and videoToken == "") then
        print("^3[WARNING] Add your token(s) in server/editable/token.lua^7")
        print("^3[WARNING] Add your token(s) in server/editable/token.lua^7")
        print("^3[WARNING] Add your token(s) in server/editable/token.lua^7")
        return
    end
    if Config.Items[name] then
        TriggerClientEvent('av_cameras:useCamera', source, photoToken, name)
    else
        print("^3[WARNING] Item "..name.." doesn't exist in Config.Items^7")
    end
end

function useKit(source,item,info)
    dbug("useKit item")
    TriggerClientEvent('av_cameras:useKit', source)
end

function useJammer(source,item,info)
    dbug('useJammer item')
    local ped = GetPlayerPed(source)
    if ped ~= 0 then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle and vehicle ~= 0 then
            local plates = GetVehicleNumberPlateText(vehicle)
            local res = blockVehicle(plates) -- returns true/false just in case u want to do something extra here
            if res then
                TriggerClientEvent('av_laptop:notification',source,Lang['app_title'], Lang['camera_jammed'], 'success')
            else

            end
        else
            TriggerClientEvent('av_laptop:notification',source,Lang['app_title'],Lang['not_in_vehicle'],"error")
        end
    end
end