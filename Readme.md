# cold clear ai love2d wrapper
This is a love2d/lua wrapper for [cold clear](https://github.com/MinusKelvin/cold-clear), in order use it in tetris games made by [love2d game engine](https://love2d.org/).

## How to build
### windows version
* gcc (mingw or msys2 or tdm-gcc)
* build cold_clear.dll and copy it here
* copy lua51.dll here from love2d folder
* run `make` (maybe `mingw32-make`)

### linux version
* gcc
* build libcold_clear.so and copy it here
* run `make libCCloader.so`

### android version
* ndk
* build libcold_clear.so and copy it here
* extract love.apk somewhere, copy path, and replace `path/to/` in `Android.mk` with it
* run `path/to/ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk`

**Note:** To use it on android, you need to put libcold_clear.so in `/lib` and copy `libccloader.so` to *save directory*.
```lua
-- Hint, but not the only way to load it
package.cpath="/data/data/org.love2d.android.embed/files/save/archive/lib?.so;"..package.cpath
love.filesystem.write("libCCloader.so", love.filesystem.read("libCCloader.so"))
require "CCloader"
```

### Have trouble in building cold clear?
You can get it from [here](https://github.com/flaribbit/cold-clear/actions).

## How to use
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
cc.request_next_move(bot, jeopardy)

-- or without jeopardy
cc.request_next_move(bot)

-- get next move
-- cc_is_dead_async now in status
status, hold, move = cc.poll_next_move(bot)

-- or blocking version
status, hold, move = cc.block_next_move(bot)

-- destroy
cc.destroy_async(bot)

-- remember to free there pointers
cc.free(options)
cc.free(weights)
```

Some important information from coldclear.h

```c
typedef enum CCBotPollStatus {
    CC_MOVE_PROVIDED,
    CC_WAITING,
    CC_BOT_DEAD
} CCBotPollStatus;

typedef enum CCPiece {
    CC_I, CC_O, CC_T, CC_L, CC_J, CC_S, CC_Z
} CCPiece;

typedef enum CCMovement {
    CC_LEFT, CC_RIGHT,
    CC_CW, CC_CCW,
    /* Soft drop all the way down */
    CC_DROP
} CCMovement;
```
