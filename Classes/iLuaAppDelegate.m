//
//  iLualAppDelegate.m
//  iLua
//
//  Created by matt on 1/27/10.
//  Copyright BlueDino Software 2010. All rights reserved.
//

#import "iLuaAppDelegate.h"
#import "iLuaViewController.h"

@implementation iLuaAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
