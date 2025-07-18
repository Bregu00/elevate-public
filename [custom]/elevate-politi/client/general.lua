local keybinds = {}

local function keybindCooldown(key)
    keybinds[key]:disable(true)
    SetTimeout(5000, function()
        keybinds[key]:disable(false)
    end)
end

CreateThread(function()
    keybinds['ping'] = lib.addKeybind({
        name = 'pingPoliti',
        description = 'Ping aktive politibetjente',
        defaultKey = 'DOWN',
        onPressed = function(self)
            if ESX.GetPlayerData().job.name ~= 'police' then return end
            keybindCooldown('ping')
            exports['tk_dispatch']:addCall({
                title = 'Ping',
                code = 'Ping',
                priority = 'Prioritet 1',
                sound = false,
                jobs = {'police'},
                coords = GetEntityCoords(cache.ped),
                showLocation = true,
                showGender = true,
                showPerson = true,
                removeTime = 1000 * 60 * 1,
                blip = {
                    color = 3,
                    sprite = 480,
                    scale = 0.8,
                }
            })
        end,
    })
end)
