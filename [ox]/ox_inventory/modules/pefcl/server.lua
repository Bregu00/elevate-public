--[[
	Intended for use with https://github.com/project-error/pefcl
	config.useFrameworkIntegration.resource should be set as "ox_inventory"

	This isn't intended for use with frameworks with their own accounts,
	use the proper pefcl-framework resources and ensure item/account syncing
	works on your own.
]]

local Inventory = require 'modules.inventory.server'

---@param source number
---@param amount number
exports('addCash', function(source, amount)
	Inventory.AddItem(source, 'money', amount)
end)

---@param source number
---@param amount number
exports('removeCash', function(source, amount)
	Inventory.RemoveItem(source, 'money', amount)
end)

---@param source number
---@return number
exports('getCash', function(source)
	return Inventory.GetItemCount(source, 'money')
end)

---no-op
exports('getBank', function() end)

