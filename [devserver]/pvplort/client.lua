-- Wait for ox_lib to be ready
CreateThread(function()
    while not lib do
        Wait(100)
    end
end)

local isNoClip = false
local noclipSpeed = 1.0

-- Function to toggle NoClip
local function toggleNoClip()
    isNoClip = not isNoClip
    local ped = PlayerPedId()
    
    if isNoClip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
    end
end

-- NoClip thread
CreateThread(function()
    while true do
        Wait(0)
        if isNoClip then
            local ped = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local dx, dy, dz = GetCamDirection()
            
            -- Speed control
            if IsControlPressed(0, 21) then -- Left Shift
                noclipSpeed = 2.0
            else
                noclipSpeed = 1.0
            end
            
            -- Movement
            if IsControlPressed(0, 32) then -- W
                x = x + (dx * noclipSpeed)
                y = y + (dy * noclipSpeed)
                z = z + (dz * noclipSpeed)
            end
            if IsControlPressed(0, 33) then -- S
                x = x - (dx * noclipSpeed)
                y = y - (dy * noclipSpeed)
                z = z - (dz * noclipSpeed)
            end
            if IsControlPressed(0, 34) then -- A
                x = x + (dy * noclipSpeed)
                y = y - (dx * noclipSpeed)
            end
            if IsControlPressed(0, 35) then -- D
                x = x - (dy * noclipSpeed)
                y = y + (dx * noclipSpeed)
            end
            if IsControlPressed(0, 22) then -- Space
                z = z + noclipSpeed
            end
            if IsControlPressed(0, 36) then -- Ctrl
                z = z - noclipSpeed
            end
            
            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

-- Function to get camera direction
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

-- Function to give armor
local function giveArmor()
    local ped = PlayerPedId()
    SetPedArmour(ped, 100)
end

-- Function to revive player
local function revivePlayer()
    TriggerServerEvent('pvplort:revivePlayer')
end

-- Register command
RegisterCommand('pvp', function()
    exports.ox_lib:registerContext({
        id = 'pvp_menu',
        title = 'PvP Menu',
        options = {
            {
                title = 'Weapons',
                description = 'Choose a weapon',
                menu = 'weapons_menu'
            },
            {
                title = 'Give Ammo & Attachments',
                description = 'Gives you 9999 ammo, 9999 ammo2, 20 clips, and 20 silencers',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveAmmoAndAttachments')
                end
            },
            {
                title = 'Give Armor',
                description = 'Gives you full armor',
                onSelect = function()
                    giveArmor()
                end
            },
            {
                title = 'Revive',
                description = 'Revives your character',
                onSelect = function()
                    revivePlayer()
                end
            },
            {
                title = 'Toggle NoClip',
                description = 'Enable/Disable NoClip mode',
                onSelect = function()
                    toggleNoClip()
                end
            }
        }
    })

    exports.ox_lib:registerContext({
        id = 'weapons_menu',
        title = 'Weapons Menu',
        menu = 'pvp_menu',
        options = {
            {
                title = 'Pistol .50',
                description = 'Gives you a .50 Pistol',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_PISTOL50')
                end
            },
            {
                title = 'Pistol',
                description = 'Gives you a Pistol',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_PISTOL')
                end
            },
            {
                title = 'Vintage Pistol',
                description = 'Gives you a Vintage Pistol',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_VINTAGEPISTOL')
                end
            },
            {
                title = 'Pistol XM3',
                description = 'Gives you a Pistol XM3',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_PISTOLXM3')
                end
            },
            {
                title = 'Navy Revolver',
                description = 'Gives you a Navy Revolver',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_NAVYREVOLVER')
                end
            },
            {
                title = 'Revolver',
                description = 'Gives you a Revolver',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_REVOLVER')
                end
            },
            {
                title = 'Shotgun',
                description = 'Gives you a Shotgun',
                onSelect = function()
                    TriggerServerEvent('pvplort:giveWeapon', 'WEAPON_PUMPSHOTGUN')
                end
            }
        }
    })
    
    exports.ox_lib:showContext('pvp_menu')
end, false)

-- Register /r command for self revive
RegisterCommand('r', function()
    revivePlayer()
end, false)

-- Register /n command for noclip
RegisterCommand('n', function()
    toggleNoClip()
end, false)

-- Register the menu when resource starts
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    exports.ox_lib:showContext('pvp_menu')
end) 