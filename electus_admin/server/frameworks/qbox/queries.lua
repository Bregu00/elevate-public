if Config.framework ~= "qbx" then
	return
end

Queries = {}

Queries.Users = {}
Queries.Users.table = "players"
Queries.Users.name = "CONCAT(JSON_EXTRACT(charinfo, '$.firstname'), ' ', JSON_EXTRACT(charinfo, '$.lastname'))"
Queries.Users.identifier = "citizenid"
Queries.Users.firstname = "JSON_EXTRACT(charinfo, '$.firstname')"
Queries.Users.lastname = "JSON_EXTRACT(charinfo, '$.lastname')"
Queries.Users.bank = "JSON_EXTRACT(money, '$.bank')"
Queries.Users.bank2 = "bank"
Queries.Users.cash = "JSON_EXTRACT(money, '$.cash')"
Queries.Users.cash2 = "cash"
Queries.Users.job = "job"
Queries.Users.accounts = "money"

Queries.Vehicles = {}
Queries.Vehicles.table = "player_vehicles"
Queries.Vehicles.plate = "plate"
Queries.Vehicles.garage = "garage"
Queries.Vehicles.owner = "citizenid"
Queries.Vehicles.vehicle = "mods"

Queries.Jobs = {}
Queries.Jobs.table = "job_grades"
Queries.Jobs.jobName = "job_name"
