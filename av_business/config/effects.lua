Config = Config or {}
Config.DefaultEffects = { -- If the item doesn't have ingredients or the ingredients don't trigger any effect we will use this based on the item type
    ['drink'] = function()
        exports['av_laptop']:addMetadata("thirst", 50) -- adds 50 points to thirst
    end,
    ['food'] = function()
        exports['av_laptop']:addMetadata("hunger", 50) -- adds 50 points to hunger
    end,
    ['alcohol'] = function()
        CreateThread(function()
            alcohol(30)
        end) -- Trigger an alcohol effect for 30 seconds)
    end,
    ['joint'] = function()
        CreateThread(function()
            drugs(30) -- Trigger a drug effect for 30 seconds
        end) 
    end,
}
Config.Effects = { -- each index key is an ingredient
    -- ['milk'] = function()   -- ingredient name
    --     exports['av_laptop']:addMetadata("thirst", 100)
    --     -- exports['ps-buffs']:AddStressBuff(30000, 10) -- the buff to trigger, this is just an example using ps-buffs
    -- end,
    -- ['chocolate'] = function()  -- ingredient name
    --     exports['av_laptop']:addMetadata("thirst", 100) -- u can trigger anything u want
    --     -- exports['ps-buffs']:AddHealthBuff(10000, 10) -- the buff to trigger, this is just an example using ps-buffs
    -- end,
    -- ['ice'] = function()  -- ingredient name
    --     exports['av_laptop']:addMetadata("thirst", 25) -- u can trigger anything u want
    --     -- exports['ps-buffs']:AddHealthBuff(10000, 10) -- the buff to trigger, this is just an example using ps-buffs
    -- end,
    -- ['water'] = function()  -- ingredient name
    --     -- exports['ps-buffs']:AddArmorBuff(30000, 10)  -- the buff to trigger, this is just an example using ps-buffs
    -- end,
}
