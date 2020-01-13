//
//  CameraSettingsViewController.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "CameraSettingsViewController.h"
#import "AppDelegate.h"

@interface CameraSettingsViewController ()

@end

@implementation CameraSettingsViewController

@synthesize modePicker;
@synthesize cameraSelector;

- (id)init
{
    self = [super initWithNibName: @"CameraSettings" bundle: nil];
    if (self) {
        self.title = @"Camera Settings";
    }
    return self;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"";
}
- (void)selectCameraAction:(id)sender
{
    [DEVICE_MANAGER switchCamera];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)dealloc
{
}

@end
