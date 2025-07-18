-- IMPORTANT, IF YOU ARE GONNA EDIT THIS FUNCTIONS MAKE SURE THEY RETURN TRUE/FALSE
-- IMPORTANT, IF YOU ARE GONNA EDIT THIS FUNCTIONS MAKE SURE THEY RETURN TRUE/FALSE
-- IMPORTANT, IF YOU ARE GONNA EDIT THIS FUNCTIONS MAKE SURE THEY RETURN TRUE/FALSE

--[[
    THIS IS LOCKPICK MINIGAME & CONFIG
    How minigames works can be found here: https://docs.byte-labs.net/bl_ui/games
]]
local lockpick = {
    [1] = function(iterations, difficulty)
        return exports['bl_ui']:CircleProgress(iterations, difficulty)
    end,
    [2] = function(iterations, difficulty)
        return exports['bl_ui']:Progress(iterations, difficulty)
    end,
    [3] = function(iterations, difficulty)
        return exports['bl_ui']:KeySpam(iterations, difficulty)
    end,
}

local lockpick_settings = {
    ['D'] = {iterations = 2, difficulty = 55},
    ['C'] = {iterations = 3, difficulty = 60},
    ['B'] = {iterations = 4, difficulty = 70},
    ['A'] = {iterations = 5, difficulty = 75},
    ['A+'] = {iterations = 6, difficulty = 80},
    ['S'] = {iterations = 6, difficulty = 85},
    ['S+'] = {iterations = 7, difficulty = 85},
}

function lockpickMinigame(vehicle,class)
    local random = math.random(1,3) -- picks a random minigame from minigames table (1-3)
    local data = lockpick_settings[class]
    if not data then
        print("lockpickMinigame() received a class that doesn't exists in lockpick_settings(?)", class )
        return false 
    end
    return lockpick[random] and lockpick[random](data['iterations'], data['difficulty']) or false
end

--[[
    THIS IS TRACKER MINIGAME & CONFIG
    How minigame works can be found here: https://docs.byte-labs.net/bl_ui/hacking/DigitDazzle
]]
local hacking_settings = {
    ['D'] = {iterations = 1, length = 3, duration = 60},
    ['C'] = {iterations = 1, length = 4, duration = 60},
    ['B'] = {iterations = 2, length = 4, duration = 60},
    ['A'] = {iterations = 2, length = 5, duration = 60},
    ['A+'] = {iterations = 3, length = 6, duration = 55},
    ['S'] = {iterations = 3, length = 6, duration = 50},
    ['S+'] = {iterations = 4, length = 7, duration = 50},
}

function trackingMinigame(vehicle,class)
    local settings = hacking_settings[class] or false
    if not settings then
        print("trackingMinigame() received a class that doesn't exists in hacking_settings(?)", class )
        return false 
    end
    return exports['bl_ui']:DigitDazzle(settings['iterations'], {
        length = settings['length'],
        duration = settings['duration'] * 1000,
    })
end