-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- DISCORD CONFIG IS INSIDE SERVER/FRAMEWORK/_DISCORD.LUA
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
Config = {}
Config.Debug = false
Config.App = {
    name = "boosting",
    label = "Boosting", -- You can rename the app by editing this field
    isEnabled = function()
        return exports['av_laptop']:hasItem('black_usb')
    end
}
Config.DebugCommand = "boosting:debug" -- Debug vehicle list and verify if all models exists in game (run this command if you update the vehicle list to verify the model names)
Config.Admin = "god" -- Permission needed to access CreateContract command
Config.CreateContract = "boosting:contract" -- Command used to create and give contracts to specific players
Config.MaxVinVehicles = 3 -- Max vinscratched vehicles a player can own, set false to ignore this limit
Config.CrackerItem = "transponder" -- Used to open vehicles, don't use your current lockpick item
Config.TrackerItem = "hackingdevice" -- Item used to disable GPS from vehicles
Config.MaxUsernameCharacters = 20 -- Max characters an username can have
Config.CryptoAccount = "crypto" -- Crypto used for APP
Config.PoliceJobName = "police" -- Police job name or job type (for qb core), can be just a string or a table {"police", "bcso", "leo"}
Config.PoliceRadiusCheck = 25.0 -- Distance check for cops around you
Config.MaxContractsPerPlayer = 4 -- Max contracts a player can own at the same time
Config.QueueTime = 1 -- Every X minutes send contracts to random players in queue
Config.MaxMembers = 4 -- Max members per boosting group
Config.HackingCooldown = 10 -- In milliseconds (10 seconds), is the cooldown after using the hack device (police won't receive veh blip during cooldown)
Config.DeliveryBlip = {
    sprite = 225,
    color = 2,
    scale = 0.8
}
Config.MinSpeedHack = 30 -- Min speed needed to start hacking the vehicle (in miles)
Config.MaxSContracts = 5 -- Max S contracts per server restart (for all users)
Config.MaxSPlusContracts = 2 -- Max S+ contracts per server restart (for all users)
Config.GuardModels = {`g_m_importexport_01`, `g_m_m_chicold_01`, `g_m_y_armgoon_02`, `s_m_y_dealer_01`, `s_m_y_robber_01`}
Config.GuardSpawn = {-15,15} -- Distance for guards spawn, -15 mts behind - 15 mts in front of player ped, the guard will spawn inside that range
Config.RemoveVinMoneyAtBeginning = false -- True if you want to remove the vin money at the beginning of the contract, false it will remove money right before the player scratches the vin
Config.DeliveryTime = 60 -- (in minutes) Time a player have to complete the contract, if they deliver after X minutes they will NOT receive any money/vehicle
Config.AuctionTime = 30 -- (in minutes) Auction time
Config.AuctionExtraTime = 60 -- (in minutes) After the auction ends and we get a winner, this time will be set to the contract expiration