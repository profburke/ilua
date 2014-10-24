
## README

This project is an example of integrating Lua with an iOS program. It's not meant to be an example of best practice; merely as an example of how easy it is to include Lua in your Swift project.

Steps taken:

1. Add Lua Source to Project
2. Write a [Bridging Header](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html)
3. There is no step 3

Ok, you *can* stop at step 2. You now have the entire Lua API available from Swift. But for practical purposes, you'll find yourself adding step 3:


3\. write a simple wrapper class


In most cases, you want to treat the Lua interpreter as a black box: your Swift code sends a script and/or data to Lua, processing occurs, and you receive data back. You don't want to worry about the details of managing Lua state(s) and manipulating the Lua stack.

So it pays to have a Swift class to wrap the details of dealing with Lua. You class can provide a simple API and Lua state initialization is automatically handled by the class's `init` method. To begin with your Swift class can provide a trivial API consisting of an `eval` method that allows you to hand off a script and get data back. As you work with Lua more and your needs change, you can extend your wrapper class's API.

#### The Steps in Detail

###### 1. Add Lua Source to Project

Unless/until the Lua distribution changes dramatically, all you need to do is download the Lua version you want and add (almost) all of the files in the `src` directory to your Xcode project. Do not add `lua.c` and `luac.c`. These are the implementations of the stand-alone interpreter and compiler, respectively. You will not need these in your iOS app. Moreoever, they both contain `main` methods, so including them will generate linker errors as they will conflict with your app's `main` method.


###### 2. Write a Bridging Header

In order for Swift code to interact with C (or C++ or Objective C) code, you need to write a so-called bridging header.

For Lua, make sure this header includes (or imports, it doesn't really matter in this case) the files `lua.h`, `lauxlib.h`, and `lualib.h`.

You need to make sure that Xcode is aware of your bridging header by setting the **Objective-C Bridging Header** build setting which is in the **Swift Compiler - Code Generation** section. You need to set this at the **target** level, not the **project** level.


###### 3. Create a Swift wrapper for the Lua State

When embedding Lua in a larger application, it is not uncommon to create more than one Lua state (*note: I've been using Lua interpreter interchangably with `state` which is not correct. But, hey, you know what I mean...*). In order to interact with the various Lua states, it makes sense to wrap them in a Swift layer so that you can hide the details of instatiation, configuration, and interaction. In Objective-C we had one choice for a wrapper: a class. With Swift, it might make more sense to use a `struct`, particularly if we aren't going to subclass.

In this project, however, I've gone ahead and created a Swift class. The `init` method takes care of creating and configuring a new Lua state object. A reference to the Lua state is stored as a class constant of type `COpaquePointer`. I thought a `UnsafePointer<lua_State>` would do the trick, but it won't work. I'm not sure why; possibly because `lua_State` is actually a *typedef*.

We implement a `deinit` method in order to call `lua_close` and then use calls to the Lua API (particularly stack manipulation) in order to implement our wrapper's API.

**NOTE:** One thing to consider is the large number of convenience methods in the API, typically prefixed by `luaL_`. Most (all?) of these are implemented as C preprocessor macros. Consequently, you cannot call them from Swift (although Swift will pick up most "constants" defined as macros).

For example, you cannot use `lua_pop(L, n)` since it's a macro and have to resort to `lua_settop(L, -(n)-1). It may be worth converting these macros to actual C definitions. Perhaps there's a way to indicate that they should be inlined.




##### Project History and Alternatives

The original version of this project (circa 2010) used Objective C. As of October 2014, it has been rewritten in Swift and requires Xcode 6.1. The target OS is iOS 8.1.

I have a few improvements in mind, although it's not likely I'll get to them in a timely manner. 

If you want to integrate Lua with your iOS project, there are a number of available projects that are perhaps a better starting point than this one:

* [ObjC-Lua](https://github.com/PedestrianSean/ObjC-Lua), implements a nice bridge in the style of iOS 7's JavaScriptCore. It is available as a [CocoaPod](http://cocoapods.org). 
* [lua-on-ios](https://github.com/narfdotpl/lua-on-ios) leads you through a sequence of refinements, with each step a sepeart git commit
* a quick search on [Github](github.com) or [Google](google.com) will turn up a score of others


---
---


***Various copyrights statements follow:***

## This project

Copyright &copy; 2010-2014 Matthew M. Burke
 
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Lua

Lua is used under the following terms:

Copyright © 1994–2014 Lua.org, PUC-Rio.
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Logo

The logo is used under the following terms:

Copyright © 1998 Lua.org. Graphic design by Alexandre Nakonechnyj.
Permission is hereby granted, without written agreement and without license or royalty fees, to use, copy, and distribute this logo for any purpose, including commercial applications, subject to the following conditions:

* The origin of this logo must not be misrepresented; you must not claim that you drew the original logo.
* The only modification you can make is to adapt the orbiting text to your product name.
* The logo can be used in any scale as long as the relative proportions of its elements are maintained.

