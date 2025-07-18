local textUI = {}

function DrawText()
    lib.hideTextUI()
    ClearTextUI()
    textUI[#textUI + 1] = (Lang['checkpoint']..': %s  \n'):format(#CreatorData.Checkpoints)
    textUI[#textUI + 1] = Config.EditorKeys['add']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['distance']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['delete']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['cancel']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['save']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['rotate']['Label']
    textUI[#textUI + 1] = Config.EditorKeys['reset']['Label']
    lib.showTextUI(table.concat(textUI))
end

function ClearTextUI()
    textUI = {}
end

function clearAll()
    lib.hideTextUI()
    redrawBlips()
end