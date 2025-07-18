local Config, Dealer, ContainerHeist, Banktruck, ServerHeist = lib.load('config'), lib.load('open.cl_util'), lib.load('missions.containerheist'), lib.load('missions.banktruck'), lib.load('missions.serverheist')

RegisterNetEvent('mani-weaponsdealer:client:CreateBlipForGang', Dealer.CreateBlipForMission)

local Missions = {
    ContainerHeist,
    Banktruck,
    ServerHeist,
}

RegisterNUICallback('dailyMission', function(_, cb)
    local Mission = lib.callback.await('mani-weaponsdealer:server:getMissions', false)
    if not Mission then cb({}) return end

    Mission.ExpectedItem.Label = exports['ox_inventory']:Items(Mission.ExpectedItem.Item).label

    cb(Mission)
end)

RegisterNUICallback('startMission', function(ID, cb)
    Missions[ID]()
    cb(true)
end)

RegisterNUICallback('deliverMission', function(_, cb)
    local success, msg = lib.callback.await('mani-weaponsdealer:server:deliverMission', false)
    if not success then lib.notify({ title = msg, type = 'error' }) return cb(false) end

    lib.notify({ title = 'Mission færdiggjort', type = 'success' })
    cb(true)
end)