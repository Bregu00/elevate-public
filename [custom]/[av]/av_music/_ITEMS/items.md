# For QBCore add this into shared/items.lua:

```lua
['cd'] = {['name'] = 'cd', ['label'] = 'CD', ['weight'] = 100, ['type'] = 'item', ['image'] = 'cd.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Support your local artist'},

['discman'] = {['name'] = 'discman', ['label'] = 'Discman', ['weight'] = 100, ['type'] = 'item', ['image'] = 'discman.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Play CDs'},

['headphones'] = {['name'] = 'headphones', ['label'] = 'BT Headphones', ['weight'] = 100, ['type'] = 'item', ['image'] = 'headphones.png', ['unique'] = true, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = 'Listen to your favorite music'},
```

# OX_inventory

```lua
['cd'] = {
    label = 'CD',
    weight = 1,
    stack = false,
    close = true,
    description = 'Support your local artist'
},
['discman'] = {
    label = 'Discman',
    weight = 1,
    stack = false,
    close = true,
    description = 'Play CDs'
},
['headphones'] = {
    label = 'BT Headphones',
    weight = 1,
    stack = false,
    close = false,
    description = 'Listen to your favorite music'
},
```

# For qs-inventory:

```lua
["cd"] = {
    ["name"] = "cd",
    ["label"] = "CD",
    ["weight"] = 2,
    ["type"] = "item",
    ["image"] = "cd.png",
    ["unique"] = true,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Support your local artist"
},
["discman"] = {
    ["name"] = "discman",
    ["label"] = "Discman",
    ["weight"] = 2,
    ["type"] = "item",
    ["image"] = "discman.png",
    ["unique"] = true,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "Play CDs"
},
["headphones"] = {
    ["name"] = "headphones",
    ["label"] = "BT Headphones",
    ["weight"] = 2,
    ["type"] = "item",
    ["image"] = "headphones.png",
    ["unique"] = true,
    ["useable"] = false,
    ["shouldClose"] = false,
    ["combinable"] = nil,
    ["description"] = "Listen to your favorite music"
},
```
