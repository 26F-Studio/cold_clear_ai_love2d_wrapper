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
    while(lua_next(L,2)&&i<400){
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
    lua_pushboolean(L,ret);//成功否
    if(ret){
        lua_pushboolean(L,move.hold);//hold否
        lua_newtable(L);
        int i,table=lua_gettop(L);
        int len=move.movement_count;
        for(i=0;i<len;i++){
            lua_pushnumber(L,i+1);
            lua_pushnumber(L,move.movements[i]);
            lua_settable(L,table);
        }
    }else{
        lua_pushnil(L);
        lua_pushnil(L);
    }
    return 3;
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

//void cc_default_weights(CCWeights *weights);
static int default_weights(lua_State *L){
    CCWeights *weights=(CCWeights*)lua_tointeger(L,1);
    cc_default_weights(weights);
    return 0;
}

//供lua创建新的默认选项数据
static int get_default_config(lua_State *L){
    CCOptions *options=(CCOptions*)malloc(sizeof(CCOptions));
    CCWeights *weights=(CCWeights*)malloc(sizeof(CCWeights));
    cc_default_options(options);
    cc_default_weights(weights);
    lua_pushinteger(L,(lua_Integer)options);
    lua_pushinteger(L,(lua_Integer)weights);
    return 2;
}

static int set_options(lua_State *L){
    CCOptions *options=(CCOptions*)lua_tointeger(L,1);
    bool hold=lua_toboolean(L,2);
    bool _20g=lua_toboolean(L,3);
    bool bag7=lua_toboolean(L,4);
    options->use_hold=hold;
    options->mode=_20g;
    options->speculate=bag7;
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
    {"default_weights",default_weights},
    {"get_default_config",get_default_config},
    {"set_options",set_options},
    {0, 0}
};

int luaopen_CCloader(lua_State *L)
{
    luaL_register(L, "cc", funcList);
    return 1;
}
