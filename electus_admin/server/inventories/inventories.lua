function GetInventoryDatabase(identifier, returnRaw)
	local query = ("SELECT {inventory} FROM {users_table} WHERE {identifier} = @identifier")
		:gsub("{inventory}", Queries.Inventory.inventory)
		:gsub("{users_table}", Queries.Users.table)
		:gsub("{identifier}", Queries.Users.identifier)

	local inventory = MySQL.scalar.await(query, {
		["@identifier"] = identifier,
	})

	if inventory == nil then
		return {}
	end

	local retItems = {}

	inventory = json.decode(inventory)

	if returnRaw then
		return inventory
	end

	for k, v in pairs(inventory) do
		if inventory[k] then
			retItems[#retItems + 1] = {
				name = inventory[k][Queries.Inventory.itemName],
				count = inventory[k][Queries.Inventory.count],
				label = GetItemLabel(inventory[k][Queries.Inventory.itemName]),
			}
		end
	end

	return retItems
end

--- Gets the item count for a item and identifier
--- @param identifier string
--- @param item string
--- @return number
function GetItemCountDatabase(identifier, item)
	local query = [[
        SELECT
            CONVERT(JSON_UNQUOTE(JSON_EXTRACT(item, '$.{count}')), INT) AS `count`
        FROM 
            {users_table},
            JSON_TABLE({inventory}, '$[*]' COLUMNS (item JSON PATH '$')) AS jt
        WHERE 
            JSON_UNQUOTE(JSON_EXTRACT(item, '$.{name}')) = ?
            AND {identifier} = ?
    ]]

	query = query
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{name}", Queries.Inventory.itemName)
		:gsub("{count}", Queries.Inventory.count)
		:gsub("{inventory}", Queries.Inventory.inventory)
		:gsub("{users_table}", Queries.Users.table)

	local count = MySQL.scalar.await(query, { item, identifier })

	return count or 0
end

--- Adds an item to a player's inventory in the database
--- @param identifier string
--- @param item string
--- @param amount number
--- @return boolean
function AddInventoryItemDatabase(identifier, item, amount)
	local inventory = GetInventoryDatabase(identifier, true)

	for k, v in pairs(inventory) do
		if inventory[k][Queries.Inventory.itemName] == item then
			inventory[k][Queries.Inventory.count] = inventory[k][Queries.Inventory.count] + amount

			if item == "money" then
				SetCashMoneyDatabase(identifier, inventory[k][Queries.Inventory.count])
			end

			local query = ("UPDATE {users_table} SET {inventory} = @inventory WHERE {identifier} = @identifier")
				:gsub("{users_table}", Queries.Inventory.table)
				:gsub("{inventory}", Queries.Inventory.inventory)
				:gsub("{identifier}", Queries.Users.identifier)

			MySQL.update.await(query, {
				["@inventory"] = json.encode(inventory),
				["@identifier"] = identifier,
			})

			return true
		end
	end

	local slot = GetEmptySlotInInventory(inventory)

	inventory[slot] = { [Queries.Inventory.itemName] = item, [Queries.Inventory.count] = amount, slot = slot }

	local query = ("UPDATE {users_table} SET {inventory} = @inventory WHERE {identifier} = @identifier")
		:gsub("{users_table}", Queries.Inventory.table)
		:gsub("{inventory}", Queries.Inventory.inventory)
		:gsub("{identifier}", Queries.Users.identifier)

	MySQL.update.await(query, {
		["@inventory"] = json.encode(inventory),
		["@identifier"] = identifier,
	})

	if item == "money" then
		SetCashMoneyDatabase(identifier, amount)
	end

	return true
end

--- Removes an item from a player's inventory in the database
--- @param identifier string
--- @param item string
--- @param amount number
--- @return boolean
function RemoveInventoryItemDatabase(identifier, item, amount)
	local inventory = GetInventoryDatabase(identifier, true)

	for k, v in pairs(inventory) do
		if inventory[k][Queries.Inventory.itemName] == item then
			inventory[k][Queries.Inventory.count] = inventory[k][Queries.Inventory.count] - amount

			if inventory[k][Queries.Inventory.count] <= 0 then
				inventory[k] = nil
			end

			if item == "money" then
				local total = inventory[k][Queries.Inventory.count]

				if total < 0 then
					total = 0
				end

				SetCashMoneyDatabase(identifier, total)
			end

			local query = ("UPDATE {users_table} SET {inventory} = @inventory WHERE {identifier} = @identifier")
				:gsub("{users_table}", Queries.Inventory.table)
				:gsub("{identifier}", Queries.Users.identifier)
				:gsub("{inventory}", Queries.Inventory.inventory)

			MySQL.update.await(query, {
				["@inventory"] = json.encode(inventory),
				["@identifier"] = identifier,
			})

			return true
		end
	end

	return false
end

function GetItemPlayersDatabase(item)
	local query = [[SELECT 
        {identifier} AS identifier,
        {name} as name,
        CONVERT(JSON_UNQUOTE(JSON_EXTRACT(item, '$.{count}')), INT) AS `count`
    FROM 
        {users_table},
        JSON_TABLE({inventory}, '$[*]' COLUMNS (item JSON PATH '$')) AS jt
    WHERE 
        JSON_UNQUOTE(JSON_EXTRACT(item, '$.{item}')) = ?
    ]]

	query = query
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{name}", Queries.Users.name)
		:gsub("{count}", Queries.Inventory.count)
		:gsub("{inventory}", Queries.Inventory.inventory)
		:gsub("{users_table}", Queries.Users.table)
		:gsub("{item}", Queries.Inventory.itemName)

	local users = MySQL.query.await(query, { item })

	local usersSend = {}

	for i = 1, #users do
		local user = users[i]
		local player = GetSourceFromIdentifier(users[i].identifier)
		user.item = item
		user.inGameName = user.name

		if player then
			local count = GetInventoryCount(player, item)

			if count > 0 then
				user.count = count
				usersSend[#usersSend + 1] = user
			end
		elseif user.count > 0 then
			usersSend[#usersSend + 1] = user
		end
	end

	return users
end

function GetItemWithMinAmountDatabase(item, amount)
	local query = [[
        SELECT
            u.{identifier},
            SUM(jt.item_count) AS total_count
        FROM
            {users_table} AS u
            CROSS JOIN JSON_TABLE(
                u.{inventory},
                '$[*]'
                COLUMNS (
                    item_name  VARCHAR(100) PATH '$.{item}',
                    item_count INT           PATH '$.{count}'
                )
            ) AS jt
        WHERE
            jt.item_name = ?
        GROUP BY
            u.{identifier}
        HAVING
            SUM(jt.item_count) >= ?
    ]]

	query = query
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{name}", Queries.Users.name)
		:gsub("{count}", Queries.Inventory.count)
		:gsub("{inventory}", Queries.Inventory.inventory)
		:gsub("{users_table}", Queries.Users.table)
		:gsub("{item}", Queries.Inventory.itemName)

	local users = MySQL.query.await(query, { item, amount })

	return users
end

--- Get missing slot in inventory
--- @param inventory table
--- @return number
function GetEmptySlotInInventory(inventory)
	local existingSlots = {}
	local slot = 1

	for k, v in pairs(inventory) do
		existingSlots[k] = true
	end

	while existingSlots[slot] do
		slot = slot + 1
	end

	return slot
end
