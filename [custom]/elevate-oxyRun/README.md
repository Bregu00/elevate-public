# dynyx_oxyrun
FiveM | Oxy Run Script| Dynyx Scripts

# Thank you so much for your Purchase!

# If you need any help setting up the script. Join the Discord below!

| Join my discord server [here](https://discord.gg/A4gVRjnvaE) |
| ------------------------------------------------------------ |

## Preview: https://youtu.be/fmbfBQE_2jQ

## How to Install
1. Drag dynyx_oxyrun into your resources folder then ensure dynyx_oxyrun in your cfg file.
2. Make sure to intall all the Dependencies.
3. Go to ox_inventory/data/items.lua and paste this
   ```lua
	["oxyboxes"] = {
		label = "Oxy Package",
		weight = 2500,
		close = true,
		stack = false,
		description = "Package",
		client = {
			export = 'dynyx_oxyrun.oxycarry'
		}
	},
4. Go to ox_inventory / web / images and add in the images I put in that images folder.


## Dependencies
# es_extended: https://github.com/mitlight/es_extended
# ox_inventory: https://github.com/overextended/ox_inventory
# ox_target: https://github.com/overextended/ox_target
# ox_lib: https://github.com/overextended/ox_lib
