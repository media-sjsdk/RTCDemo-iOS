//
//  ScreenInfo.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "ScreenInfo.h"
#import "GCDMulticastDelegate.h"

@interface ScreenInfo()<ScreenChangedDelegate>

@property (nonatomic, assign) CGRect landWindowFrame;

@property (nonatomic, assign) CGRect proWindowFrame;

@property (nonatomic, retain) GCDMulticastDelegate <ScreenChangedDelegate> *multicastDelegate;

@end

@implementation ScreenInfo

@synthesize landWindowFrame = _landWindowFrame;

@synthesize proWindowFrame = _proWindowFrame;

@synthesize windowFrame = _windowFrame;

@synthesize interfaceOrientation = _interfaceOrientation;

@synthesize multicastDelegate = _multicastDelegate;

+ (ScreenInfo *) bindScreen {
    
    static ScreenInfo *singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        singleton = [[ScreenInfo alloc] initSingleton];
        
    });
    
    return singleton;
    
}

- (id) initSingleton {
    
    self = [super init];
    
    if (self) {
        
        CGRect frame = [[UIScreen mainScreen] bounds];
        if (frame.size.width > frame.size.height) {
            
            _landWindowFrame = frame;
            _proWindowFrame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
//            _interfaceOrientation = ScreenOrientationIsLandscape;
            
        } else {
            
            _proWindowFrame = frame;
            _landWindowFrame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
//            _interfaceOrientation = ScreenOrientationIsPortrait;
            
        }
        
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
    }
    
    return self;
    
}

- (id) init {
    
    return [ScreenInfo bindScreen];
    
}

- (void) dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIDeviceOrientationDidChangeNotification object:nil];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
}

- (void) addScreenDelegate: (id<ScreenChangedDelegate>)delegate {
    
    [_multicastDelegate addDelegate: delegate
                     delegateQueue: dispatch_get_main_queue()];
    
}

- (void) removeScreenDelegate: (id<ScreenChangedDelegate>)delegate {
    
    [_multicastDelegate removeDelegate: delegate];
    
}

//- (ScreenOrientation) interfaceOrientation {
//
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//
//        _interfaceOrientation = ScreenOrientationIsLandscape;
//
//    } else if (UIDeviceOrientationIsPortrait(orientation))  {
//
//        _interfaceOrientation = ScreenOrientationIsPortrait;
//
//    }
//
//    return _interfaceOrientation;
//
//}

//- (CGRect) windowFrame {
//
//    if (self.interfaceOrientation == ScreenOrientationIsLandscape) {
//
//        return _landWindowFrame;
//
//    } else {
//
//        return _proWindowFrame;
//
//    }
//
//}

- (void) onScreenChanged: (ScreenOrientation)orientation
             windowFrame: (CGRect)windowFrame {
    
//    [_multicastDelegate onScreenChanged: orientation
//                            windowFrame: windowFrame];
    
}

#pragma mark -
#pragma mark orientation mananger

- (void)deviceOrientationDidChange: (NSNotification *)notification {
    
//    [self onScreenChanged: self.interfaceOrientation
//              windowFrame: self.windowFrame];
    
}


@end
