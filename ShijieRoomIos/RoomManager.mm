//
//  RoomManager.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#include <vector>
#import "RoomManager.h"
#import "GCDMulticastDelegate.h"


static RoomManager *singleton = nil;

@interface RoomManager()<RoomDelegate, VideoPacketExtraObserver, DeviceEventDelegate>

@property (nonatomic, retain) GCDMulticastDelegate <RoomDelegate, DeviceEventDelegate> *multicastDelegate;

@end

@implementation RoomManager

@synthesize conferenceSession = _conferenceSession;
@synthesize rendermanager = _rendermanager;
@synthesize multicastDelegate = _multicastDelegate;
@synthesize uid = _uid;
@synthesize devicemanager = _devicemanager;

+ (RoomManager *)sharedInstance {
    
    if (singleton == nil) {
        
        @synchronized ([RoomManager class]) {
            
         
            if (singleton == nil) {
                
                singleton = [[RoomManager alloc] initSingleton];
                
            }
            
        }
        
    }
    
    return singleton;
    
}

- (id) initSingleton {
    
    self = [super init];
    
    if (self) {
        
        _multicastDelegate = (GCDMulticastDelegate <RoomDelegate> *)[[GCDMulticastDelegate alloc] init];
        
    }
    
    return self;
    
}

- (id) init {
    
    return [RoomManager sharedInstance];
    
}
                              
- (void) createRoom: (NSString *)uid withAppId:(int)appId withAppName:(NSString*)appName{
    
    @synchronized (self) {
        _devicemanager = [[DeviceManager alloc] init];
        _rendermanager = [[RenderManager alloc] init];
        _conferenceSession = [[Room alloc] initWithUid:uid withAppId:appId withAppName:appName withDeviceManager:_devicemanager delegate:nil ];
        
        _conferenceSession.delegate = self;
        _devicemanager.delegate = self;
        
    }
    
}

- (void)setUid: (NSString *)uid {
    
    _conferenceSession.uid = uid;
    
}

- (NSString *) uid {
    
    return _conferenceSession.uid;
    
}
                              
- (void) destroyRoom {
    
    @synchronized (self) {
    
        [_conferenceSession destroy];
        _conferenceSession = nil;
        [_devicemanager destroy];
        _devicemanager = nil;
        [_rendermanager destroy];
        _rendermanager = nil;
        
    }
    
}

- (void) addDelegate: (id<RoomDelegate>)delegate {
    
    [_multicastDelegate addDelegate: delegate
                      delegateQueue: dispatch_get_main_queue()];
    
}

- (void) removeDelegate: (id<RoomDelegate>)delegate {
    
    [_multicastDelegate removeDelegate: delegate];
    
}

#pragma mark -
#pragma mark RoomDelegate

- (void) onLoad: (BOOL)success {
    
    [_multicastDelegate onLoad: success];
    
}

- (void) onRemoteUserJoined: (NSString *)uid
        success: (BOOL)success {
    
    [_multicastDelegate onRemoteUserJoined: uid success: success];
    
}

- (void) onRemoteUserLeaved: (NSString *)uid {
    
    [_multicastDelegate onRemoteUserLeaved: uid];
    
}

- (void) onOffline: (NSString *)uid {
    
    [_multicastDelegate onOffline: uid];
    
}

- (void) onError: (RoomError *)err {
    
}

- (void) onSpeaking: (NSArray *)uids {
    
}

- (void) onLogevent: (CMEngineErrorType)error message:(NSString *)message {
    
    [_multicastDelegate onLogevent: error message:message];
}

- (void) onLocalUserJoined
{
    [_multicastDelegate onLocalUserJoined];
}

- (void) onLocalUserLeaved : (CMEngineErrorType) error;
{
    [_multicastDelegate onLocalUserLeaved:error];
}

- (void) onRemoteVidStreamCreated:(NSString*)nsUid
                    streamId: (NSString *)streamId
{
    [_multicastDelegate onRemoteVidStreamCreated: nsUid streamId:streamId];
}

- (void) onRemoteVidStreamRemoved:(NSString*)nsUid
                    streamId: (NSString *)streamId
{
    [_multicastDelegate onRemoteVidStreamRemoved: nsUid streamId:streamId];
}

- (void) onRemoteVidResize:(NSString*)uid width:(int)width height:(int)height
{
    [_multicastDelegate onRemoteVidResize:uid width:width height:height];
}

- (void) onCameraStopped
{
    [_multicastDelegate onStopCamera];
}

- (void) onCameraStarted
{
    [_multicastDelegate onStartCamera];
}

- (void)onAudioMixedMusicFinished {

}


- (void)onAudioMixedMusicProgress:(int)playedMs {
    
}


- (void)onCameraStartFailed {

}


- (void) onGetFirstAudioSample
{
    [_multicastDelegate onGetFirstAudioSample];
}

- (void) onGetFirstVideoSample:(NSString*)uid
{
    [_multicastDelegate onGetFirstVideoSample: uid];
}

- (BOOL)onSendVideoPacket: (const unsigned char**)yBuffer
                  strideY: (unsigned int *)strideY
                  uBuffer: (const unsigned char**)uBuffer
                  strideU: (unsigned int *)strideU
                  vBuffer: (const unsigned char**)vBuffer
                  strideV: (unsigned int *)strideV
                    width: (unsigned int *)width
                   height: (unsigned int *)height {
    NSLog(@"onSendVideoPacket\n");
    return YES;
}

@end
