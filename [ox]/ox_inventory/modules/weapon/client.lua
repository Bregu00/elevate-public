if not lib then return end

local Weapon = {}
local Items = require 'modules.items.client'
local Utils = require 'modules.utils.client'
local Holsters = exports["jungurum-smallresources"]:getHolsterConfig()

local plyState = LocalPlayer.state
local Vehicles = data 'vehicles'

local function vehicleIsCycle(vehicle)
	local class = GetVehicleClass(vehicle)
	return class == 8 or class == 13
end

function Weapon.Equip(item, data)
	local playerPed = cache.ped
	local playerModel = GetEntityModel(playerPed)
	local coords = GetEntityCoords(playerPed, true)
	local sleep

	if client.weaponanims then
		if cache.vehicle and vehicleIsCycle(cache.vehicle) then
			goto skipAnim
		end
		if Holsters.StashWeapons[data.hash] and not Holsters.ValidPedBags[playerModel] then return false end
		if Holsters.StashWeapons[data.hash] and not Holsters.ValidPedBags[playerModel].bags[GetPedDrawableVariation(playerPed, Holsters.ValidPedBags[playerModel].variation)] then return false end
		local animDict, anim = "", ""
		if Holsters.StashWeapons[data.hash] then
			animDict = 'anim@heists@ornate_bank@grab_cash'
			anim = "intro"
			sleep = 700
		elseif Holsters.HolsterWeapons[data.hash] then
			local hasFoundHolster, foundVaration, foundHolster = Utils.IsValidHolster("remove")
			if hasFoundHolster then Utils.HandleWeaponHolster(foundVaration, foundHolster, "remove") end

			animDict = 'reaction@intimidation@1h'
			anim = 'intro'
			sleep = 1200

			if Holsters.ValidPedHolsters[playerModel] and Holsters.ValidPedHolsters[playerModel][foundVaration] then
				local holsterData = Holsters.ValidPedHolsters[playerModel][foundVaration].holsterRemoveWeapon[foundHolster]
				if holsterData then
					if holsterData.holster == 'holster' then
						animDict = 'rcmjosh4'
						anim = 'josh_leadout_cop2'
						sleep = 250
					elseif holsterData.holster == 'holster_front' then
						animDict = 'combat@combat_reactions@pistol_1h_gang'
						anim = '0'
						sleep = 700
					end
				end
			end
		elseif data.hash == `WEAPON_SWITCHBLADE` then
			animDict = 'anim@melee@switchblade@holster'
			anim = "unholster"
			sleep = 200
		end

		if animDict ~= "" and anim ~= "" and sleep ~= 0 then
			Utils.PlayAnimAdvanced(sleep, animDict, anim, coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, sleep*2, 50, 0.0)
		end
	end

	::skipAnim::

	item.hash = data.hash
	item.ammo = data.ammoname
	item.melee = GetWeaponDamageType(data.hash) == 2 and 0
	item.timer = 0
	item.throwable = data.throwable
	item.group = GetWeapontypeGroup(item.hash)

	GiveWeaponToPed(playerPed, data.hash, 0, false, true)

	if item.metadata.tint then SetPedWeaponTintIndex(playerPed, data.hash, item.metadata.tint) end

	if item.metadata.components then
		for i = 1, #item.metadata.components do
			local components = Items[item.metadata.components[i]].client.component
			for v=1, #components do
				local component = components[v]
				if DoesWeaponTakeWeaponComponent(data.hash, component) then
					if not HasPedGotWeaponComponent(playerPed, data.hash, component) then
						GiveWeaponComponentToPed(playerPed, data.hash, component)
					end
				end
			end
		end
	end

	if item.metadata.specialAmmo then
		local clipComponentKey = ('%s_CLIP'):format(data.model:gsub('WEAPON_', 'COMPONENT_'))
		local specialClip = ('%s_%s'):format(clipComponentKey, item.metadata.specialAmmo:upper())

		if DoesWeaponTakeWeaponComponent(data.hash, specialClip) then
			GiveWeaponComponentToPed(playerPed, data.hash, specialClip)
		end
	end

	local ammo = item.metadata.ammo or item.throwable and 1 or 0

	SetCurrentPedWeapon(playerPed, data.hash, true)
	SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
	SetWeaponsNoAutoswap(true)
	SetPedAmmo(playerPed, data.hash, ammo)
	SetTimeout(0, function() RefillAmmoInstantly(playerPed) end)

	if item.group == `GROUP_PETROLCAN` or item.group == `GROUP_FIREEXTINGUISHER` then
		item.metadata.ammo = item.metadata.durability
		SetPedInfiniteAmmo(playerPed, true, data.hash)
	end

	TriggerEvent('ox_inventory:currentWeapon', item)
	Utils.ItemNotify({ item, 'ui_equipped' })

	return item, sleep
end

function Weapon.Disarm(currentWeapon, noAnim)
	local playerPed = cache.ped
	local playerModel = GetEntityModel(playerPed)
	if currentWeapon?.timer then
		currentWeapon.timer = nil

		if source == '' then
			TriggerServerEvent('ox_inventory:updateWeapon')
		end

		SetPedAmmo(cache.ped, currentWeapon.hash, 0)

		if client.weaponanims then
			if cache.vehicle and vehicleIsCycle(cache.vehicle) then
				goto skipAnim
			end

			ClearPedSecondaryTask(cache.ped)

			local animDict, anim, sleep = "", "", 0
			if Holsters.StashWeapons[currentWeapon.hash] then
				animDict = 'anim@heists@ornate_bank@grab_cash'
				anim = "intro"
				sleep = 700
			elseif Holsters.HolsterWeapons[currentWeapon.hash] then
				local hasFoundHolster, foundVaration, foundHolster = Utils.IsValidHolster("add")
				if hasFoundHolster then Utils.HandleWeaponHolster(foundVaration, foundHolster, "add") end

				animDict = 'reaction@intimidation@1h'
				anim = 'outro'
				sleep = 1500
	
				if Holsters.ValidPedHolsters[playerModel] and Holsters.ValidPedHolsters[playerModel][foundVaration] then
					local holsterData = Holsters.ValidPedHolsters[playerModel][foundVaration].holsterAddWeapon[foundHolster]
					if holsterData then
						if holsterData.holster == 'holster' then
							animDict = 'rcmjosh4'
							anim = 'josh_leadout_cop2'
							sleep = 250
						elseif holsterData.holster == 'holster_front' then
							animDict = 'combat@combat_reactions@pistol_1h_gang'
							anim = '0'
							sleep = 700
						end
					end
				end
			elseif currentWeapon.hash == `WEAPON_SWITCHBLADE` then
				animDict = 'anim@melee@switchblade@holster'
				anim = "holster"
				sleep = 600
			end

			if animDict ~= "" and anim ~= "" and sleep ~= 0 and not noAnim then 
				local coords = GetEntityCoords(cache.ped, true)
				Utils.PlayAnimAdvanced(sleep, animDict, anim, coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, sleep*2, 50, 0.0)
			end
		end

		::skipAnim::

		Utils.ItemNotify({ currentWeapon, 'ui_holstered' })
		TriggerEvent('ox_inventory:currentWeapon')
	end

	Utils.WeaponWheel()
	RemoveAllPedWeapons(cache.ped, true)
end

function Weapon.CanEquip(data)
	local playerPed = PlayerPedId()
	if Holsters.StashWeapons[data.hash] then
		local playerModel = GetEntityModel(playerPed)
		local hasStash = false

		if Holsters.ValidPedBags[playerModel] then
			local currentBag = GetPedDrawableVariation(playerPed, Holsters.ValidPedBags[playerModel].variation)
			local currentTextureBag = GetPedTextureVariation(playerPed, Holsters.ValidPedBags[playerModel].variation)
			hasStash = Holsters.ValidPedBags[playerModel].bags[currentBag] and (currentTextureBag ~= 255 and currentTextureBag ~= -1)
		end

		if not hasStash then
			local entity, type = Utils.Raycast()
			if entity and type == 2 then
				local vehicle, position = entity, GetEntityCoords(entity)

				local vehicleClass = GetVehicleClass(vehicle)
				if Vehicles.trunk[vehicleClass] then
					local playerCoords = GetEntityCoords(playerPed)
					if #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
						local locked = GetVehicleDoorLockStatus(vehicle)
						if locked == 0 or locked == 1 then hasStash = true end
					end
				end
			end
		end

		if not hasStash then return false end
	end

	return true
end

function Weapon.ClearAll(currentWeapon)
	Weapon.Disarm(currentWeapon)

	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
	end
end

Utils.Disarm = Weapon.Disarm
Utils.ClearWeapons = Weapon.ClearAll

return Weapon
