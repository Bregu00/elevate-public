if (Config.framework ~= "qbx") and (Config.framework ~= "auto" or GetResourceState("qbx_core") ~= "started") then
	return
end

PlayerData = {}

function GetJobName()
	local job = QBX.PlayerData.job.name or ""

	return job
end

function GetIdentifier()
	local identifier = QBX.PlayerData.citizenid

	return identifier
end

function ApplyVehicleMods(vehicleEnt, vehicle)
	if type(vehicle) == "string" then
		vehicle = json.decode(vehicle)
	end

	SetVehicleNumberPlateText(vehicleEnt, vehicle.plate)
	lib.setVehicleProperties(vehicleEnt, vehicle)

	TriggerEvent("vehiclekeys:client:SetOwner", exports.qbx_core:getVehiclePlate(vehicleEnt))

	if GetResourceState("LegacyFuel") == "started" and vehicle.fuel then
		exports.LegacyFuel:SetFuel(vehicleEnt, vehicle.fuel)
	end
end

function GetVehicleMods(vehicleEnt)
	return lib.getVehicleProperties(vehicleEnt)
end
