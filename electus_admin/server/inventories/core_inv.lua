if Config.inventory ~= "core_inventory" then
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
	exports.core_inventory:addItem(src, item, count)
end

--- Removes an item from a player's inventory
--- @param src number
--- @param item string
--- @param count number
--- @return void
function RemoveInventoryItem(src, item, count)
	exports.core_inventory:removeItem(src, item, count)
end

--- Gets the count of an item in a player's inventory
--- @param src number
--- @param item string
--- @return number
function GetInventoryCount(src, item)
	return exports.core_inventory:getItemCount(src, item) or 0
end

--- Gets the label of an items
--- @return table
function GetItemsData()
	return exports.core_inventory:getItemsList()
end

function GetInventory(src)
	return exports.core_inventory:getInventory(src)
end
