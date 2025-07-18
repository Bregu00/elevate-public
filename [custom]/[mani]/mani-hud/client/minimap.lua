CreateThread(function()
    RequestStreamedTextureDict('squaremap', false)
    while not HasStreamedTextureDictLoaded('squaremap') do Wait(2500) end

    SetMinimapClipType(0)
    AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
    AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')

    local defaultAR, resX, resY = 1920 / 1080, GetActiveScreenResolution()
    local aspect = resX / resY
    local offset = (aspect > defaultAR) and (((defaultAR - aspect) / 3.6) - 0.008) or 0

    SetMinimapComponentPosition('minimap',      'L', 'B', 0.0 + offset, -0.035, 0.1638, 0.183)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0 + offset,  0.012, 0.128,  0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + offset, 0.040, 0.262, 0.300)

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarZoom(1100)
    Citizen.InvokeNative(0x231C8F89D0539D8F, false)
end)