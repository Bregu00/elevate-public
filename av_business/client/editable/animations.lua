function doAnimation(prop)
    local animData = Config.Animations[prop] or Config.Animations[Config.DefaultAnimation]
    local movement = 1
    local propRot = {}
    if animData['prop'] then
        propRot = {
            model = GetHashKey(animData['prop']),
            bone = animData['bone'],
            pos = vec3(animData['offset'][1], animData['offset'][2], animData['offset'][3]),
            rot = vec3(animData['offset'][4], animData['offset'][5], animData['offset'][6]),
        }
    end
    return lib.progressBar({
        duration = animData['time'] or 5000,
        label = animData['label'],
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = not animData['canWalk'],
            car = not animData['canDrive'],
        },
        anim = {
            dict = animData['dict'],
            clip = animData['animation']
        },
        prop = propRot,
    })
end