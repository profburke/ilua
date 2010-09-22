//
//  iLuaViewController.h
//  iLua
//
//  Created by matt on 1/27/10.
//  Copyright BlueDino Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

@interface iLuaViewController : UIViewController 
{
	UITextView *output;
	UITextView *input;
	
	lua_State *L;
}

@property (nonatomic, retain) IBOutlet UITextView *output;
@property (nonatomic, retain) IBOutlet UITextView *input;

-(IBAction) evaluate;
-(IBAction) clearInput;
-(IBAction) clearOutput;

@end

