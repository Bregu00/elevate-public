ConfigServer = {
	-- example: "895af8ea68c1c97ec106450391c50564173ed014"
	ownerLicense = "dc18488f0ae07b5617fd73ab17bcc490271d06ed", -- your head license do not use discord, ip, or anything else just the license as the format provided.
}

if ConfigServer.ownerLicense == nil or ConfigServer.ownerLicense == "" then
	print("^1[ERROR]^7 ConfigServer.ownerLicense is not set in server_config/config.lua")
	print("^1[ERROR]^7 Please set the ownerLicense to your license")
end
