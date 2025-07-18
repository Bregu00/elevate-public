local isPlayerIdsEnabled = false
local playerGamerTags = {}
local distanceToCheck = 10

local fivemGamerTagCompsEnum = {
    GamerName = 0,
    AudioIcon = 4,
}

local function cleanAllGamerTags()
    for _, v in pairs(playerGamerTags) do
        if IsMpGamerTagActive(v.gamerTag) then
            RemoveMpGamerTag(v.gamerTag)
        end
    end
    playerGamerTags = {}
end

local function setGamerTagFivem(targetTag, pid)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 1)
    SetMpGamerTagAlpha(targetTag, fivemGamerTagCompsEnum.AudioIcon, 255)
    if NetworkIsPlayerTalking(pid) then
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, true)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 12)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 12)
    else
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, false)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    end
end

local function clearGamerTagFivem(targetTag)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
end

local function showGamerTags()
    local curCoords = GetEntityCoords(PlayerPedId())
    local allActivePlayers = GetActivePlayers()
    local localPlayerId = PlayerId()

    for _, pid in ipairs(allActivePlayers) do
        local targetPed = GetPlayerPed(pid)
        local playerId = GetPlayerServerId(pid)

        if playerGamerTags[pid] and IsMpGamerTagActive(playerGamerTags[pid].gamerTag) then
            clearGamerTagFivem(playerGamerTags[pid].gamerTag)
        end
        playerGamerTags[pid] = nil

        playerGamerTags[pid] = {
            gamerTag = CreateFakeMpGamerTag(targetPed, playerId, false, false, 0),
            ped = targetPed,
        }
        local targetTag = playerGamerTags[pid].gamerTag
        local targetPedCoords = GetEntityCoords(targetPed)
        if #(targetPedCoords - curCoords) <= distanceToCheck or pid == localPlayerId then
            setGamerTagFivem(targetTag, pid)
        else
            clearGamerTagFivem(targetTag)
        end
    end
end

local function createGamerTagThread()
    CreateThread(function()
        while isPlayerIdsEnabled do
            showGamerTags()
            Wait(500)
        end
        cleanAllGamerTags()
    end)
end

function toggleShowPlayerIDs(enabled, showNotification)
    isPlayerIdsEnabled = enabled
    if isPlayerIdsEnabled then
        createGamerTagThread()
    end
end

lib.addKeybind({
    name = "id_peak",
    description = "Vis nærmeste ID's",
    defaultKey = "PAGEUP",
    onPressed = function(self)
        toggleShowPlayerIDs(true, false)
    end,
    onReleased = function(self)
        toggleShowPlayerIDs(false, false)
    end,
})