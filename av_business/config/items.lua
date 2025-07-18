Config = Config or {}
Config.itemsWhitelist = {
    -- This whitelist is for items that already exist in your Framework and u want the business to be able to craft it on their menus
    -- value: how the item is named in your Framework/inventory
    -- label: how the business boss will see it in the app
    -- jobs: authorized jobs that can add this item to their menus
    -- type: table with ItemTypes that are compatible with this item (for example milk can be compatible with drink but also with food)
    -- override: true/false, if true it will use av_business effects/animations, if you have this same item registered in a different script leave it as false
    
    { value = "water", label = "Water", jobs = { "burgershot", "uwu_cafe", "upnatom" }, type = {"drink"}, override = false },
--    { value = "milk", label = "Milk", jobs = { "burgershot", "uwu_cafe" }, type = {"drink", "food"}, override = false },
}

-- Item types
Config.ItemTypes = { -- Used for Create Item in Laptop APP
    -- You can job restrict or use false so everyone can use it
    { value = "drink",   label = "Drink", jobs = false },
    { value = "food",    label = "Food", jobs = false  },
    { value = "joint",   label = "Joint", jobs = false  },
    { value = "others",  label = "Others", jobs = false  },
    { value = "box",     label = "Boxes", jobs = false  },
    { value = "alcohol", label = "Alcohol", jobs = false  },
--    { value = "example",    label = "Example Item Type", jobs = {"police", "ambulance"}  },
}

Config.DefaultItemWeight = 5000 -- Just in case the item type isn't defined in the following table
Config.ItemsWeight = {
    ['drink'] = 1000,           -- 1kg
    ['food'] = 1000,            -- 1kg
    ['joint'] = 1000,           -- 1kg
    ['others'] = 1000,          -- 1kg
    ['box'] = 5000,             -- 5kg
}