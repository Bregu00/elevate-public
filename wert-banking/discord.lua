local WebHook = "https://discord.com/api/webhooks/1339553642566385695/Gon8CXWiwna1PWT2YcR5tyQKplEXu5zUxoNrSl_EtYg2-UMpGP8Hv-uRBbOlap-fOdQc?thread_id=1339553535347392524" -- Edit webhook

if Config.EnableDiscordLog then
    RegisterNetEvent('wert-banking:discord-log', function(title, message)
        if WebHook == "" then return end
        local embedData = {
            {
                ['title'] = title,
                ['color'] = 65280,
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'Wert banking',
                    ['icon_url'] = 'https://cdn.discordapp.com/attachments/971695978962907176/1037779442078056478/w.png',
                },
            }
        }
        PerformHttpRequest(WebHook, function() end, 'POST', json.encode({ username = 'Wert Bank', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end)
end