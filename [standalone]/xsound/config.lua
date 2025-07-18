Config = {} -- Do not touch this

--[[----------------------------------->
   Please note, this config file is only visible for the server-side, so don't be scared to put your API keys inside the GetYoutubeMP3 function, as dumpers won't be able to see this code.
   3D Configuration starts below.
---------------------------------------]]

Config.EnableUpdateNotifications = true -- Enable messages informing about new updates available in the server console?
Config.RefreshTime = 100 --[[ In miliseconds
You can put 30 for higher 3D responsiveness, but this will increase CPU usage to ~0.04ms put 90-110 for ~0.01ms cpu usage, but lower 3D responsiveness.]]

Config.MaxAudioPlayers = 5 --[[ Max audio players near you.
The max audio players works by counting how many audio players there are near you, but does not limit creating them.
For example, if there were 10 audio players near you, and another 5 appeared next to you, you won't hear these 5, unless other 5 audio players disappear.]]

Config.UseGTASetting = true -- Use GTA settings for determining the volume of audio?
Config.ProfileSetting = 306 -- By default SFX Volume setting, change to 306 for Music Volume setting.
Config.SettingMaxValue = 10 -- Do not change this if you don't change the profilesetting, SFX and Music volume max values are the same.

Config.CameraOrientation = true -- You can change this to false to have the player indicate the orientation for calculating an angle to the audio player!
Config.CameraPosition = true -- You can change this to false to have the player indicate the position of the listener for calculating the distance to the audio player!

Config.WaterIsolation = true -- Apply muffled effect on sounds played inside a car under water or sounds outside water when diving?

Config.Enable3DOwnVehicle = false -- Enable the 3D effect for audio if sitting inside the playing vehicle? Slightly better for performance when set to false and inside the playing vehicle.

Config.VehicleIsolation = true -- Apply muffled effect on sounds played inside a car that you're not in?
Config.NeverIsolatedClasses = {8, 13, 14} -- Car classes that never have the muffled sound effect.
Config.IgnoredVehicleDoors = {4} -- Only vehicle hood is ignored
Config.OutsideVehicleIsolation = true -- Isolate playing sounds outside the car when you're in inside a car?
Config.OutsideThirdPersonVehicleIsolation = false -- Isolate playing sounds outside the car when you're in first person cam inside a car?
Config.ThirdPersonIsolation = false -- Is the sound very quiet and muffled when you're inside your car in third person camera? Set to false if you want regular volume/non-muffled audio when in third person in the car that's playing the radio.

Config.MuffleEfectGain = 1.5 -- Over 1.0 = more bass to muffled sounds.

Config.DefaultDistance = 25 -- Max default distance for hearing 3D sounds, if a distance isn't set in an event.
Config.MaxDistance = 200 -- If the distance is set to more in an event to play at coords, player trying to trigger this will be reported.
Config.DefaultVolume = 1.0 -- A default volume for 3D sounds in the range of 0.0 to 1.0.

Config.LoadCurrentSoundsOnJoin = true -- Play already existing sounds before you joined? [APPLIES ONLY FOR SOUNDS PLAYED WITH SERVER-SIDE FUNCTIONS!]

-- Below is configuration for more advanced developers.
Config.SoundsFolder = "./assets/sounds/" -- Folder where all audio files are located in.
Config.SupportedAudioFormats = {"mp3", "ogg", "wav", "aac"} -- Supported audio file formats, you can add more but make sure Web Audio API supports them.
Config.BypassCopyright = true -- Enable our API and bypass copyrights for YouTube embeds?
Config.Debug = false -- If you're a developer, you can set it to true

-- Do not change these if you don't know what you're doing.
Config.WaitMaxTime = 20 -- In seconds, how long can the script wait for the song to start playing when trying to modify a YET non existing sound/returning a sound object in the Play functions.
Config.MinUpdateLength = 5 -- In seconds, how long does the audio file have to be to send its information from the NUI to LUA, it is not smart to update short sounds [send their information like duration, updating its playing state, timestamp, etc.] on servers with many players, this will heavily impact the performance of player PCs.

Config.PlayerSpawnedEvent = "esx:playerLoaded"
Config.Addons = false -- Change to true if you want to enable the exports.high_3dsounds:DurDur and other exports required by some phone scripts.
Config.Commands = {
    -- Do not rename the index, only change the name field if you want to change the command name.
    ["streamer_mode"] = {
        enabled = true,
        name = "streamermode",
        suggestion_label = "Toggle streamer mode (mutes all sounds)",
        notifications = {
            ["success_prefix"] = "^2ELEVATE",
            ["toggled_on"] = "Streamer mode er slået til!",
            ["toggled_off"] = "Streamer mode er slået fra!"
        }
    }
}