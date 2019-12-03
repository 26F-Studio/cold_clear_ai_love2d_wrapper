#include "coldclear.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int About(lua_State *L){
    printf("wrapper by flaribbit\n");
    return 0;
}

static const struct luaL_Reg funcList[]=
{
    {"About", About},
    {0, 0}
};

int luaopen_testlibs_libtt(lua_State *L)
{
    luaL_register(L, "cc", funcList);
    return 1;
}
