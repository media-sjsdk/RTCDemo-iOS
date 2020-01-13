//
//  AppDelegate.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "RoomManager.h"
#import "BaseNavigationViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RoomDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, retain) BaseNavigationViewController *navigationController;
@property (nonatomic, retain) LoginViewController *loginViewController;

@end

