# cold clear ai love2d wrapper

```lua
require "cold_clear_wrapper"
-- get default options and weights
options, weights=cc.get_default_config()
-- create new bot
bot = cc.launch_async(bot, options, weights)
-- refresh current status and field
-- field is a table contains 400 bools
cc.reset_async(bot, field, b2b, combo)
-- add next piece
cc.add_next_piece_async(bot, piece)
-- calculate next move
cc.request_next_move(bot)
-- get next move
success, hold, move = cc.poll_next_move(bot)
dead = cc.is_dead_async(bot)
```