-- This animations are triggered when the player uses a crafted item from the restaurant script, items given with admin command won't do anything...
-- Why? Because the items crafted with av_business contains metadata which is used for the script to trigger an animation or effect

Config = Config or {}
Config.DefaultAnimation = "default" -- If no animation is set, it will use this one
Config.Props = {
    -- value should match an index from Config.Animations
    -- label is how the player will see the animation option in laptop
    -- jobs is a table with the allowed jobs to use this prop/animation or false to make it available for everyone
    -- type is a table with the itemTypes that can use this animation example {"food", "drinks", "others"} or just {"food"} / false won't work here
    { value = "burger",   label = "Burger",   jobs = false, type = {"food"} },
    { value = "soda",     label = "Soda",     jobs = false, type = {"drink"} },
    { value = "sandwich", label = "Sandwich", jobs = false, type = {"food"} },
--  { value = "example_item", label = "Example Item", jobs = { "burgershot", "uwucafe" }, type = {"food"} },
}

-- I use this tool to get the prop offsets: https://forum.cfx.re/t/paid-tool-prop-attach-to-ped-tool-dev-tool/4782266
Config.Animations = {
    ["burger"] = {                                          -- same as Config.Props > value
        label = "Eating",                                    -- label for progressbar
        prop = "prop_cs_burger_01",                         -- prop name, must exist in your server - set to false if u don't want to use any prop
        dict = "mp_player_inteat@burger",                   -- animation dictionary
        animation = "mp_player_int_eat_burger",             -- animation name
        time = 5000,                                        -- animation duration
        bone = 18905,                                       -- ped bone where the prop will be attached
        offset = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },   -- prop offsets
        canWalk = true,                                     -- freeze player while using the item
        canDrive = true,                                    -- freeze player vehicle while using the item
    },
    ["soda"] = {                                            -- same as Config.Props > value
        label = "Drinking",                                  -- label for progressbar
        prop = "prop_ecola_can",                            -- prop name, must exist in your server - set to false if u don't want to use any prop
        dict = "mp_player_intdrink",                        -- animation dictionary
        animation = "loop_bottle",                          -- animation name
        time = 5000,                                        -- animation duration
        bone = 18905,                                       -- ped bone where the prop will be attached
        offset = { 0.11, -0.01, 0.03, 240.0, -30.0, -2.0 }, -- prop offsets
        canWalk = true,                                    -- freeze player while using the item
        canDrive = true,                                    -- freeze player vehicle while using the item
    },
    ["sandwich"] = {                                        -- same as Config.Props > value
        label = "Eating",                                  -- label for progressbar
        prop = "prop_sandwich_01",                          -- prop name, must exist in your server - set to false if u don't want to use any prop
        dict = "mp_player_inteat@burger",                   -- animation dictionary
        animation = "mp_player_int_eat_burger",             -- animation name
        time = 5000,                                        -- animation duration
        bone = 18905,                                       -- ped bone where the prop will be attached
        offset = { 0.13, 0.05, 0.02, -50.0, 16.0, 60.0 },   -- prop offsets
        canWalk = true,                                     -- freeze player while using the item
        canDrive = true,                                    -- freeze player vehicle while using the item
    },
    ['default'] = {
        label = "Consuming",
        prop = false,
        dict = "move_p_m_two_idles@generic",
        animation = "fidget_sniff_fingers",
        time = 5000,
        bone = false,
        offset = false,
        canWalk = true,
        canDrive = true,
    }
}
