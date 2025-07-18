Config = Config or {}

Config.Seconds = function(seconds) return seconds * 1000 end
Config.Minutes = function(minutes) return minutes * 60 * 1000 end
Config.Hours = function(hours) return hours * 3600 * 1000 end
Config.Days = function(days) return days * 86400 * 1000 end