local function hasItem()
    local ped = PlayerPedId()
    local _, wep = GetCurrentPedWeapon(ped)

    for i = 1, #Config.slashTireOptions.weapons do
        if wep == GetHashKey(Config.slashTireOptions.weapons[i][1]) then
            return true
        end
    end
    return false
end

local function GetDriverOfVehicle(vehicle)
	local driver = GetPedInVehicleSeat(vehicle, -1)
    if driver then
        if IsPedAPlayer(driver) then
            local plyId = NetworkGetPlayerIndexFromPed(driver)
            if NetworkGetPlayerIndexFromPed(driver) > 0 then
                return plyId
            else
                return -1
            end
        else
            return -1
        end
    else
        return -1
	end
end

local function loadDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(50) RequestAnimDict(dict) end
    return dict
end

local function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local plyPed = PlayerPedId()
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.5
	local closestTire = nil
	
	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = #(plyPos - vector3(bonePos.x, bonePos.y, bonePos.z))

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end
    -- print(closestTire, 'closestTire')
	return closestTire
end

CreateThread(function()
    exports['ox_target']:addGlobalVehicle({
        label = 'Stik dæk',
        name = 'slashtire',
        distance = Config.slashTireOptions.distance,
        bones = {'wheel_lf', 'wheel_rf', 'wheel_lm1', 'wheel_rm1', 'wheel_lm2', 'wheel_rm2', 'wheel_lm3', 'wheel_rm3', 'wheel_lr', 'wheel_rr'},
        canInteract = function(entity)
            return hasItem()
        end,
        onSelect = function(entity)
            local closestTire = GetClosestVehicleTire(entity.entity)
            if closestTire ~= nil then
                if IsVehicleTyreBurst(entity.entity, closestTire.tireIndex, 0) == false then
                    local animDict = 'melee@knife@streamed_core_fps'
                    local animName = 'ground_attack_on_spot'
                    loadDict('melee@knife@streamed_core_fps')
                    local animDuration = GetAnimDuration(animDict, animName)
                    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, animDuration, 15, 1.0, 0, 0, 0)
                    Wait((animDuration / 2) * 1000)
                    local driverId = GetDriverOfVehicle(entity.entity)
                    local driverServId = GetPlayerServerId(driverId)
                    if driverServId == 0 then
                        SetEntityAsMissionEntity(entity.entity, true, true)
                        SetVehicleTyreBurst(entity.entity, closestTire.tireIndex, 0, 100.0)
                        SetEntityAsNoLongerNeeded(entity.entity)
                    else
                        TriggerServerEvent('jungurum-tireslash:server:sync', driverServId, closestTire.tireIndex)
                    end
                    Wait((animDuration / 2) * 1000)
                    ClearPedTasks(PlayerPedId())
                    RemoveAnimDict(animDict)
                else
                    lib.notify({title = 'Dækket er allerede punkteret', type = 'error'})
                end
            end
        end,
    })
end)

RegisterNetEvent('jungurum-tireslash:client:sync', function(tireIndex)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleTyreBurst(vehicle, tireIndex, 0, 100.0)
end)