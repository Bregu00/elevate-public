-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/

Config = {}
Config.Debug = false
Config.ItemName = "cd" -- cd item name
Config.Discman = "discman" -- item name or false to allow player to use CDs directly
Config.MetadataImageField = "imageurl" -- used for ox_inventory custom images, not sure if other inventories supports this (?)
Config.RemoveAfter = 7 -- remove playlist without any activity in the last X days to free some space
Config.MaxSongsInPlaylist = 30 -- max songs a playlist can have, higher number = playlist will take a little more time to load
Config.MouseKey = 'INSERT' -- Key used to enable mouse for mini player (every player can change it from keybinds menu)
Config.HeadphonesItem = "headphones" -- Item used to listen music connected to laptop / can't be false
Config.UseAnimation = true -- enable default headphones prop and animation (client/editable/headphones.lua)

Config.App = {
    name = "music",
    label = "Music", -- You can rename the app by editing this field
    isEnabled = function()
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end