local Config = {}

Config.Debug = false

Config.Framework = 'esx'

Config.ServerLogo = 'https://files.fivemerr.com/images/7d802115-861b-49c4-8d0a-da2ed9d6ec45.png'

Config.SpeedUnit = 'km/t'

Config.SpeedMultipler = 3.6 -- For MPH use: 2.236936

Config.Currency = {
    Symbol = ' kr.',
    Position = 'after', -- before or after
    Separator = ','
}

Config.Weapons = {
    [GetHashKey('WEAPON_SNSPISTOL')] = 'SNS Pistol',
    [GetHashKey('WEAPON_PISTOL')] = '9mm Pistol',
    [GetHashKey('WEAPON_CERAMICPISTOL')] = 'Ceramic Pistol',
    [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage Pistol',
    [GetHashKey('WEAPON_PISTOLXM3')] = 'XM3 Pistol',
    [GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
    [GetHashKey('WEAPON_NAIVYREVOLVER')] = 'Navy Revolver',
    [GetHashKey('WEAPON_REVOLVER')] = 'Heavy Revolver',
    [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pump Shotgun',
    [GetHashKey('WEAPON_COMBATPISTOL')] = 'Combat Pistol',
    [GetHashKey('WEAPON_HEAVYPISTOL')] = 'Heavy Pistol',
    [GetHashKey('WEAPON_SMG')] = 'SMG',
    [GetHashKey('WEAPON_CARBINERIFLE')] = 'Carbine Rifle',
}

Config.Commands = {
    ['toggle'] = 'togglehud'
}

Config.Intervals = {
    ['Prio'] = 800,
    ['InVehicle'] = 300,
    ['LowPrio'] = 2000
}

return Config