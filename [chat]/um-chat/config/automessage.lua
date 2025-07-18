return {
    status = false,
    messageList = {
        -- [1] = [[
        --     Welcome to the server! Please read the rules and have fun!'
        --     discord.gg/uyuyorumstore
        -- ]],
        -- [2] = [[
        --     Welcome to the server! Please read the rules and have fun!'
        --     discord.gg/uyuyorumstore
        -- ]],
        -- [3] = [[
        --     Welcome to the server! Please read the rules and have fun!'
        --     discord.gg/uyuyorumstore
        -- ]],
    },
    -- If steps is true, it will send new messages every x minutes following the sequence,
    --if false, it will send all your messages at once every x minutes
    steps = true,
    interval = 30 * 60 * 1000, -- 30 minutes
    tag = {
        name = '📗 Auto Message',
        background = '#fff'
    },
}
