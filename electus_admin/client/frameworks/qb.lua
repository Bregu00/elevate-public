QBCore = nil
PlayerData = {}

if Config.framework ~= "qb" then
	return
end

QBCore = exports["qb-core"]:GetCoreObject()

function MenuClose()
	QBCore.UI.Menu.CloseAll()
end

PlayerData = QBCore.Functions.GetPlayerData()

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	-- TriggerEvent("electus_gangs:playerLoaded")
	-- OnPlayerLoad()
end)

function GetJobName()
	local job = QBCore.Functions.GetPlayerData().job.name

	return job
end

function GetIdentifier()
	local identifier = QBCore.Functions.GetPlayerData().citizenid

	return identifier
end

function ApplyVehicleMods(vehicleEnt, vehicle)
	if type(vehicle) == "string" then
		vehicle = json.decode(vehicle)
	end

	SetVehicleNumberPlateText(vehicleEnt, vehicle.plate)

	QBCore.Functions.SetVehicleProperties(vehicleEnt, vehicle.mods)
	TriggerEvent("vehiclekeys:client:SetOwner", QB.Functions.GetPlate(vehicleEnt))

	if GetResourceState("LegacyFuel") == "started" and vehicle.fuel then
		exports.LegacyFuel:SetFuel(vehicleEnt, vehicle.fuel)
	end
end

function GetVehicleMods(vehicleEnt)
	local mods = QB.Functions.GetVehicleProperties(vehicleEnt)
	return mods
end
