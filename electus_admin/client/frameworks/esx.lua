PlayerData = {}

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

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer, isNew, skin)
	PlayerData = xPlayer
	-- TriggerEvent("electus_gangs:playerLoaded")
	-- OnPlayerLoad()
end)

function MenuClose()
	ESX.UI.Menu.CloseAll()
end

function GetJobName()
	local job = ESX.GetPlayerData().job.name

	return job
end

function GetIdentifier()
	local identifier = ESX.GetPlayerData().identifier

	return identifier
end

function EnableHelpText(msg, icon)
	lib.showTextUI(msg, {
		icon = icon,
		style = {
			borderRadius = 10,
			backgroundColor = "#111111",
			color = "#ffffff",
		},
	})
end

function DisableHelpText()
	lib.hideTextUI()
end

function GetInventory()
	local inventory = ESX.GetPlayerData().inventory
	return inventory
end

function ApplyVehicleMods(vehicleEnt, vehicle)
	if type(vehicle) == "string" then
		vehicle = json.decode(vehicle)
	end

	SetVehicleOnGroundProperly(vehicleEnt)
	SetVehicleNumberPlateText(vehicleEnt, vehicle.plate)

	ESX.Game.SetVehicleProperties(vehicleEnt, vehicle)

	if vehicle.damages then
		SetVehicleEngineHealth(vehicleEnt, vehicle.damages.engineHealth)
		SetVehicleBodyHealth(vehicleEnt, vehicle.damages.bodyHealth)
	end

	if vehicle.fuel then
		SetVehicleFuelLevel(vehicleEnt, vehicle.fuel)
	end
end

function GetVehicleMods(vehicleEnt)
	local mods = ESX.Game.GetVehicleProperties(vehicleEnt)
	return mods
end
