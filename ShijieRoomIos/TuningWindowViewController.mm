//
//  TuningWindowViewController.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "TuningWindowViewController.h"
#import "RoomManager.h"

@interface TuningWindowViewController ()

@property (retain, nonatomic) IBOutlet UISegmentedControl *routeSwitch;

@end

@implementation TuningWindowViewController

@synthesize routeSwitch;

- (id)init
{
    self = [super initWithNibName: @"TuningWindow" bundle: nil];
    if (self) {
        self.title = @"Tuning";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear: (BOOL)animated {
    
    // 设置不显示NavigationBar
    self.navigationController.navigationBarHidden = NO;
    
}

-(BOOL) shouldAutorotate {
    return NO;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
