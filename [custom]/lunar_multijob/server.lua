exports("getAccountBalance", function(job)
    return exports["elevate-multijob"]:getAccountBalance(job)
end)

exports("addAccountBalance", function(jobName, amount)
    exports["elevate-multijob"]:addAccountBalance(jobName, amount)
end)

exports("removeAccountBalance", function(jobName, amount)
    exports["elevate-multijob"]:removeAccountBalance(jobName, amount)
end)