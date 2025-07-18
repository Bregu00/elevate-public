Config = Config or {}
-- This are the buttons shown in the cashier and the account used for it
-- Maybe u want a business to only accept X money account rather than bank and cash?

Config.Buttons = {
    ['uwu_cafe'] = { -- index key needs to be the job name
        {account = "bank", label = "Pay with bank", color = "teal"}
    },
}

DefaultButtons = { -- if no Config.Buttons then we are gonna use this
    {account = "bank", label = "Pay with bank", color = "teal"},
    {account = "cash", label = "Pay with cash", color = "cyan"}, -- cash is used in QBCore, for ESX use money
}