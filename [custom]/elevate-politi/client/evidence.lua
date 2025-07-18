local function openBevisRum(id)
    local verifyStash = lib.callback.await('elevate-politi:server:verifyStash', false, id)
    if not verifyStash then return end

    exports['ox_inventory']:openInventory('stash', Config.EvidenceOptions['InventoryPrefix'] .. id)
end

CreateThread(function()
    for i = 1, #Config.EvidenceOptions['Coords'] do
        exports['ox_target']:addBoxZone({
            name = 'politiBevisRum',
            coords = Config.EvidenceOptions['Coords'][i],
            size = vector3(1, 1, 1),
            rotation = Config.EvidenceOptions['Coords'][i].w,
            options = {
                {
                    label = Config.EvidenceOptions['TargetLabel'],
                    icon = 'fas fa-file',
                    groups = Config.EvidenceOptions['Jobs'],
                    onSelect = function()
                        local input = lib.inputDialog('Åben Bevis rum', {
                            { type = 'number', label = 'Bevis Række', description = 'Indtast bevis række', icon = 'fas fa-file', required = true },
                        })
                        if not input then return end
                        openBevisRum(input[1])
                    end
                }
            }
        })
    end
end)