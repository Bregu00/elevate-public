if Config.inventory ~= "ox_inventory" then
	return
end

while not Queries do
	Wait(100)
end

Queries.Inventory = {}

Queries.Inventory.table = "users"
Queries.Inventory.inventory = "inventory"
Queries.Inventory.itemName = "name"
Queries.Inventory.count = "count"

--- Adds an item to a player's inventory
--- @param src number
--- @param item string
--- @param count number
function AddInventoryItem(src, item, count)
	exports.ox_inventory:AddItem(src, item, count)
end

--- Removes an item from a player's inventory
--- @param src number
--- @param item string
--- @param count number
--- @return void
function RemoveInventoryItem(src, item, count)
	exports.ox_inventory:RemoveItem(src, item, count)
end

--- Gets the count of an item in a player's inventory
--- @param src number
--- @param item string
--- @return number
function GetInventoryCount(src, item)
	return exports.ox_inventory:GetItemCount(src, item) or 0
end

--- Gets the label of an items
--- @return table
function GetItemsData()
	return exports.ox_inventory:Items()
end

function GetInventory(src)
	local inventory = exports.ox_inventory:GetInventoryItems(src)

	local retItems = {}

	for k, v in pairs(inventory) do
		if inventory[k] then
			retItems[#retItems + 1] = {
				name = inventory[k].name,
				count = inventory[k]?.amount or inventory[k]?.count,
				label = inventory[k]?.label or GetItemLabel(inventory[k]?.name),
			}
		end
	end

	return retItems
end
