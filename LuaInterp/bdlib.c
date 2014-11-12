//
//  bdlib.c
//  LuaInterp
//
//  Created by Matthew Burke on 10/26/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

#include "bdlib.h"


static int flexiprint(lua_State *L)
{
    
    int n = lua_gettop(L);  /* number of arguments */
    int i;
    lua_getglobal(L, "tostring");
    for (i=1; i<=n; i++) {
        const char *s;
        size_t l;
        lua_pushvalue(L, -1);  /* function to be called */
        lua_pushvalue(L, i);   /* value to print */
        lua_call(L, 1, 1);
        s = lua_tolstring(L, -1, &l);  /* get result */
        if (s == NULL)
            return luaL_error(L,
                              LUA_QL("tostring") " must return a string to " LUA_QL("print"));
        if (i>1) luai_writestring("\t", 1);
        luai_writestring(s, l);
        lua_pop(L, 1);  /* pop result */
    }
    luai_writeline();
    return 0;

}


static const luaL_Reg bdlib[] = {
    {"flexiprint", flexiprint},
    {NULL, NULL}
};


int open_bdlib(lua_State *L)
{
    luaL_newlib(L, bdlib);
    return 1;
}
