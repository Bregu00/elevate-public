local shotspotter = {}

shotspotter.debug = false -- if you set it to true you will see the shotspotters on map.
shotspotter.delay = 1 -- delay in seconds for shotspotter to report a shooting.
shotspotter.cooldown = 120 -- seconds cooldown until player can trigger it again.
shotspotter.radius = 550 -- how far the shotspotter will detect shots.

shotspotter.ignoredJobs = {"police"}

shotspotter.locations = {

}

-- weapons that won't trigger the shotspotter
shotspotter.ignoredWeapons = {
    `weapon_flaregun`,
    `weapon_stungun_mp`,
    `weapon_grenade`,
    `weapon_bzgas`,
    `weapon_molotov`,
    `weapon_stickybomb`,
    `weapon_proxmine`,
    `weapon_snowball`,
    `weapon_pipebomb`,
    `weapon_ball`,
    `weapon_smokegrenade`,
    `weapon_flare`,
    `weapon_petrolcan`,
    `weapon_fireextinguisher`,
    `weapon_hazardcan`,
    `weapon_fertilizercan`
}

shotspotter.suppresors = {
    `COMPONENT_AT_PI_SUPP_02`, -- Pistol, Pistol Mk2, SNS Pistol Mk2.
    `COMPONENT_AT_PI_SUPP`, -- Combat Pistol, AP Pistol, Heavy Pistol, Vintage Pistol, SMG, SMG Mk2, Machine Pistol.
    `COMPONENT_AT_AR_SUPP_02`, -- .50 Pistol, Micro SMG, Assault SMG, Bullpup Shotgun, Heavy Shotgun, Assault Rifle, Special Carbine, Special Carbine Mk2, Assault Rifle Mk2, Sniper Rifle.
    `COMPONENT_AT_AR_SUPP`, -- Assault Shotgun, Combat Shotgun, Carbine Rifle, Advanced Rifle, Bullpup Rifle, Bullpup Rifle Mk2, Carbine Rifle Mk2, Military Rifle, Marksman Rifle Mk2, Marksman Rifle.
    `COMPONENT_AT_SR_SUPP` -- Pump Shotgun.
}


return shotspotter
