local Config = lib.load('config')
if Config.Framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

local AmmoTypes = {
    [GetHashKey('WEAPON_SNSPISTOL')] = 'ammo',
    [GetHashKey('WEAPON_PISTOL')] = 'ammo',
    [GetHashKey('WEAPON_CERAMICPISTOL')] = 'ammo',
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'ammo',
    [GetHashKey('WEAPON_PISTOLXM3')] = 'ammo',
    [GetHashKey('WEAPON_PISTOL50')] = 'ammo',
    [GetHashKey('WEAPON_NAIVYREVOLVER')] = 'ammo',
    [GetHashKey('WEAPON_REVOLVER')] = 'ammo',
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'ammo2',
    [GetHashKey('WEAPON_COMBATPISTOL')] = 'ammo',
    [GetHashKey('WEAPON_HEAVYPISTOL')] = 'ammo',
    [GetHashKey('WEAPON_SMG')] = 'ammo',
    [GetHashKey('WEAPON_CARBINERIFLE')] = 'ammo',
}

RegisterNetEvent('esx:playerLoaded', function()
    CreateThread(function()
        while not DoesEntityExist(PlayerPedId()) do Wait(100) end
        Mani_Hud:Initiate()
    end)
end)

AddEventHandler('esx_status:onTick', function(data)
	for i = 1, #data do
		if data[i].name == 'hunger' then
			Mani_Hud.Hunger = math.floor(data[i].percent)
        elseif data[i].name == 'thirst' then
			Mani_Hud.Thirst = math.floor(data[i].percent)
        end
	end
end)

local function GetAccounts(accounts)
    local Accounts = {}
    for i = 1, #accounts do
        Accounts[accounts[i].name] = accounts[i].money
    end
    return Accounts
end

function Mani_Hud:GetFuel()
    if not cache.vehicle then return 0 end
    return Entity(cache.vehicle).state.fuel
end

function Mani_Hud:UpdatePlayerData()
    local PlayerData = ESX.GetPlayerData()
    local Job = PlayerData.job
    local Accounts = GetAccounts(PlayerData.accounts)

    self.PlayerData = {
        Job = Job.label,
        Grade = Job.grade_label,
        Money = math.floor(Accounts.money),
        BlackMoney = math.floor(Accounts.black_money),
        Bank = math.floor(Accounts.bank)
    }
end

function Mani_Hud:GetAmmoCount(weapon)
    return exports['ox_inventory']:Search('count', AmmoTypes[weapon]) or 0
end

RegisterNetEvent('pma-voice:setTalkingMode', function(range)
    Mani_Hud.VoiceRange = range
end)