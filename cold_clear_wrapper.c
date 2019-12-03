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
    {0, 0}
};

int luaopen_cold_clear_wrapper(lua_State *L)
{
    luaL_register(L, "cc", funcList);
    return 1;
}
