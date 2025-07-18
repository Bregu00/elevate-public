local adminGrades = 'god'

RegisterNetEvent('ap_createjob:notify')
AddEventHandler('ap_createjob:notify', function(msg)
	ESX.ShowNotification(msg)
end)

RegisterCommand("admin:jobs", function(source, args, raw)
    local xPlayer = ESX.GetPlayerData()
    local group = xPlayer.group
    if (group == "admin") or (group == "god") then
        TriggerEvent('ap_createjob:apadminmenu')
    else
        ESX.ShowNotification('You are not authorised to use this command!')
    end
end, false)

-- function checkAdmin()
-- 	ESX.TriggerServerCallback('ap_createjob:getAdmin', function(data)
-- 		for k,v in pairs(data) do
-- 			if (v.group == "admin") or (v.group == "god") then
-- 				TriggerEvent('ap_createjob:apadminmenu')
-- 			else
-- 				ESX.ShowNotification('You are not authorised to use this command!')
-- 			end
-- 		end
-- 	end)
-- end

RegisterNetEvent('ap_createjob:apadminmenu')
AddEventHandler('ap_createjob:apadminmenu', function()
	lib.registerContext({
        id = 'admin_main_menu',
        title = 'AP Admin Menu',
        options = {
            {
                title = 'Jobs Menu',
                description = 'Click for jobs menu.',
                onSelect = function()
                    TriggerEvent('ap_createjob:createjobMain')
                end
            },
            -- {
            --     title = 'Items Menu',
            --     description = 'Click for items menu.',
            --     onSelect = function()
            --         TriggerEvent('ap_createjob:createitemMain')
            --     end
            -- }
        }
    })
    
    lib.showContext('admin_main_menu')
end)

RegisterNetEvent('ap_createjob:createjobMain')
AddEventHandler('ap_createjob:createjobMain', function()
	lib.registerContext({
        id = 'job_main_menu',
        title = 'Job Management',
        options = {
            {
                title = 'Add Jobs',
                description = 'Add jobs to database.',
                onSelect = function()
                    TriggerEvent('ap_createjob:addjob')
                end
            },
            {
                title = 'Add Grades',
                description = 'Add grades to database.',
                onSelect = function()
                    TriggerEvent('ap_createjob:addgrade')
                end
            },
            {
                title = 'Refresh Jobs',
                description = 'Click to refresh jobs table.',
                onSelect = function()
                    TriggerServerEvent('ap_createjob:RefreshJobs')
                end
            },
            {
                title = 'Back',
                description = 'Back to main menu.',
                onSelect = function()
                    TriggerEvent('ap_createjob:apadminmenu')
                end
            }
        }
    })
    
    lib.showContext('job_main_menu')
end)

RegisterNetEvent('ap_createjob:addjob')
AddEventHandler('ap_createjob:addjob', function()
	local result = lib.inputDialog('Make New Job', {
        { type = 'input', label = 'Job Name (lowercase)' },
        { type = 'input', label = 'Job label' },
        { type = 'checkbox', label = 'Whitelisted (0 or 1)' },
        { type = 'checkbox', label = 'isGang (0 or 1)' }
    })
    if result ~= nil then
        if result[1] == nil or result[2] == nil or result[3] == nil or result[4] == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createJob', function(hasJob)
				if hasJob then
					ESX.ShowNotification('Job name: '..result[1]..' Job label: '..result[2]..' Whitelisted status: '..result[3]..' isGang status: ' ..result[4] ..  ' has been added.')
					TriggerEvent('ap_createjob:addjob')
				end
			end, result[1], result[2], result[3], result[4])
        end
    end
end)

RegisterNetEvent('ap_createjob:addgrade')
AddEventHandler('ap_createjob:addgrade', function()
	local result = lib.inputDialog('Make New Grade', {
        { type = 'input', label = 'Job Name (lowercase)' },
        { type = 'number', label = 'Job grade' },
        { type = 'input', label = 'Grade name (lowercase)' },
        { type = 'input', label = 'Grade label' },
        { type = 'number', label = 'Salary ($)' }
    })
    if result ~= nil then
        if result[1] == nil or result[2] == nil or result[3] == nil or result[4] == nil or result[5] == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createRank', function(hasGrade)
				if hasGrade then
					ESX.ShowNotification('Rank name: '..result[3]..' Rank label: '..result[4]..' Rank salary: $'..result[5]..' for job '..result[1]..' has been added.')
					TriggerEvent('ap_createjob:addgrade')
				end
			end, result[1], result[3], result[4], result[2], result[5])
        end
    end
end)

RegisterNetEvent('ap_createjob:createitemMain')
AddEventHandler('ap_createjob:createitemMain', function()
	lib.registerContext({
        id = 'item_main_menu',
        title = 'Item Management',
        options = {
            {
                title = 'Add Items',
                description = 'Add items to database.',
                onSelect = function()
                    TriggerEvent('ap_createjob:additem')
                end
            },
            {
                title = 'Refresh Items',
                description = 'Click to refresh items table.',
                onSelect = function()
                    TriggerEvent('ap_createjob:RefreshItems')
                end
            },
            {
                title = 'Back',
                description = 'Back to main menu.',
                onSelect = function()
                    TriggerEvent('ap_createjob:apadminmenu')
                end
            }
        }
    })
    
    lib.showContext('item_main_menu')
end)

RegisterNetEvent('ap_createjob:additem')
AddEventHandler('ap_createjob:additem', function()
	local result = lib.inputDialog('Make New Item', {
        { label = 'Item name (lowercase)', value = '' },
        { label = 'Item label', value = '' },
        { label = 'Item weight', value = '' },
        { label = 'Item rare', value = '' },
        { label = 'Item can_remove', value = '' }
    })
    if result ~= nil then
        if result[1].value == nil or result[2].value == nil or result[3].value == nil or result[4].value == nil or result[5].value == nil then
            ESX.ShowNotification('All fields need to be filled.')
        else
            ESX.TriggerServerCallback('ap_createjob:createItem', function(hasItem)
				if hasItem then
					ESX.ShowNotification(' Item label: '..result[2].value..' has been added.')
					TriggerEvent('ap_createjob:createitemMain')
				end
			end, result[1].value, result[2].value, result[3].value, result[4].value, result[5].value)
        end
    end
end)

function getAllGangRanks(cb)
    ESX.TriggerServerCallback("ap_createjob:server:getAllGangRanks", function(allGangs)
        cb(allGangs)
    end)
end

exports("getAllGangRanks", getAllGangRanks)