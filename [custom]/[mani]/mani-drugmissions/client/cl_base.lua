local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02dh %02dm %02ds", hours, minutes, seconds)
end

RegisterNetEvent('mani-drugmissions:updateTextUI', function(data)
    lib.showTextUI(data.text, data.options)
end)

RegisterNetEvent('mani-drugmissions:hideTextUI', function()
    lib.hideTextUI()
end)

exports('openMissionContext', function()
    local job = ESX.GetPlayerData().job
    if not job.isgang then return end
    local cooldowns, currentTime = exports['jungurum-lib']:GetAllGangCooldowns(job.name)
    local options = {}

    for i = 1, #Config.Missions do
        local mission = Config.Missions[i]
        local cooldown = cooldowns[mission.name] or { active = false }
        local canDo = not cooldown.active
        local label = mission.label

        if not canDo then
            local remainingTime = math.floor(cooldown.expiring - currentTime)
            label = label .. ' (' .. formatTime(remainingTime) .. ')'
        end

        options[#options + 1] = {
            title = label,
            disabled = not canDo,
            icon = 'fas fa-briefcase',
            iconColor = canDo and 'green' or 'red',
            onSelect = function()
                mission.func()
            end
        }
    end
    
    lib.registerContext({
        id = 'gang_drugmissions',
        title = 'Missioner',
        options = options
    })

    lib.showContext('gang_drugmissions')
end)