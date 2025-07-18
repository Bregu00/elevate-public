Config = Config or {}

Config.Devmode = true

Config.Minutes = function(minutes) return minutes * 60 end
Config.Hours = function(hours) return hours * (60 * 60) end
Config.Days = function(days) return days * (24 * (60 * 60)) end

-- Police Officers needed for doing action in Perico Heist.

Config.PoliceNeeded = 0

-- Checking Police only on start 
-- If this is true, it will only check police online on starting the heist.

Config.OnlyCheckOnStart = true

-- How long cooldown the heist has
-- RECOMMENDED TO ONLY HAVE 1 HEIST FOR EACH RESTART

Config.Cooldown = Config.Hours(12)

-- How long until the Jail key expires, and cannot be used again.

Config.JailKeyExpire = Config.Hours(2)

-- If you want to use Stausi interaction menu for this script, set this to false.
-- If you want to use your ox_target interaction menu, set this to true.

Config.UseOxTarget = true

-- Data about the NPC which starts the heist
-- Set MissionStartModel to false if you don't want a NPC to start the heist.
-- Use the exports.st_perico_heist:StartHeist() to start the heist.

Config.MissionStartModel = "CSB_Gustavo"
Config.startRobberyNPC = vector4(484.30, -3052.50, 5.24, 1.5)

-- Shows a list of which resources are needed in the heist.

Config.ShowListOfResourcesNeeded = true

-- Which Guards is spawned in the Hangar Pre-Heist

Config.HangarNPCGuards = {
    "G_M_M_CartelGuards_01",
    "G_M_M_CartelGuards_02",
}

-- Which weapons the Guards has in the Hangar Pre-Heist

Config.HangarNPCWeapons = {
    "WEAPON_MG",
    "WEAPON_ASSAULTRIFLE",
}

-- Which Guards is spawned in the Mansion and around

Config.MansionNPCGuards = {
    "G_M_M_CartelGuards_01",
    "G_M_M_CartelGuards_02",
}

-- Which weapons the Guards has in the Mansion and around

Config.MansionNPCWeapons = {
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_TACTICALRIFLE",
}

-- Which item is rewarded for each artifact

Config.ArtifactItems = {
    ["h4_prop_h4_art_pant_01a"] = "perico_artifacts_1",
    ["h4_prop_h4_diamond_01a"] = "perico_artifacts_2",
    ["h4_prop_h4_necklace_01a"] = "perico_artifacts_3",
    ["h4_prop_h4_t_bottle_02b"] = "perico_artifacts_4",
}

--[[
Config.Categories Explanation:

Each category defines a set of customizable properties for different handler actions in your script.
Below is a description of each configurable property:

- label:          (string) The text that appears to describe the action to the player.
- icon:           (string) The Font Awesome icon to visually represent the action in the UI.
- tableType       (string) If a table, you can set the type to either `weed`, `coke`, `gold` or `money`
- rewards:        (table) Specifies the loot items from which the player will receive rewards.
    - pool:            (table) A reward pool, it will select a random pool when rewarding the player
        - name:            (string) The item’s internal identifier.
        - amount:          (number) The quantity of the item required.
- requiredItems:  (table) A list of items needed to perform the action. Each item includes:
    - name:            (string) The item’s internal identifier.
    - amount:          (number) The quantity of the item required.
    - removeOnSucceed: (boolean, optional) Whether the item is removed upon successful action.
    - removeOnFail:    (boolean, optional) Whether the item is removed if the action fails.
    - hideOnList:      (boolean, optional) If true, hides this item from resource overview.
- alertPolice (NEW)    (boolean, optional) If true, this action will trigger the police alert in server/utils.lua

Categories:
Define common settings for similar actions to streamline configuration.
These categories are then referenced in PericoHandlers by the `category` field.
--]]

Config.Categories = {
    ["TakeKey"] = {
        label = "Tag Nøgle",
        icon = "fa-solid fa-key",
    },
    ["HackComputer"] = {
        label = "Hack Computer",
        icon = "fa-solid fa-laptop",
    },
    ["Table_1"] = { -- 4435.65869, -4446.60059, 4.25266075
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "gold",
        rewards = {
            [1] = {
                { item = "gold_bar", amount = { min = 24, max = 24 }, chance = 100 },
            },
        },
    },
    ["Table_2"] = { -- 4438.331, -4445.77539, 4.25266075
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "money",
        rewards = {
            [1] = {
                { item = "black_money", amount = { min = 1500000, max = 1500000 }, chance = 100 },
            },
        },
    },
    ["Table_3"] = { -- 4447.779, -4442.102, 7.17647648
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "coke",
        rewards = {
            [1] = {
                { item = "coke_packaged", amount = { min = 24, max = 24 }, chance = 100 },
            },
        },
    },
    ["Table_4"] = { -- 4448.776, -4444.84131, 7.17647648
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "coke",
        rewards = {
            [1] = {
                { item = "coke_packaged", amount = { min = 24, max = 24 }, chance = 100 },
            },
        },
    },
    ["ChainLock"] = {
        label = "Brænd igennem kæden",
        icon = "fa-solid fa-link",
        requiredItems = {
            { name = "blowtorch", amount = 1 },
        },
    },
    ["ElectricBox"] = {
        label = "Hack Electrik Boks",
        icon = "fa-solid fa-bolt",
        requiredItems = {
            { name = "usb_stick_2", amount = 1, removeOnSucceed = true },
        },
    },
    ["Thermite"] = {
        label = "Ødelæg Elektrisk Installation",
        icon = "fas fa-plug",
        requiredItems = {
            { name = "thermal", amount = 1, remove = true },
        },
    },
    ["Explode"] = {
        label = "Sprænge Porten",
        icon = "fa-solid fa-fire",
        requiredItems = {
            { name = "bigbomb", amount = 1, removeOnSucceed = true },
        },
    },
    ["OpenDoorKey"] = {
        label = "Åbne Dør",
        icon = "fa-solid fa-key",
        requiredItems = {
            { name = "jail_keys", amount = 1, hideOnList = true }, -- PLEASE DO NOT CHANGE - ITS A PART OF THE HEIST
        },
    },
    ["LockpickDoor"] = {
        label = "Lockpick Dør",
        icon = "fas fa-unlock-alt",
        requiredItems = {
            { name = "lockpick_advanced", amount = 1, removeOnFail = true },
        },
    },
    ["TakeCard"] = {
        label = "Tag Kort",
        icon = "fa-solid fa-sd-card",
    },
    ["OpenVault"] = {
        label = "Åbne Vault",
        icon = "fa-solid fa-wallet",
        weaponModel = "w_pi_revolver_g",
        weaponReward = "WEAPON_GADGETPISTOL",
    },
    ["TakeGun"] = {
        label = "Tag Gun",
        icon = "fa-solid fa-gun",
    },
    ["Fingerprint"] = {
        label = "Hack Keypad",
        icon = "fa-solid fa-code-simple",
        requiredItems = {
            { name = "hacking_card", amount = 1, hideOnList = true, removeOnSucceed = true },  -- PLEASE DO NOT CHANGE - ITS A PART OF THE HEIST
            { name = "phone", amount = 1 },
        },
    },
    ["Painting"] = {
        label = "Steal Painting",
        icon = "fas fa-pencil-paintbrush",
        rewards = {
            [1] = {
                { item = "painting", amount = { min = 1, max = 1 }, chance = 100 },
            },
        },
    },
    ["SafeCrack"] = {
        label = "Åbne Safe",
        icon = "fa-solid fa-lock-open",
        rewards = {
            [1] = {
                { item = "black_money", amount = { min = 1500000, max = 1500000 }, chance = 100 },
                { item = "dia_box", amount = { min = 20, max = 30 }, chance = 100 },
            },
        },
    },
    ["OpenChest"] = {
        label = "Åbne Chest",
        icon = "fa-solid fa-lock-open",
        rewards = {
            [1] = {
                { item = "black_money", amount = { min = 500000, max = 750000 }, chance = 100 },
                { item = "dia_box", amount = { min = 1, max = 2 }, chance = 30 },
            },
        },
    },
    ["GlassCut"] = {
        label = "Brænd i Display Case",
        icon = "fa-solid fa-cut",
        requiredItems = {
            { name = "glass_cutter", amount = 1 },
        },
    },
    ["Table_5"] = { -- 5029.2373, -5733.843, 17.8307419
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "gold",
        rewards = {
            [1] = {
                { item = "gold_bar", amount = { min = 24, max = 24 }, chance = 100 },
            },
        },
    },
    ["Table_6"] = { -- 4998.08057, -5752.451, 14.7928619
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "money",
        rewards = {
            [1] = {
                { item = "black_money", amount = { min = 750000, max = 750000 }, chance = 100 },
            },
        },
    },
    ["Table_7"] = { -- 5003.955, -5748.694, 14.7809343
        label = "Tag fra bord",
        icon = "fa-solid fa-sack-dollar",
        tableType = "money",
        rewards = {
            [1] = {
                { item = "black_money", amount = { min = 750000, max = 750000 }, chance = 100 },
            },
        },
    },
}
