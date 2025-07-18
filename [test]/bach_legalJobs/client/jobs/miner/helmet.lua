local minerConfig = lib.load("shared.jobs.miner")

local currentHelmet = {
    index = nil,
    texture = nil,
}
local isWearingHelmet = false

local function equipMinerHelmet()
    local playerPed = PlayerPedId()

    if isWearingHelmet then
        return
    end

    currentHelmet.index = GetPedPropIndex(playerPed, 0)
    currentHelmet.texture = GetPedPropTextureIndex(playerPed, 0)

    if currentHelmet.index ~= -1 then
        ClearPedProp(playerPed, 0)
    end

    SetPedPropIndex(playerPed, 0, minerConfig["minerHelmet"].prop, minerConfig["minerHelmet"].texture, true)
    isWearingHelmet = true
end

local function restoreOriginalHelmet()
    local playerPed = PlayerPedId()

    if not isWearingHelmet then
        return
    end

    ClearPedProp(playerPed, 0)

    if currentHelmet.index ~= -1 and currentHelmet.index ~= nil then
        SetPedPropIndex(playerPed, 0, currentHelmet.index, currentHelmet.texture, true)
    end
    isWearingHelmet = false
end

local function isPlayerWearingHelmet()
    local hasHelmet = exports.ox_inventory:Search("count", "minerhelmet")

    -- return GetPedPropIndex(PlayerPedId(), 0) == minerConfig["minerHelmet"].prop
    return true
end

exports("isPlayerWearingHelmet", isPlayerWearingHelmet)

local function toggleMinerHelmet()
    local puttingOnDict = "missheistdockssetup1hardhat@"
    local puttingOnClip = "put_on_hat"
    local takingOffDict = "missheist_agency2ahelmet"
    local takingOffClip = "take_off_helmet_stand"

    if not HasAnimDictLoaded(puttingOnDict) then
        RequestAnimDict(puttingOnDict)
        while not HasAnimDictLoaded(puttingOnDict) do
            Wait(10)
        end
    end

    if not HasAnimDictLoaded(takingOffDict) then
        RequestAnimDict(takingOffDict)
        while not HasAnimDictLoaded(takingOffDict) do
            Wait(10)
        end
    end

    if isWearingHelmet or GetPedPropIndex(PlayerPedId(), 0) == minerConfig["minerHelmet"].prop then
        lib.progressBar({
            duration = 600,
            label = "Fjerner minerhat...",
            useWhileMoving = false,
            canCancel = true,
            anim = {
                dict = takingOffDict,
                clip = takingOffClip,
                flags = 49,
            },
            disable = {
                move = false,
                car = false,
                combat = true,
            },
        })
        restoreOriginalHelmet()
        return false
    else
        local hasHelmet = exports.ox_inventory:Search("count", "minerhelmet")
        if hasHelmet > 0 then
            lib.progressBar({
                duration = 1000,
                label = "Tager minerhat på...",
                useWhileMoving = false,
                canCancel = true,
                anim = {
                    dict = puttingOnDict,
                    clip = puttingOnClip,
                    flags = 49,
                },
                disable = {
                    move = false,
                    car = false,
                    combat = true,
                },
            })
            equipMinerHelmet()
            return true
        else
            lib.notify({
                description = "Du har ikke en minerhat i dit inventar.",
                type = "error",
                icon = "fas fa-hat-hard",
            })
            return false
        end
    end
end

exports("toggleMinerHelmet", toggleMinerHelmet)
