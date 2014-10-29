//
//  LuaState.swift
//  LuaInterp
//
//  Created by Matthew Burke on 10/22/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

import Foundation

// maybe make this an enum with associated data...or see
// cocoaphany for possibilities of sleeker error handling
typealias EvalResult = (code: Int32, results: [String])

// TODO: update for Lua 5.3 beta


class LuaState
{
    let L: COpaquePointer
    
    
    init()
    {
        L = luaL_newstate()
        luaL_openlibs(L)
    }
    
    
    
    
    deinit
    {
        lua_close(L)
    }
    
    
    
        
    func evaluate(script: String) -> EvalResult
    {
        var results: [String] = []
        var script = script
        
        lua_settop(L, 0)
        
        // FIXME: this is a hack
        if script.hasPrefix("=") {
            let index = script.rangeOfString("=", options: NSStringCompareOptions.LiteralSearch,
                range: Range(start: script.startIndex, end: script.endIndex), locale: nil)?.endIndex.successor()
            script = String("return ") + script.substringFromIndex(index!)
        }
        
        var err = luaL_loadstring(L, script)
        if err != LUA_OK
        {
            let msg = String(UTF8String: lua_tolstring(L, -1, nil))
            
            if let errmsg = msg
            {
                results.append(errmsg)
            }

            return (err, results)
        }
        
        
        err = lua_pcallk(L, 0, LUA_MULTRET, 0, 0, nil)
        if err != LUA_OK
        {
            let msg = String(UTF8String: lua_tolstring(L, -1, nil))
            
            if let errmsg = msg
            {
                results.append(errmsg)
            }
            
            return (err, results)
        }

        
        let nresults = lua_gettop(L)
        if nresults != 0
        {
            for var i = nresults; i > 0; i--
            {
                let msg = String(UTF8String: lua_tolstring(L, -1 * i, nil))
                
                if let errmsg = msg
                {
                    results.append(errmsg)
                }
            }
            
            lua_settop(L, -(nresults)-1) // can't use lua_pop since it's a #define
        }

        
        return (LUA_OK, results)
    }
    
    
    
    
}