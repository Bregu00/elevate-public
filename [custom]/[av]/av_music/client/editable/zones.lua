local points = {}
local busy = false

for k, v in pairs(Config.Labels) do
    for _, coords in pairs(v['locations']) do
        points[#points + 1] = lib.points.new({
            coords = vector3(coords.x, coords.y, coords.z),
            distance = 2,
            record = k,
            job = v['job'],
        })
    end
end

for k, v in pairs(points) do
    function v:nearby()
        if not lib.isTextUIOpen() and not busy then
            lib.showTextUI(Lang['interact'])
        end
        if self.currentDistance <= 2 and IsControlJustReleased(0, 38) and not busy then
            busy = true
            if exports['av_laptop']:getJob().name == self.job then
                TriggerEvent('av_music:zone', self.record)
            else
                TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['not_employee'], "error")
            end
            removeBusy() -- just to prevent spam
        end
        if busy and lib.isTextUIOpen() then
            lib.hideTextUI()
        end
    end

    function v:onExit()
        if lib.isTextUIOpen() then
            lib.hideTextUI()
        end
    end
end

function removeBusy()
    CreateThread(function()
        Wait(2000)
        busy = false
    end)
end