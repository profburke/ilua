//
//  lconvenience.c
//  LuaInterp
//
//  Created by Matthew Burke on 11/2/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

#include "lconvenience.h"



void lua_pop(lua_State *L, int n)
{
    lua_settop(L, -n-1);
}




void lua_insert(lua_State *L, int n)
{
    lua_rotate(L, n, 1);
}
               
               
               
               
void lua_remove(lua_State *L, int n)
{
    lua_rotate(L, n, -1);
    lua_pop(L, 1);
}




// TODO: more details for the complex types
void dumpstackEntry(lua_State *L, int i)
{
    printf("%d: ", i);
    int val_type = lua_type(L, i);
    switch (val_type) {
        case LUA_TNIL:
            printf("nil\n");
            break;
        case LUA_TNUMBER:
            printf("%f\n", lua_tonumber(L, i));
            break;
        case LUA_TSTRING:
            printf("%s\n", lua_tostring(L, i));
            break;
        case LUA_TBOOLEAN:
            printf("%s\n", lua_toboolean(L, i)?"true":"false");
            break;
        case LUA_TLIGHTUSERDATA:
            printf("lightuserdata\n");
            break;
        case LUA_TTABLE:
            printf("table\n");
            break;
        case LUA_TFUNCTION:
            printf("function\n");
            break;
        case LUA_TUSERDATA:
            printf("userdata\n");
            break;
        case LUA_TTHREAD:
            printf("thread\n");
            break;
        default:
            printf("Unknown type: %d\n", val_type);
            break;
    }
}




void dumpstack(lua_State *L)
{
    int n = lua_gettop(L);
    
    printf("Stack Top\n----- ---\n");
    for (int i = n; i > 0; i--) {
        dumpstackEntry(L, i);
    }
    printf("Stack Bottom\n----- ------\n");
}
