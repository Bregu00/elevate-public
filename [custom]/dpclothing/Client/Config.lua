Config = {
	Language = "en",					-- You can change the language here. I translated some with a tool online so they might not be 100% accurate. Let me know!
	ExtrasEnabled = true,				-- This toggles the extra commands (Shirt, Pants) in case you dont want your players stripping their clothes for whatever reason.
	Debug = false,						-- Enables logging and on screen display of what your character is wearing.
	GUI = {
		Position = {x = 0.65, y = 0.5},	-- 0.5 is the middle!
		AllowInCars = false,			-- Allow the GUI in cars?
		AllowWhenRagdolled = false,			-- Allow the GUI when ragdolled?
		Enabled = false, 				-- You can turn the gui off here, the base commands will still work.
		Key = GetKey("Y"), 				-- Change the GUI key here.
		Sound = true,					-- You can disable sound in the GUI here.
		TextColor = {255,255,255},
		TextOutline = true,
		TextFont = 0,					-- Change font, useful for other languages.
		TextSize = 0.21,				-- Change the text size below buttons here, useful for other languages.
		Toggle = false,					-- Change the keybind from toggling the window open, or just holding it to open it.
	}
}

--[[
		Here are the commands to be generated, this is the layout.

		["commandname"] = {
			Func = Function that gets triggered.
			Sprite = You probably shouldnt change this.
			Desc = Description to be added in chat.
			Button = The position of the button in the GUI.
			Name = The display string for the GUI, we grab this with the Lang function, so they can be changed above.
		},

		You can change the command name if you wish, do so in the language file Locales/LANGUAGE.lua,
		Some alternatives i thought of were :

			Top   : Jacket, Hoodie.
			Hair  : Bun, Ponytail, Hairdown.
			Visor : Brim, Cap.

		And then for the props you can change em to something real short to make it easy for people to use.

			Glasses : G.
			Hat : H.
			Mask : M.
			Visor : V.
]]--

Config.Commands = {
	['top'] = {
		Func = function() ToggleClothing("Top") end,
		Sprite = "top",
		Desc = 'Toggle top variation.',
		Button = 1,
		Name = Lang("Top")
	},
	['handsker'] = {
		Func = function() ToggleClothing("Gloves") end,
		Sprite = "gloves",
		Desc = 'Tag dine handsker af/på.',
		Button = 2,
		Name = Lang("Gloves")
	},
	['flip'] = {
		Func = function() ToggleProps("Visor") end,
		Sprite = "visor",
		Desc = 'Toggle hat variation.',
		Button = 3,
		Name = Lang("Visor")
	},
	['sko'] = {
		Func = function() ToggleClothing("Shoes") end,
		Sprite = "shoes",
		Desc = 'Tag dine sko af/på',
		Button = 5,
		Name = Lang("Shoes")
	},
	['vest'] = {
		Func = function() ToggleClothing("Vest") end,
		Sprite = "vest",
		Desc = 'Tag din vest af/på.',
		Button = 14,
		Name = Lang("Vest")
	},
	['hår'] = {
		Func = function() ToggleClothing("Hair") end,
		Sprite = "hair",
		Desc = 'Toggle hår variation.',
		Button = 7,
		Name = Lang("Hair")
	},
	['hat'] = {
		Func = function() ToggleProps("Hat") end,
		Sprite = "hat",
		Desc = 'Tag din hat af/på.',
		Button = 4,
		Name = Lang("Hat")
	},
	['briller'] = {
		Func = function() ToggleProps("Glasses") end,
		Sprite = "glasses",
		Desc = 'Tag dine briller af/på.',
		Button = 9,
		Name = Lang("Glasses")
	},
	['øre'] = {
		Func = function() ToggleProps("Ear") end,
		Sprite = "ear",
		Desc = 'Tag dine øre accessoires af/på.',
		Button = 10,
		Name = Lang("Ear")
	},
	['kæde'] = {
		Func = function() ToggleClothing("Neck") end,
		Sprite = "neck",
		Desc = 'Tag din hals accessoires af/på.',
		Button = 11,
		Name = Lang("Neck")
	},
	['ur'] = {
		Func = function() ToggleProps("Watch") end,
		Sprite = "watch",
		Desc = 'Tag dit ur af/på.',
		Button = 12,
		Name = Lang("Watch"),
		Rotation = 5.0
	},
	['hånd'] = {
		Func = function() ToggleProps("Bracelet") end,
		Sprite = "bracelet",
		Desc = 'Tag dit håndleds accessoire af/på.',
		Button = 13,
		Name = Lang("Bracelet")
	},
	['maske'] = {
		Func = function() ToggleClothing("Mask") end,
		Sprite = "mask",
		Desc = 'Tag din maske af/på.',
		Button = 6,
		Name = Lang("Mask")
	},
	['mærker'] = {
		Func = function() ToggleClothing("Decal") end,
		Sprite = "decal",
		Desc = 'Toggle decal variation.',
		Button = 1,
		Name = 'Mærker'
	},
}

local Bags = {				-- This is where bags/parachutes that should have the bag sprite, instead of the parachute sprite.
}

Config.ExtraCommands = {
	['bukser'] = {
		Func = function() ToggleClothing("Pants", true) end,
		Sprite = "pants",
		Desc = 'Tag dine bukser af/på.',
		Name = Lang("Pants"),
		OffsetX = -0.04,
		OffsetY = 0.0,
	},
	['trøje'] = {
		Func = function() ToggleClothing("Shirt", true) end,
		Sprite = "shirt",
		Desc = 'Tag din trøje af/på.',
		Name = Lang("Shirt"),
		OffsetX = 0.04,
		OffsetY = 0.0,
	},
	['tshirt'] = {
		Func = function() ToggleClothing("TShirt", true) end,
		Sprite = "shirt",
		Desc = 'Tag din t-trøje af/på.',
		Name = Lang("Shirt"),
		OffsetX = 0.04,
		OffsetY = 0.0,
	},
	['resettøj'] = {
		Func = function() if not ResetClothing(true) then Notify(Lang("AlreadyWearing")) end end,
		Sprite = "reset",
		Desc = 'Reset dit tøj til standard.',
		Name = Lang("Reset"),
		OffsetX = 0.12,
		OffsetY = 0.2,
		Rotate = true
	},
	["taske"] = {
		Func = function() ToggleClothing("Bagoff", true) end,
		Sprite = "bagoff",
		SpriteFunc = function()
			local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
			local BagOff = LastEquipped["Bagoff"]
			if LastEquipped["Bagoff"] then
				if Bags[BagOff.Drawable] then
					return "bagoff"
				else
					return "paraoff"
				end
			end
			if Bag ~= 0 then
				if Bags[Bag] then
					return "bagoff"
				else
					return "paraoff"
				end
			else
				return false
			end
		end,
		Desc = 'Tag din taske af/på.',
		Name = Lang("Bag"),
		OffsetX = -0.12,
		OffsetY = 0.2,
	},
}