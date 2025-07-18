if not Config.AccessTool.enabled then return end

local function useAccessTool(_, data, inv, x, y)
    if not CanAccess(inv.id) then 
        ShowNotification(inv.id, Locales["access_tool_no_access"], "error")
        return
    end
    local unlockedCar = lib.callback.await("snipe-evidence:client:useAccessTool", inv.id)
    if unlockedCar then
        ShowNotification(inv.id, Locales["access_tool_success"], "success")
    else
        ShowNotification(inv.id, Locales["no_nearby_car"], "error")
    end
end

exports('useAccessTool', useAccessTool)