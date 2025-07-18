Config = {}
Config.Debug = false -- Prints some info in F8 and server console, useful to find possible bugs or report something
Config.Identifier = "steam" -- Identifier type ID you wanna use for players, https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/
Config.SettingsCommand = "multicharacter" -- Command used to open the multicharacter menu, let your players to select their preferred scene and/or vehicle
Config.EditorCommand = "multi:editor" -- Opens the scene editor
Config.CoordsCommand = "multi:copy" -- Copy your current ped coords
Config.AdminGroup = {"group.admin", "group.god"} -- Groups allowed to use editor command
Config.ESXPrefix = "char" -- Only for ESX, prefix used for player identifier (prefix + slot, e.g. char1:licensexxxxx, char2:licensexxxxxx)
Config.RelogCommand = false -- or false to disable it
Config.RelogGroups = {"group.admin", "group.god"} -- ACE Groups allowed to use relogcommand
Config.DefaultSpawns = {
    vec4(110.11, -1085.46, 29.19, 339.64),
    vec4(-1037.52, -2737.40, 13.78, 328.94),
    vec4(-267.67, -959.07, 31.22, 204.99),
    vec4(222.70, -898.93, 30.69, 323.55),
    vec4(237.51, -406.21, 47.92, 337.88),
    vec4(473.11, -110.53, 62.75, 167.18),
    vec4(-541.54, -210.27, 37.64, 209.91),
    vec4(-920.99, -723.28, 19.90, 0.246 ),
    vec4(-1700.56, -1091.73, 13.15, 49.64),
    vec4(-773.87, -1277.47, 5.15, 169.80),
    vec4(-215.24, -1505.78, 31.49, 356.29),
    vec4(287.12, -1586.09, 30.52, 5.01),
    vec4(559.95, -1760.65, 29.16, 243.90),

} -- x, y, z, heading... default spawn after character register

-- Character slots config
Config.Slots = {
    default = 2, -- The default character slots a player can own by default
    max = 4, -- Max slots a player can own, no matter if he bought them or is using VIP or whatever, X is the limit
}

-- Only for ESX, tables to wipe when a character is deleted
Config.DeleteTables = {
    ['addon_account_data'] = "owner",
    ['av_boosting'] = "identifier",
    ['av_racing_profiles'] = "identifier",
    ['billing'] = "identifier",
    ['bn_crafting_players'] = "identifier",
    ['dunski_balances'] = "player_identifier",
    ['dunski_bets'] = "player_identifier",
    ['dunski_deposits'] = "player_identifier",
    ['dunski_stats'] = "player_identifier",
    ['lbtablet_police_accounts'] = "id",
    ['lbtablet_tablets'] = "id",
    ['lunar_contracts_profiles'] = "identifier",
    ['lunar_multijob'] = "identifier",
    ['lunar_multijob_duty'] = "identifier",
    ['mani_metadata'] = "identifier",
    ['owned_vehicles'] = "owner",
    ['phone_backups'] = "id",
    ['phone_phones'] = "id",
    ['player_houses'] = "owner",
    ['policeloadouts'] = "`char`",
    ['rcore_clothing_current'] = "identifier",
    ['rcore_clothing_outfits'] = "identifier",
    ['rcore_clothing_purchased'] = "identifier",
    ['refunds'] = "identifier",
    ['users'] = "identifier",
    ['vehiclewarehouse'] = "identifier",
    ['warehouse'] = "identifier",
    ['population'] = "steamid",
    ['av_cameras'] = "owner",
    ['ox_inventory'] = "owner",
}

-- Used for debug prints, don't modify anything from here...
function dbug(...)
    if Config.Debug then print('^3[DEBUG]^7', ...) end
end

function warn(...)
    print('^1[WARNING]^7', ...)
end