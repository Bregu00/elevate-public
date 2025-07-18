function canBurn() -- Burn CDs?
    return true
end
function canDelete() -- Delete songs?
    return exports['av_laptop']:isBoss()
end
function canAdd() -- Add new songs?
    return true
end