if Config.garage ~= "qb-garages" then
	return
end

function GetGarages()
	return exports["qb-garages"].getAllGarages()
end

function UpdateGarage(plate, parking)
	MySQL.update("UPDATE player_vehicles SET garage = ? WHERE plate = ?", { parking, plate })

	return true
end
