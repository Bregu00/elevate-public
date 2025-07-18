return {
    debug = false,            -- If you want to see the debug information, set this to true.

    framework = 'es_extended', -- standalone, qbox, qb-core, es_extended

    commandGeneral = {
        forwardSlash = '/', -- If you want to use a different character for commands, you can change it here.
        onlyCommand = {
            status = true,  -- If you want to use only commands, set this to true, or like text chat using set false
            executeChat = 'ooc',
        },

        --[[
            ?Beta Feature
        --  only works if there are players near you
        ]]
        typingDot = {
            status = false,      -- If you want to use the typing dot, set this to true.
            selectedDotType = 2, -- 1: only emoji (no animation), 2: animation dot (emoji), 3: animation dot (text)
            dotTypeList = {
                [1] = {
                    text = '💬',
                    scale = 0.35,
                },
                [2] = {
                    text = { '⚪', '⚪⚪', '⚪⚪⚪' }, -- other colors: 🔴, 🔵, 🟢, 🟡, 🟠, 🟤, 🟣
                    scale = 0.10,
                    animation = true,
                },
                [3] = {
                    text = { '.', '..', '...' },
                    animation = true,
                    scale = 0.55,
                    color = { 255, 255, 255, 215 },
                }
            }
        }
    },

    clearCommand = 'clearchat', -- If you want to clear the chat, you can use this command.

    chatLogs = {
        joinLeave = {
            status = false,                 -- If you want to save the join and leave logs, set this to true.
            firstMessageShowWindow = false, -- If you want to send a message to the player when they first join or leave the server, set this to true.
        },
        generalChat = {
            status = true, -- If you want to save the general chat logs, set this to true.
        }
    },

    adminChat = {
        status = false,         -- If you want to use the admin chat, set this to true.
        command = {
            name = 'adminchat', -- If you want to use a different command for the admin chat, you can change it here.
            help = 'Åben Admin Chat',
        },
        -- If you want to use a different key for the admin chat, you can change it here.
        -- If dont work check ESC > Settings > Keybindings > FiveM > chat
        key = 'F9',
        permission = 'group.admin', -- If you want to use a different permission for the admin chat, you can change it here.
    }
}
