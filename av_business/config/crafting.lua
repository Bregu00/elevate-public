Config = Config or {}
-- Crafting Options
Config.CraftingLabel = Lang['crafting']                       -- Default label for progressbar
Config.CraftingTime = 5000                                    -- Default 5 seconds
Config.CraftingDict = "anim@amb@business@coc@coc_unpack_cut@" -- Default Animation dictionary
Config.CraftAnimation = "fullcut_cycle_v6_cokecutter"         -- Default Animation

Config.Crafting = {
    ['drink'] = {
        label = Lang['crafting'], -- label for progressbar
        duration = 5000, -- ms
        dict = "anim@amb@business@coc@coc_unpack_cut@", -- anim dictionary
        animation = "fullcut_cycle_v6_cokecutter" -- anim name
    },
    ['food'] = {
        label = Lang['crafting'], -- label for progressbar
        duration = 5000, -- ms
        dict = "anim@amb@business@coc@coc_unpack_cut@", -- anim dictionary
        animation = "fullcut_cycle_v6_cokecutter" -- anim name
    },
    ['alcohol'] = {
        label = Lang['crafting'], -- label for progressbar
        duration = 5000, -- ms
        dict = "anim@amb@business@coc@coc_unpack_cut@", -- anim dictionary
        animation = "fullcut_cycle_v6_cokecutter" -- anim name
    },
    ['joint'] = {
        label = Lang['crafting'], -- label for progressbar
        duration = 5000, -- ms
        dict = "anim@amb@business@coc@coc_unpack_cut@", -- anim dictionary
        animation = "fullcut_cycle_v6_cokecutter" -- anim name
    },
}

Config.MaxItemsPerCraft = { -- Max items player can craft at the same time
    -- boxes need a serial number, if u craft more than 1 at the same time the serial will be duplicated, to prevent it we need to craft 1 box at the time
    ['box'] = 1,
}