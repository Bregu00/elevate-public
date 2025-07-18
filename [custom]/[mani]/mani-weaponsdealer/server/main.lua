local Config, Dealer = lib.load('config'), lib.load('open.sv_util')

local MissionBackup = table.clone(Config.Missions)

local PedCoords = Config.NPCSpawns[math.random(1, #Config.NPCSpawns)]

local Gangs, GangCache = {}, {}

local maxCost = 0

local LootedEntities, GlobalMissions = {}, {}

local MigrateTable = {
    ['sns'] = { category = 'Handguns', item = 'weapon_snspistol' },
    ['ceramic'] = { category = 'Handguns', item = 'weapon_ceramicpistol' },
    ['pistol'] = { category = 'Handguns', item = 'weapon_pistol' },
    ['vintage'] = { category = 'Handguns', item = 'weapon_vintagepistol' },
    ['xm'] = { category = 'Handguns', item = 'weapon_pistolxm3' },
    ['pistol50'] = { category = 'Handguns', item = 'weapon_pistol50' },
    ['navy'] = { category = 'Handguns', item = 'weapon_navyrevolver' },
    ['heavy'] = { category = 'Handguns', item = 'weapon_revolver' },
    ['pump'] = { category = 'Shotguns', item = 'weapon_pumpshotgun' },
    ['plate'] = { category = 'Misc', item = 'plate' },
}

CreateThread(function()
    for category, weapons in pairs(Config.Stock) do
        for weapon, data in pairs(weapons) do
            maxCost = maxCost + (data.Price * data.Stock[#data.Stock])
        end
    end
end)

local function getLevel(xp)
    for i = 1, #Config.Levels do
        if xp >= Config.Levels[i][1] and xp <= Config.Levels[i][2] then
            return i
        end
    end

    return #Config.Levels
end

local function RegisterGang(name)
    local missionIndex = math.random(1, #Config.Missions)

    Gangs[name] = {
        XP = 0,
        Deliveries = {},
        Mission = missionIndex
    }

    MySQL.insert('INSERT INTO `weapondealer_gangs` (gang, xp, mission) VALUES (?, ?, ?)', { name, 0, missionIndex })
end

local function CreateBlipForGang(coords, gang)
    local Members = ESX.GetExtendedPlayers('job', gang)
    if not Members then return end

    for Member = 1, #Members do
        local xPlayer = Members[Member]
        TriggerClientEvent('mani-weaponsdealer:client:CreateBlipForGang', xPlayer.source, coords, 515, 'Våbenlevering')
    end
end

local function getDeliveryVehicle(cost)
    if cost <= maxCost * 0.25 then
        return 'burrito'
    elseif cost > maxCost * 0.25 and cost <= maxCost * 0.5 then
        return 'mule2'
    elseif cost > maxCost * 0.5 then
        return 'pounder'
    end
end

local function RefreshMissions()
    for gang, data in pairs(Gangs) do
        local missionIndex = math.random(1, #Config.Missions)

        Gangs[gang]['Mission'] = missionIndex

        MySQL.update.await('UPDATE `weapondealer_gangs` SET `mission` = ? WHERE `gang` = ?', {missionIndex, gang})

        Wait(100)
    end
end

local function RemoveTimeDelivery(gang, time)
    local newTime = Gangs[gang]['Deliveries'][#Gangs[gang]['Deliveries']].Droptime - time
    Gangs[gang]['Deliveries'][#Gangs[gang]['Deliveries']].Droptime = newTime

    MySQL.update.await('UPDATE `weapondealer_drops` SET `droptime` = ? WHERE `id` = ?', {newTime, Gangs[gang]['Deliveries'][#Gangs[gang]['Deliveries']].Id})
end

local function RemoveMission(gang)
    Gangs[gang].Mission = nil
    MySQL.update.await('UPDATE `weapondealer_gangs` SET `mission` = ? WHERE `gang` = ?', {0, gang})
end

local function VerifyJob(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local job = xPlayer.getJob()
    if not job.isgang then Dealer.ACLog(src, ('[%s - %s] Kørte en våbenhandler funktion uden at være et gang. (Job: %s)'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: UD73' end
    if not Gangs[job.name] then RegisterGang(job.name) end

    return job, nil, xPlayer
end

local function AddXP(src, gang, amount)
    Gangs[gang]['XP'] = Gangs[gang]['XP'] + amount
    MySQL.update.await('UPDATE `weapondealer_gangs` SET `xp` = ? WHERE `gang` = ?', {Gangs[gang]['XP'], gang})
end

MySQL.ready(function()
    MySQL.query('SELECT * FROM `weapondealer_gangs`', function(response)
        if response then
            for i = 1, #response do
                local row = response[i]
                Gangs[row.gang] = {
                    XP = row.xp,
                    Deliveries = {},
                    Mission = row.mission ~= 0 and row.mission or nil
                }
            end
        end

        MySQL.query('SELECT * FROM `weapondealer_drops`', function(response)
            if response then
                for i = 1, #response do
                    local row = response[i]
                    if Gangs[row.gang] then
                        Gangs[row.gang]['Deliveries'][#Gangs[row.gang]['Deliveries'] + 1] = {
                            Id = row.id,
                            Droptime = row.droptime,
                            Order = json.decode(row.order),
                            Price = row.price,
                            Collected = row.collected == 1 and true or false
                        }
                    end
                end
            end
        end)

        if not Config.Migrate then return end

        MySQL.query('SELECT * FROM `bandelevel`', function(response)
            if response then
                for i = 1, #response do
                    local row = response[i]
                    Gangs[row.gang] = Gangs[row.gang] or {
                        XP = 0,
                        Deliveries = {},
                        Mission = nil
                    }
                    Gangs[row.gang]['XP'] = row.repitation
    
                    MySQL.Async.execute('DELETE FROM `bandelevel` WHERE `gang` = ?', {row.gang})
                    MySQL.insert('INSERT INTO `weapondealer_gangs` (gang, xp, mission) VALUES (?, ?, ?)', { row.gang, row.repitation, 0 })
                end
            end
    
            MySQL.query('SELECT * FROM `weapondrops`', function(response)
                if response then
                    for i = 1, #response do
                        local row = response[i]
                        MySQL.Async.execute('DELETE FROM `weapondrops` WHERE `id` = ?', {row.id})
                        if Gangs[row.gang] then
                            local Order = json.decode(row.items)
                            local NewOrder = {}
        
                            for i = 1, #Order do
                                local MigrateData = MigrateTable[Order[i].item]
                                if MigrateData then
                                    NewOrder[i] = { id = i, weapon = MigrateData.item, category = MigrateData.category, amount = Order[i].amount, price = Config.Stock[MigrateData.category][MigrateData.item]['Price'] }
                                end
                            end
        
                            local id = MySQL.insert.await('INSERT INTO `weapondealer_drops` (`gang`, `order`, `droptime`, `price`, `collected`) VALUES (?, ?, ?, ?, ?)', {
                                row.gang,
                                json.encode(NewOrder),
                                row.droptime,
                                row.price,
                                row.hasCollected or 0
                            })
        
                            if id then
                                Gangs[row.gang]['Deliveries'][#Gangs[row.gang]['Deliveries'] + 1] = {
                                    Id = id,
                                    Droptime = row.droptime,
                                    Order = NewOrder,
                                    Price = row.price,
                                    Collected = (row.hasCollected and row.hasCollected == 1) and true or false
                                }
                            end
                        end
                    end
                end
            end)
        end)
    end)
end)

lib.callback.register('mani-weaponsdealer:server:getPedCoords', function()
    return PedCoords
end)

lib.callback.register('mani-weaponsdealer:server:getXP', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    return Gangs[job.name]['XP']
end)

lib.callback.register('mani-weaponsdealer:server:getMissions', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    if Gangs[job.name].MissionActive then return { Mission = Gangs[job.name].MissionActive, ExpectedItem = Config.Missions[Gangs[job.name].MissionActive].ExpectedItem } end

    return Config.Missions[Gangs[job.name]['Mission']] or false
end)

lib.callback.register('mani-weaponsdealer:server:placeOrder', function(source, weapons)
    local src = source
    local job, errorMsg, xPlayer = VerifyJob(src)
    if not job then return false, errorMsg end
    if not job.grade_name == 'boss' then return false, 'Kun ledelsen af din bande kan gøre dette' end

    local CurrentDeliveries = Gangs[job.name]['Deliveries']

    if next(CurrentDeliveries) and not CurrentDeliveries[#CurrentDeliveries].Collected then return false, 'Du har allerede en aktiv bestilling' end

    local Level = getLevel(Gangs[job.name]['XP'])

    local total = 0
    for i = 1, #weapons do
        local Category = weapons[i].category
        if not Category then return false, 'Der skete en fejl: UK13' end
        local Weapon = weapons[i].weapon
        if not Weapon then return false, 'Der skete en fejl: UW14' end
        local MaxAmount = Config.Stock[Category][Weapon]['Stock'][Level]
        if not MaxAmount then return false, 'Der skete en fejl: UA15' end
        local Amount = weapons[i].amount
        if not Amount then return false, 'Der skete en fejl: UA16' end
        local Price = Config.Stock[Category][Weapon]['Price']
        if not Price then return false, 'Der skete en fejl: UP17' end

        if Amount > MaxAmount then Dealer.ACLog(src, ('[%s - %s] Prøvede at bestille mere end man burde - %sx %s'):format(src, GetPlayerName(src), Amount, Weapon)) return false, 'Der skete en fejl: UA18' end

        total = total + (Price * Amount)
    end

    local DropTime = os.time() + (Config.Cooldown / 1000)

    local playerMoney = xPlayer.getAccount('money').money

    if playerMoney < total then return false, ('Du mangler %s DKK'):format(ESX.Math.GroupDigits(total - playerMoney)) end

    local id = MySQL.insert.await('INSERT INTO `weapondealer_drops` (`gang`, `order`, `droptime`, `price`) VALUES (?, ?, ?, ?)', {
        job.name,
        json.encode(weapons),
        DropTime,
        total
    })

    if not id then return false, 'Der skete en fejl: UK38' end

    xPlayer.removeMoney(total)

    Gangs[job.name]['Deliveries'][#Gangs[job.name]['Deliveries'] + 1] = {
        Id = id,
        Droptime = DropTime,
        Order = weapons,
        Price = total,
        Collected = false
    }

    Dealer.Log(src, ('[%s - %s] Har placeret en bestilling på %s DKK (%s)'):format(src, GetPlayerName(src), ESX.Math.GroupDigits(total), job.name), {
        content = json.encode(weapons),
        name = 'Bestilling.txt'
    })

    return true
end)

lib.callback.register('mani-weaponsdealer:server:getOrders', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    return Gangs[job.name]['Deliveries']
end)

lib.callback.register('mani-weaponsdealer:server:verifyPickup', function(source, orderId)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end
    if not job.grade_name == 'boss' then return false, 'Kun ledelsen af din bande kan gøre dette' end

    local Order = Gangs[job.name]['Deliveries'][#Gangs[job.name]['Deliveries'] - orderId]

    if not Order then return false, 'Der skete en fejl: UP19' end
    
    if Order.Droptime > os.time() then return false, 'Din bestilling er ikke klar' end
    
    if Order.Collected then return false, 'Du har allerede hentet din bestilling' end

    Gangs[job.name]['Deliveries'][#Gangs[job.name]['Deliveries'] - orderId].Collected = true
    MySQL.update.await('UPDATE `weapondealer_drops` SET `collected` = 1 WHERE `id` = ?', {Order.Id})

    local CurrentOrder = Order.Order

    local location = Config.DeliveryLocations[math.random(1, #Config.DeliveryLocations)]

    CreateBlipForGang(location, job.name)

    local vehicleModel = getDeliveryVehicle(Order.Price)

    local vehicle = CreateVehicle(GetHashKey(vehicleModel), location.x, location.y, location.z, location.w, true, false)

    while not DoesEntityExist(vehicle) do Wait(100) end

    CreateThread(function()
        local plate = GetVehicleNumberPlateText(vehicle)

        while not exports['ox_inventory']:GetInventory(('trunk%s'):format(plate), false) do Wait(100) end

        for Order = 1, #CurrentOrder do
            local OrderConfig = Config.Stock[CurrentOrder[Order].category][CurrentOrder[Order].weapon]
            local Amount = CurrentOrder[Order].amount
    
            exports['ox_inventory']:AddItem(('trunk%s'):format(plate), OrderConfig.Item, Amount)

            Wait(100)
        end

        Dealer.Log(src, ('[%s - %s] Har hentet en bestilling (%s)'):format(src, GetPlayerName(src), job.name), {
            content = json.encode(CurrentOrder),
            name = 'Bestilling.txt'
        })
    end)

    return true
end)

local function StartMission(src, gang, mission)
    if Gangs[gang]['Deliveries'][#Gangs[gang]['Deliveries']].Collected then return false, 'Du har ingen aktiv bestilling' end

    if not Gangs[gang].Mission or Gangs[gang].Mission ~= mission then
        Dealer.ACLog(src, ('[%s - %s] Startede Mission (%s) uden at have missionen. (Job: %s)'):format(src, GetPlayerName(src), mission, gang))
        return false, 'Der skete en fejl: TJ48'
    end

    local Members = ESX.GetExtendedPlayers('job', gang)
    if not Members then return false end

    GangCache[gang] = { Members = {}, Mission = mission }

    for Member = 1, #Members do
        local xPlayer = Members[Member]
        if xPlayer.getJob().grade > 0 then
            GangCache[gang].Members[#GangCache[gang].Members + 1] = xPlayer.source
        end
    end

    if #GangCache[gang].Members < Config.MemberReq then return false end

    Dealer.Log(src, ('[%s - %s] Har startet en mission (%s)'):format(src, GetPlayerName(src), Config.Missions[mission].Label))

    return true
end

lib.callback.register('mani-weaponsdealer:server:verifyContainerStart', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end
    if not job.grade_name == 'boss' then return false, 'Kun ledelsen af din bande kan gøre dette' end

    if not next(Config.Missions[1].Locations) then Config.Missions[1].Locations = MissionBackup[1].Locations end

    local Index = math.random(1, #Config.Missions[1].Locations)
    local Location = Config.Missions[1].Locations[Index]
    table.remove(Config.Missions[1].Locations, Index)

    local success, msg = StartMission(src, job.name, 1)
    if not success then return false, msg end

    for Member = 1, #GangCache[job.name].Members do
        TriggerClientEvent('mani-weaponsdealer:client:CreateBlipForGang', GangCache[job.name].Members[Member], Location.Prop, 478, 'Container Heist')
    end

    RemoveMission(job.name)
    Gangs[job.name].MissionActive = 1

    return Location
end)

lib.callback.register('mani-weaponsdealer:server:verifyBanktruckStart', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end
    if not job.grade_name == 'boss' then return false, 'Kun ledelsen af din bande kan gøre dette' end

    local MissionData = Config.Missions[2]

    local success, msg = StartMission(src, job.name, 2)
    if not success then return false, msg end

    for Member = 1, #GangCache[job.name].Members do
        TriggerClientEvent('mani-weaponsdealer:client:CreateBlipForGang', GangCache[job.name].Members[Member], MissionData.Coords, 67, 'Banktruck Heist')
    end

    RemoveMission(job.name)
    Gangs[job.name].MissionActive = 2

    return true
end)

lib.callback.register('mani-weaponsdealer:server:verifyServerStart', function(source)
    local src = source

    if GlobalMissions['ServerHeist'] then return false, 'Server Heist er allerede aktiv - Vent venligst' end

    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end
    if not job.grade_name == 'boss' then return false, 'Kun ledelsen af din bande kan gøre dette' end

    local success, msg = StartMission(src, job.name, 3)
    if not success then return false, msg end

    for Member = 1, #GangCache[job.name].Members do
        TriggerClientEvent('mani-weaponsdealer:client:StartServerHeist', GangCache[job.name].Members[Member])
    end

    RemoveMission(job.name)
    Gangs[job.name].MissionActive = 3

    GlobalMissions['ServerHeist'] = { Active = false, Locations = {} }
    SetTimeout(Config.Missions[3].Cooldown, function()
        GlobalMissions['ServerHeist'] = nil
    end)

    return true
end)

lib.callback.register('mani-weaponsdealer:server:openContainer', function(source)
    local src = source

    return exports['ox_inventory']:RemoveItem(src, Config.ItemConfig['AngleGrinder'].Item, 1)
end)

lib.callback.register('mani-weaponsdealer:server:openCrate', function(source, netid)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    local crate = NetworkGetEntityFromNetworkId(netid)
    if not DoesEntityExist(crate) then return false, 'Der skete en fejl: HK85' end
    if GetEntityModel(crate) ~= GetHashKey('xm3_prop_xm3_crate_01a') then Dealer.ACLog(src, ('[%s - %s] Kørte "openContainer" på en prop der ikke var en container (Job: %s) - Våbenhandler'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: UJ37' end

    if not job.isgang then Dealer.ACLog(src, ('[%s - %s] Kørte en våbenhandler funktion uden at være et gang. (Job: %s)'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: EJ38' end

    if not Gangs[job.name].MissionActive or Gangs[job.name].MissionActive ~= 1 then Dealer.ACLog(src, ('[%s - %s] Våbenhandler - Forsøgte at færdiggøre en mission uden at være i en mission (Job: %s)'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: KH37' end

    if LootedEntities[netid] then return false, 'Dette er allerede gjort' end

    LootedEntities[netid] = true

    local Expected = Config.Missions[1].ExpectedItem

    exports['ox_inventory']:AddItem(src, Expected.Item, Expected.Amount)
    Dealer.Log(src, ('[%s - %s] Har åbnet en crate - Modtog %sx %s (Våbenmateriale Heist)'):format(src, GetPlayerName(src), Expected.Amount, Expected.Item))

    return true
end)

lib.callback.register('mani-weaponsdealer:server:deliverMission', function(source)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    if not Gangs[job.name].MissionActive then Dealer.ACLog(src, ('[%s - %s] Våbenhandler - Forsøgte at færdiggøre en mission uden at være i en mission (Job: %s)'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: DJ27' end

    if not exports['ox_inventory']:RemoveItem(src, Config.Missions[Gangs[job.name].MissionActive].ExpectedItem.Item, Config.Missions[Gangs[job.name].MissionActive].ExpectedItem.Amount) then return false, ('Du mangler %sx %s'):format(Config.Missions[Gangs[job.name].MissionActive].ExpectedItem.Amount, Config.Missions[Gangs[job.name].MissionActive].ExpectedItem.Item) end

    local Reward = Config.Missions[Gangs[job.name].MissionActive].Reward

    RemoveTimeDelivery(job.name, Reward)

    Dealer.Log(src, ('[%s - %s] Har aflevert en mission - Reward: %s Sekunder'):format(src, GetPlayerName(src), Reward))

    Gangs[job.name].MissionActive = nil

    return true
end)

lib.callback.register('mani-weaponsdealer:server:deliverXPItem', function(source, item)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    if not Config.XPItems[item] then Dealer.ACLog(src, ('[%s - %s] Forsøgte at aflevere et item, der ikke er gyldigt (%s)'):format(src, GetPlayerName(src), item)) return false, 'Der skete en fejl: JD48' end

    local itemAmount = exports['ox_inventory']:Search(src, 'count', item)
    if not itemAmount then return false, ('Du mangler %s'):format(item) end

    if not exports['ox_inventory']:RemoveItem(src, item, itemAmount) then return false, ('Du mangler %s'):format(item) end

    local XPAmount = math.floor(itemAmount * Config.XPItems[item].Reward)

    AddXP(src, job.name, XPAmount)

    return XPAmount, Gangs[job.name]['XP']
end)

lib.callback.register('mani-weaponsdealer:server:getServerHeistData', function(source)
    local src = source

    if GlobalMissions['ServerHeist'].Active then
        while not next(GlobalMissions['ServerHeist'].Locations) do Wait(100) end
        return false, GlobalMissions['ServerHeist']
    else
        if not next(GlobalMissions['ServerHeist']) then return false, nil, 'Der skete en fejl: DJ28' end

        GlobalMissions['ServerHeist'].Active = true

        local Locations = {}
        local Chosenlocations = {}

        for i = 1, Config.Missions[3].ServerAmount do
            local index = math.random(1, #Config.Missions[3].Location.ServerLocations)
            while Chosenlocations[index] do
                index = math.random(1, #Config.Missions[3].Location.ServerLocations)
            end
            Locations[#Locations + 1] = { Hacked = false, Coords = Config.Missions[3].Location.ServerLocations[index] }
            Chosenlocations[index] = true
        end

        GlobalMissions['ServerHeist'].Locations = Locations

        return true, GlobalMissions['ServerHeist']
    end
end)

lib.callback.register('mani-weaponsdealer:server:verifyServerHack', function(source, index)
    local src = source

    if GlobalMissions['ServerHeist'].Locations[index].Hacked then return false, 'Denne server er allerede hacket' end
    if index ~= 1 and not GlobalMissions['ServerHeist'].Locations[index - 1].Hacked then return false, ('Du skal hacket server %s først'):format(index - 1) end

    return true
end)

lib.callback.register('mani-weaponsdealer:server:hackedServer', function(source, index)
    local src = source
    local job, errorMsg = VerifyJob(src)
    if not job then return false, errorMsg end

    if not Gangs[job.name].MissionActive or Gangs[job.name].MissionActive ~= 3 then Dealer.ACLog(src, ('[%s - %s] Forsøgte at hacket en server uden at være i en server heist (Job: %s)'):format(src, GetPlayerName(src), job.name)) return false, 'Der skete en fejl: BU87' end

    if GlobalMissions['ServerHeist'].Locations[index].Hacked then return false, 'Denne server er allerede hacket' end
    if index ~= 1 and not GlobalMissions['ServerHeist'].Locations[index - 1].Hacked then return false, ('Du skal hacket server %s først'):format(index - 1) end

    GlobalMissions['ServerHeist'].Locations[index].Hacked = true

    local Expected = Config.Missions[3].ExpectedItem

    exports['ox_inventory']:AddItem(src, Expected.Item, 1)
    Dealer.Log(src, ('[%s - %s] Har åbnet en crate - Modtog 1x %s (Server Heist)'):format(src, GetPlayerName(src), Expected.Item))

    return true
end)

CreateThread(function()
    if Config.Debug then Wait(1000) RefreshMissions() end

    for i = 1, #Config.RefreshMissions do
        local v = Config.RefreshMissions[i]
        lib.cron.new(('%s %s * * *'):format(v.Minute, v.Hour), RefreshMissions)
    end
end)

local function RegisterWeaponUsableItem(caseConfig)
    ESX.RegisterUsableItem(caseConfig.label, function(source)
        if not exports['ox_inventory']:RemoveItem(source, caseConfig.label, 1) then return end
        exports['ox_inventory']:AddItem(source, caseConfig.give, caseConfig.amount)
        exports['ox_inventory']:AddItem(source, caseConfig.ammoItem, 30)
    end)
end