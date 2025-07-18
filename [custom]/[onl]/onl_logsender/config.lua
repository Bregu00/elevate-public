Config = {}

-- Loki settings
Config.LokiEnabled = true
Config.LokiUrl = "" -- Adjust to your Loki host/port
Config.LokiToken = ""
-- Discord settings
Config.DiscordEnabled = true
Config.DiscordWebhook = "" -- Default Discord webhook URL
Config.DiscordColor = 3447003 -- Default blue

-- Default Loki labels
Config.DefaultLabels = {
    job = "fivem_script",
    env = "production"
}

Config.ServerIcon = "https://i.imgur.com/NBvrV8p.png" -- Footer icon URL
Config.ServerLogo = "" -- Thumbnail URL
Config.DefaultPlayerIcon = "https://i.imgur.com/NBvrV8p.png" -- Default player icon URL
