function applicationsMenu(job)
    local input = lib.inputDialog(Lang['application_title'], {
        {type = 'input', label = Lang['application_email'], icon = "at", required = true, min = 4, max = 16},
        {type = 'number', label = Lang['application_phone'], icon = 'phone', required = true},
        {type = 'textarea', label = Lang['application_question'], required = true, min = 2, max = 4, autosize = true},
    })
    if input then
        TriggerServerEvent("av_business:newApplication", job, input)
    end
end