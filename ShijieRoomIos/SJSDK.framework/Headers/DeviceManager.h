#pragma once

#import <Foundation/Foundation.h>
#ifdef IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#define EXPORT_OBJC_CLASS __attribute__((visibility("default")))

EXPORT_OBJC_CLASS
@protocol DeviceEventDelegate <NSObject>
@required
- (void) onAudioMixedMusicFinished;
- (void) onAudioMixedMusicProgress: (int)playedMs;
- (void) onCameraStarted;
- (void) onCameraStopped;
- (void) onCameraStartFailed;
@end



/**
 *  基础类，管理音视频硬件及render。
 */
EXPORT_OBJC_CLASS
@interface DeviceManager : NSObject

@property (nonatomic, assign) BOOL  enableVideoPreprocess; /*Default is off*/
@property (nonatomic, assign) int   smoothLevel; /*Default is 1, the range is 1-5*/
@property (nonatomic, assign) id<DeviceEventDelegate> delegate;
//-------------------------------------------Device && Obj API Part--------------------------------------//


- (instancetype) init;

/**
 *  销毁当前DeviceManager对象。
 *
 *  销毁后这个DeviceManager对象将无法再被使用
 */
- (void) destroy;


/**
 *  get deviceManager
 *
 */
- (void *) getDeviceManager;


/**
 * 启用 Audio 设备（Mic、Speaker）
 * Warning：不建议使用此接口！
 */
- (void) startAudioDevice:(BOOL)useAEC;

/**
 * 禁用 Audio 设备（Mic、Speaker）
 * Waring：不建议使用此接口！
 */
- (void) stopAudioDevice;


/**
 *  设置本端停止语音播放
 */
- (void) muteSpeaker;

/**
 *  设置本端开启语音播放
 */
- (void) unMuteSpeaker;


/**
 *  设置本端停止 Mic 语音输入
 */
- (void) muteMicrophone;

/**
 *  设置本端开启 Mic 语音输入
 */
- (void) unMuteMicrophone;

/**
 *  设置本端在通话中是否使用扬声器。
 *
 *  @param enable YES为使用扬声器，NO为不使用扬声器
 */
- (void) setSpeaker: (BOOL)enable;

/**
 *  set voice change mode
 *
 *  @param voiceChangeMode:
 *  0: man
 *  1: woman
 *  2: child
 *  3: robot
 */
- (void) setVoiceChangeMode: (int)voiceChangeMode;

//-------------------------------------------Video API Part--------------------------------------//

/**
 * set the rotate angle degree
 *
 * @param angleDegree
 *            the angle degree to be rotated
 */
- (void) setRotate: (int)deviceAngleDegree withUIAngleDegree:(int)uiAngle;


/**
 * 设置摄像头采集参数
 */
- (void) setCameraParam:(int)width
                 height:(int)height
              frameRate:(int)frameRate;

/**
 * 设置视频输出参数
 */
- (void) setVideoOutputParam:(int)width
                      height:(int)height
                   frameRate:(int)frameRate;

/**
 * 设置耳机插拔事件处理
 */
- (void) setHeadsetPlugAutoHandler:(bool) enable;

/**
 * 开启本地视频
 */
- (void) startCamera;

/**
 * 关闭本地视频
 */
- (void) stopCamera;

- (BOOL) isUsingFrontCamera;

- (void) enableRotation: (BOOL) enable;

/**
 * 待定 设置切换摄像头
 *
 */
- (void) switchCamera;


/**
 * 设置采样信号类型
 *
 * @param audioType
            信号类型，0表示普通语音信号，1表示高保真音乐信号。当audioType=0时，引擎可以进行AGC，NS的音频处理算法。
 */
- (void) setAudioType:(int)audioType;

- (bool) startMixMusic:(NSString*) path
                isLoop:(BOOL) loop;

- (void) stopMixMusic;

- (void) pauseMixMusic;

- (void) resumeMixMusic;

- (int)  getBackgroundVolume;

- (void) setBackgroundVolume:(int) volume;

- (int)  getBackgroundMaxVolume;

- (int)  getBackgroundMinVolume;

- (int) getForegroundVolume;
//Same as getForegroundVolume, sugar API
- (int) getMicVolume;

- (void) setForegroundVolume:(int) volume;
//Same as setForegroundVolume, sugar API
- (void) setMicVolume:(int) volume;

- (int) getForegroundMaxVolume;
//Same as getForegroundMaxVolume, sugar API
- (int) getMicMaxVolume;

- (int) getForegroundMinVolume;
//Same as getForegroundMinVolume, sugar API
- (int) getMicMinVolume;

- (int) getLoopbackBackgroundVolume;

- (void) setLoopbackBackgroundVolume:(int) volume;

- (int) getLoopbackBackgroundMaxVolume;

- (int) getLoopbackBackgroundMinVolume;

- (int) getPlayoutVolume;

- (void) setPlayoutVolume:(int) volume;

- (int) getPlayoutMaxVolume;

- (int) getPlayoutMinVolume;

- (void) enableHeadset:(BOOL) enableHeadset;

- (void) enableMicMixMusic:(BOOL) enableMixing;

- (void) setVideoPreprocessParameters: (float) smoothLevel
                        withWhiteLevel: (float) whiteLevel;

- (void) enableVideoPreprocess: (BOOL) enable;

- (void) startReverberation: (int) level;

- (void) stopReverberation;

- (void) loopbackAudio: (BOOL) enable;

- (void) enableBuiltInAEC:(BOOL) enable;

- (BOOL) setFocusPointWithX:(float)x  withY:(float)y;

- (BOOL) setVideoZoomFactor: (float)zoomFactor;

- (BOOL) isVideoZoomSupported;

- (float) getSupportedVideoZoomMaxFactor;

- (float) getCurrentVideoZoomFactor;

- (void) setBlurLevel:(int)blurLevel;

- (void) setSmoothLevel:(int)smoothLevel;

- (void) setWhiteLevel:(int)whiteLevel;

- (void) setEyeZoomRatio: (int) eyeZoomRatio;

- (void) setFaceThinRatio: (int) faceThinRatio;

- (bool) playEffective:(NSString*) path
                isLoop:(BOOL) loop;

//filterType
//0 --> normal video filter
//1 --> face detect video filter
- (bool) addVideoFilter:(void*) videoFilter
             filterType:(int)filterType;

- (void) removeVideoFilter:(void*) videoFilter
                filterType:(int) filterType;

// defined video filters as follows:
// "com.videofilter.gray"       --> GRAY
// "com.videofilter.clarendon"  --> CLARENDON
// "com.videofilter.sweet"      --> SWEET
// "com.videofilter.juno"       --> JUNO
// "com.videofilter.nashville"  --> NASHVILLE
// "com.videofilter.dogpatch"   --> DOGPATCH
// "com.videofilter.crema"      --> CREMA
// "com.videofilter.aden"       --> ADEN
// "com.videofilter.stinson"    --> STINSON
// "com.videofilter.gingham"    --> GINGHAM
// "com.videofilter.basic"      --> None video filter
- (void) setVideoFilter: (NSString*) videoFilter;

- (void) setVideoFilterIntensity: (float) videoFilterIntensity;

- (bool) setStickerPath:(NSString*)path;

- (int)  getSmoothLevel;

- (int)  getWhiteLevel;

- (int)  getEyeZoomRatio;

- (int)  getFaceThinRatio;

- (BOOL) isSupportResolution:(int)width
                withHeight:(int)height
                withFrameRate:(int) framerate;

- (long) startPlayBackgroundMusic:(NSString*) path
                isLoop:(BOOL) loop;

- (void) stopPlayBackgroundMusic:(long) streamId;
//-------------------------------------------Debug API Part(Please Not Use)--------------------------------------//

#ifdef NOT_RELEASE

@property (nonatomic, assign) int cameraIndex;
@property (nonatomic, readonly, retain) NSMutableArray *cameraModes;

#endif

@end


