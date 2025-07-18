### Trigger the following export from your own resource (client side):

```lua
-- res will return true/false
local res = exports['av_alphabet']:start(hand, seconds, blocks)
if res then
    -- do something here:
end
```

**For hand you can use:** "left", "right" or "both"

> When using "left" the script will use the following characters:
> Q W E R A S D F Z X C

> For right hands it uses:
> U I O P J K L N M

> "both" is a mix of both characters list.

**Seconds:** This needs to be a number and is the time the player have to complete the sequence.

**Blocks:** How many characters will show on screen, min is 1 and max is 18.
