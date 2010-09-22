//
//  iLuaViewController.m
//  iLua
//
//  Created by matt on 1/27/10.
//  Copyright BlueDino Software 2010. All rights reserved.
//

#import "iLuaViewController.h"


@implementation iLuaViewController

@synthesize output;
@synthesize input;

#pragma mark -
#pragma mark Lua/View Interaction Methods
#pragma mark -

-(void)clearInput 
{
	input.text = @"";
}


-(void)clearOutput 
{
	output.text = @"";
}


-(void)displayError 
{
	output.text = [output.text stringByAppendingFormat:@"%@\n",
			[NSString stringWithCString:lua_tostring(L, -1) 
									 encoding:NSASCIIStringEncoding]];
	lua_pop(L, 1);
}


-(void)evaluate 
{
	int err;
	
	[input resignFirstResponder];
	lua_settop(L, 0);
	
	err = luaL_loadstring(L, [input.text 
								 cStringUsingEncoding:NSASCIIStringEncoding]);
	if (0 != err) {
		[self displayError];
		return;
	}

	err = lua_pcall(L, 0, LUA_MULTRET, 0);
	if (0 != err) {
		[self displayError];
		return;
	}
	int nresults = lua_gettop(L);
	
	if (0 == nresults) {
		output.text = [output.text stringByAppendingFormat:@"<no results>\n"];
	} else {
		NSString *outputNS = [NSString string];
		for (int i = nresults; i > 0; i--) {
			outputNS = [outputNS stringByAppendingFormat:@"%s ", lua_tostring(L, -1 * i)];
		}
		lua_pop(L, nresults);
		output.text = [output.text stringByAppendingFormat:@"%@\n", outputNS];
	}
}


#pragma mark -
#pragma mark Life Cycle Methods
#pragma mark -

- (void)viewDidLoad 
{
    [super viewDidLoad];

	input.font = [UIFont systemFontOfSize:12];
	output.font = [UIFont systemFontOfSize:12];
	
	L = luaL_newstate();
	luaL_openlibs(L);
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc 
{
	lua_close(L);
	[output release];
	[input release];
	[super dealloc];
}


@end
