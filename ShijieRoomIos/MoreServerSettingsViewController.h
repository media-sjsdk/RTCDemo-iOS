//
//  MoreServerSettingsViewController.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreServerSettingsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *server;
@property (nonatomic, retain) IBOutlet UITextField *port;
@property (nonatomic, retain) IBOutlet UITextField *remoteName;
@property (nonatomic, retain) IBOutlet UITextField *localName;
@property (nonatomic, retain) IBOutlet UISwitch *p2pCallButton;
@property (nonatomic, retain) IBOutlet UISwitch *callerSideButton;



- (IBAction)reset:(UIButton *)sender;

@end
