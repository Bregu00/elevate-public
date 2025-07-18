if Config.inventory ~= "esx" then
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
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.addInventoryItem(item, count)
end

--- Removes an item from a player's inventory
--- @param src number
--- @param item string
--- @param count number
--- @return void
function RemoveInventoryItem(src, item, count)
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeInventoryItem(item, count)
end

--- Gets the count of an item in a player's inventory
--- @param src number
--- @param item string
--- @return number
function GetInventoryCount(src, item)
	local xPlayer = ESX.GetPlayerFromId(src)

	return xPlayer.getInventoryItem(item)?.count or 0
end

--- Gets the label of an items
--- @return table
function GetItemsData()
	local data = MySQL.query.await("SELECT * FROM items")

	local items = {}

	for i = 1, #data do
		items[data[i].name] = data[i]
	end

	return items
end

function GetInventory(src)
	local xPlayer = ESX.GetPlayerFromId(src)

	return xPlayer.inventory
end
