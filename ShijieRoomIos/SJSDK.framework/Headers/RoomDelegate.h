//
//  RoomDelegate.h
//  RoomManager
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomStruct.h"
#import "RoomError.h"

/**
 *  Room事件监听Delegate
 *
 *  @sa Room
 */
@protocol RoomDelegate <NSObject>

@optional

/**
 *  Room对象加载成功
 *
 *  @param success 加载是否成功，YES表示加载成功，NO表示加载失败
 */
- (void) onLoad: (BOOL)success;

/**
 *  有用户加入会议
 *
 *  当ID等于本端用户ID时，同时表示Room的joinRoom函数调用成功
 *  @sa Room
 *
 *  @param uid     加入会议的用户ID
 *  @param success 是否加入成功，YES表示加入成功，NO表示加入失败
 */
- (void) onRemoteUserJoined: (NSString *)uid
        success: (BOOL)success;

/**
 *  有用户离开会议
 *
 *  当ID等于本端用户ID时，同时表示Room的leaveRoom函数调用成功
 *  @sa Room
 *
 *  @param uid 离开会议的用户ID
 */
- (void) onRemoteUserLeaved: (NSString *)uid;

/**
 *  有用户离线
 *
 *  当ID等于本端用户ID时，表示用户自己掉线
 *  @sa Room
 *
 *  @param uid 离线的用户ID
 */
- (void) onOffline: (NSString *)uid;

/**
 *  当前会议发生错误
 *
 *  @param err 错误信息 @sa RoomError
 */
- (void) onError: (RoomError *)err;

/**
 *  当前正在说话的用户
 *
 *  @param uids 当前增在说话的用户IDs
 */
- (void) onSpeaking: (NSArray *)uids;

/**
 *  日志信息
 *
 *  @param message 日志内容
 */
- (void) onLogevent: (CMEngineErrorType) error
            message: (NSString *)message;

- (void) onLocalUserJoined;

- (void) onLocalUserLeaved: (CMEngineErrorType) error;

//////////////////////////Video related callbacks END//////////////////////////
// Notify that frame size has been changed
- (void) onRemoteVidResize: (NSString *)uid
                     width: (int)width
                    height: (int)height;

// Notify that remote video stream is coming
- (void) onRemoteVidStreamCreated: (NSString *)uid
                         streamId: (NSString *)streamId;

// Notify that remote video stream has stopped
- (void) onRemoteVidStreamRemoved: (NSString *)uid
                         streamId: (NSString *)streamId;

// Notify that remote audio stream is coming
- (void) onRemoteAudioStreamCreated: (NSString *)uid;

// Notify that remote audio stream has stopped
- (void) onRemoteAudioStreamRemoved: (NSString *)uid;

- (void) onStartCamera;

- (void) onStopCamera;

- (void) onGetFirstAudioSample;

- (void) onGetFirstVideoSample:(NSString*)uid;

-(void) onSpeakingStatusChanged: (NSString*) uid
                        isSpeaking: (BOOL)isSpeaking;

-(void) onUsersVolumeChanged: (NSArray *) participantsName
                        volumes: (NSArray *) participantsVolume;

// Notify that video stream has added
- (void) onRemoteSourceAdded: (NSString *)uid
                    streamId: (unsigned long) streamId;

// Notify that video stream has removed
- (void) onRemoteSourceRemoved: (NSString *)uid
                      streamId: (unsigned long) streamId;
//////////////////////////video related callbacks END//////////////////////////

@end
