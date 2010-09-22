//
//  iLuaAppDelegate.h
//  iLua
//
//  Created by matt on 1/27/10.
//  Copyright BlueDino Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iLuaViewController;

@interface iLuaAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    iLuaViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iLuaViewController *viewController;

@end

