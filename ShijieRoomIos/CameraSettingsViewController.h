//
//  CameraSettingsViewController.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraSettingsViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView         *modePicker;
@property (nonatomic, retain) IBOutlet UISegmentedControl	*cameraSelector;

- (IBAction)selectCameraAction:(id)sender;

@end
