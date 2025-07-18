local config = lib.load("shared.jobcenter")
local jobs = lib.load("shared.jobs")

local function createjobcenterBlip()
    local coords = config["locations"]["jobcenter"].coords
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 498)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Job Center")
    EndTextCommandSetBlipName(blip)
    return blip
end

local function openjobcenter()
    local options = {
        {
            title = "Tilgængelige jobs",
            description = "Liste af tilgængelige jobs",
            icon = "fa-solid fa-briefcase",
            iconColor = "#c17b3f",
        }
    }

    for _, job in pairs(jobs["jobs"]) do
        options[#options + 1] = {
            title = job.label,
            description = ('%s | Type: %s'):format(job.description, job.type),
            icon = "fa-solid fa-" .. job.icon,
            iconColor = job.iconColor,
            onSelect = function()
                SetNewWaypoint(job.coords)
            end,
        }
    end

    lib.registerContext({
        id = "jobcenter_menu",
        title = "Job Center",
        menuBackdrop = "blur",
        options = options,
    })
    lib.showContext("jobcenter_menu")
end

local function createjobcenterPed()
    local pedModel = config["locations"]["jobcenter"].pedModel
    lib.requestModel(pedModel, 1000)

    local coords = vector4(config["locations"]["jobcenter"].coords.x, config["locations"]["jobcenter"].coords.y,
        config["locations"]["jobcenter"].coords.z - 1.0, config["locations"]["jobcenter"].coords.w)

    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)

    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addBoxZone({
        coords = vector3(config["locations"]["jobcenter"].coords.x, config["locations"]["jobcenter"].coords.y,
            config["locations"]["jobcenter"].coords.z),
        size = vec3(2, 2, 2),
        rotation = config["locations"]["jobcenter"].coords.w,
        debug = false,
        options = {
            {
                name = "jobcenter",
                icon = "fa-solid fa-tree-city",
                label = "Job Center",
                distance = 2.0,
                onSelect = function()
                    openjobcenter()
                end,
            },
        },
    })

    return ped
end

CreateThread(function()
    local jobcenterPed = createjobcenterPed()
    local jobcenterBlip = createjobcenterBlip()
end)