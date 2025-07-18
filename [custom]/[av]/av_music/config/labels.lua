Config = Config or {}
Config.Labels = {
    ['av_records'] = { -- an unique index key
        job = "uwu_cafe", -- allowed job to access CD menu and add new music to label
        label = "AV Records", -- Shown in the Music APP
        thumbnail = "https://r2.fivemanage.com/QmVAYSlqeAlD4IxVbdvu5/av_music.png", -- shown in music APP
        description = "Los Santos House Music", -- shown in music APP
        locations = { -- Label Menu locations, only employees can access it
            {x = -816.4627, y = -698.7722, z = 32.1409},
            {x = -818.5936, y = -718.8042, z = 32.3408},
        },
    },
}