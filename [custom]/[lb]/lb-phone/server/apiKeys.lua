-- Webhook for instapic posts, recommended to be a public channel
INSTAPIC_WEBHOOK = ""
-- Webhook for birdy posts, recommended to be a public channel
BIRDY_WEBHOOK = ""
-- Discord webhook for server logs
LOGS = {
    Default = "", -- set to false to disable
    Calls = "",
    Messages = "",
    InstaPic = "",
    Birdy = "",
    YellowPages = "",
    Marketplace = "",
    Mail = "",
    Wallet = "",
    DarkChat = "",
    Services = "",
    Crypto = false,
    Trendy = "",
    Uploads = "" -- all camera uploads will go here
}

DISCORD_TOKEN = "" -- you can set a discord bot token here to get the players discord avatar for logs

-- Set your API keys for uploading media here.
-- Please note that the API key needs to match the correct upload method defined in Config.UploadMethod.
-- The default upload method is Fivemanage
-- We STRONGLY discourage using Discord as an upload method, as uploaded files may become inaccessible after a while.
-- You can get your API keys from https://fivemanage.com/
-- A video tutorial for how to set up Fivemanage can be found here: https://www.youtube.com/watch?v=y3bCaHS6Moc
API_KEYS = {
    Video = "",
    Image = "",
    Audio = "",
}
