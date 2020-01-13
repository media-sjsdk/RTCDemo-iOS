//
//  RoomProcessObserver.h
//  RoomManager
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioPacketObserver <NSObject>

@optional
- (BOOL)onSendAudioPacket: (const unsigned char*)buffer
                     size: (unsigned int)size;

- (BOOL)onReceiveAudioPacket: (const unsigned char*)buffer
                        size: (unsigned int)size;

@end

@protocol VideoPacketObserver <NSObject>

@optional
- (BOOL)onSendVideoPacket: (const unsigned char**)yBuffer
                  uBuffer: (const unsigned char**)uBuffer
                  vBuffer: (const unsigned char**)vBuffer
                    width: (unsigned int *)width
                   height: (unsigned int *)height;

- (BOOL)onReceiveVideoPacket: (const unsigned char**)yBuffer
                     uBuffer: (const unsigned char**)uBuffer
                     vBuffer: (const unsigned char**)vBuffer
                       width: (unsigned int *)width
                      height: (unsigned int *)height;

@end

@protocol VideoPacketExtraObserver <NSObject>

@optional
- (BOOL)onSendVideoPacket: (const unsigned char**)yBuffer
                  strideY: (unsigned int *)strideY
                  uBuffer: (const unsigned char**)uBuffer
                  strideU: (unsigned int *)strideU
                  vBuffer: (const unsigned char**)vBuffer
                  strideV: (unsigned int *)strideV
                    width: (unsigned int *)width
                   height: (unsigned int *)height;

- (BOOL)onReceiveVideoPacket: (const unsigned char**)yBuffer
                     strideY: (unsigned int *)strideY
                     uBuffer: (const unsigned char**)uBuffer
                     strideU: (unsigned int *)strideU
                     vBuffer: (const unsigned char**)vBuffer
                     strideV: (unsigned int *)strideV
                       width: (unsigned int *)width
                      height: (unsigned int *)height;

- (BOOL)onGetVideoScreen: (const unsigned char**)yBuffer
                 uBuffer: (const unsigned char**)uBuffer
                 vBuffer: (const unsigned char**)vBuffer
                   width: (unsigned int *)width
                  height: (unsigned int *)height;

@end
