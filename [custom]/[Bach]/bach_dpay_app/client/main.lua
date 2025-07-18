local identifier = "dPay"

CreateThread(function()
    while GetResourceState("lb-phone") ~= "started" do
        Wait(500)
    end

    local function AddApp()
        local added, errorMessage = exports["lb-phone"]:AddCustomApp({
            identifier = identifier,
            name = "dPay",
            description = "Send, anmod eller kontroller dine køb",
            developer = "Bach",
            defaultApp = true,
            ui = GetCurrentResourceName() .. "/html/index.html",
            -- ui = "http://localhost:5173",
            icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/dPay.png",
        })

        if not added then
            print("Could not add app:", errorMessage)
        end
    end

    AddApp()

    AddEventHandler("onResourceStart", function(resource)
        if resource == "lb-phone" then
            AddApp()
        end
    end)
end)

RegisterNUICallback("drp_dpay:client:getContacts", function(data, cb)
    local contacts = lib.callback.await("drp_dpay:server:getContacts", false)
    cb(contacts)
end)

RegisterNUICallback("drp_dpay:client:getActivity", function(data, cb)
    local activity = lib.callback.await("drp_dpay:server:getActivity", false)
    cb(activity)
end)

RegisterNUICallback("drp_dpay:client:getSuggestions", function(data, cb)
    local suggestions = lib.callback.await("drp_dpay:server:getSuggestions", false)
    cb(suggestions)
end)

RegisterNUICallback("drp_dpay:client:getUserFromID", function(data, cb)
    local suggestions = lib.callback.await("drp_dpay:server:getUserFromID", false, data)
    cb(suggestions)
end)

RegisterNUICallback("drp_dpay:client:sendMoney", function(data, cb)
    local suggestions = lib.callback.await("drp_dpay:server:sendMoney", false, data)
    cb(suggestions)
end)

RegisterNUICallback("drp_dpay:client:requestMoney", function(data, cb)
    local suggestions = lib.callback.await("drp_dpay:server:requestMoney", false, data)
    cb(suggestions)
end)

RegisterNUICallback("drp_dpay:client:cancelRequest", function(data, cb)
    local suggestions = lib.callback.await("drp_dpay:server:cancelRequest", false, data)
    cb(suggestions)
end)

