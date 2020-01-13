//
//  VideoViewController.m
//  ShijeRoomIos
//
//  Copyright (c) 2015 Shisu.Inc. All rights reserved.
//

#import "VideoViewController.h"
#import "AppDelegate.h"
#import "RoomManager.h"
#import "SJSDK/RenderManager.h"
#import "PhoneActionBar.h"
#include <algorithm>
#include <string>


@interface VideoViewController ()<RoomDelegate>

@property (nonatomic, strong) IBOutlet UIView *renderLayer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollStat;
@property (weak, nonatomic) IBOutlet UILabel *statText;
@property (weak, nonatomic) IBOutlet UIButton *terminateBtn;

@end

@implementation VideoViewController

@synthesize renderLayer = _renderLayer;
@synthesize statText;
@synthesize scrollStat;
@synthesize terminateBtn;

std::string FREELAYOUT = "free_layout";

#define SCREENWIDTH ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0 ?[UIScreen mainScreen].bounds.size.width :[UIScreen mainScreen].bounds.size.height)
#define SCREENHEIGTH ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0 ?[UIScreen mainScreen].bounds.size.height :[UIScreen mainScreen].bounds.size.width)

#define TOPHEIGHT  15 //(SCREENHEIGTH - 40)
#define BOTTOMHEIGHT  (40 + TOPHEIGHT) //40


- (void)viewDidLoad {
    [super viewDidLoad];
    view_n = 0;
    
}

- (void) viewWillAppear: (BOOL)animated {
    localView = nil;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear: (BOOL)animated {
}

- (void) viewWillDisappear: (BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (id)init
{
    self = [super initWithNibName: @"VideoView" bundle: [NSBundle mainBundle]];
    if (self) {
        self.title = @"VideoView";
        [CONFERENCE_MANAGER addDelegate: self];
        
        [self.view bringSubviewToFront:_renderLayer];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            terminateBtn.titleLabel.font =  [UIFont systemFontOfSize: 29.0];
        }
        [statText setHidden:YES];
        [scrollStat setHidden:YES];
    }
    return self;
}

- (void) onLocalUserLeaved
{
     NSLog(@"onLocalUserLeaved");
    
}

- (void) onRemoteVidStreamCreated:(NSString *)nsUid
                     streamId: (NSString *)streamId
{
    NSLog(@"OnRemoteVidStreamCreated: with uid:%@", nsUid);
}

- (void)setDynamicView:(size_t) windows_num
{
    int num = (int)windows_num;
    for (int i =0; i<remoteTextLables.size();i++){
        [remoteTextLables[i] setText:@""];
    }
    remoteTextLables.clear();
    for (int i = 0;i <remoteViewes.size();i++){
        if(remoteViewes[i] !=nil){
            [remoteViewes[i] removeFromSuperview];
            [RENDER_MANAGER destroyRender:remoteViewes[i]];
        }
    }
    remoteViewMap.clear();
    remoteViewes.clear();
    view_n = num <= 12 ? num : 12;
    
    for (int i = 0; i <= view_n - 1; i++) {
        CGRect rect;
        CGRect LabelRect;
        LabelRect.size.width = 100;
        LabelRect.size.height = 25;
        if (view_n == 1) {
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.width = SCREENWIDTH;
            rect.size.height = (SCREENHEIGTH - BOTTOMHEIGHT);
        } else if (view_n <= 4) {
            rect.size.width = SCREENWIDTH / 2;
            rect.size.height = (SCREENHEIGTH - BOTTOMHEIGHT)/ 2;
            rect.origin.x = rect.size.width * (i % 2);
            rect.origin.y = rect.size.height * (i / 2);
        } else {
            rect.size.width = SCREENWIDTH / 3;
            rect.size.height = (SCREENHEIGTH - BOTTOMHEIGHT) / 3;
            rect.origin.x = (i % 3) * rect.size.width;
            rect.origin.y = rect.size.height * (i / 3);
        }
        UIView* remoteView = [RENDER_MANAGER createRender:rect];
        remoteViewes.push_back(remoteView);
        remoteViewMap[remoteView] = FREELAYOUT;

        LabelRect.origin.x = rect.origin.x + 5;
        LabelRect.origin.y = rect.origin.y + 5;
        UILabel* userLabel = [[UILabel alloc] initWithFrame:LabelRect];
        [userLabel setText:@""];
        userLabel.textColor = [UIColor redColor];
        remoteTextLables.push_back(userLabel);
    }
}

-(void) AddRemoteStreamForView:(NSString*) uid
{
    for(int i=0;i < streamIds.size();i++){
        [self unbindViewandWindow:streamIds[i]];
    }

    // put the self preview as the first one.
    if ([uid length] == 0) {
        streamIds.push_front(uid);
    } else {
        streamIds.push_back(uid);
    }
    
    [self setDynamicView:streamIds.size()];
    NSLog(@"AddRemoteStreamForView: with uid:%@   size:%lu", uid,streamIds.size());
    for(int i=0;i < streamIds.size();i++){
        [ self bindViewandWindow:streamIds[i]];
    }
}

-(void) RemoveRemoteStreamForView:(NSString*) uid
{
    for(int i=0;i < streamIds.size();i++){
        [self unbindViewandWindow:streamIds[i]];
    }
    streamIds.erase(std::remove(streamIds.begin(), streamIds.end(), uid),streamIds.end());
    NSLog(@"RemoveRemoteStreamForView: with uid:%@   size:%lu", uid,streamIds.size());
    [self setDynamicView:streamIds.size()];
    for(int i=0;i < streamIds.size();i++){
        [self bindViewandWindow:streamIds[i]];
    }
    NSLog(@"RemoveRemoteStreamForView: userLabel:%lu",remoteTextLables.size());
    
}

-(void) unbindViewandWindow:(NSString*) uid
{
    UIView* remoteView = nil;
    UILabel* textLabel = nil;
    for (int i = 0; i < view_n; i++) {
        UIView* key = remoteViewes[i];
        if (remoteViewMap[key] == [uid UTF8String]) {
            remoteView = key;
            remoteViewMap[key] = FREELAYOUT;
            [remoteTextLables[i] setText:@""];
            textLabel = remoteTextLables[i];
            break;
        }
    }
    if (remoteView == nil) return;
    [RENDER_MANAGER unbindRenderWithStream:remoteView streamId:uid];
    remoteViewes.erase(std::remove(remoteViewes.begin(),remoteViewes.end(), remoteView),remoteViewes.end());
    [remoteView removeFromSuperview];
    [textLabel removeFromSuperview];
    [RENDER_MANAGER destroyRender:remoteView];
    NSLog(@"unbindViewandWindow:");
}

-(void) bindViewandWindow:(NSString*) uid
{
    UIView* remoteView = nil;
    UILabel* textLabel = nil;
    for (int i = 0; i < view_n; i++) {
        UIView* key = remoteViewes[i];
        if (remoteViewMap[key] == FREELAYOUT) {
            remoteView = key;
            [RENDER_MANAGER bindRenderWithStream:remoteView streamId:uid disableLipSync:FALSE];
            std::string uidStr = [uid UTF8String];
            remoteViewMap[remoteView] = uidStr;
            [remoteTextLables[i] setText:uid];
            textLabel = remoteTextLables[i];
            break;
        }
    }
    if (remoteView == nil) return;
    [self.view addSubview:remoteView];
    [self.view addSubview:textLabel];
    NSLog(@"adddSubView:");
}


- (void) onRemoteVidStreamRemoved:(NSString *)uid
                   streamId: (NSString *)streamId
{

    NSLog(@"onRemoteVidStreamRemoved: with uid:%@", uid);
    
}

- (void) onGetConnectionData
{
    
}

- (IBAction)terminate:(id)sender {
    NSLog(@"onClickHangUp\n");
    [DEVICE_MANAGER stopCamera];
    [DEVICE_MANAGER stopAudioDevice];
    [CONFERENCE_SESSION leaveRoom];
    for (int i = 0; i < streamIds.size();) {
        [self RemoveRemoteStreamForView:streamIds[i]];
    }
    [self setDynamicView:0];
    remoteViewMap.clear();
    remoteTextLables.clear();
    remoteViewes.clear();
    streamIds.clear();
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark -
#pragma mark PhoneActionBar Manager

- (void)managePhoneActions:(UITapGestureRecognizer *)gesture {
    
//    if (_phoneActionBar.isShow) {
//        [_phoneActionBar hide: YES];
//    } else {
//        [_phoneActionBar show: YES];
//    }
    
}

#pragma mark -
#pragma mark PhoneActionBarDelegate

- (void) onClickSettings {
    
    // do nothing
    
}

- (void) onClickMuteAudio: (BOOL)on {
    
    if (on) {
    
        [CONFERENCE_SESSION muteMicrophone];
        
    } else {
        
        [CONFERENCE_SESSION unMuteMicrophone];
        
    }
    
}

- (void) onClickMuteVideo: (BOOL)on {
    if (on) {
        [CONFERENCE_SESSION muteVideo];
    } else {
        [CONFERENCE_SESSION unmuteVideo];
    }
}

- (void) onClickStartCamera: (BOOL)on {
   if (on) {
       [DEVICE_MANAGER startCamera];
    } else {
        [DEVICE_MANAGER stopCamera];
    }
}

- (void) onClickStartVideo: (BOOL)on {
}
- (void) onClickSpeakerOn: (BOOL)on {

    DEVICE_MANAGER.speaker = on;

}

- (void)onClickSwitchCamera: (BOOL)on {

    [DEVICE_MANAGER switchCamera];

}

- (void)onClickSwitchRotation: (BOOL)on {
    [DEVICE_MANAGER enableRotation: on];
}

@end
