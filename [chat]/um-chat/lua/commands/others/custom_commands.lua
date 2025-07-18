local customCommands = require('config.commands').customs --Todo: next return
local errNotify = require('lua.commands.modules.errorMessage')
local addCustomCommand = lib.addCommand

---@param src number
---@param data table
local function addChatMessage(src, data)
	TriggerClientEvent('chat:addMessage', src, data)
end

if customCommands['pm'] then
	addCustomCommand('pm', {
		help = 'Private message',
		params = {
			{ name = 'target',  type = 'number',    help = 'Target player\'s server id' },
			{ name = 'message', type = 'longString' }
		}
	}, function(source, args)
		if not source then return end
		local src = source
		local paramsName = args['message']

		if #paramsName < 1 then return end

		local target = args['target']
		if target == nil or target == 0 then return end

		local msg = table.concat({ paramsName }, ' '):gsub('[~<].-[>~]', '')

		if GetPlayerFirstName(target) == nil or target == src then
			local errorTexts = target == src and 'You can\'t send a message to yourself' or 'Player not found'
			return errNotify(src, { message = errorTexts, title = 'Error!' })
		end

		local senderData = {
			args = msg,
			title = "New Message!",
			tag = {
				name = 'PM | Sender:' .. ' | ' .. GetPlayerFirstName(src) .. ' | ID: ' .. src,
				background = '#a855f7', -- optional
			},
		}

		addChatMessage(target, senderData)

		local receiverData = {
			args = msg,
			title = "Message Sended!",
			tag = {
				name = 'PM | Message Sent:' .. ' | ' .. GetPlayerFirstName(target) .. ' | ID: ' .. target,
				background = '#4ade80', -- optional
			}
		}

		addChatMessage(src, receiverData)
	end)
end
