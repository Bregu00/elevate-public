lib.onCache('vehicle', function(vehicle)
    local ped = PlayerPedId()
    while IsPedInAnyVehicle(ped, false) do
        local sleep = 100
        if GetPedInVehicleSeat(vehicle, 0) == ped and GetIsTaskActive(ped, 165) then
            sleep = 0
            SetPedIntoVehicle(ped, vehicle, 0)
            SetPedConfigFlag(ped, 184, true)
        end
        Wait(sleep)
    end
end)

RegisterCommand("s", function(dinmor, args)
    local seat = args[1] - 2
    local ped = PlayerPedId()
    local isDead = exports["ars_ambulancejob"]:isDead()
    if isDead then lib.notify({ title = 'Du er død', type = 'error' }) return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then lib.notify({ title = 'Du er ikke i et køretøj', type = 'error' }) return end
    if seat < -1 or seat > GetVehicleMaxNumberOfPassengers(vehicle) - 1 then lib.notify({ title = 'Dette sæde eksistere ikke', type = 'error' }) return end
    TaskWarpPedIntoVehicle(ped, vehicle, seat)
end, false)

RegisterCommand("d", function(dinmor, args)
    local door = tonumber(args[1]) - 1
    local ped = PlayerPedId()
    local isDead = exports["ars_ambulancejob"]:isDead()
    if isDead then lib.notify({ title = 'Du er død', type = 'error' }) return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not vehicle then  lib.notify({ title = 'Du er ikke i et køretøj', type = 'error' }) return  end
    if door < 0 or door > GetNumberOfVehicleDoors(vehicle) - 1 then lib.notify({ title = 'Denne dør eksisterer ikke', type = 'error' }) return end
    SetVehicleDoorOpen(vehicle, door, false, false)
end, false)