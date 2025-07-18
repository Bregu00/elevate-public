function Notify(src, text, type)
	TriggerClientEvent("ox_lib:notify", src, {
		title = L("gangs"),
		description = text,
		type = type,
	})
end

function Split(string, delimiter)
	local result = {}
	for match in (string .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

function GetUtils()
	if not Config.apiUrl then
		local weburl = ("https://%s/%s"):format(GetConvar("web_baseUrl", ""), GetCurrentResourceName())

		Config.apiUrl = weburl
	end

	return {
		config = Config,
		locale = GetAllLocales(),
	}
end

exports("GetUtils", GetUtils)
