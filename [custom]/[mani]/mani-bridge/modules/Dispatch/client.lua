local function Dispatch(data)
    data = data or {}
    local playerCoords = GetEntityCoords(PlayerPedId())
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local locationInfo = GetStreetNameFromHashKey(streetName)
    if crossingRoad ~= nil and crossingRoad ~= 0 then
        local crossName = GetStreetNameFromHashKey(crossingRoad)
        if crossName and crossName ~= "" then
            locationInfo = locationInfo .. " & " .. crossName
        end
    end
    local gender = GetGender()

    if Config.Dispatch.Resource == 'linden' then
        TriggerServerEvent('wf-alerts:svNotify', {
            dispatchData = {
                displayCode = data.displayCode,
                description = data.description,
                isImportant = 0,
                recipientList = Config.Dispatch.jobs,
                length = '10000',
                infoM = 'fa-info-circle',
                info = data.message
            },
            caller = 'Citizen',
            coords = playerCoords
        })
    elseif Config.Dispatch.Resource == 'cd' then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Dispatch.jobs,
            coords = playerCoords,
            title = data.title,
            message = data.message .. ' on ' .. locationInfo,
            flash = 0,
            unique_id = math.random(999999999),
            sound = 1,
            blip = {
                sprite = data.sprite,
                scale = data.scale,
                colour = data.colour,
                flashes = false,
                text = data.blipText,
                time = 5,
                radius = 0,
            }
        })
    elseif Config.Dispatch.Resource.Resource == 'ps' then
        TriggerServerEvent('ps-dispatch:server:notify', {
            message = data.title,
            codeName = data.dispatchcodename,
            code = data.displayCode,
            icon = 'fas fa-info-circle',
            priority = 2,
            coords = playerCoords,
            gender = gender,
            street = locationInfo,
            jobs = Config.Dispatch.Resource.types
        })
    elseif Config.Dispatch.Resource == 'qs' then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.Dispatch.jobs,
            callLocation = playerCoords,
            callCode = { code = data.displayCode, snippet = data.description },
            message = data.message .. ' on ' .. locationInfo,
            flashes = false,
            blip = {
                sprite = data.sprite,
                scale = data.scale,
                colour = data.colour,
                flashes = true,
                text = data.blipText,
                time = (6 * 60 * 1000),
            }
        })
    elseif Config.Dispatch.Resource == 'core' then
        TriggerServerEvent("core_dispatch:addCall",
            data.displayCode,
            data.description,
            { {icon = "fa-info-circle", info = data.message} },
            { playerCoords.x, playerCoords.y, playerCoords.z },
            Config.Dispatch.jobs,
            10000,
            data.sprite,
            data.colour
        )
    elseif Config.Dispatch.Resource == 'origen' then
        TriggerServerEvent("SendAlert:police", {
            coords = playerCoords,
            title = data.message,
            type = data.displayCode,
            message = data.description,
            job = Config.Dispatch.jobs,
        })
    elseif Config.Dispatch.Resource == 'codem' then
        exports['codem-dispatch']:CustomDispatch({
            type = 'Illegal',
            header = data.title,
            text = data.message .. ' on ' .. locationInfo,
            code = data.displayCode,
        })
    else
        -- Custom dispatch system implementation placeholder
    end
end

exports('Dispatch', Dispatch)