Config = Config or {}
Config.BlacklistedPlayers = { 
    -- Players from this list won't be able to review any business, use it to blacklist trolls who leaves negative reviews for no reason
    -- For QBCore add the citizenid
    -- For ESX the player identifier from users table (char1:example123)
    -- For your custom framework whatever identifier you use in getIdentifier export (laptop/server/framework/exports.lua)
    ['identifier123'] = true,
    ['char1:aosdhoashd'] = true,
}