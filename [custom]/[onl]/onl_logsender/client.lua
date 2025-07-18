ESX.RegisterClientCallback("onl_logsender:client:takeScreenShot", function(cb, uploadHookOrSecret)
    exports['screenshot-basic']:requestScreenshotUpload('https://api.elevaterp.dk/api/image?apiKey=' .. uploadHookOrSecret, 'file', function(data)
        local image = json.decode(data)
        local link = (image and image.url) or 'invalid_url'
        cb(link)
    end)
end)