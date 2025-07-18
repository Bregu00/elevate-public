local discordColors = {
	info = tonumber("3498DB", 16),
	warning = tonumber("F1C40F", 16),
	error = tonumber("E74C3C", 16),
}

local logWebHook = "YOUR_API_KEY"

function GetTimestampISO()
	return os.date("!%Y-%m-%dT%H:%M:%S.000Z")
end

---@param source number
---@param level "info" | "warning" | "error"
---@param title string
---@param metadata? table<string, any>
function AdminLog(source, level, title, metadata)
	if not Config.adminLogs.enabled then
		return
	end

	if Config.adminLogs.service == "ox_lib" then
		exports["ox_lib"]:logger(source, level, title)
	elseif Config.adminLogs.service == "fivemanage" then
		if not metadata then
			metadata = {}
		end

		metadata.playerSource = source

		exports.fmsdk:LogMessage(level, title, metadata)
	elseif Config.adminLogs.service ~= "discord" then
		return
	end

	if logWebHook == "YOUR_API_KEY" or not logWebHook then
		print("Config.adminLogs.service is set to discord, but no discord webhook URL is set")
		return
	end

	local cleanedUpIdentifiers = {}
	local accounts = {}
	-- local identifiers = GetPlayerIdentifiers(source)
	local description = metadata and json.encode(metadata, { indent = true }) .. "\n\n" or ""
	local accountsCount = 0

	-- for i = 1, #identifiers do
	-- 	local identifierTypeIndex = identifiers[i]:find(":")

	-- 	if not identifierTypeIndex then
	-- 		goto continue
	-- 	end

	-- 	local identifierType = identifiers[i]:sub(1, identifierTypeIndex - 1)
	-- 	local identifier = identifiers[i]:sub(identifierTypeIndex + 1)

	-- 	if identifierType == "steam" then
	-- 		accountsCount += 1
	-- 		accounts[accountsCount] = "- Steam: https://steamcommunity.com/profiles/" .. tonumber(identifier, 16)
	-- 	elseif identifierType == "discord" then
	-- 		accountsCount += 1
	-- 		accounts[accountsCount] = "- Discord: <@" .. identifier .. ">"
	-- 	end

	-- 	if identifierType ~= "ip" then
	-- 		cleanedUpIdentifiers[identifierType] = identifier
	-- 	end

	-- 	::continue::
	-- end

	-- if accountsCount > 0 then
	-- 	description = description .. "**Accounts:**\n"
	-- 	for i = 1, accountsCount do
	-- 		description = description .. accounts[i] .. "\n"
	-- 	end
	-- end

	-- description = description .. "**Identifiers:**"

	-- for identifierType in pairs(cleanedUpIdentifiers) do
	-- 	description = description .. "\n- **" .. identifierType .. ":** " .. cleanedUpIdentifiers[identifierType]
	-- end

	local embed = {
		title = "Admin log",
		description = title,
		color = discordColors[level],
		timestamp = GetTimestampISO(),
		author = {
			icon_url = "https://cdn.discordapp.com/embed/avatars/" .. math.random(0, 5) .. ".png",
		},
	}

	PerformHttpRequest(
		logWebHook,
		function() end,
		"POST",
		json.encode({
			username = "Electus Admin Logs",
			embeds = { embed },
		}),
		{ ["Content-Type"] = "application/json" }
	)
end

-- if Config.adminLogs.enabled and Config.adminLogs.service == "ox_lib" then
-- 	local oxInit = LoadResourceFile("ox_lib", "init.lua")

-- 	if oxInit then
-- 		load(oxInit)()
-- 	else
-- 		Config.adminLogs.enabled = false

-- 		infoprint("error", "Failed to load ox_lib")
-- 	end
-- end
