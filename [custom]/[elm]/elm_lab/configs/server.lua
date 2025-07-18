ConfigServer = {
    Shells = {
        ["coke"] = {
            obj = `k4coke_shell`,
            ["pack"] = {
                itemgiven = 'pakket_kokain',
                itemrequired = 'posekokain',
                amount_required = 50,
                amount_given = 1
            }
        },
        ["weed"] = {
            obj = `k4weed_shell`,
            ["pack"] = {
                itemgiven = 'pakket_skunk',
                itemrequired = 'joint',
                amount_required = 50,
                amount_given = 1
            }
        },
        ["meth"] = {
            obj = `k4meth_shell`,
            ["pack"] = {
                itemgiven = 'pakket_meth',
                itemrequired = 'posemeth',
                amount_required = 50,
                amount_given = 1
            }
        },
        ["heroin"] = {
            obj = `k4meth_shell`,
            ["pack"] = {
                itemgiven = 'pakket_heroin',
                itemrequired = 'kanyleindhold',
                amount_required = 50,
                amount_given = 1
            }
        },
    },
    whitelisted_gangs = { -- liste af jobs som kan raide labs udover politiet
    }
}