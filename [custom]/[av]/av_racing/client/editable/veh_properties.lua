function GetVehicleProperties(vehicle)
    if not vehicle then return end
    return exports['av_laptop']:getVehicleProperties(vehicle)
end

function SetVehicleProperties(vehicle,props)
    if not vehicles or not properties then return end
    exports['av_laptop']:setVehicleProperties(vehicle,props)
end