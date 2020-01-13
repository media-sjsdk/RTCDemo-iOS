//
//  LoginViewController.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <vector>
#import "XDSDropDownMenu.h"
#include <map>
struct resolutionInfo{
    int width;
    int height;
    BOOL resolution_adapter;
    resolutionInfo(int w,int h,BOOL adapter) {
        width = w;
        height = h;
        resolution_adapter = adapter;
    }
};
@interface LoginViewController : UIViewController
{
    @private
    std::vector<resolutionInfo> resolutionInfolist;
    NSArray *resolutionarr;
    NSArray *rolearry;
}

@property (weak, nonatomic) IBOutlet UIButton *selcetbutton;
@property (nonatomic, retain) IBOutlet UITextField *localName;
@property (weak, nonatomic) IBOutlet UIButton *resolution;
@property (weak, nonatomic) IBOutlet UIButton *role;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) IBOutlet UISwitch *speakerSwitch;

@property (nonatomic, retain) IBOutlet UITextField *remoteName;
@property (nonatomic, retain) IBOutlet UITextField *serverAddress;
@property (nonatomic, retain) IBOutlet UITextField *conference;
@property (nonatomic, retain) IBOutlet UISwitch *joinWithoutVideoButton;
@property (nonatomic, strong)  NSArray *dropDownMenuArray;
@property (nonatomic, strong)  NSArray *buttonArray;
@property (nonatomic, strong) XDSDropDownMenu* resolutionDropDownMenu;
@property (nonatomic, strong) XDSDropDownMenu* roleDropDownMenu;
@property (weak, nonatomic) IBOutlet UIButton *selectRole;

- (IBAction)reset:(UIButton *)sender;

- (IBAction)connecting:(id)sender;
- (IBAction)switchCamera:(id)sender;
- (void) show;

@end

