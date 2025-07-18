local playerBets = {}
local playerBalance = 0

RegisterNetEvent('dunski-bet:refreshBettingData')
AddEventHandler('dunski-bet:refreshBettingData', function()
  TriggerServerEvent('dunski-bet:fetchBettingData')
end)

RegisterCommand('refreshbets', function()
  TriggerServerEvent('dunski-bet:fetchBettingData')
  lib.notify({
    title = Config.AppName,
    description = Config.Notifications.BetsUpdated,
    type = 'success'
  })
end)

--print("^2" .. Config.AppName .. "^7: Client initialized")
