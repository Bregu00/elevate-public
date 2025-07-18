function vehAnimation()
    dbug("vehAnimation()")
    return lib.progressCircle({
        duration = math.random(15000,25000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer',
            flag = 16
        },
    })
end

function repairAnimation()
    dbug("repairAnimation()")
    return lib.progressCircle({
        duration = math.random(15000,25000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
        anim = {
            dict = 'amb@prop_human_movie_bulb@idle_a',
            clip = 'idle_b',
            flag = 1
        },
    })
end