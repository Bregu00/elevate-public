if Config.inventory ~= "qs-inventory" then
	return
end

while not Queries do
	Wait(100)
end

Queries.Inventory = {}

if Config.framework == "qb" or Config.framework == "qbx" then
	Queries.Inventory.table = "players"
	Queries.Inventory.inventory = "inventory"
	Queries.Inventory.itemName = "name"
	Queries.Inventory.count = "amount"
elseif Config.framework == "esx" then
	Queries.Inventory.table = "users"
	Queries.Inventory.inventory = "inventory"
	Queries.Inventory.itemName = "name"
	Queries.Inventory.count = "amount"
end

--- Adds an item to a player's inventory
--- @param src number
--- @param item string
--- @param count number
function AddInventoryItem(src, item, count)
	exports["qs-inventory"]:AddItem(src, item, count)
end

--- Removes an item from a player's inventory
--- @param src number
--- @param item string
--- @param count number
function RemoveInventoryItem(src, item, count)
	exports["qs-inventory"]:RemoveItem(src, item, count)
end

--- Gets the count of an item in a player's inventory
--- @param src number
--- @param item string
--- @return number
function GetInventoryCount(src, item)
	return exports["qs-inventory"]:GetItemTotalAmount(src, item) or 0
end

--- Gets the label of an items
--- @return table
function GetItemsData()
	return exports["qs-inventory"]:GetItemList()
end

function GetInventory(src)
	local inventory = exports["qs-inventory"]:GetInventory(src)

	local retItems = {}

	for k, v in pairs(inventory) do
		if inventory[k] then
			retItems[#retItems + 1] = {
				name = inventory[k].name,
				count = inventory[k].amount,
				label = inventory[k].label,
			}
		end
	end

	return retItems
end
