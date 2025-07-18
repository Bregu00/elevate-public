--[[
        Actions:
        Examples such as /me /do are found here, every command you add to actions will be ?automatically added,

        You can add extra things like /me and /do to indicate status

        Or you can add only chatMessage like ooc no drawtext, for this delete drawText table
        https://docs.uyuyorumstore.com/scripts/um-chat/addActions
    ]]
return {
    maxCharacterLength = 200,

    --[[
        Anonymous Mask:
        be anonymous when you wear a mask
    ]]
    anonymousMask = {
        status = false,

        name = 'Anonymous',
        --[[ mode
             1: excluded (if the mask slot number is in the list, not anonymous),
             2: included (if the mask slot number is in the list, anonymous)
        ]]
        mode = 1,
        --[[
        -- Exclude these mask slots number
            if mode 1 is selected, the mask slot number in this list will not be anonymous
            if mode 2 is selected, the mask slot number in this list will be anonymous (delete [-1] and 0 from the list)
        ]]
        maskSlots = {
            [-1] = true,
            [0] = true,
            --[250] = true,
        }
    },

    actions = {
        --[[ Default Commands: ]]
        ['me'] = {
            status = true,
            command = {
                help = 'Skriv en me handling',
                params = {
                    { name = 'message', type = 'longString' }
                }
            },
            distance = 5,
            showID = true,
            drawText = {
                rect = 0.025,
                z = 0.10,
                color = { r = 0, g = 0, b = 0 }
            },
            logs = true,
        },
        ['do'] = {
            status = true,
            command = {
                help = 'Skriv en do handling',
                params = {
                    { name = 'message', type = 'longString' }
                }
            },
            distance = 5,
            showID = true,
            drawText = {
                rect = 0.025,
                z = 0.30,
                color = { r = 255, g = 131, b = 129 },
            },
            logs = true,
        },
        ['ool'] = {
            status = true,
            command = {
                help = 'Skriv en besked til spillere i nærheden',
                params = {
                    { name = 'message', type = 'longString' }
                }
            },
            distance = 15,
            showID = true,
            tag = {
                name = 'OOL',
                background = '#0ea5e9'
            },
            logs = true,
        },
        --[[ Games Commands ]]
        ['rps'] = {
            status = true,
            command = {
                help = 'Slå sten, papir eller saks',
                params = false,
            },
            distance = 5,
            drawText = {
                font = 7,
                rect = 0.045,
                z = 0.80,
                color = { r = 0, g = 0, b = 0 }
            },
            anim = {
                dict = 'anim@mp_player_intcelebrationmale@wank',
                clip = 'wank',
                duration = 1500
            },
            message = function()
                local rpsItems = {
                    '✊ Sten',
                    '✋ Papir',
                    '✌️ Saks'
                }
                return rpsItems[math.random(1, #rpsItems)]
            end,
            logs = false,
        },
        ['dice'] = {
            status = true,
            command = {
                help = 'Slå en terning',
                params = false,
            },
            distance = 5,
            drawText = {
                font = 7,
                rect = 0.045,
                z = 0.80,
                color = { r = 0, g = 0, b = 0 }
            },
            anim = {
                dict = 'anim@mp_player_intcelebrationmale@wank',
                clip = 'wank',
                duration = 1500
            },
            message = function()
                return '🎲 ' .. math.random(1, 12)
            end,
            logs = false,
        },
        --[[ Jobs Commands: ]]
        ['emschat'] = {
            status = true,
            command = {
                help = 'Skriv en ems udmeldelse',
                params = {
                    { name = 'message', type = 'longString' }
                }
            },
            job = {
                name = 'ambulance',
                gradeShow = true,
                callsignShow = false,
                onlyOnDuty = false
            },
            tag = {
                name = '🚑 EMS UDMELDING',
                background = '#f32837'
            },
            logs = true,
        },
        ['pdchat'] = {
            status = true,
            command = {
                help = 'Skriv en politi udmeldelse',
                params = {
                    { name = 'message', type = 'longString' }
                }
            },
            job = {
                name = 'police',
                gradeShow = true,
                callsignShow = false,
                onlyOnDuty = false
            },
            tag = {
                name = '🚨 POLITI UDMELDING',
                background = '#135DD8'
            },
            logs = true,
        },

    },

    --[[
        Custom Commands:
        These are [not added automatically] and are your individual commands, you must create them yourself
    ]]
    customs = {
        ['pm'] = false
    }
}
