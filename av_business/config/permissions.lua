Config = Config or {}
Config.Permissions = {
    -- value: string, label: string, jobs: false or table with jobs who can access this permission
    { value = "employees",    label = "Employees", jobs = false }, -- Used for App (don't edit value field)
    { value = "menu",         label = "Menu", jobs = false }, -- Used for App (don't edit value field)
    { value = "bank",         label = "Bank", jobs = false }, -- Used for App (don't edit value field)
    { value = "applications", label = "Applications", jobs = false  }, -- Used for App (don't edit value field)
    { value = "stashes",      label = "Stashes", jobs = false  }, -- Gives access to business stashes
    { value = "cameras",      label = "Cameras", jobs = false  }, -- Gives access to business stashes
--    { value = "evidence_stash",      label = "Evidence Stash", jobs = {"police", "bcso"}  }, -- Gives access to evidence stashes / this is just an example
}
