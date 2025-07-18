if Config.framework ~= "esx" then
	return
end

export, ESX = pcall(function()
	return exports.es_extended:getSharedObject()
end)

if not export then
	TriggerEvent("esx:getSharedObject", function(obj)
		ESX = obj
	end)
end

function GetPlayer(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer
end

function GetIdentifier(player)
	if player then
		return player.getIdentifier()
	end
end

function GetPlayerFromIdentifier(identifier)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	return xPlayer
end

--- Get the source from an identifier
--- @param identifier string
--- @return number
function GetSourceFromIdentifier(identifier)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	return xPlayer.source
end

function RemoveBankMoney(player, amount)
	player.removeAccountMoney("bank", amount)
end

function RemoveCashMoney(player, amount)
	player.removeAccountMoney("money", amount)
end

function AddCashMoney(player, amount)
	player.addAccountMoney("money", amount)
end

function AddBankMoney(player, amount)
	player.addAccountMoney("bank", amount)
end

function GetBankMoney(player)
	return player.getAccount("bank").money
end

function GetCashMoney(player)
	return player.getAccount("money").money
end

---@param player string
---@return string
function GetCharacterName(player)
	if not player then
		return "Name not found"
	end

	return player.getName() or "Name not found"
end

function SetCharacterName(player, firstname, lastname)
	player.setName(firstname .. " " .. lastname)
end

--- Get the Item Label
---@param item string
---@return string
function GetItemLabel(item)
	local itemLabel = ESX.GetItemLabel(item)
	return itemLabel
end

---@param plate string
---@return table | boolean
function FrameworkGetSpecificVehicleInDB(plate)
	local query = ("SELECT *, {garage} AS garage, {outside} as stored FROM {vehicle_table} WHERE {plate} = ?")
		:gsub("{plate}", Queries.Vehicles.plate)
		:gsub("{vehicle_table}", Queries.Vehicles.table)
		:gsub("{garage}", Queries.Vehicles.garage)
		:gsub("{outside}", Queries.Vehicles.outside)

	local vehicle = MySQL.single.await(query, { plate })

	if not vehicle then
		return false
	end

	local retVehicle = {}

	local vehEntity = FindVehicleEntityByPlate(vehicle.plate)

	if vehEntity then
		retVehicle.entity = vehEntity
		retVehicle.coords = GetEntityCoords(vehEntity)
	end

	retVehicle.identifier = vehicle.owner

	local vehData = json.decode(vehicle.vehicle)

	retVehicle.primaryColor = vehData.color1
	retVehicle.secondaryColor = vehData.color2
	retVehicle.model = vehData.model
	retVehicle.plate = vehicle.plate
	retVehicle.type = vehicle.type

	if vehicle.stored == 1 then
		retVehicle.garage = vehicle.garage or "Garage"
	else
		retVehicle.garage = vehicle.pound or "Impounded"
	end

	return retVehicle
end

---@return table
function FrameworkGetAllPlayers()
	local query = ("SELECT {name} AS `name`, {identifier} AS identifier, {bank} AS `bank`, {cash} AS `cash` FROM {users_table}")
		:gsub("{name}", Queries.Users.name)
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{bank}", Queries.Users.bank)
		:gsub("{cash}", Queries.Users.cash)
		:gsub("{users_table}", Queries.Users.table)

	local result = MySQL.Sync.fetchAll(query)

	local players = {}

	for i = 1, #result do
		players[i] = {}
		local player = ESX.GetPlayerFromIdentifier(result[i].identifier)

		if player then
			players[i].playerId = player.source
			players[i].name = GetPlayerName(player.source)
		else
			players[i].name = MySQL.single.await(
				"SELECT name FROM electus_admin_names WHERE license = ?",
				{ players[i].license }
			)?.name or "Name not found"
		end

		players[i].inGameName = result[i].name
		players[i].identifier = result[i].identifier
		players[i].license = string.match(result[i].identifier, ":(%w+)")

		players[i].bank = result[i].bank
		players[i].money = result[i].cash
	end

	return players
end

--- Gets all online players
--- @return table
function FrameworkGetOnlinePlayers()
	local players = ESX.GetPlayers()
	local onlinePlayers = {}

	for i, v in pairs(players) do
		local player = ESX.GetPlayerFromId(players[i])

		if player then
			onlinePlayers[#onlinePlayers + 1] = {
				playerId = player.source,
				inGameName = player.getName(),
				identifier = player.getIdentifier(),
				license = string.match(player.getIdentifier(), ":(%w+)"),
				bank = player.getAccount("bank").bank,
				money = player.getAccount("money").money,
			}
		end
	end

	return onlinePlayers
end

---@param identifier string
---@return table | nil
function FrameworkGetExtendedPlayer(identifier)
	local query = ("SELECT *, {name} AS `name`, {identifier} AS identifier, {bank} AS `bank`, {cash} AS `cash` FROM {users_table} WHERE {identifier} = ?")
		:gsub("{name}", Queries.Users.name)
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{bank}", Queries.Users.bank)
		:gsub("{cash}", Queries.Users.cash)
		:gsub("{users_table}", Queries.Users.table)

	local result = MySQL.single.await(query, { identifier })

	local player = {}

	if result then
		local onlinePlayer = ESX.GetPlayerFromIdentifier(result.identifier)

		if onlinePlayer then
			player.playerId = onlinePlayer.source
			player.job = {
				name = onlinePlayer.job.name,
				label = onlinePlayer.job.label,
				grade = onlinePlayer.job.grade,
				gradeLabel = onlinePlayer.job.label,
			}
			player.ping = GetPlayerPing(onlinePlayer.source)
			player.health = GetEntityHealth(GetPlayerPed(onlinePlayer.source))
		else
			local gradeLabel =
				MySQL.single.await("SELECT label FROM job_grades WHERE job_name = @job AND grade = @grade", {
					["@job"] = result.job,
					["@grade"] = result.job_grade,
				})

			player.job = {
				name = result.job,
				label = GetJobsLabels()[result.job].label,
				grade = result.job_grade,
				gradeLabel = gradeLabel?.label,
			}
		end

		player.inGameName = result.name
		player.identifier = result.identifier
		player.license = string.match(result.identifier, ":(%w+)")

		player.bank = result.bank
		player.money = result.cash
		player.dateofbirth = result.dateofbirth
		player.isBanned = IsBanned(player.license, nil, nil)
		player.numWarns = GetNumWarns(player.license)
		player.height = result.height
		player.sex = (result.sex == "m" and "Male") or "Female"
		player.createdAt = result.created_at
		player.lastLogin = result.last_seen

		return player
	end

	return nil
end

function CollectJob()
	local statistics = {}

	for i = 1, #Config.statistics.jobs do
		local job = Config.statistics.jobs[i]
		local query = ("SELECT COUNT(*) as count FROM {users_table} WHERE {job} = ?")
			:gsub("{job}", Queries.Users.job)
			:gsub("{users_table}", Queries.Users.table)

		local players = MySQL.query.await(query, { job })

		statistics[#statistics + 1] = { job = job, count = players[1].count }
	end

	return statistics
end

function GetJobsLabels()
	local jobs = ESX.GetJobs()
	local availableJobs = {}

	for k, v in pairs(jobs) do
		availableJobs[k] = { label = v.label, name = k }
	end

	return availableJobs
end

function GetJobGrades(job)
	local query = ("SELECT * FROM {job_grades_table} WHERE {job_name} = @job")
		:gsub("{job_grades_table}", Queries.Jobs.table)
		:gsub("{job_name}", Queries.Jobs.jobName)

	local grades = MySQL.query.await(query, {
		["@job"] = job,
	})

	return grades
end

function SetJobOnline(player, job, grade)
	player.setJob(job, grade)
end

function SetJobDatabase(identifier, job, grade)
	local query = ("UPDATE {users_table} SET {job} = @job, {job_grade} = @grade WHERE {identifier} = @identifier")
		:gsub("{users_table}", Queries.Users.table)
		:gsub("{job}", Queries.Users.job)
		:gsub("{job_grade}", Queries.Users.jobGrade)
		:gsub("{identifier}", Queries.Users.identifier)

	MySQL.update.await(query, {
		["@job"] = job,
		["@grade"] = grade,
		["@identifier"] = identifier,
	})
end

function SetCashMoneyDatabase(identifier, amount)
	amount = tonumber(amount)

	local query = ("SELECT accounts FROM {users_table} WHERE {identifier} = @identifier")
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{users_table}", Queries.Users.table)

	local accounts = MySQL.scalar.await(query, {
		["@identifier"] = identifier,
	})

	if accounts then
		accounts = json.decode(accounts)

		if accounts.money < amount then
			AddCashMoneyDatabase(identifier, amount - accounts.money)
		elseif accounts.money > amount then
			RemoveCashMoneyDatabase(identifier, accounts.money - amount)
		end
	end
end

function SetBankMoneyDatabase(identifier, amount)
	amount = tonumber(amount)

	local query = ("SELECT accounts FROM {users_table} WHERE {identifier} = @identifier")
		:gsub("{identifier}", Queries.Users.identifier)
		:gsub("{users_table}", Queries.Users.table)

	local accounts = MySQL.scalar.await(query, {
		["@identifier"] = identifier,
	})

	if accounts then
		accounts = json.decode(accounts)

		if accounts.bank < amount then
			AddBankMoneyDatabase(identifier, amount - accounts.bank)
		elseif accounts.bank > amount then
			RemoveBankMoneyDatabase(identifier, accounts.bank - amount)
		end
	end
end

function GetPlayersWithMinItem(item, amount)
	local users = GetItemPlayersDatabase(item)

	local userCheck = {}

	for i = 1, #users do
		if userCheck[users[i].identifier] == nil then
			userCheck[users[i].identifier] = users[i]
		else
			userCheck[users[i].identifier].count = userCheck[users[i].identifier].count + users[i].count
		end
	end

	local retUsers = {}

	for k, v in pairs(userCheck) do
		if v.count < amount then
			retUsers[#retUsers + 1] = v
		end
	end

	return retUsers
end

exports("DeleteCharacter", DeleteCharacter)
exports("ChangeName", ChangeName)
exports("GetJobsLabels", GetJobsLabels)
exports("GetJobGrades", GetJobGrades)
