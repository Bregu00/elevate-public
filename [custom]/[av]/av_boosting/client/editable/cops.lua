CurrentCops = 0

RegisterNetEvent('av_boosting:SetCopCount', function(amount) -- triggered from av_laptop
    CurrentCops = amount
end)