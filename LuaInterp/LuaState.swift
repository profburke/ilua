//
//  LuaState.swift
//  LuaInterp
//
//  Created by Matthew Burke on 10/22/14.
//  Copyright (c) 2014 BlueDino Software. All rights reserved.
//

import Foundation

// TODO: maybe make this an enum with associated data...or see
// cocoaphany for possibilities of sleeker error handling
typealias EvalResult = (code: Int32, results: [String])

// TODO: pass in L to all the functions to make them easier to test...

// TODO: TODO: TODO: see AnotherLuaState.swift for some ideas about improvements



class LuaState
{
    let L: COpaquePointer
    let RETURN_CHARSET = NSCharacterSet(charactersInString: "\n")
    let RETURN = "return ".cStringUsingEncoding(NSASCIIStringEncoding)!
    let EOFMARK = "<eof>"
    let NEWLINE = "\n".cStringUsingEncoding(NSASCIIStringEncoding)!

    var firstLine: Bool = true
    
    
    // MARK: - Lifecycle Methods
    
    
    init()
    {
        L = luaL_newstate()
        luaL_openlibs(L)
    }
    
    
    
    
    deinit
    {
        lua_close(L)
    }
    
    
    
    // MARK: - REPL Methods
    
    
    
    func l_print(inout results: [String])
    {
        let n = lua_gettop(self.L)
        if n > 0 {
            lua_getglobal(self.L, "tostring")
            for var i = n; i > 0; i--
            {
                lua_pushvalue(self.L, -1)
                lua_pushvalue(self.L, i)
                lua_callk(self.L, 1, 1, 0, nil)
                let msg = String(UTF8String: lua_tolstring(L, -1 * i, nil))
                
                if let errmsg = msg
                {
                    results.append(errmsg)
                }
                
                lua_pop(self.L, 1)
            }
        }
    }
    
    
    
    
    func report(status: Int32, inout results: [String])
    {
        if status != LUA_OK && status != LUA_ERRINCOMPLETE {
            let msg = String(UTF8String: lua_tolstring(self.L, -1, nil))
            results.append(msg!)
            lua_pop(L, 1)  /* remove message */
            
        }
    }
    
    
    
    
    func removeInput()
    {
        let n = lua_gettop(self.L)
        for var i: Int32 = 1; i < n; i++ {
            lua_remove(self.L, 1)
        }
    }
    
    
    
    
    func incomplete(status: Int32) -> Bool
    {
        if status == LUA_ERRSYNTAX {
            var lmsg: size_t = 0
            let msg = NSString(CString: lua_tolstring(self.L, -1, &lmsg), encoding: NSASCIIStringEncoding)!
            if msg.hasSuffix(EOFMARK) {
                lua_pop(self.L, 1)
                return true
            }
        }
        return false
    }
    
    
    
    
    func compile() -> Int32
    {
        let line = lua_tolstring(self.L, -1, nil)
        let status = luaL_loadstring(self.L, line)
        return status
    }
    
    
    
    
    func compileAsIs() -> Int32
    {
        var status = compile()
        if status != LUA_OK {
            if incomplete(status) {
                status = LUA_ERRINCOMPLETE
            }
        }
        return status
    }
    
    
    
    
    func compileWithReturn() -> Int32
    {
        let line = NSString(CString: lua_tolstring(self.L, -1, nil), encoding: NSASCIIStringEncoding)
        if let lline = line {
            if !lline.hasPrefix("return ") {
                let newInput = NSString(format: "return %@", lline)
                lua_pushstring(self.L, newInput.cStringUsingEncoding(NSASCIIStringEncoding))
            }
        }
 
        let status = compile()
        if status != LUA_OK {
            lua_pop(self.L, 2)
        }
        return status
    }
    
    
    
    
    private func processLine(var script: String)
    {
        let n = lua_gettop(self.L)
        
        script = script.stringByTrimmingCharactersInSet(RETURN_CHARSET)
        
        // legacy handling from Lua 5.2
        if n == 0 && script.hasPrefix("=") {
            let afterEqualsIndex = script.startIndex.successor()
            script = "return " + script.substringFromIndex(afterEqualsIndex)
        }
        lua_pushstring(self.L, script.cStringUsingEncoding(NSASCIIStringEncoding)!)
        
        // If we already have the start of a Lua command, combine our new
        // input with what was leftover.
        if n > 0 {
            lua_pushstring(self.L, NEWLINE)
            lua_insert(self.L, -2)
            lua_concat(self.L, 3)
        }
    }
    
    
    

    /*
     * 1. Trim line and place on stack
     * 2. If it's first line and begins with "=", replace it with "return"
     * 3. If there is an existing input line on stack, combine
     * 4. Try adding return and compiling, if error, remove the altered line
     * 5. If previous compile was unsuccessful, try compiling without the added "return"
     * 6. If compile successul, run it; return results, reset stack.
     * 7. If the input is incomplete, return and wait for more input
     * 8. If an error, report it.
     */
    func eval(script: String) -> EvalResult
    {
        var output: [String] = []
        var status = LUA_OK
        
        processLine(script)

        status = compileWithReturn()
        
        if status != LUA_OK {
            status = compileAsIs()
        }

        if status == LUA_OK {
            removeInput()
            status = lua_pcallk(self.L, 0, LUA_MULTRET, 0, 0, nil)
        }
        
        if status == LUA_OK {
            l_print(&output)
        } else {
            report(status, results: &output)
        }
        
        if status != LUA_ERRINCOMPLETE {
            lua_settop(self.L, 0)
        }
        
        return EvalResult(status, output)
    }
    
 
    
    
}
