return {
    --[[ Template:
        um,
        dark,
        or custom hex '#0000'

        ?info: If you don't already have a cache, this will set you to the cache
        ?click on the ``Reset Settings`` button in the settings to go back to defaultBGColor
    ]]
    defaultBGColor = 'um',

    commandChat = {
        globalTag = {
            name = 'ELEVATE',
            background = '#4ade80'
        },
        windowShowTime = 7000,  -- ms
        lastCommandShow = true, -- If you want to show the command history you typed, set this to true
        buttons = {
            emoji = true,       -- If you want to use emoji set this to true
            games = true,       -- If you want to use games set this to true
            chat = false         --! If you want to use general chat set this to true (right chat window)
        }
    },

    generalChat = {
        settings = {
            maxMessageLimit = 250,            -- This is the limit of how many characters to type
            waitForMessage = 3000,            -- You can think of it as a slow mode to prevent message spam
            deleteOldMessage = 30 * 60 * 1000 -- 30 minute | Messages exceeding 30 minutes are deleted
        },
        buttons = {
            emoji = true,
            gif = true
        },
    },
}
