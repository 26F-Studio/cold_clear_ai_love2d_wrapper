# Cold Clear AI wrapper for Love2D - with Lê Duy Quang's patch
### FOR INTERNAL USE ONLY<BR>Do not make any PR from this fork to the upstream repo. 

[![CI](https://github.com/26F-Studio/cold_clear_ai_love2d_wrapper/actions/workflows/build.yml/badge.svg)](https://github.com/26F-Studio/cold_clear_ai_love2d_wrapper/actions)
![platform](https://img.shields.io/badge/platform-windows%20%7C%20linux%20%7C%20android%20%7C%20macos%20%7C%20ios-brightgreen.svg)

This is a Love2D/Lua wrapper for [Cold Clear](https://github.com/MinusKelvin/cold-clear), in order use it in Tetris games made with [Love2D game engine](https://love2d.org/).
# Special thanks to Lê Duy Quang who made the patch for Windows to fix errors while importing library from child folder, also combine CCloader and Cold Clear into one DLL file now
> Sadly I don't have any knowledge of C
But this repo will be included in (\<I will put the link later\>)

## Pitfalls

### Piece id

In the code of cold clear, the pieces are represented as integer thus:

```c
typedef enum CCPiece {
    CC_I, CC_O, CC_T, CC_L, CC_J, CC_S, CC_Z
} CCPiece;
```

However, for *tech*nical reasons (pun intended!), the wrapper uses a reversed order,
i.e. `Z S J L T O I`.

### Error messages

The whole API segfaults on any type errors. To see sensible error messages and stack traces, uncomment the `#define DEBUG_CC` macro in `cold_clear_wrapper.c`.

## How to build

`git clone https://github.com/26F-Studio/cold_clear_ai_love2d_wrapper --recursive`

### windows

* gcc ([tdm-gcc](https://jmeubank.github.io/tdm-gcc/) or mingw or msys2)
* build cold_clear.dll and copy it here
* copy lua51.dll here from love2d folder
* run `mingw32-make`

### linux

* (For Ubuntu) `sudo apt install gcc make cargo rustc love`
* `make CCloader.so`

### ios

* Xcode 13, CMake
* `chmod +x MacReleaseIOS.sh`
* run `MacReleaseIOS.sh`

### android

* ndk
* build libcold_clear.so and copy it here
* extract love.apk somewhere, copy path
* run `ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk LOVE2D_LIB=path/to/love2d/lib`

**Note:** To use it on android, you need to put libcold_clear.so in `/lib` and copy `libccloader.so` to *save directory*.

```lua
-- Hint, but not the only way to load it
package.cpath="/data/data/org.love2d.android.embed/files/save/archive/lib?.so;"..package.cpath
love.filesystem.write("libCCloader.so", love.filesystem.read("libCCloader.so"))
require "CCloader"
```

## How to use

See `cc.lua`

Some important information from coldclear.h

```c
typedef enum CCBotPollStatus {
    CC_MOVE_PROVIDED,
    CC_WAITING,
    CC_BOT_DEAD
} CCBotPollStatus;

typedef enum CCMovement {
    CC_LEFT, CC_RIGHT,
    CC_CW, CC_CCW,
    /* Soft drop all the way down */
    CC_DROP
} CCMovement;
```
