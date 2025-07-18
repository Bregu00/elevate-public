Config = {}

Config.NotificationType = 'native' -- native/custom (native means built in notify from the radar itself, custom will mean it'll use ShowNotification function)

Config.ReopenRadarAfterLeave = true -- true/false (if true, the radar will automatically reopen when you re-enter a vehicle after leaving it)

-- Restrict opening the radar to a certain class of vehicle
Config.RestrictToVehicleClass = {
    Enable = true, -- true/false
    Class = 18 -- Police vehicles (18)
}

Config.Keybinds = {
    ToggleRadar = 'F7',             -- Toggle radar on/off
    Interact = 'Y',                 -- Interact with radar UI
    SaveReading = 'J',              -- Save current reading
    LockRadar = 'PERIOD',           -- Lock/unlock radar
    SelectFront = 'LEFT',           -- Select front radar
    SelectRear = 'RIGHT',           -- Select rear radar
    ToggleLog = 'I',                -- Toggle log panel
    ToggleBolo = 'O',               -- Toggle BOLO list
    ToggleKeybinds = false          -- Toggle keybinds display
}

-- Speed multiplier (2.23694 for MPH, 3.6 for KMH)
Config.SpeedMultiplier = 3.6

-- Update interval in ms
Config.UpdateInterval = 300

-- Radar detection ranges
Config.FrontDetectionRange = 105.0
Config.RearDetectionRange = 90.0
