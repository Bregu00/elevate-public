RegisterNetEvent("jg-dealerships:client:purchase-vehicle:config", function(vehicle, plate, purchaseType, amount, paymentMethod, financed)

end)

RegisterNetEvent("jg-dealerships:client:start-test-drive:config", function(vehicle, plate)
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  
  if vehicle and vehicle ~= 0 then
    SetVehicleModKit(vehicle, 0)
    SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) -- Engine
    SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) -- Brakes
    SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false) -- Transmission
    ToggleVehicleMod(vehicle, 18, true) -- Turbo
    
    Framework.Client.Notify("Køretøjet har maks specs!", "success")
  else
    Framework.Client.Notify("Fejl!", "error")
  end
end)

RegisterNetEvent("jg-dealerships:client:sell-vehicle:config", function(vehicle, plate)
  --
  -- Add code here to run before the vehicle is deleted
  --

  deleteVehicle(vehicle) -- this runs Kimi's AdvancedParking export already! 
end)

RegisterNetEvent("jg-dealerships:client:showroom-pre-check", function(dealershipId, cb)
  local res = lib.callback.await("jg-dealerships:server:showroom-pre-check", false, dealershipId) -- You can also do some server-side/database checks. This callback can be found in config-sv.lua
  if not res then return cb(false) end

  local allowed = true
  
  -- Write some code here. Update the "allowed" variable to true or false :)
  -- This would typically be used to check you have a license, for example

  if not allowed then
    Framework.Client.Notify("You are not allowed to access the showroom", "error")
    return cb(false)
  end
  
  return cb(true)
end)
