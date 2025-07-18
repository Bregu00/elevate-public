local bolos = {}

CreateThread(function()
    while true do
        bolos = {}
        local plates = MySQL.query.await('SELECT plate FROM population_vehicles')

        for i = 1, #plates do
            bolos[#bolos + 1] = plates[i].plate
        end
        Wait(3600000)
    end
end)

lib.callback.register('sd-policeradar:server:returnBolos', function()
    return bolos
end)