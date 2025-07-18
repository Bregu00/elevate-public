Config = Config or {}

Config.RemoveVestTime = 5000
Config.RemovePlateTime = 1000 -- Time in milliseconds per plate.

Config.LagSwitchLevel = 4 -- The higher the more likely it will be to return false positives // the lower the more likely it will be not to detect lag switches

Config.Armor = { -- Remember to create items per armor type.
    armor = {
        plateLimit = 4,
        useTime = 1800,
    },
    policearmor = {
        plateLimit = 4,
        useTime = 1800,
        job = 'police', -- Can also be a table of jobs. { 'police', 'sherrif' }
    }
}

Config.Plates = { -- Remember to create items per plate type.
    plate = {
        armor = 25, -- Remember to match item default durability.
        useTime = 1350,
        animation = {
            dict = 'mani@plateanimations',
            anim = 'equip_b_clip',
            loop = false
        },
    },
    policeplate = {
        armor = 25,
        useTime = 1100,
        animation = {
            dict = 'mani@plateanimations',
            anim = 'equip_a_clip',
            loop = false
        },
        job = 'police', -- Can also be a table of jobs. { 'police', 'sherrif' }
    },
}

Config.RepairNPC = {
    model = 'S_M_M_AmmuCountry',
    coords = vec4(5189.63, -5131.75, 3.34, 130.37),
    route = {
        vec4(5191.59, -5133.53, 3.34, 254.39),
        vec4(5195.98, -5133.72, 3.35, 257.34),
    },
    repairTime = 1000, -- * Time per percentage repaired.
    price = 1500, -- * Price per percentage repaired.
    moneyTypes = {'black_money', 'money'},
}

Config.Keybinds = {
    removeVest = '9', -- false to disable
    removePlates = '0',
    equipPlate = 'G',
}

Config.Commands = {
    removevest = 'removevest', -- false to disable
    removeplates = 'removeplates',
}