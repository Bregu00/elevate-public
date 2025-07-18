local vehicles = {}

CreateThread(function()
    local result = exports['oxmysql']:executeSync('SELECT * FROM dealership_vehicles')
    for i,v in pairs(result) do
        vehicles[tostring(v.hashkey)] = v
    end
end)

exports('getVehicleFromHash', function(hash)
    return vehicles[tostring(hash)]
end)