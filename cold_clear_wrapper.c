#include <stdlib.h>
#include <stdio.h>
#include "coldclear.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

//CCAsyncBot *cc_launch_async(CCOptions *options, CCWeights *weights);
static int launch_async(lua_State *L){
    CCOptions *options=(CCOptions*)lua_tointeger(L,1);
    CCWeights *weights=(CCWeights*)lua_tointeger(L,2);
    CCAsyncBot *bot=cc_launch_async(options,weights);
    lua_pushinteger(L,(lua_Integer)bot);
    return 1;
}

//void cc_destroy_async(CCAsyncBot *bot);
static int destroy_async(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    cc_destroy_async(bot);
    return 0;
}

//void cc_reset_async(CCAsyncBot *bot, bool *field, bool b2b, uint32_t combo);
static int reset_async(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    bool b2b=lua_toboolean(L,3);
    int combo=lua_tointeger(L,4);
    bool field[400];
    int i=0;
    while(lua_next(L,2)){
        field[i++]=lua_toboolean(L,-1);
        lua_pop(L,1);
    }
    cc_reset_async(bot,field,b2b,combo);
    return 0;
}

//void cc_add_next_piece_async(CCAsyncBot *bot, CCPiece piece);
static int add_next_piece_async(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    int piece=lua_tointeger(L,2);
    cc_add_next_piece_async(bot,piece);
    return 0;
}

//void cc_request_next_move(CCAsyncBot *bot);
static int request_next_move(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    cc_request_next_move(bot);
    return 0;
}

//bool cc_poll_next_move(CCAsyncBot *bot, CCMove *move);
static int poll_next_move(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    CCMove move;
    bool ret=cc_poll_next_move(bot,&move);
    //TODO: 返回是否成功和按键
    lua_pushboolean(L,ret);
    return 2;
}

//bool cc_is_dead_async(CCAsyncBot *bot);
static int is_dead_async(lua_State *L){
    CCAsyncBot *bot=(CCAsyncBot*)lua_tointeger(L,1);
    bool ret=cc_is_dead_async(bot);
    lua_pushboolean(L,ret);
    return 1;
}

//void cc_default_options(CCOptions *options);
static int default_options(lua_State *L){
    CCOptions *options=(CCOptions*)lua_tointeger(L,1);
    cc_default_options(options);
    return 0;
}

static int about(lua_State *L){
    lua_pushstring(L,"wrapper by flaribbit");
    return 1;
}

static const struct luaL_Reg funcList[]=
{
    {"about", about},
    {"launch_async",launch_async},
    {"destroy_async",destroy_async},
    {"reset_async",reset_async},
    {"add_next_piece_async",add_next_piece_async},
    {"request_next_move",request_next_move},
    {"poll_next_move",poll_next_move},
    {"default_options",default_options},
    {0, 0}
};

int luaopen_cold_clear_wrapper(lua_State *L)
{
    luaL_register(L, "cc", funcList);
    return 1;
}
