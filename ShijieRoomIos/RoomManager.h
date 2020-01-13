//
//  RoomManager.h
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJSDK/Room.h"
#import "SJSDK/RenderManager.h"
#import "SJSDK/DeviceManager.h"

#define CONFERENCE_MANAGER [RoomManager sharedInstance]
#define DEVICE_MANAGER [RoomManager sharedInstance].devicemanager
#define CONFERENCE_SESSION [RoomManager sharedInstance].conferenceSession
#define RENDER_MANAGER [RoomManager sharedInstance].rendermanager

@interface RoomManager : NSObject

@property (nonatomic, readonly, retain) DeviceManager *devicemanager;

@property (nonatomic, readonly, retain) Room *conferenceSession;

@property (nonatomic, readonly, retain) NSString *uid;

@property (nonatomic, readonly, retain) RenderManager *rendermanager;


+ (RoomManager *)sharedInstance;

- (void) createRoom: (NSString *)uid withAppId:(int)appId withAppName:(NSString*)appName ;

- (void) addDelegate: (id<RoomDelegate>)delegate;

- (void) removeDelegate: (id<RoomDelegate>)delegate;

- (void) destroyRoom;

- (void) onGetFirstVideoSample : (NSString*)uid;

@end
