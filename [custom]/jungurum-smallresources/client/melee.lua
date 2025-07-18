Citizen.CreateThread(function()
    while true do
        SetWeaponDamageModifier("WEAPON_NIGHTSTICK", 0.25) 
        Wait(0)
        SetWeaponDamageModifier("WEAPON_BAT", 0.69)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_COLBATON", 0.25)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_HAMMER", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_GOLFCLUB", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_CROWBAR", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_POOLCUE", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_STONE_HATCHET", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_WRENCH", 0.45)
        Wait(0)
        SetWeaponDamageModifier("WEAPON_UNARMED", 0.1) 
        Wait(0)
        SetWeaponDamageModifier("WEAPON_KNUCKLE", 0.35) 
        -- fjerner npc weapon drops
        Wait(0)
        RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
        Wait(0)
        RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        Wait(0)
        RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
        Citizen.Wait(100)
    end
end)

local relationshipTypes = {
    'GANG_1',
    'GANG_2',
    'GANG_9',
    'GANG_10',
    'AMBIENT_GANG_LOST',
    'AMBIENT_GANG_MEXICAN',
    'AMBIENT_GANG_FAMILY',
    'AMBIENT_GANG_BALLAS',
    'AMBIENT_GANG_MARABUNTE',
    'AMBIENT_GANG_CULT',
    'AMBIENT_GANG_SALVA',
    'AMBIENT_GANG_WEICHENG',
    'AMBIENT_GANG_HILLBILLY',
    'DEALER',
    'COP',
    'PRIVATE_SECURITY',
    'SECURITY_GUARD',
    'ARMY',
    'MEDIC',
    'FIREMAN',
    'HATES_PLAYER',
    'NO_RELATIONSHIP',
    'SPECIAL',
    'MISSION2',
    'MISSION3',
    'MISSION4',
    'MISSION5',
    'MISSION6',
    'MISSION7',
    'MISSION8'
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for _, group in ipairs(relationshipTypes) do
            SetRelationshipBetweenGroups(1, GetHashKey('PLAYER'), GetHashKey(group)) 
            SetRelationshipBetweenGroups(1, GetHashKey(group), GetHashKey('PLAYER'))
        end
    end
end)

local unarmedCount, nightstickCount = 0, 0
local randomCount = math.random(1, 100)

local timerCount = 0
local TimeoutCounter = {}

CreateTimeout = function(msec, cb)
    local id = timerCount + 1

    SetTimeout(msec, function()
        if TimeoutCounter[id] then
            TimeoutCounter[id] = nil
        else
            cb()
        end
    end)

    timerCount = id

    return id
end

DeleteTimeout = function(id)
    if TimeoutCounter[id] then 
        TimeoutCounter[id] = true
    end
end

random = function(x, y)
    return math.random(x, y)
end

local weaponTimeOuts = {}
local rageWeapons = {
    [`WEAPON_UNARMED`] = { ragTimes = {7500, 14000}, neededCount = 7, chance = 65 },
    [`WEAPON_NIGHTSTICK`] = { ragTimes = {7500, 14000}, neededCount = 1, chance = 75 },
    [`WEAPON_COLBATON`] = { ragTimes = {7500, 14000}, neededCount = 1, chance = 75 },
    -- [`WEAPON_FLASHLIGHT`] = { ragTimes = {7500, 14000}, neededCount = 4, chance = 75 },
    -- [`WEAPON_KNUCKLE`] = { ragTimes = {7500, 14000}, neededCount = 4, chance = 60 },
    -- [`WEAPON_POOLCUE`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
    -- [`WEAPON_HAMMER`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
    -- [`WEAPON_BAT`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
    -- [`WEAPON_GOLFCLUB`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
    -- [`WEAPON_CROWBAR`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
    -- [`WEAPON_WRENCH`] = { ragTimes = {7500, 14000}, neededCount = 3, chance = 60 },
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        for weaponHash, data in pairs(rageWeapons) do
            if HasPedBeenDamagedByWeapon(playerPed, weaponHash, 0) then
                local weaponHitted = LocalPlayer.state[weaponHash] or 0
                weaponHitted = weaponHitted + 1
                ClearEntityLastDamageEntity(playerPed)

                if weaponHitted == 1 then
                    weaponTimeOuts[weaponHash] = CreateTimeout(300000, function()
                        weaponHitted = 0
                    end)
                end

                LocalPlayer.state:set(weaponHash, weaponHitted, true)

                if weaponHitted >= data.neededCount and not LocalPlayer.state.isDead then
                    if not data.chance or (data.chance and WeaponKnockoutChance(data.chance)) then
                        DeleteTimeout(weaponTimeOuts[weaponHash])
                        LocalPlayer.state:set(weaponHash, 0, true)
        
                        DoScreenFadeOut(1000)
                        ClearEntityLastDamageEntity(playerPed)

                        local ragTime = random(data.ragTimes[1], data.ragTimes[2])
                        SetPedToRagdoll(playerPed, ragTime, ragTime, 0, 0, 0, 0)
                        Citizen.Wait(ragTime)

                        DoScreenFadeIn(1000)
                    end
                end
            end
        end
    end
end)

WeaponKnockoutChance = function(number)
    math.randomseed(GetGameTimer() + math.random(1, 99999))
    local random = math.random(1, 100)

    print("Chance : " .. random .. " <= " .. number)

    if random <= number then
        return true
    else
        return false
    end
end
