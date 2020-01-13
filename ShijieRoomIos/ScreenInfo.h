//
//  ScreenInfo.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_INFO_WIDTH [ScreenInfo bindScreen].windowFrame.size.width
#define SCREEN_INFO_HEIGHT [ScreenInfo bindScreen].windowFrame.size.height

typedef NS_ENUM(NSInteger, ScreenOrientation) {
    
    ScreenOrientationIsPortrait,
    ScreenOrientationIsLandscape
    
};

@protocol ScreenChangedDelegate <NSObject>

- (void) onScreenChanged: (ScreenOrientation)orientation
             windowFrame: (CGRect)windowFrame;

@end

@interface ScreenInfo : NSObject

+ (ScreenInfo *) bindScreen;

@property (nonatomic, readonly, assign) CGRect windowFrame;

@property (nonatomic, readonly, assign) ScreenOrientation interfaceOrientation;

- (void) addScreenDelegate: (id<ScreenChangedDelegate>)delegate;

- (void) removeScreenDelegate: (id<ScreenChangedDelegate>)delegate;


@end
