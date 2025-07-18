function ReceivePlayers()
	local players = GetPlayers()
	local playersData = {}

	for i = 1, #players do
		local player = GetPlayer(players[i])
		local playerData = {
			id = player,
			name = GetCharacterName(player),
			identifier = GetIdentifier(player),
			bank = GetBankMoney(player),
			cash = GetCashMoney(player),
		}

		table.insert(playersData, playerData)
	end
	return playersData
end

function CheckStaff(license)
	license = string.match(license, ":(%w+)")
	local result =
		MySQL.query.await("SELECT * FROM electus_admin_staffs WHERE license=@license", { ["license"] = license })

	if result[1] or ConfigServer.ownerLicense == license then
		return true
	else
		return false
	end
end

function IsAdmin(src)
	local license = GetPlayerIdentifierByType(src, "license")
	local isAdmin = CheckStaff(license)

	if isAdmin then
		return true
	else
		return false
	end
end

lib.callback.register("electus_admin:isAdmin", function(src)
	local license = GetPlayerIdentifierByType(src, "license")
	local isAdmin = CheckStaff(license)

	return isAdmin
end)

lib.callback.register("electus_admin:spawnVehicle", function(src, model)
	local license = GetPlayerIdentifierByType(src, "license")
	local isAdmin = CheckStaff(license)

	if not isAdmin then
		return
	end

	AdminLog(src, "info", "Spawned vehicle " .. model .. " by " .. src)

	local playerPed = GetPlayerPed(src)
	local pos = GetEntityCoords(playerPed)
	local heading = GetEntityHeading(playerPed)
	local vehicleHash = GetHashKey(model)
	local currentVehicle = GetVehiclePedIsIn(playerPed, false)

	if currentVehicle and currentVehicle ~= 0 then
		DeleteEntity(currentVehicle)
	end

	-- RequestModel(vehicleHash)
	-- while not HasModelLoaded(vehicleHash) do
	-- 	Wait(500)
	-- end

	local spawnedVehicle = CreateVehicle(vehicleHash, pos.x, pos.y, pos.z, heading, true, false)

	TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)

	return NetworkGetNetworkIdFromEntity(spawnedVehicle)
end)

lib.callback.register("electus_admin:createAccount", function(src, username, password)
	local isAdmin = IsAdmin(src)

	if not isAdmin then
		return false
	end

	AdminLog(src, "info", "Created account for " .. username)

	local usernameExist = MySQL.scalar.await("SELECT * FROM electus_admin_staffs WHERE username=@username", {
		["username"] = username,
	})

	if usernameExist then
		return { error = L("login.username_exist"), usernameExist = true }
	end

	local license = string.match(GetPlayerIdentifierByType(src, "license"), ":(%w+)")

	if ConfigServer.ownerLicense == license then
		local insert = MySQL.update.await(
			"INSERT INTO electus_admin_staffs (username, password, license) VALUES (@username, @password, @license)",
			{
				["username"] = username,
				["password"] = GetPasswordHash(password),
				["license"] = ConfigServer.ownerLicense,
			}
		)

		return insert
	else
		local passHash = GetPasswordHash(password)

		local update = MySQL.update.await(
			"UPDATE electus_admin_staffs SET username=@username, password=@password WHERE license=@license",
			{
				["username"] = username,
				["password"] = passHash,
				["license"] = license,
			}
		)

		return update
	end
end)

lib.callback.register("electus_admin:getBaseUrl", function(src)
	local baseUrl = ("https://%s/%s"):format(GetConvar("web_baseUrl", ""), GetCurrentResourceName())

	return baseUrl
end)

exports("ReceivePlayers", ReceivePlayers)
