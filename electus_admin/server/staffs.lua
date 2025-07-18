--- @param username string
--- @param password string
--- @return boolean | table
function ValidateUser(username, password)
	local result =
		MySQL.single.await("SELECT * FROM electus_admin_staffs WHERE username=@username", { ["username"] = username })

	if result and VerifyPasswordHash(password, result.password) then
		return true
	else
		return false
	end
end

--- @return table | false | {}
function GetStaffs()
	local result = MySQL.query.await("SELECT * FROM electus_admin_staffs")

	if result then
		for i = 1, #result do
			result[i].password = nil
		end
		return result
	else
		return false
	end
end

--- @param username string
--- @return boolean
function IsMainLicense(username)
	local user = GetStaffByUsername(username)

	if user?.license == ConfigServer.ownerLicense then
		return true
	else
		return false
	end
end

--- @param username string
--- @param permission string
--- @return boolean | table
function HasPermission(username, permission)
	local user =
		MySQL.single.await("SELECT * FROM electus_admin_staffs WHERE username=@username", { ["username"] = username })

	if not user then
		return false
	end

	if user.license == ConfigServer.ownerLicense then
		return true
	end

	if user?.role then
		local role = MySQL.single.await("SELECT * FROM electus_admin_roles WHERE name=@role", { ["role"] = user?.role })

		if not role then
			return false
		end

		local permissions = json.decode(role?.permissions or {})

		if permissions[permission] then
			return true
		else
			return false
		end
	end
end

--- @param license string
--- @return table | false | {}
function GetStaffByLicense(license)
	local result =
		MySQL.single.await("SELECT * FROM electus_admin_staffs WHERE license=@license", { ["license"] = license })

	if result then
		return result
	else
		return false
	end
end

--- @param username string
--- @return table | false | {}
function GetStaffByUsername(username)
	local result =
		MySQL.single.await("SELECT * FROM electus_admin_staffs WHERE username=@username", { ["username"] = username })

	if result then
		local isOwner = result.license == ConfigServer.ownerLicense
		result.isOwner = isOwner

		return result
	else
		return false
	end
end

--- @param role string
--- @return table | false | {}
function GetRoleByName(role)
	local result = MySQL.single.await("SELECT * FROM electus_admin_roles WHERE name=@role", { ["role"] = role })

	if result then
		result.permissions = json.decode(result.permissions)
		return result
	else
		return false
	end
end

--- @param requestUser string
--- @param license string
--- @param role string
--- @return boolean | table
function AddStaff(requestUser, license, role)
	local hasPermissions = HasPermission(requestUser, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

    local isAdmin = GetStaffByLicense(license)

    if isAdmin then
        return false
    end

	AdminLog(-1, "info", "Added staff " .. license .. " with role " .. role .. " by " .. requestUser)

	local staff = GetStaffByUsername(requestUser)
	local myRole = staff?.role

	if staff?.isOwner then
		local result = MySQL.insert.await(
			"INSERT INTO electus_admin_staffs (license, role) VALUES (@license, @role)",
			{ ["license"] = license, ["role"] = role }
		)

		if result then
			return true
		else
			return false
		end
	end

	local myGrade = GetRoleByName(myRole).grade
	local targetRole = GetRoleByName(role)
	local targetGrade = targetRole?.grade or 9999

	if myGrade > targetGrade or IsMainLicense(requestUser) then
		local result = MySQL.insert.await(
			"INSERT INTO electus_admin_staffs (license, role) VALUES (@license, @role)",
			{ ["license"] = license, ["role"] = role }
		)

		if result then
			return true
		else
			return false
		end
	else
		return false
	end
end

--- @param requestUser string
--- @param targetLicense string
--- @return boolean | table
function RemoveStaff(requestUser, targetLicense)
	local hasPermissions = HasPermission(requestUser, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Removed staff " .. targetLicense .. " by " .. requestUser)

	local myRole = GetStaffByUsername(requestUser)?.role
	local myGrade = GetRoleByName(myRole)?.grade
	local targetRole = GetRoleByName(GetStaffByLicense(targetLicense)?.role)
	local targetGrade = targetRole?.grade or 9999

	if (myGrade and myGrade >= targetGrade) or IsMainLicense(requestUser) then
		local result = MySQL.insert.await(
			"DELETE FROM electus_admin_staffs WHERE license=@license",
			{ ["license"] = targetLicense }
		)

		if result then
			return true
		else
			return false
		end
	else
		return false
	end
end

--- @return boolean | table
function NewDayTracking()
	MySQL.update.await(
		"UPDATE electus_admin_active_admins SET last_login = @last_login, saved_time = @saved_time WHERE logged_in = 1",
		{
			["last_login"] = os.time(),
			["@saved_time"] = 0,
		}
	)

	MySQL.update.await("DELETE FROM electus_admin_active_admins WHERE logged_in = 0", {})
end

AddEventHandler("playerJoining", function(src)
	local playerId = src
	local playerLicense = GetPlayerIdentifierByType(playerId, "license"):gsub("license:", "")
	local isAdmin = IsAdmin(playerId)

	local anyActivity = MySQL.single.await("SELECT * FROM electus_admin_active_admins LIMIT 1", {})

	if anyActivity then
		local time = anyActivity.last_login
		local currentTime = os.time()

		local diff = os.difftime(currentTime, time)

		local days = math.floor(diff / (24 * 3600))

		if days > 0 then
			NewDayTracking()
		end
	end

	if isAdmin then
		local adminActivity = MySQL.single.await(
			"SELECT * FROM electus_admin_active_admins WHERE license=@license",
			{ ["license"] = playerLicense }
		)

		if not adminActivity then
			StartTrackAdminData(playerLicense)
		else
			MySQL.update.await(
				"UPDATE electus_admin_active_admins SET last_login = @last_login, logged_in = 1 WHERE license = @license",
				{
					["@license"] = playerLicense,
					["@last_login"] = os.time(),
				}
			)
		end
	end
end)

--- @param license string
function StartTrackAdminData(license)
	MySQL.insert.await(
		"INSERT INTO electus_admin_active_admins (license, last_login) VALUES (@license, @last_login)",
		{ ["@license"] = license, ["@last_login"] = os.time() }
	)
end

--- @param source number
AddEventHandler("playerDropped", function()
	local playerId = source
	local playerLicense = GetPlayerIdentifierByType(playerId, "license"):gsub("license:", "")
	local isAdmin = GetStaffByLicense(playerLicense)

	if isAdmin then
		local adminActivity = MySQL.single.await(
			"SELECT * FROM electus_admin_active_admins WHERE license=@license",
			{ ["license"] = playerLicense }
		)

		if adminActivity then
			MySQL.update.await(
				"UPDATE electus_admin_active_admins SET logged_in = 0, saved_time = @saved_time WHERE license = @license",
				{
					["@license"] = playerLicense,
					["@saved_time"] = (os.time() - adminActivity.last_login) + adminActivity.saved_time,
				}
			)
		end
	end
end)

--- @return table | false | {}
function GetAdminActiveData()
	local result = MySQL.query.await("SELECT * FROM electus_admin_active_admins")

	local data = {}
	local differentColors = 5

	for i = 1, #result do
        local time = 0

        if(result[i].logged_in == 1) then
            time = (os.time() - result[i].last_login) + result[i].saved_time
        else
            time = result[i].saved_time
        end

		data[i] = {
			username = GetStaffByLicense(result[i].license)?.username,
			license = result[i].license,
			name = GetStaffByLicense(result[i].license)?.username,
			time = math.floor(time / 60),
			fill = "hsl(var(--chart-" .. (differentColors % i) + 1 .. "))",
		}
	end

	return data
end

--- @param role1 string
--- @param role2 string
--- @return boolean | table
function SwitchRoleGrades(role1, role2)
	local role1Data = GetRoleByName(role1)
	local role2Data = GetRoleByName(role2)

	if role1Data and role2Data then
		local tempGrade = role1Data.grade
		MySQL.update.await(
			"UPDATE electus_admin_roles SET grade=@grade WHERE name=@role",
			{ ["@role"] = role1, ["@grade"] = role2Data.grade }
		)
		MySQL.update.await(
			"UPDATE electus_admin_roles SET grade=@grade WHERE name=@role",
			{ ["@role"] = role2, ["@grade"] = tempGrade }
		)

		return true
	end

	return false
end

--- @param requestUser string
--- @param role string
--- @return boolean | table
function PromoteRole(requestUser, role)
	local hasPermissions = HasPermission(requestUser, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Promoted " .. requestUser .. " to role " .. role)

	local myRole = GetStaffByUsername(requestUser)?.role
	local myGrade = GetRoleByName(myRole).grade
	local targetRole = GetRoleByName(role)
	local targetGrade = targetRole?.grade or 1

	if myGrade < targetGrade or IsMainLicense(requestUser) then
		local toSwitchWith =
			MySQL.single.await("SELECT * FROM electus_admin_roles WHERE grade=@grade", { ["@grade"] = targetGrade - 1 })

		if not toSwitchWith then
			return false
		end

		return SwitchRoleGrades(role, toSwitchWith.name)
	else
		return false
	end
end

--- @param requestUser string
--- @param role string
--- @return boolean | table
function DemoteRole(requestUser, role)
	local hasPermissions = HasPermission(requestUser, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Demoted " .. requestUser .. " to role " .. role)

	local myRole = GetStaffByUsername(requestUser)?.role
	local myGrade = GetRoleByName(myRole).grade
	local targetRole = GetRoleByName(role)
	local targetGrade = targetRole?.grade or 1

	if myGrade < targetGrade or IsMainLicense(requestUser) then
		local toSwitchWith =
			MySQL.single.await("SELECT * FROM electus_admin_roles WHERE grade=@grade", { ["@grade"] = targetGrade + 1 })

		if not toSwitchWith then
			return false
		end

		return SwitchRoleGrades(role, toSwitchWith.name)
	else
		return false
	end
end

--- @param requestUsername string
--- @param role table
--- @return boolean | table
function CreateRole(requestUsername, role)
	local hasPermissions = HasPermission(requestUsername, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Created role " .. role.name .. " by " .. requestUsername)

	local roles = GetRoles()
	local highestGrade = 1

	if #roles > 0 then
		highestGrade = roles?[#roles]?.grade
	end

	local result = MySQL.insert.await(
		"INSERT INTO electus_admin_roles (name, label, color, grade, permissions) VALUES (@name, @label, @color, @grade, @permissions)",
		{
			["@name"] = role.name,
			["@label"] = role.label,
			["@color"] = role.color,
			["@grade"] = highestGrade + 1,
			["@permissions"] = json.encode(role.permissions),
		}
	)

	if result then
		return true
	else
		return false
	end
end

--- @param removedGrade number
function RemoveRoleGap(removedGrade)
	local roles = GetRoles()

	for i = 1, #roles do
		if roles[i].grade > removedGrade then
			MySQL.update.await(
				"UPDATE electus_admin_roles SET grade=@grade WHERE name=@role",
				{ ["@grade"] = roles[i].grade - 1, ["@role"] = roles[i].name }
			)
		end
	end
end

--- @param requestUsername string
--- @param role string
--- @return boolean | table
function DeleteRole(requestUsername, role)
	local hasPermissions = HasPermission(requestUsername, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Deleted role " .. role .. " by " .. requestUsername)

	local anyStaffs = MySQL.single.await("SELECT * FROM electus_admin_staffs WHERE role=@role", { ["role"] = role })

	if anyStaffs then
		return {
			error = L("manage_staffs.role_assigned"),
		}
	end

	local roleData = GetRoleByName(role)

	local result = MySQL.update.await("DELETE FROM electus_admin_roles WHERE name=@name", { ["@name"] = role })

	if result then
		RemoveRoleGap(roleData.grade)
		return true
	else
		return false
	end
end

--- @return table | false | {}
function GetRoles()
	local result = MySQL.query.await("SELECT * FROM electus_admin_roles ORDER BY grade ASC")

	if result then
		for i = 1, #result do
			result[i].permissions = json.decode(result[i].permissions)
		end

		return result
	else
		return {}
	end
end

--- @param requestUsername string
--- @param license string
--- @param roleName string
--- @return boolean | table
function ChangeRole(requestUsername, license, roleName)
	local hasPermissions = HasPermission(requestUsername, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Changed role " .. license .. " to " .. roleName .. " by " .. requestUsername)

	local result = MySQL.update.await(
		"UPDATE electus_admin_staffs SET role=@role WHERE license=@license",
		{ ["@role"] = roleName, ["@license"] = license }
	)

	if result then
		return true
	else
		return false
	end
end

--- @param requestUsername string
--- @param role table
--- @return boolean | table
function SaveRole(requestUsername, role)
	local hasPermissions = HasPermission(requestUsername, "manage_staffs")

	if not hasPermissions then
		return { error = "permission" }
	end

	AdminLog(-1, "info", "Saved role " .. role.name .. " by " .. requestUsername)

	local result = MySQL.update.await(
		"UPDATE electus_admin_roles SET label=@label, color=@color, grade=@grade, permissions=@permissions WHERE name=@name",
		{
			["@label"] = role.label,
			["@color"] = role.color,
			["@grade"] = role.grade,
			["@permissions"] = json.encode(role.permissions),
			["@name"] = role.name,
		}
	)

	if result then
		return true
	else
		return false
	end
end

local backendTokens = {}

function ValidateBackendToken(token, username)
	local savedToken = backendTokens[username]

	if savedToken == token then
		backendTokens[token] = nil
		return true
	else
		return false
	end
end

lib.callback.register("electus_admin:checkStaffStatus", function(source)
	local license = GetPlayerIdentifierByType(source, "license"):gsub("license:", ""):gsub("license2:", "")
	local staff = GetStaffByLicense(license)

	if staff and not staff.username or (not staff and ConfigServer.ownerLicense == license) then
		return { createAccount = true }
	elseif staff and staff.username then
		return true
	else
		return false
	end
end)

lib.callback.register("electus_admin:requestBackendToken", function(source, username)
	backendTokens[username] = math.random(1000000, 9999999)
	return backendTokens[username]
end)

lib.callback.register("electus_admin:getConnectedUser", function(source)
	local username = GetStaffByLicense(GetPlayerIdentifierByType(source, "license"):gsub("license:", ""):gsub("license2:", ""))?.username

	return username
end)

exports("ChangeRole", ChangeRole)
exports("GetRoles", GetRoles)
exports("CreateRole", CreateRole)
exports("PromoteRole", PromoteRole)
exports("DemoteRole", DemoteRole)
exports("GetAdminActiveData", GetAdminActiveData)
exports("GetStaffs", GetStaffs)
exports("AddStaff", AddStaff)
exports("ValidateUser", ValidateUser)
exports("GetStaffByUsername", GetStaffByUsername)
exports("RemoveStaff", RemoveStaff)
exports("DeleteRole", DeleteRole)
exports("HasPermission", HasPermission)
exports("SaveRole", SaveRole)
exports("ValidateBackendToken", ValidateBackendToken)
