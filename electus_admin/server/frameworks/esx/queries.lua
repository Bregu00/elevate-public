if Config.framework ~= "esx" then
	return
end

Queries = {}

Queries.Users = {}
Queries.Users.table = "users"
Queries.Users.name = "CONCAT(firstname, ' ', lastname)"
Queries.Users.identifier = "identifier"
Queries.Users.firstname = "firstname"
Queries.Users.lastname = "lastname"
Queries.Users.bank = "JSON_EXTRACT(accounts, '$.bank')"
Queries.Users.bank2 = "bank"
Queries.Users.cash = "JSON_EXTRACT(accounts, '$.money')"
Queries.Users.cash2 = "money"
Queries.Users.job = "job"
Queries.Users.accounts = "accounts"

Queries.Vehicles = {}
Queries.Vehicles.table = "owned_vehicles"
Queries.Vehicles.plate = "plate"
Queries.Vehicles.garage = "stored"
Queries.Vehicles.outside = "parked"
Queries.Vehicles.owner = "owner"
Queries.Vehicles.vehicle = "vehicle"

Queries.Jobs = {}
Queries.Jobs.table = "job_grades"
Queries.Jobs.jobName = "job_name"
