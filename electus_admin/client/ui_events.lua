RegisterNUICallback("request_token", function(data, cb)
	local ret = lib.callback.await("electus_admin:checkStaffStatus", false)
	cb(ret)
end)

RegisterNUICallback("create_account", function(data, cb)
	local account = lib.callback.await("electus_admin:createAccount", false, data.username, data.password)

	cb(account)
end)

RegisterNUICallback("request_backend_token", function(data, cb)
	local token = lib.callback.await("electus_admin:requestBackendToken", false, data.username)
	cb(token)
end)

RegisterNUICallback("get_connected_user", function(data, cb)
	local username = lib.callback.await("electus_admin:getConnectedUser", false)
	cb(username)
end)
