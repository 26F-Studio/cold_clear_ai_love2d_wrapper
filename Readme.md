# cold clear ai love2d wrapper

```lua
require "cold_clear_wrapper"
-- get default options and weights
options, weights=cc.get_default_config()
-- you can change some options (bool)
cc.set_options(options, _hold, _20g, _bag7)
-- create new bot
bot = cc.launch_async(options, weights)
-- refresh current status and field
-- field is a table contains 400 bools
cc.reset_async(bot, field, b2b, combo)
-- add next piece
cc.add_next_piece_async(bot, piece)
-- calculate next move
cc.request_next_move(bot)
-- get next move
status, hold, move = cc.poll_next_move(bot)
-- or blocking version
status, hold, move = cc.block_next_move(bot)
-- destroy
cc.destroy_async(bot)
```

Some information from coldclear.h

```c
typedef enum CCBotPollStatus {
    CC_MOVE_PROVIDED,
    CC_WAITING,
    CC_BOT_DEAD
} CCBotPollStatus;

typedef enum CCPiece {
    CC_I, CC_T, CC_O, CC_S, CC_Z, CC_L, CC_J
} CCPiece;

typedef enum CCMovement {
    CC_LEFT, CC_RIGHT,
    CC_CW, CC_CCW,
    /* Soft drop all the way down */
    CC_DROP
} CCMovement;
```
