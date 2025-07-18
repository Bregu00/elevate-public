Config = Config or {}
Config.Events = { -- Used to create zones
    -- key index needs to be the item type
    -- label: string (except for cashiers, it uses table)
    -- icon: "string" (except for cashiers, it uses table)
    -- job: boolean (job restricted zone)
    -- icons are from the free section in fontawesome website: https://fontawesome.com/search?m=free&o=r
    ['cashier'] = { label = {employee = "Cashier", customer = "Pay"}, icon = { employee = "fas fa-cash-register", customer = "fas fa-credit-card" }, job = true},
    ['drink'] = { label = "Drinks", event = "av_business:products", icon = "fas fa-glass-whiskey", job = true },
    ['food'] = { label = "Food", event = "av_business:products", icon = "fas fa-utensils", job = true },
    ['joint'] = { label = "Joint", event = "av_business:products", icon = "fas fa-cannabis", job = true },
    ['alcohol'] = { label = "Alcohol", event = "av_business:products", icon = "fa-solid fa-wine-glass", job = true },
    ['others'] = { label = "Others", event = "av_business:products", icon = "fas fa-box", job = true },
    ['stash'] = { label = "Stash", event = "av_business:stash", icon = "fas fa-box-open", job = true },
    ['tray'] = { label = "Tray", event = "av_business:tray", icon = "fas fa-box-open", job = false },
    ['rate'] = { label = "Rate", event = "av_business:rate", icon = "fas fa-star", job = false },
    ['duty'] = { label = "Duty", event = "av_business:duty", icon = "fa-solid fa-briefcase", job = true },
    ['applications'] = { label = "Applications", event = "av_business:applications", icon = "fa-solid fa-briefcase", job = false  },
    ['box'] = { label = "Boxes", event = "av_business:products", icon = "fa-solid fa-box", job = true  },
    ['orders'] = { label = "Orders", event = "av_business:orders", icon = "fa-solid fa-clipboard-list", job = true  },
}

Config.OnUseEvents = { 
    -- event: Client side event triggered when a player consumes an item from this script
    -- remove: remove item on use?
    ['drink'] = {event = "av_business:consumable", remove = true}, -- this event is on client/editable/items.lua
    ['food'] = {event = "av_business:consumable", remove = true}, -- this event is on client/editable/items.lua
    ['joint'] = {event = "av_business:consumable", remove = true}, -- this event is on client/editable/items.lua
    ['alcohol'] = {event = "av_business:consumable", remove = true}, -- this event is on client/editable/items.lua
    ['box'] = {event = "av_business:box", remove = false}, -- this event is on client/editable/items.lua
}