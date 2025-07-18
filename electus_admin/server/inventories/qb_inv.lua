if Config.inventory ~= "qb-inventory" then
	return
end

while not Queries do
	Wait(100)
end

Queries.Inventory = {}

Queries.Inventory.table = "players"
Queries.Inventory.inventory = "inventory"
Queries.Inventory.itemName = "name"
Queries.Inventory.count = "amount"

--- Adds an item to a player's inventory
--- @param src number
--- @param item string
--- @param count number
function AddInventoryItem(src, item, count)
	exports["qb-inventory"]:AddItem(src, item, count)
end

--- Removes an item from a player's inventory
--- @param src number
--- @param item string
--- @param count number
function RemoveInventoryItem(src, item, count)
	exports["qb-inventory"]:RemoveItem(src, item, count, false)
end

--- Gets the count of an item in a player's inventory
--- @param src number
--- @param item string
--- @return number
function GetInventoryCount(src, item)
	return exports["qb-inventory"]:GetItemCount(src, item) or 0
end

--- Gets the label of an items
--- @return table
function GetItemsData()
	return QBCore.Shared.Items
end

function GetInventory(src)
	local player = QBCore.Functions.GetPlayer(src)
	local inventory = player.PlayerData.items

	local retItems = {}

	for i, v in pairs(inventory) do
		if inventory[i] then
			retItems[#retItems + 1] = {
				name = inventory[i].name,
				count = inventory[i].amount,
				label = QBCore.Shared.Items[inventory[i].name].label,
				slot = inventory[i].slot,
			}
		end
	end

	return retItems
end
