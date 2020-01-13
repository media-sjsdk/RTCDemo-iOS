//
//  PhoneActionBar.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "PhoneActionBar.h"
#import "ScreenInfo.h"

#define kPhoneActionBarFrame(barHeight) CGRectMake(0, SCREEN_INFO_HEIGHT - barHeight, SCREEN_INFO_WIDTH, barHeight)

#define kPhoneActionBarShowDurationTimeInterval 0.5

#define kPhoneActionBarHideDurationTimeInterval 0.5

#define kPhoneActionBarShowTimeDuration 10.0f

@interface PhoneActionBar()

@property (nonatomic, retain) id<PhoneActionBarDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *timeCounterLabel;

@property (nonatomic, weak) IBOutlet UISwitch *videoMuteSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *camreStartSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *videoStartSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *audioMuteSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *speakerSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *cameraSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *testCrashSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *qosSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *rotationSwitch;

@property (nonatomic, readonly, retain) NSTimer *hiddenCounter;

@property (nonatomic, assign) float x;

@property (nonatomic, assign) float y;

@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float barHeight;

@property (nonatomic, assign) CGRect historyRect;

+ (PhoneActionBar *) createView: (id)owner;

- (void) startHiddenCounter;

- (void) stopHiddenCounter;

@end

@implementation PhoneActionBar

@synthesize delegate = _delegate;
@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;
@synthesize historyRect = _historyRect;
@synthesize isShow = _isShow;
@synthesize hiddenCounter = _hiddenCounter;
@synthesize timeCounterLabel = _timeCounterLabel;
@synthesize barHeight = _barHeight;
@synthesize videoMuteSwitch = _videoMuteSwitch;
@synthesize camreStartSwitch = _camreStartSwitch;
@synthesize videoStartSwitch = _videoStartSwitch;
@synthesize audioMuteSwitch = _audioMuteSwitch;
@synthesize speakerSwitch = _speakerSwitch;
@synthesize cameraSwitch = _cameraSwitch;
@synthesize testCrashSwitch = _testCrashSwitch;
@synthesize qosSwitch = _qosSwitch;
@synthesize rotationSwitch = _rotationSwitch;


+ (id) phoneActionBarWithDelegate: (id<PhoneActionBarDelegate>)delegate {
    
    return [[PhoneActionBar alloc] initWithDelegate: delegate];
    
}

- (id) initWithDelegate: (id<PhoneActionBarDelegate>)delegate {
    
    PhoneActionBar *oldSelf = self;
    self = [PhoneActionBar createView: oldSelf];
    if (self) {
        _delegate = delegate;
        _barHeight = self.frame.size.height;
        self.frame = kPhoneActionBarFrame(_barHeight);
        _historyRect = self.frame;
        self.hidden = NO;
        _isShow = YES;
        // copy
        _timeCounterLabel = oldSelf.timeCounterLabel;
        _videoMuteSwitch = oldSelf.videoMuteSwitch;
        _camreStartSwitch = oldSelf.camreStartSwitch;
        _videoStartSwitch = oldSelf.videoStartSwitch;
        _audioMuteSwitch = oldSelf.audioMuteSwitch;
        _speakerSwitch = oldSelf.speakerSwitch;
        _cameraSwitch = oldSelf.cameraSwitch;
        _testCrashSwitch = oldSelf.testCrashSwitch;
        _qosSwitch = oldSelf.qosSwitch;
        
        
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        
    }
    return self;
}

- (void) dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIDeviceOrientationDidChangeNotification object:nil];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
//    
}

- (void) show: (BOOL)animation {
    
    if (animation) {

        self.y = SCREEN_INFO_HEIGHT;
    
        // Animation
        [UIView animateWithDuration: kPhoneActionBarShowDurationTimeInterval animations:^{
            
            self.y = SCREEN_INFO_HEIGHT - self.height;
            self.hidden = NO;
            
        } completion:^(BOOL finished) {
            
            self.frame = _historyRect;
            _isShow = YES;
            [self startHiddenCounter];
            
        }];
        
    } else {
        
        self.frame = _historyRect;
        _isShow = YES;
        self.hidden = NO;
        [self startHiddenCounter];
        
    }
    
}

- (void) hide: (BOOL)animation {
    
    if (animation) {
    
        // Animation
        [UIView animateWithDuration: kPhoneActionBarHideDurationTimeInterval animations:^{
            
            self.y = SCREEN_INFO_HEIGHT;
            
        } completion:^(BOOL finished) {
            
            self.frame = _historyRect;
            self.hidden = YES;
            _isShow = NO;
            
        }];
        
    } else {
        
        self.frame = _historyRect;
        self.hidden = YES;
        _isShow = NO;
        
    }
    
}

- (void) updateTime: (NSTimeInterval)timer {
    
    int hour = (int)(timer / 3600);
    int munite = (int)(timer - hour * 3600) / 60;
    int second = timer - hour * 3600 - munite * 60;
    NSString *dateTime = nil;
    if (hour > 0) {
        dateTime = [NSString stringWithFormat:@"%02u:%02u:%02u", hour, munite, second];
    } else {
        dateTime = [NSString stringWithFormat:@"%02u:%02u", munite, second];
    }
    
    self.timeCounterLabel.text = dateTime;
    
}

- (void) setX: (float)x {
    
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
}

- (float) x {
    
    return self.frame.origin.x;
    
}

- (void) setY: (float)y {
    
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
    
}

- (float) y {
    
    return self.frame.origin.y;
    
}

- (void) setWidth: (float)width {
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    
}

- (float) width {
    
    return self.frame.size.width;
    
}

- (void) setHeight: (float)height {
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
}

- (float) height {
    
    return self.frame.size.height;
    
}

- (IBAction) clickHangUp: (id)sender {
    
    [self stopHiddenCounter];
    [_delegate onClickHangUp];
    
}

- (IBAction) clickSettings: (id)sender {
    
    [_delegate onClickSettings];
    
}


- (IBAction) clickMuteAudio: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickMuteAudio: switcher.isOn];
    
}


- (IBAction) clickMuteVideo: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickMuteVideo: switcher.isOn];
    
}

- (IBAction) clickStartVideo: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickStartVideo: switcher.isOn];
    
}


- (IBAction) clickSpeakerOn: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickSpeakerOn: switcher.isOn];
    
}

- (IBAction) clickStartCamera: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickStartCamera: switcher.isOn];
    
}

- (IBAction)onClickSwitchRotation: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickSwitchRotation: switcher.isOn];
}

- (IBAction) clickSwitchCamera: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onClickSwitchCamera: switcher.isOn];
    
}

- (IBAction) clickTestCrash: (id)sender {
    
    UISwitch *switcher = (UISwitch *)sender;
    
    [_delegate onTestCrash: switcher.isOn];
    
}

- (IBAction)clickSwitchQos:(id)sender {
    UISwitch *switcher = (UISwitch*)sender;
    
    [_delegate onClickSwitchQos: switcher.isOn];
}

- (void) reset {
    
    self.videoMuteSwitch.on = NO;
    self.camreStartSwitch.on = NO;
    self.videoStartSwitch.on = NO;
    self.audioMuteSwitch.on = NO;
    self.speakerSwitch.on = YES;
    self.cameraSwitch.on = YES;
    self.testCrashSwitch.on = NO;
    self.qosSwitch.on = NO;
    
}

+ (PhoneActionBar *) createView: (id)owner {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed: @"PhoneActionBar" owner: owner options: nil];
    return [nibView objectAtIndex: 0];
    
}

- (void) startHiddenCounter {
    
    if (_hiddenCounter == nil) {
    
        _hiddenCounter = [NSTimer timerWithTimeInterval: kPhoneActionBarShowTimeDuration
                                                 target: self
                                               selector: @selector(hiddenCounterSel)
                                               userInfo: nil
                                                repeats: NO];
        NSRunLoop *runloop=[NSRunLoop mainRunLoop];
        [runloop addTimer: _hiddenCounter
                  forMode: NSDefaultRunLoopMode];
        
    }
    
}

- (void) stopHiddenCounter {
    
    if (_hiddenCounter != nil) {
        
        [_hiddenCounter invalidate];
        _hiddenCounter = nil;
        
    }
    
}

- (void) hiddenCounterSel {
    
    if (_isShow) {
    
        [self hide: YES];
    
    }
    
    [_hiddenCounter invalidate];
    _hiddenCounter = nil;
    
}

#pragma mark -
#pragma mark orientation mananger

- (void)deviceOrientationDidChange: (NSNotification *)notification {
    
    self.frame = kPhoneActionBarFrame(_barHeight);
    _historyRect = self.frame;
    // restart
    [self stopHiddenCounter];
    [self startHiddenCounter];
    
}

@end
