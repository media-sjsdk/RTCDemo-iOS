//
//  VideoViewController.h
//  ShijeRoomIos
//
//  Copyright (c) 2015 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <vector>
#include <deque>
#include <map>
@interface VideoViewController : UIViewController
{
@private
    UIDeviceOrientation currentOrientation;
    UIView* localView;
    std::map<UIView*, std::string> remoteViewMap;
    std::vector<UIView*> remoteViewes;
    std::vector<UILabel*> remoteTextLables;
    std::deque<NSString*> streamIds;
    int view_n;
}


- (void)onClickSwitchRotation: (BOOL)on;


- (IBAction)terminate:(id)sender;

-(void) RemoveRemoteStreamForView:(NSString*) uid;
-(void) AddRemoteStreamForView:(NSString*) uid;
-(void) unbindViewandWindow:(NSString*) uid;
-(void) bindViewandWindow:(NSString*) uid;


@property (retain, nonatomic) IBOutlet UITextField *txtViewNum;

@end
