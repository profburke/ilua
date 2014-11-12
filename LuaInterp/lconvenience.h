//
//  lconvenience.h
//  LuaInterp
//
//  Created by Matthew Burke on 11/2/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

#ifndef __LuaInterp__lconvenience__
#define __LuaInterp__lconvenience__

#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"


void lua_pop(lua_State *L, int n);
void lua_remove(lua_State *L, int n);
void lua_insert(lua_State *L, int n);


void dumpstack(lua_State *L);


#endif /* defined(__LuaInterp__lconvenience__) */
