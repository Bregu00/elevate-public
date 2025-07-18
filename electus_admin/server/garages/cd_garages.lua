if Config.garage ~= "cd_garage" then
	return
end

function GetGarages()
	local cfg = exports["cd_garage"]:GetConfig()
	local garages = {}

	for k, v in pairs(cfg.Locations) do
		garages[#garages + 1] = {
			name = v.Garage_ID,
			label = v.Garage_ID,
		}
	end

	return garages
end

function UpdateGarage(plate, parking)
	if Config.framework == "esx" then
		MySQL.update.await("UPDATE owned_vehicles SET garage_id = ? WHERE `plate` = ?", { parking, plate })
	elseif Config.framework == "qb" then
		MySQL.update.await("UPDATE player_vehicles SET garage_id = ? WHERE plate = ?", { parking, plate })
	end

	return true
end
