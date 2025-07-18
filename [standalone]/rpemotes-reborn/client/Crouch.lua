local Crouched = false
local CrouchedForce = false
local Aimed = false
local CoolDown = false

local PlayerInfo = {
	playerPed = cache.ped,
	playerID = cache.playerId,
	nextCheck = GetGameTimer() + 1500
}

local CoolDownTime = 500 -- in ms // if put 0 or false you will disable the cooldown

local function RefreshPlayerInfo(force)
	local now = GetGameTimer()
	if force or now >= PlayerInfo.nextCheck then
		PlayerInfo = {
			playerPed = cache.ped,
			playerID = cache.playerId,
			nextCheck = now + 1500
		}
	end
end

local function NormalWalk()
    ResetPedStrafeClipset(PlayerInfo.playerPed)
    ResetPedWeaponMovementClipset(PlayerInfo.playerPed)
    SetPedMaxMoveBlendRatio(PlayerInfo.playerPed, 1.0)
    SetPedCanPlayAmbientAnims(PlayerInfo.playerPed, true)

    local walkstyle = GetResourceKvpString("walkstyle")
    if walkstyle ~= nil then
        RequestWalking(walkstyle)
        SetPedMovementClipset(PlayerInfo.playerPed, walkstyle, 0.5)
        RemoveClipSet(walkstyle)
    else
        ResetPedMovementClipset(PlayerInfo.playerPed, 0.5)
    end

    RemoveAnimSet('move_ped_crouched')
	LocalPlayer.state.Crouched = false
	Crouched = false
end

local function SetupCrouch()
	while not HasAnimSetLoaded('move_ped_crouched') do
		Wait(5)
		RequestAnimSet('move_ped_crouched')
	end
end

local function RemoveCrouchAnim()
	RemoveAnimDict('move_ped_crouched')
end

local function CanCrouch()
	if IsPedOnFoot(PlayerInfo.playerPed) and not IsPedInAnyVehicle(PlayerInfo.playerPed, false) and not IsPedJumping(PlayerInfo.playerPed)
	and not IsPedFalling(PlayerInfo.playerPed) and not IsPedDeadOrDying(PlayerInfo.playerPed) then
		return true
	else
		return false
	end
end

local function CrouchPlayer()
	SetPedUsingActionMode(PlayerInfo.playerPed, false, -1, "DEFAULT_ACTION")
	SetPedMovementClipset(PlayerInfo.playerPed, 'move_ped_crouched', 0.55)
	SetPedStrafeClipset(PlayerInfo.playerPed, 'move_ped_crouched_strafing') -- it force be on third person if not player will freeze but this func make player can shoot with good anim on crouch if someone know how to fix this make request :D
	SetWeaponAnimationOverride(PlayerInfo.playerPed, "Ballistic")
	LocalPlayer.state.Crouched = true
	Crouched = true
	Aimed = false
end

local function SetPlayerAimSpeed()
	SetPedMaxMoveBlendRatio(PlayerInfo.playerPed, 0.2)
	Aimed = true
end

local function IsPlayerFreeAimed()
	if IsPlayerFreeAiming(PlayerInfo.playerID) or IsAimCamActive() or IsAimCamThirdPersonActive() then
		return true
	else
		return false
	end
end

local function CrouchLoop()
	SetupCrouch()
	while CrouchedForce do
		DisableFirstPersonCamThisFrame()

		RefreshPlayerInfo()

		local CanDo = CanCrouch()
		if CanDo and Crouched and IsPlayerFreeAimed() then
			SetPlayerAimSpeed()
		elseif CanDo and (not Crouched or Aimed) then
			CrouchPlayer()
		elseif not CanDo and Crouched then
			CrouchedForce = false
			NormalWalk()
		end

		Wait(5)
	end
	NormalWalk()
	RemoveCrouchAnim()
end

RegisterCommand('crouch', function()
	DisableControlAction(0, 36, true)
	if not CoolDown and not LocalPlayer.state.invOpen and not cache.vehicle then
		RefreshPlayerInfo(true)

		local CanDo = CanCrouch()
		CrouchedForce = CanDo and not CrouchedForce or false

		if CrouchedForce then
			CreateThread(CrouchLoop)
		end

		if CoolDownTime and CoolDownTime ~= 0 then
			CoolDown = true
			SetTimeout(CoolDownTime, function()
				CoolDown = false
			end)
		end
	end
end, false)
RegisterKeyMapping('crouch', 'Crouch', 'keyboard', 'LCONTROL')