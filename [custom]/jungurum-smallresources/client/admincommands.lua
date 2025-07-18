-- -- Max Mods
-- local mods = { 11, 12, 13, 15, 16 }
-- local function UpgradePerformance(vehicle)
--     SetVehicleModKit(vehicle, 0)
--     ToggleVehicleMod(vehicle, 18, true)
--     SetVehicleFixed(vehicle)

--     for _, modType in ipairs(mods) do
--         local maxMod = GetNumVehicleMods(vehicle, modType) - 1
--         SetVehicleMod(vehicle, modType, maxMod, false)
--     end

--     lib.notify({title = 'Dit køretøj er nu fulltuned', type = 'success'})
-- end


-- RegisterCommand('fulltune', function(source, args)
--     local playerPed = PlayerPedId()
--     local vehicle = GetVehiclePedIsIn(playerPed, false)
--     local xPlayer = ESX.GetPlayerData()
--     if not xPlayer.group == "god" then
--         lib.notify({title = 'Du er ikke staff', type = 'error'})
--         return
--     end
--     if not IsPedInAnyVehicle(playerPed, false) then
--         lib.notify({title = 'Du er ikke i et køretøj', type = 'error'})
--         return
--     end

--     UpgradePerformance(vehicle)
-- end, false)

RegisterCommand('clothing', function(source, args)
    TriggerEvent('rcore_clothing:openChangingRoom')
end, false)