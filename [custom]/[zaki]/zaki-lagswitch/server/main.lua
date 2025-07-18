local pingThreshold = 350
local spikeCountThreshold = 3
local checkInterval = 2000

local playerSpikes = {}
local webhookUrl = "https://discord.com/api/webhooks/1342603085725433947/_QVg1Co6xottWMpPTY4aCn8oGjtgiogebvLz1TfnXqRkuwJgG6_yT9UFUYimoW3HkW0D"

function checkPlayerPing(playerId)
    local ping = GetPlayerPing(playerId)
    if ping > pingThreshold then
        if playerSpikes[playerId] == nil then
            playerSpikes[playerId] = 1
        else
            playerSpikes[playerId] = playerSpikes[playerId] + 1
        end

        local identifiers = GetPlayerIdentifiers(playerId)
        local identifierString = table.concat(identifiers, "\n")

        if playerSpikes[playerId] >= spikeCountThreshold then
            sendToDiscord("Mulig lag-switch", "Spiller ID: [" .. playerId .. " / " .. GetPlayerName(playerId) .. "] med en ping på " .. ping .. "ms\nIdentifiers:\n" .. identifierString)
            playerSpikes[playerId] = 0 
        end
    else
        playerSpikes[playerId] = 0
    end
end

function sendToDiscord(name, message)
    local embed = {
        {
            ["title"] = name,
            ["description"] = message,
            ["color"] = 16711680 
        }
    }
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

CreateThread(function()
    while true do
        Wait(checkInterval)
        local players = GetPlayers()
        for i=1, #players do
            checkPlayerPing(players[i])
        end
    end
end)