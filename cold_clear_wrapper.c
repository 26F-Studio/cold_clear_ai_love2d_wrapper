#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "coldclear.h"
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

//CCAsyncBot *cc_launch_async(CCOptions *options, CCWeights *weights);
static int launch_async(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    CCWeights *weights = (CCWeights *)lua_touserdata(L, 2);
    CCAsyncBot *bot = cc_launch_async(options, weights, 0, 0, 0);
    lua_pushlightuserdata(L, (void *)bot);
    return 1;
}

//void cc_destroy_async(CCAsyncBot *bot);
static int destroy_async(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    cc_destroy_async(bot);
    return 0;
}

//void cc_reset_async(CCAsyncBot *bot, bool *field, bool b2b, uint32_t combo);
static int reset_async(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    bool b2b = lua_toboolean(L, 3);
    int combo = lua_tointeger(L, 4);
    bool field[400];
    int size = luaL_getn(L, 1);
    for (int i=1; i<=size; i++) {
        lua_rawgeti(L, 2, i);
        field[i] = lua_toboolean(L, -1);
        lua_pop(L, 1);
    }
    /* Should we check for whether i==400 ? */
    cc_reset_async(bot, field, b2b, combo);
    return 0;
}

//void cc_add_next_piece_async(CCAsyncBot *bot, CCPiece piece);
static int add_next_piece_async(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    int piece = lua_tointeger(L, 2);
    cc_add_next_piece_async(bot, piece);
    return 0;
}

//void cc_request_next_move(CCAsyncBot *bot, uint32_t incoming);
static int request_next_move(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    if (lua_isnumber(L, 2)) {
        cc_request_next_move(bot, lua_tointeger(L, 2));
    } else {
        cc_request_next_move(bot, 0);
    }
    return 0;
}

int return_cc_move(lua_State *L, CCBotPollStatus ret, CCMove *move, CCPlanPlacement *plan, uint32_t *plan_length) {
    lua_pushnumber(L, ret);  //成功否
    if (CC_MOVE_PROVIDED == ret) {
        lua_newtable(L);
        int k, table1 = lua_gettop(L);
        for (k = 0; k < 4; ++k) {
            lua_pushnumber(L, k + 1);
            lua_newtable(L);
            int j, table2 = lua_gettop(L);
            lua_pushnumber(L, 1);
            lua_pushnumber(L, move->expected_x[k]);
            lua_settable(L, table2);
            lua_pushnumber(L, 2);
            lua_pushnumber(L, move->expected_y[k]);
            lua_settable(L, table2);
            lua_settable(L, table1);
        }
        lua_pushboolean(L, move->hold);  //hold否
        lua_newtable(L);
        int i, table = lua_gettop(L);
        int len = move->movement_count;
        for (i = 0; i < len; i++) {
            lua_pushnumber(L, i + 1);
            lua_pushnumber(L, move->movements[i]);
            lua_settable(L, table);
        }
    } else {
        lua_pushnil(L);
        lua_pushnil(L);
        lua_pushnil(L);
    }
    return 4;
}

//CCBotPollStatus cc_poll_next_move(
//    CCAsyncBot *bot,
//    CCMove *move,
//    CCPlanPlacement* plan,
//    uint32_t *plan_length
//);
static int poll_next_move(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    CCMove move;
    CCBotPollStatus ret = cc_poll_next_move(bot, &move, NULL, NULL);
    return return_cc_move(L, ret, &move, NULL, NULL);
}

//CCBotPollStatus cc_block_next_move(
//    CCAsyncBot *bot,
//    CCMove *move,
//    CCPlanPlacement* plan,
//    uint32_t *plan_length
//);
static int block_next_move(lua_State *L) {
    CCAsyncBot *bot = (CCAsyncBot *)lua_touserdata(L, 1);
    CCMove move;
    CCBotPollStatus ret = cc_block_next_move(bot, &move, NULL, NULL);
    return return_cc_move(L, ret, &move, NULL, NULL);
}

//void cc_default_options(CCOptions *options);
static int default_options(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    cc_default_options(options);
    return 0;
}

//void cc_default_weights(CCWeights *weights);
static int default_weights(lua_State *L) {
    CCWeights *weights = (CCWeights *)lua_touserdata(L, 1);
    cc_default_weights(weights);
    return 0;
}

//void cc_fast_weights(CCWeights *weights);
static int fast_weights(lua_State *L) {
    CCWeights *weights = (CCWeights *)lua_touserdata(L, 1);
    cc_fast_weights(weights);
    return 0;
}

//供lua创建新的默认选项数据
static int get_default_config(lua_State *L) {
    CCOptions *options = (CCOptions *)malloc(sizeof(CCOptions));
    CCWeights *weights = (CCWeights *)malloc(sizeof(CCWeights));
    cc_default_options(options);
    // Not the same with techmino, but suits better
    // note that rows in cold clear is 0-indexed
    // maybe it should be settable
    options->spawn_rule = CC_ROW_21_AND_FALL;
    cc_default_weights(weights);
    lua_pushlightuserdata(L, (void *)options);
    lua_pushlightuserdata(L, (void *)weights);
    return 2;
}

//供lua调用的hold 20g bag7 pcf设置
static int set_options(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    bool hold = lua_toboolean(L, 2);
    bool _20g = lua_toboolean(L, 3);
    bool bag7 = lua_toboolean(L, 4);
    bool pcloop = lua_toboolean(L, 5);
    options->use_hold = hold;
    options->mode = _20g;
    options->speculate = bag7;
    options->pcloop = pcloop;
    return 0;
}

static int set_hold(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    bool hold = lua_toboolean(L, 2);
    options->use_hold = hold;
    return 0;
}

static int set_20g(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    bool _20g = lua_toboolean(L, 2);
    options->mode = _20g;
    return 0;
}

static int set_bag7(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    bool bag7 = lua_toboolean(L, 2);
    options->speculate = bag7;
    return 0;
}

static int set_pcloop(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    bool pcloop = lua_toboolean(L, 2);
    options->pcloop = pcloop;
    return 0;
}

static int set_min_nodes(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    int min_nodes = lua_tointeger(L, 2);
    options->min_nodes = min_nodes;
    return 0;
}

static int set_max_nodes(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    int max_nodes = lua_tointeger(L, 2);
    options->max_nodes = max_nodes;
    return 0;
}

static int set_threads(lua_State *L) {
    CCOptions *options = (CCOptions *)lua_touserdata(L, 1);
    int threads = lua_tointeger(L, 2);
    options->threads = threads;
    return 0;
}

static int cfree(lua_State *L) {
    void *p = lua_touserdata(L, 1);
    free(p);
    return 0;
}

static int set_weights(lua_State *L) {
    CCWeights *weights = (CCWeights *)lua_touserdata(L, 1);
    while (lua_next(L, 2)) {
        const char *key = lua_tostring(L, -2);
        int value = lua_tonumber(L, -1);
        // clang-format off
        if(!strcmp(key,"back_to_back"))          weights->back_to_back=value;
        else if(!strcmp(key,"bumpiness"))        weights->bumpiness=value;
        else if(!strcmp(key,"bumpiness_sq"))     weights->bumpiness_sq=value;
        else if(!strcmp(key,"height"))           weights->height=value;
        else if(!strcmp(key,"top_half"))         weights->top_half=value;
        else if(!strcmp(key,"top_quarter"))      weights->top_quarter=value;
        else if(!strcmp(key,"cavity_cells"))     weights->cavity_cells=value;
        else if(!strcmp(key,"cavity_cells_sq"))  weights->cavity_cells_sq=value;
        else if(!strcmp(key,"overhang_cells"))   weights->overhang_cells=value;
        else if(!strcmp(key,"overhang_cells_sq"))weights->overhang_cells_sq=value;
        else if(!strcmp(key,"covered_cells"))    weights->covered_cells=value;
        else if(!strcmp(key,"covered_cells_sq")) weights->covered_cells_sq=value;
        //else if(!strcmp(key,"tslot"))            weights->tslot=value;
        else if(!strcmp(key,"well_depth"))       weights->well_depth=value;
        else if(!strcmp(key,"max_well_depth"))   weights->max_well_depth=value;
        //else if(!strcmp(key,"well_column"))      weights->well_column=value;
        else if(!strcmp(key,"b2b_clear"))        weights->b2b_clear=value;
        else if(!strcmp(key,"clear1"))           weights->clear1=value;
        else if(!strcmp(key,"clear2"))           weights->clear2=value;
        else if(!strcmp(key,"clear3"))           weights->clear3=value;
        else if(!strcmp(key,"clear4"))           weights->clear4=value;
        else if(!strcmp(key,"tspin1"))           weights->tspin1=value;
        else if(!strcmp(key,"tspin2"))           weights->tspin2=value;
        else if(!strcmp(key,"tspin3"))           weights->tspin3=value;
        else if(!strcmp(key,"mini_tspin1"))      weights->mini_tspin1=value;
        else if(!strcmp(key,"mini_tspin2"))      weights->mini_tspin2=value;
        else if(!strcmp(key,"perfect_clear"))    weights->perfect_clear=value;
        else if(!strcmp(key,"combo_garbage"))    weights->combo_garbage=value;
        else if(!strcmp(key,"move_time"))        weights->move_time=value;
        else if(!strcmp(key,"wasted_t"))         weights->wasted_t=value;
        // clang-format on
        lua_pop(L, 1);
    }
    return 0;
}

static int about(lua_State *L) {
    lua_pushstring(L, "wrapper by flaribbit");
    return 1;
}

static const struct luaL_Reg funcList[] = {
    {"about", about},
    {"launch_async", launch_async},
    {"destroy_async", destroy_async},
    {"reset_async", reset_async},
    {"add_next_piece_async", add_next_piece_async},
    {"request_next_move", request_next_move},
    {"poll_next_move", poll_next_move},
    {"block_next_move", block_next_move},
    {"default_options", default_options},
    {"default_weights", default_weights},
    {"fast_weights", fast_weights},
    {"get_default_config", get_default_config},
    {"set_options", set_options},
    {"set_hold", set_hold},
    {"set_20g", set_20g},
    {"set_bag7", set_bag7},
    {"set_pcloop", set_pcloop},
    {"set_max_nodes", set_max_nodes},
    {"set_weights", set_weights},
    {"free", cfree},
    {0, 0}};

int luaopen_CCloader(lua_State *L) {
    luaL_register(L, "cc", funcList);
    return 1;
}
