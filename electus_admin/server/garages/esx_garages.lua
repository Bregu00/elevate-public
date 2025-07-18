if Config.garage ~= "esx_garage" then
	return
end

function GetGarages()
	local esxGarages = exports["esx_garage"].getGarages()
	local garages = {}

	for k, v in pairs(esxGarages) do
		garages[#garages + 1] = {
			name = k,
			label = k,
		}
	end

	return garages
end

function UpdateGarage(plate, parking)
	MySQL.update("UPDATE owned_vehicles SET `parking` = @parking WHERE `plate` = @plate", {
		["@plate"] = plate,
		["@parking"] = parking,
	})

	return true
end
