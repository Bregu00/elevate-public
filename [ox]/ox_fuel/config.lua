if not lib.checkDependency('ox_lib', '3.22.0', true) then return end
if not lib.checkDependency('ox_inventory', '2.30.0', true) then return end

return {
	-- Get notified when a new version releases
	versionCheck = true,

	-- Enable support for ox_target
	ox_target = true,

	/*
	* Show or hide gas stations blips
	* 0 - Hide all
	* 1 - Show nearest (5000ms interval check)
	* 2 - Show all
	*/
	showBlips = 1,

	-- Total duration (ex. 10% missing fuel): 10 / 0.25 * 250 = 10 seconds

	-- Fuel refill value (every 250msec add 0.25%)
	refillValue = 1.0,

	-- Fuel tick time (every 250 msec)
	refillTick = 250,

	-- Fuel cost (Added once every tick)
	priceTick = 5,

	-- Can durability loss per refillTick
	durabilityTick = 1.3,

	-- Enables fuel can
	petrolCan = {
		enabled = true,
		duration = 5000,
		price = 1000,
		refillPrice = 800,
	},

	---Modifies the fuel consumption rate of all vehicles - see [`SET_FUEL_CONSUMPTION_RATE_MULTIPLIER`](https://docs.fivem.net/natives/?_0x845F3E5C).
	globalFuelConsumptionRate = 10.0,

	-- Gas pump models
	pumpModels = {
		`prop_gas_pump_old2`,
		`prop_gas_pump_1a`,
		`prop_vintage_pump`,
		`prop_gas_pump_old3`,
		`prop_gas_pump_1c`,
		`prop_gas_pump_1b`,
		`prop_gas_pump_1d`,
		'486135101',
	},

	-- Electric Ting
	Locations = {
		vec4(175.9, -1546.65, 28.26, 224.29),
		vec4(-51.09, -1767.02, 28.26, 47.16),
		vec4(-514.06, -1216.25, 17.46, 66.29),
		vec4(-704.64, -935.71, 18.21, 90.02),
		vec4(279.79, -1237.35, 28.35, 181.07),
		vec4(834.27, -1028.7, 26.16, 88.39),
		vec4(1194.41, -1394.44, 34.37, 270.3),
		vec4(1168.38, -323.56, 68.3, 280.22),
		vec4(633.64, 247.22, 102.3, 60.29),
		vec4(-1420.51, -278.76, 45.26, 137.35),
		vec4(-2080.61, -338.52, 12.26, 352.21),
		vec4(-98.12, 6403.39, 30.64, 141.49),
		vec4(181.14, 6636.17, 30.61, 179.96),
		vec4(1714.14, 6425.44, 31.79, 155.94),
		vec4(1703.57, 4937.23, 41.08, 55.74),
		vec4(1994.54, 3778.44, 31.18, 215.25),
		vec4(1770.86, 3337.97, 40.43, 301.1),
		vec4(2690.25, 3265.62, 54.24, 58.98),
		vec4(1208.26, 2649.46, 36.85, 222.32),
		vec4(1033.32, 2662.91, 38.55, 95.38),
		vec4(267.96, 2599.47, 43.69, 5.8),
		vec4(50.21, 2787.38, 56.88, 147.2),
		vec4(-2570.04, 2317.1, 32.22, 21.29),
		vec4(2545.81, 2586.18, 36.94, 83.74),
		vec4(2561.24, 357.3, 107.62, 266.65),
		vec4(-1819.22, 798.51, 137.16, 315.13),
		vec4(-341.63, -1459.39, 29.76, 271.73),
		vec4(837.7554, -793.623, 25.23, 105.22)
	},

	chargerModels = {
		`electric_charger`
	},

	electricVehicles = {
		[GetHashKey("cyclone")] = true,
		[GetHashKey("cyclone2")] = true,
		[GetHashKey("dilettante")] = true,
		[GetHashKey("iwagen")] = true,
		[GetHashKey("imorgon")] = true,
		[GetHashKey("khamelion")] = true,
		[GetHashKey("neon")] = true,
		[GetHashKey("omnisegt")] = true,
		[GetHashKey("raiden")] = true,
		[GetHashKey("surge")] = true,
		[GetHashKey("tezeract")] = true,
		[GetHashKey("virtue")] = true,
		[GetHashKey("voltic")] = true,
	}
}