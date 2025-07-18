local UserGroup
local Muted = false
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('sendRelyMessage')
AddEventHandler('sendRelyMessage', function(id, target, name, message)
    if Muted == true then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    UserGroup = Group
    if pid == myId then
        TriggerServerEvent("sendtoownplayer", name, message)
    elseif pid ~= myId then
        print("er her")
        TriggerServerEvent("sendreplytoplayer", target, name, message)
    end
end)

RegisterNetEvent('fh_rpchat:SendReportToAdmin')
AddEventHandler('fh_rpchat:SendReportToAdmin', function(id, name, message)
    if Muted or LocalPlayer.state.staffDisable then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    ESX.TriggerServerCallback('esx_chatforadmin:GetGroup', function(Group)
        UserGroup = Group
        if UserGroup ~= 'user' then
            TriggerEvent('chat:addMessage', {
                template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba(237, 252, 244, 1); color: rgba(0, 0, 0, 1); border-radius: 3px; max-width: 94%; word-wrap: break-word;" class="testing animated zoomIn delay-2s"><i class="fas fa-exclamation-triangle fa-lg" style="color: rgba(255, 0, 0, 1);"></i> <span style="color: black; font-weight: bold;">REPORT</span> <span style="color: black; font-weight: bold;">@</span><span style="color: red; font-weight: bold;">{0}</span> <span style="color: black; font-weight: bold;">- ID:</span> <span style="color: green; font-weight: bold;">{2}</span><span style="font-weight: bold;">:</span> <span style="color: black; font-weight: bold;">{1}</span></div>',
                args = {name, message, id}
            })
        end
    end)
end)
