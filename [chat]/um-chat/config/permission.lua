--[[
    These perms are only for um-chat and have ``! nothing to do with your perms in server.cfg``
    You can only think of it as tags that will appear next to you in the general chat
    Color hex: https://tailwindcss.com/docs/customizing-colors
]]

return {

    identifier = 'discord', -- steam or license or discord

    permissions = {
        ['admin'] = {
            prefix = 'Admin',
            color = "#fbbf24",
            permissions = {
                -- 'discordid',
            }
        },
        ['staff'] = {
            prefix = 'Staff',
            color = "#22c55e",
            permissions = {
                -- 'discordid',
            }
        },
        ['vip'] = {
            prefix = 'VIP',
            color = "#a78bfa",
            permissions = {
                -- 'discordid',
            }
        },
        ['streamer'] = {
            prefix = 'Streamer',
            color = "#ec4899",
            permissions = {
                -- 'discordid',
            }
        },
    }
}
