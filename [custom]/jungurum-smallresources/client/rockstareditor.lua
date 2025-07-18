RegisterCommand('record', function()
    StartRecording(1)
    lib.notify({ title = 'Rockstar Optagelse Begyndt', type = 'success' })
end, false)

RegisterCommand('saveclip', function()
    StopRecordingAndSaveClip()
    lib.notify({ title = 'Optagelse er gemt', type = 'success' })
end, false)

RegisterCommand('delclip', function()
    StopRecordingAndDiscardClip()
    lib.notify({ title = 'Optagelse er slettet', type = 'success' })
end, false)