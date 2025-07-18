local mainserver = GetConvar("mainserver", false)

-- Logging function with flexible Discord webhook
function SendLog(source, message, options)
    if not mainserver then return end
    options = options or {}
    
    -- Fetch player details
    local playerSteamName = GetPlayerName(source) or ("ID " .. source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local fullMessage = string.format("%s[Player: %s] %s", getFormattedTime(), playerSteamName, message)
    local timestamp = tostring(os.time() * 1000000000) -- Nanoseconds for Loki
    
    -- Loki-specific labels
    local lokiLabels = {}
    local tempLabels = options.labels or {}
    if next(tempLabels) then
        lokiLabels.serverId = source
        lokiLabels.job = tempLabels.job or lokiLabels.job
        lokiLabels.script = tempLabels.script or lokiLabels.script
        lokiLabels.service_name = tempLabels.service_name or lokiLabels.service_name
        lokiLabels.discordId = tempLabels.discordId and (GetSpecificIdentifier(source, "discord") or "Not linked") or nil
        lokiLabels.steamId = tempLabels.steamId and (GetSpecificIdentifier(source, "steam") or "N/A") or nil
        lokiLabels.license = tempLabels.license and (GetSpecificIdentifier(source, "license") or "N/A") or nil
        lokiLabels.playerJob = tempLabels.playerJob and (xPlayer and xPlayer.job and xPlayer.job.name or "Unemployed") or nil
        lokiLabels.jobGrade = tempLabels.jobGrade and (xPlayer and xPlayer.job and xPlayer.job.grade or "0") or nil
        lokiLabels.playerName = tempLabels.playerName and (xPlayer and xPlayer.getName and xPlayer.getName() or playerSteamName) or nil
        lokiLabels.money = tempLabels.money and (xPlayer and xPlayer.getMoney() or 0) or nil
        lokiLabels.bank = tempLabels.bank and (xPlayer and xPlayer.getAccount('bank').money or 0) or nil
        lokiLabels.black_money = tempLabels.black_money and (xPlayer and xPlayer.getAccount('black_money').money or 0) or nil
        lokiLabels.ip = tempLabels.ip and (GetSpecificIdentifier(source, "discord") ~= "541613959929790464" and GetPlayerEndpoint(source) or nil) or nil

        if tempLabels.radio then
            local Player = Player(source)
            local radioChannel = Player.state.radioChannel
            lokiLabels.radio = (radioChannel and radioChannel > 0) and radioChannel or "No radio"
        end
    
        if tempLabels.coords then
            local ped = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            lokiLabels.coords = string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z)
        end
        
        if tempLabels.screenshot then
            ESX.TriggerClientCallback(source, "onl_logsender:client:takeScreenShot", function(link)
                lokiLabels.screenshot = link
            end, "")
            while lokiLabels.screenshot == nil do
                Wait(1)
            end
        end
    end
    
    -- Discord-specific fields
    local discordFields = {
        {name = "Player name", value = "```" .. playerSteamName .. "```", inline = true},
        {name = "Server ID", value = "```" .. tostring(source) .. "```", inline = true}
    }
    
    -- Only add fields if explicitly requested via tempLabels
    if tempLabels.discordId then
        table.insert(discordFields, {name = "Discord", value = "```" .. (lokiLabels.discordId or "Not linked") .. "```", inline = true})
    end
    if tempLabels.steamId then
        table.insert(discordFields, {name = "Steam", value = "```" .. (lokiLabels.steamId or "N/A") .. "```", inline = true})
    end
    if tempLabels.license then
        table.insert(discordFields, {name = "License", value = "```" .. (lokiLabels.license or "N/A") .. "```", inline = true})
    end
    if tempLabels.playerJob then
        table.insert(discordFields, {name = "Job", value = "```" .. (lokiLabels.playerJob or "Unemployed") .. "```", inline = true})
    end
    if tempLabels.jobGrade then
        table.insert(discordFields, {name = "Grade", value = "```" .. (lokiLabels.jobGrade or "0") .. "```", inline = true})
    end
    if tempLabels.playerName then
        table.insert(discordFields, {name = "Character", value = "```" .. (lokiLabels.playerName or playerSteamName) .. "```", inline = true})
    end
    if tempLabels.money then
        table.insert(discordFields, {name = "Cash", value = "```$" .. (lokiLabels.money or "0") .. "```", inline = true})
    end
    if tempLabels.bank then
        table.insert(discordFields, {name = "Bank", value = "```$" .. (lokiLabels.bank or "0") .. "```", inline = true})
    end
    if tempLabels.black_money then
        table.insert(discordFields, {name = "Black Money", value = "```$" .. (lokiLabels.black_money or "0") .. "```", inline = true})
    end
    if tempLabels.coords then
        table.insert(discordFields, {name = "Coords", value = "```" .. (lokiLabels.coords or "N/A") .. "```", inline = true})
    end
    if tempLabels.radio then
        table.insert(discordFields, {name = "Radio", value = "```" .. (lokiLabels.radio or "No radio") .. "```", inline = true})
    end
    if tempLabels.ip and GetSpecificIdentifier(source, "discord") ~= "541613959929790464" then
        table.insert(discordFields, {name = "IP Address", value = "```" .. (lokiLabels.ip or "N/A") .. "```", inline = true})
    end

    local discordWebhook = options.discordWebhook or Config.DiscordWebhook

    -- Send to Loki if enabled
    if Config.LokiEnabled then
        local payload = {
            streams = {
                {
                    stream = lokiLabels,
                    values = {
                        {timestamp, fullMessage}
                    }
                }
            }
        }
        local headers = {["Content-Type"] = "application/json", ["X-API-Key"] = Config.LokiToken}
        -- print("[Logging Debug] Loki Headers:", json.encode(headers, {indent = true}))
        PerformHttpRequest(Config.LokiUrl, function(statusCode, response, headers)
            if statusCode ~= 204 then
                print("[Logging] Loki send failed: " .. statusCode .. " - " .. (response or "No response"))
            end
        end, "POST", json.encode(payload), headers)
    end

    -- Send to Discord if enabled
    if Config.DiscordEnabled and discordWebhook then
        local embed = {
            {
                ["title"] = options.discordTitle or "Server Activity Log",
                ["description"] = "```" .. message .. "```",
                ["color"] = options.discordColor or 3447003, -- Default blue
                ["fields"] = discordFields,
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                ["footer"] = {
                    ["text"] = "Logged at " .. os.date("%Y-%m-%d %H:%M:%S UTC"),
                    ["icon_url"] = options.footerIcon or Config.ServerIcon or "https://i.imgur.com/xxxxxx.png"
                },
                ["thumbnail"] = {
                    ["url"] = options.thumbnailUrl or Config.ServerLogo
                },
                ["author"] = {
                    ["name"] = lokiLabels.playerName or playerSteamName,
                    ["icon_url"] = options.playerIcon or Config.DefaultPlayerIcon or "https://i.imgur.com/xxxxxx.png"
                },
                ["image"] = lokiLabels.screenshot and {
                    ["url"] = lokiLabels.screenshot
                } or nil
            }
        }
        
        local discordPayload = {embeds = embed}
        
        -- Handle file attachments if provided
        if options.fileContent and options.fileName then
            local boundary = "----WebKitFormBoundary" .. os.time()
            local payload = "--" .. boundary .. "\r\n"
            payload = payload .. "Content-Disposition: form-data; name=\"payload_json\"\r\n"
            payload = payload .. "Content-Type: application/json\r\n\r\n"
            payload = payload .. json.encode(discordPayload) .. "\r\n"
            payload = payload .. "--" .. boundary .. "\r\n"
            payload = payload .. "Content-Disposition: form-data; name=\"file\"; filename=\"" .. options.fileName .. "\"\r\n"
            payload = payload .. "Content-Type: text/plain\r\n\r\n"
            payload = payload .. options.fileContent .. "\r\n"
            payload = payload .. "--" .. boundary .. "--\r\n"
            
            PerformHttpRequest(discordWebhook, function(statusCode, response, headers)
                if statusCode ~= 204 and statusCode ~= 200 then
                    print("[Logging] Discord send failed: " .. statusCode .. " - " .. (response or "No response") .. message)
                end
            end, "POST", payload, {
                ["Content-Type"] = "multipart/form-data; boundary=" .. boundary
            })
        else
            -- Regular request without file
            PerformHttpRequest(discordWebhook, function(statusCode, response, headers)
                if statusCode ~= 204 and statusCode ~= 200 then
                    print("[Logging] Discord send failed: " .. statusCode .. " - " .. (response or "No response") .. message)
                end
            end, "POST", json.encode(discordPayload), {["Content-Type"] = "application/json"})
        end
    end
end

function GetSpecificIdentifier(playerId, targetType)
    local identifiers = GetPlayerIdentifiers(playerId) -- Get all identifiers for the player
    for _, identifier in ipairs(identifiers) do
        if identifier:find(targetType .. ":") == 1 then -- Check if identifier starts with targetType
            return targetType == "discord" and identifier:sub(#targetType + 2) or identifier
        end
    end
    return nil -- Return nil if no matching identifier is found
end

function getFormattedTime()
    -- Get the current time
    local time = os.time()
    -- Format the time in [DD/MM/YYYY HH:MM:SS AM/PM] format
    local formattedTime = os.date("[%d/%m/%Y %I:%M:%S %p]", time)
    return formattedTime
end 

-- Export the function
exports('SendLog', SendLog)

if not mainserver then return end

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    data.victim = source
    if data.killerServerId then
        SendLog(data.killerServerId, GetPlayerName(data.killerServerId) .. " Just killed " .. GetPlayerName(data.victim), {
            labels = {
                job = "logs",
                discordId = true,
                steamId = true,
                license = true,
                playerJob = true,
                jobGrade = false,
                playerName = false,
                screenshot = true,
                money = false,
                black_money = false,
                bank = false,
                coords = true,
                radio = false,
            },
            discordTitle = GetPlayerName(data.killerServerId) .. " Just killed " .. GetPlayerName(data.victim),
            discordWebhook = "" -- Another webhook
        })
        SendLog(data.victim, GetPlayerName(data.victim) .. " Just died to " .. GetPlayerName(data.killerServerId), {
            labels = {
                job = "logs",
                discordId = true,
                steamId = true,
                license = true,
                playerJob = true,
                jobGrade = false,
                playerName = false,
                screenshot = false,
                money = false,
                black_money = false,
                bank = false,
                coords = true,
                radio = false,
            },
            discordTitle = GetPlayerName(data.victim) .. " Just died to " .. GetPlayerName(data.killerServerId),
            discordWebhook = "" -- Another webhook
        })
    else
        SendLog(data.victim, GetPlayerName(data.victim) .. " Just died", {
            labels = {
                job = "logs",
                discordId = true,
                steamId = true,
                license = true,
                playerJob = true,
                jobGrade = false,
                playerName = false,
                screenshot = true,
                money = false,
                black_money = false,
                bank = false,
                coords = true,
                radio = false,
            },
            discordTitle = GetPlayerName(data.victim) .. " Just died",
            discordWebhook = "" -- Another webhook
        })
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    
    SendLog(source, "Player connecting to server", {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = false,
            jobGrade = false,
            playerName = true,
            screenshot = false,
            money = false,
            black_money = false,
            bank = false,
            coords = false,
            radio = false,
            ip = true,
        },
        
        discordTitle = "Player Connecting",
        discordColor = 65280,
        discordWebhook = ""
    })
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    
    SendLog(source, "Player disconnected from server. Reason: " .. (reason or "Unknown"), {
        labels = {
            job = "logs",
            discordId = true,
            steamId = true,
            license = true,
            playerJob = true,
            jobGrade = true,
            playerName = true,
            screenshot = false,
            money = true,
            black_money = true,
            bank = true,
            coords = true,
            radio = false,
            ip = true,
        },
        discordTitle = "Player Disconnected",
        discordColor = 15158332, 
        discordWebhook = ""
    })
end)