#pragma once
#import <Foundation/Foundation.h>

#ifdef IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#define EXPORT_OBJC_CLASS __attribute__((visibility("default")))

#import "RoomStruct.h"
#import "RoomDelegate.h"
#import "RoomProcessObserver.h"

@class DeviceManager;


EXPORT_OBJC_CLASS
@interface Room : NSObject

/**
 *  设置和获取当前注册的用户id。
 */
@property (nonatomic, retain) NSString *uid;

/**
 *  设置和获取当前的RoomDelegate
 */
@property (nonatomic, weak) id<RoomDelegate> delegate;

+ (NSString *)getEngineVersion;

//-------------------------------------------Room && Obj API Part--------------------------------------//

/**
 *  初始化Room对象。
 *
 *  @param uid      用户唯一ID
 *  @param delegate 会议事件监听对象
 *
 *  @return Room对象
 */
- (id) initWithUid: (NSString *)uid withAppId:(int)appId withAppName:(NSString*)appName
        withDeviceManager: (DeviceManager*) deviceManager
          delegate: (id<RoomDelegate>)delegate;

/**
 *  初始化Room对象。
 *
 *  @return Room对象
 */
- (id) init;

/**
 *  销毁当前Room对象。
 *
 *  销毁后这个Room对象将无法再被使用
 */
- (void) destroy;

/**
 *  加入会议。
 *
 *  @param roomId 将要加入的会议唯一ID
 */
-(BOOL) joinRoom: (NSString *)roomId
   withLocalName: (NSString *) localName
   withprofile:(IosRoomProfile)iosprofile
       withAppToken:(NSString*)appToken;


/**
 *  离开会议。
 */
- (void) leaveRoom;

/**
 *  切换观众角色
 *
 */
- (void) switchClientRole:(IOSClientRole)role;

//-------------------------------------------Audio API Part--------------------------------------//

/**
 *  设置本端通话中语音静音
 */
- (void) muteMicrophone;

/**
 *  设置本端通话中语音正常(非静音)
 */
- (void) unMuteMicrophone;


- (void) setResolution:(int) Width
                liveHeight:(int) Height
                frameRate:(int) frameRate;

/**
 * 关闭视频发送
 */
- (void) muteVideo;

/**
 * 打开视频发送
 */
- (void) unmuteVideo;


/**
 * 设置编码最大码率
 *
 * @param bitrate
 *            编码码率
 */
- (void) setEncoderMaxBitRate: (int)bitrate;


// add external video stream;
// return stream id.
- (long) addVideoStream:(int)width height:(int)height type:(IOSVideoContentTypeT)type;

- (void) removeVideoStream:(long)streamId;

//pixelType:
// 0:I420 1:BGRA 2:BGR1(ABGR without A plane) 3:ABGR 4:BGR(RGBA without A plane)  5:ARGB 6:RGBA 7:ARGB (without alpha)
- (void) pushVideoFrame:(int)width height:(int)height data:(NSString*)data stride:(int)stride
            pixelType:(int)pixelType frameType:(int)frameType streamId:(long)streamId
            timestamp:(long)timestamp;


//-------------------------------------------Other API Part--------------------------------------//

- (void) setUserPlayoutVolume: (NSString *)userId
                       volume:(double)volume;

- (void) muteUserAudio: (NSString *)userId
                  mute:(BOOL)mute;

- (int) getUserPlayoutVolume: (NSString *)userId;

- (BOOL) startSpeakingMonitor;

- (BOOL) stopSpeakingMonitor;

- (BOOL) startVolumeMonitor: (int)monitorInterval;

- (BOOL) stopVolumeMonitor;

-(BOOL) isInRoom;


@end


