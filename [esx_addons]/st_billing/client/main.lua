local appInfo = {
    identifier = "billing_app",
    name = "Faktura",
    description = "Dine faktura/bøder"
}

Citizen.CreateThread(function()
	while GetResourceState("lb-phone") ~= "started" do
        Wait(500)
    end

    local added, errorMessage = exports["lb-phone"]:AddCustomApp({
        identifier = appInfo.identifier,
        name = appInfo.name,
        description = appInfo.description,
        defaultApp = true,
        ui = GetCurrentResourceName() .. "/web/build/index.html",
        icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/web/build/icon.png",
    })

    if not added then
        print("Could not add app:", errorMessage)
    end
end)

RegisterNUICallback("setupApp", function(data, cb)
    cb(lib.callback.await('st_billing_app:GetBills', false))
end)

RegisterNUICallback("payBill", function(data, cb)
	local bill_id = data.id

	ESX.TriggerServerCallback('esx_billing:payBill', function(playerBills)
		Citizen.Wait(500)
		exports["lb-phone"]:SendCustomAppMessage(appInfo.identifier, {
			action = "refreshBillings",
			billings = playerBills
		})
	end, bill_id)

    cb('ok')
end)

RegisterNetEvent("esx_billing:addBill", function()
    local playerBills = lib.callback.await('st_billing_app:GetBills', false)
    exports["lb-phone"]:SendCustomAppMessage(appInfo.identifier, {
        action = "refreshBillings",
        billings = playerBills
    })
end)

CreateThread(function()
    local allJobs = lib.callback.await("st_billing:server:GetAllJobs", false)
    exports.ox_target:addGlobalPlayer({
        {
            icon = "fa-solid fa-file-lines",
            label = "Giv faktura",
            groups = allJobs,
            onSelect = function(data)
                GivFaktura(NetworkGetPlayerIndexFromPed(data.entity))
            end,
            distance = 1.5,
        } 
    })
end)


GivFaktura = function(entity)
    local input = lib.inputDialog('Faktura', {'Faktura Beløb'})

    if not input or not tonumber(input[1]) then
        lib.notify({
            title = 'Fejl',
            description = 'Ugyldigt antal.',
            type = 'error'
        })
        return
    end

    local amount = tonumber(input[1])
    lib.notify({
        title = 'Succes',
        description = "Faktura er nu blevet givet til: " .. GetPlayerServerId(entity),
        type = 'success'
    })
    
    if ESX.PlayerData.job and ESX.PlayerData.job.name then
        TriggerServerEvent("esx_billing:sendBill", GetPlayerServerId(entity), 
        "society_" .. ESX.PlayerData.job.name, 
        ESX.PlayerData.job.label .. " Faktura: " .. ESX.Math.GroupDigits(amount) .. " DKK", 
        amount)
    end
end
