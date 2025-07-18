-- Error Message

---@param src number
---@param data table
local function errorMessage(src, data)
	TriggerClientEvent('chat:addMessage', src, {
		args = data.message,
		tag = {
			name = data.title,
			background = '#e4eaf4'
		},

	})
end

return errorMessage
