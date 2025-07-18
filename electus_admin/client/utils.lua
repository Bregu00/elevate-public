function SendReactMessage(action, data)
	SendNUIMessage({
		action = action,
		data = data,
	})
end

function HelpText(msg)
	lib.showTextUI(msg)
end

function Notify(text, type)
	lib.notify({
		title = L("shared.admin_menu"),
		description = text,
		type = type,
	})
end

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(("%s-debugMode"):format(currentResourceName), 0) == 1

function debugPrint(...)
	if not debugIsEnabled then
		return
	end
	local args <const> = { ... }

	local appendStr = ""
	for _, v in ipairs(args) do
		appendStr = appendStr .. " " .. tostring(v)
	end
	local msgTemplate = "^3[%s]^0%s"
	local finalMsg = msgTemplate:format(currentResourceName, appendStr)
	print(finalMsg)
end

local ray
local rayFlag = 1 | 16 | 32 | 64 | 128 | 256
local lastWorldCoords = vector3(0.0, 0.0, 0.0)
local lastSurfaceNormal = vector3(0.0, 0.0, 0.0)
local depth = 75

function GetWorldCoordsFromScreen()
	if not ray then
		local world, normal = GetWorldCoordFromScreenCoord(0.5, 0.5)
		local targetCoords = world + normal * depth

		ray = StartShapeTestLosProbe(
			world.x,
			world.y,
			world.z,
			targetCoords.x,
			targetCoords.y,
			targetCoords.z,
			rayFlag,
			PlayerPedId(),
			7
		)
	end

	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)

	if retval ~= 1 then
		if endCoords ~= vector3(0.0, 0.0, 0.0) then
			lastWorldCoords = endCoords
			lastSurfaceNormal = surfaceNormal
		end

		ray = nil
	end

	return lastWorldCoords, lastSurfaceNormal
end

function GetWorldCoordsAndMaterialFromScreen()
	local camCoords = GetFinalRenderedCamCoord()
	local rot = GetFinalRenderedCamRot(2)
	local dir = RotToDir(rot)
	local endPoint = camCoords + dir * 75
	local raycast = StartExpensiveSynchronousShapeTestLosProbe(
		camCoords.x,
		camCoords.y,
		camCoords.z,
		endPoint.x,
		endPoint.y,
		endPoint.z,
		1,
		PlayerPedId(),
		4
	)
	local result, hit, coords, surfaceNormal, material = GetShapeTestResultIncludingMaterial(raycast)

	return coords, surfaceNormal, material
end

function RotToDir(rot)
	return vector3(
		-math.sin((math.pi / 180) * rot.z) * math.abs(math.cos((math.pi / 180) * rot.x)),
		math.cos((math.pi / 180) * rot.z) * math.abs(math.cos((math.pi / 180) * rot.x)),
		math.sin((math.pi / 180) * rot.x)
	)
end

function ReloadAndCloseUI()
	SendReactMessage("updateComponent", {
		component = "",
	})
	ToggleNuiFrame(false)
end

function GetUtils()
	if not Config.apiUrl then
		local weburl = lib.callback.await("electus_admin:getBaseUrl", false)

		Config.apiUrl = weburl
	end

	return {
		config = Config,
		locale = GetAllLocales(),
	}
end
