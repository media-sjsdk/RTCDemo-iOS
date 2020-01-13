//
//  PhoneActionBar.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneActionBarDelegate <NSObject>

@required

- (void) onClickHangUp;

- (void) onClickSettings;

- (void) onClickMuteAudio: (BOOL)on;

- (void) onClickMuteVideo: (BOOL)on;

- (void) onClickStartCamera: (BOOL)on;

- (void) onClickStartVideo: (BOOL)on;

- (void) onClickSpeakerOn: (BOOL)on;

- (void) onClickSwitchCamera: (BOOL)on;

- (void) onClickSwitchQos: (BOOL)on;

- (void) onTestCrash: (BOOL)on;

- (void)onClickSwitchRotation: (BOOL)on;

@end

@interface PhoneActionBar : UIView

@property (nonatomic, assign) BOOL isShow;

@property (readonly) UISwitch *rotationSwitch;

+ (id) phoneActionBarWithDelegate: (id<PhoneActionBarDelegate>)delegate;

- (id) initWithDelegate: (id<PhoneActionBarDelegate>)delegate;

- (void) updateTime: (NSTimeInterval)timer;

- (void) show: (BOOL)animation;

- (void) hide: (BOOL)animation;

- (void) reset;



@end