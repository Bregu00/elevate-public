Config = Config or {}

Config.MaxAlliances = 3

Config.AlertGang = 100              -- Percentage for alerting gang members

Config.MaximumPoints = 5000         -- Maximum points a gang can have
Config.PointsAddAmount = 1          -- How many points to add when selling drugs
Config.PointsRemoveAmount = 1       -- How many points to remove when a opposing gang member is selling drugs

Config.PopularDrugMultiplier = 1.25 -- Multiplier for popular drugs
Config.OwnedZoneMultiplier = 1.25   -- Multiplier for selling in your own zone

Config.AdminCommand = 'admin:zones'  -- Admin command to open the admin menu
Config.ZoneCommand = 'zone'         -- Command to open the zone menu

-- Math Example: Config.ReducePointsAmount = 1
-- Note: This is per 10 minutes and will be rounded to the nearest whole number

-- Per minute: Config.Config.ReducePointsAmount / Config.ReducePointsCheck = 0.1
-- Per hour: 60 / Config.ReducePointsCheck * Config.ReducePointsAmount = 6
-- Per day: 60 * 24 / Config.ReducePointsCheck * Config.ReducePointsAmount = 144
-- Per week: 60 * 24 * 7 / Config.ReducePointsCheck * Config.ReducePointsAmount = 1008
-- Per month: 60 * 24 * 30 / Config.ReducePointsCheck * Config.ReducePointsAmount = 4320
Config.ReducePointsEnabled = false
Config.ReducePointsCheck = 30      -- How often in minutes to check for reducing points rounds to nearest whole number
Config.ReducePointsTimer = 6       -- How long in hours before the points start to reduce
Config.ReducePointsAmount = 1      -- Will run every 10 minutes and remove Config.ReducePointsAmount points

Config.PhoneContactName = 'Ukendt' -- Name of the contact in the phone when alerting gang members

Config.AllowedGroups = { -- Groups for admin menu
    'god',
    'admin',
}

Config.Zones = {
    ['AIRP'] = 'Los Santos International Airport',
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr',
    ['BANNING'] = 'Banning',
    ['BEACH'] = 'Vespucci Beach',
    ['BHAMCA'] = 'Banham Canyon',
    ['BRADP'] = 'Braddock Pass',
    ['BRADT'] = 'Braddock Tunnel',
    ['BURTON'] = 'Burton',
    ['CALAFB'] = 'Calafia Bridge',
    ['CANNY'] = 'Raton Canyon',
    ['CCREAK'] = 'Cassidy Creek',
    ['CHAMH'] = 'Chamberlain Hills',
    ['CHIL'] = 'Vinewood Hills',
    ['CHU'] = 'Chumash',
    ['CMSW'] = 'Chiliad Mountain State Wilderness',
    ['CYPRE'] = 'Cypress Flats',
    ['DAVIS'] = 'Davis',
    ['DELBE'] = 'Del Perro Beach',
    ['DELPE'] = 'Del Perro',
    ['DELSOL'] = 'La Puerta',
    ['DESRT'] = 'Grand Senora Desert',
    ['DOWNT'] = 'Downtown',
    ['DTVINE'] = 'Downtown Vinewood',
    ['EAST_V'] = 'East Vinewood',
    ['EBURO'] = 'El Burro Heights',
    ['ELGORL'] = 'El Gordo Lighthouse',
    ['ELYSIAN'] = 'Elysian Island',
    ['GALFISH'] = 'Galilee',
    ['GOLF'] = 'GWC and Golfing Society',
    ['GRAPES'] = 'Grapeseed',
    ['GREATC'] = 'Great Chaparral',
    ['HARMO'] = 'Harmony',
    ['HAWICK'] = 'Hawick',
    ['HORS'] = 'Vinewood Racetrack',
    ['HUMLAB'] = 'Humane Labs and Research',
    ['JAIL'] = 'Bolingbroke Penitentiary',
    ['KOREAT'] = 'Little Seoul',
    ['LACT'] = 'Land Act Reservoir',
    ['LAGO'] = 'Lago Zancudo',
    ['LDAM'] = 'Land Act Dam',
    ['LEGSQU'] = 'Legion Square',
    ['LMESA'] = 'La Mesa',
    ['LOSPUER'] = 'La Puerta',
    ['MIRR'] = 'Mirror Park',
    ['MORN'] = 'Morningwood',
    ['MOVIE'] = 'Richards Majestic',
    ['MTCHIL'] = 'Mount Chiliad',
    ['MTGORDO'] = 'Mount Gordo',
    ['MTJOSE'] = 'Mount Josiah',
    ['MURRI'] = 'Murrieta Heights',
    ['NCHU'] = 'North Chumash',
    ['NOOSE'] = 'N.O.O.S.E',
    ['OCEANA'] = 'Pacific Ocean',
    ['PALCOV'] = 'Paleto Cove',
    ['PALETO'] = 'Paleto Bay',
    ['PALFOR'] = 'Paleto Forest',
    ['PALHIGH'] = 'Palomino Highlands',
    ['PALMPOW'] = 'Palmer-Taylor Power Station',
    ['PBLUFF'] = 'Pacific Bluffs',
    ['PBOX'] = 'Pillbox Hill',
    ['PROCOB'] = 'Procopio Beach',
    ['RANCHO'] = 'Rancho',
    ['RGLEN'] = 'Richman Glen',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills',
    ['RTRAK'] = 'Redwood Lights Track',
    ['SANAND'] = 'San Andreas',
    ['SANCHIA'] = 'San Chianski Mountain Range',
    ['SANDY'] = 'Sandy Shores',
    ['SKID'] = 'Mission Row',
    ['SLAB'] = 'Stab City',
    ['STAD'] = 'Maze Bank Arena',
    ['STRAW'] = 'Strawberry',
    ['TATAMO'] = 'Tataviam Mountains',
    ['TERMINA'] = 'Terminal',
    ['TEXTI'] = 'Textile City',
    ['TONGVAH'] = 'Tongva Hills',
    ['TONGVAV'] = 'Tongva Valley',
    ['VCANA'] = 'Vespucci Canals',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm',
    ['WVINE'] = 'West Vinewood',
    ['ZANCUDO'] = 'Zancudo River',
    ['ZP_ORT'] = 'Port of South Los Santos',
    ['ZQ_UAR'] = 'Davis Quartz',
}

exports("getZoneLabel", function(zone)
    return Config.Zones[zone]
end)

Config.PopularZoneDrugs = {
    ['AIRP'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['ALTA'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['ARMYB'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['BANNING'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['BEACH'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['BURTON'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['CHAMH'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['CHIL'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['CHU'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['CYPRE'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['DAVIS'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['DELBE'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['DELPE'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['DELSOL'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['DOWNT'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['DTVINE'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['EAST_V'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['EBURO'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['ELYSIAN'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['GOLF'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['GRAPES'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['HARMO'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['HAWICK'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['HORS'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['HUMLAB'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['JAIL'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['KOREAT'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['LEGSQU'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['LMESA'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['LOSPUER'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['MIRR'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['MORN'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['MOVIE'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['MURRI'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['PALETO'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['PBLUFF'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['PBOX'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['RANCHO'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['RGLEN'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['RICHM'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['ROCKF'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['SANDY'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['SKID'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['SLAB'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['STAD'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['STRAW'] = {
        ['kanyleindhold'] = true,
        ['pakket_heroin'] = true,
    },
    ['TEXTI'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['VCANA'] = {
        ['posekokain'] = true,
        ['pakket_kokain'] = true,
    },
    ['VESP'] = {
        ['posemeth'] = true,
        ['pakket_meth'] = true,
    },
    ['VINE'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
    ['WVINE'] = {
        ['joint'] = true,
        ['pakket_skunk'] = true,
    },
}