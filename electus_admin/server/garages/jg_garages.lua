if Config.garage ~= "jg-advancedgarages" then
	return
end

function GetGarages()
	return exports["jg-advancedgarages"]:getAllGarages()
end

function UpdateGarage(plate, parking)
	if Config.framework == "esx" then
		MySQL.update("UPDATE owned_vehicles SET garage_id = ? WHERE `plate` = ?", { parking, plate })

		return true
	elseif Config.framework == "qb" then
		MySQL.update("UPDATE player_vehicles SET garage_id = ? WHERE plate = ?", { parking, plate })

		return true
	end
end
