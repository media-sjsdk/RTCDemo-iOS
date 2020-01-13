//
//  RoomStruct.h
//  RoomManager
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#ifndef RoomManager_RoomStruct_h
#define RoomManager_RoomStruct_h

   typedef NS_ENUM(NSInteger, IOSClientRole)
    {
        CLIENT_ROLE_PROXY,
        CLIENT_ROLE_COHOST,
        CLIENT_ROLE_VIEWER,
        CLIENT_ROLE_ATTENDEE
    };

    typedef struct {
        bool joinWithoutVideo;
        IOSClientRole role;
        bool startMixer;
        int videoWidth;
        int videoHeight;
        bool enableAdaptiveResolution;
        NSString* serverAddress;
    } IosRoomProfile;
   /**
     *  日志类型
     */
    typedef NS_ENUM(NSInteger, CMMessageType){
        /**
         *  未知类型
         */
        kCMMTUnknown,
        /**
         *  信息类型
         */
        kCMMTInfo,
        /**
         *  警告类型
         */
        kCMMTWarning,
        /**
         *  错误类型
         */
        kCMMTError
    };

    /**
     *  会议类型
     */
    typedef NS_ENUM(NSInteger, CMType){
        /**
         *  仅语音通话
         */
        kCMAudioType,
        /**
         *  视频通话(包含语音)
         */
        kCMVideoType,
    };
    
    // View policy
    typedef NS_ENUM(NSInteger, CMDynamicViewPolicyT)
    {
        kCMShowIfNotStaticallyViewed,
        kCMShowEvenIfStaticallyViewed
        
    };

    typedef NS_ENUM(NSInteger, IOSVideoContentTypeT)
    {
        KIOSPeople,
        KIOSScreen
    };
    
    typedef struct
    {
        char *codecName;
        int8_t payloadType;
        
        long long bitRate;
        long long packetsReceived;
        long long packetsLost;
        long long jitter;
        int32_t rtt;
        int32_t fecSuccessRate;
        
    } CMInAudioStat, *pCMInAudioStat;

    typedef struct
    {
        char *codecName;
        int8_t payloadType;
        
        long long bitRate;
        long long packetsSended;
        int32_t rtt;
        
    } CMOutAudioStat, *pCMOutAudioStat;

    typedef struct
    {
        char *codecName;
        int8_t payloadType;
        
        long long bitrate;
        long long packetsReceived;
        long long packetsLost;
        
        long long frameRate;
        long long framesDecoded;
        long long framesDisplay;
        
        int32_t width;
        int32_t height;
        
        int32_t  rtt;
        int32_t  fecSuccessRate;
        
    } CMInVideoStat, *pCMInVideoStat;

    typedef struct
    {
        const char *codecName;
        int8_t payloadType;
        long long bitrate;
        
        long long captureFrameRate;
        long long encodeFrameRate;
        long long iFramesSent;
        
        int width;
        int height;
        
        int rTT;
    } CMOutVideoStat, *pCMOutVideoStat;

    typedef struct
    {
        CMInAudioStat inAudioStat;
        CMOutAudioStat outAudioStat;
        CMInVideoStat inVideoStat;
        CMOutVideoStat outVideoStat;
        
    } CMQuality, *pCMQuality;

    typedef struct
    {
        long long availSendBwVideo;
        long long availSendBwAudio;
        long long availSendBwApplication;
        long long availSendBwMax;
        
        long long actualSendBwVideo;
        long long actualSendBwAudio;
        long long actualSendBwApplication;
        long long actualSendBwMax;
        
        long long availRecvBwVideo;
        long long availRecvBwAudio;
        long long availRecvBwApplication;
        long long availRecvBwMax;
        
        long long actualRecvBwVideo;
        long long actualRecvBwAudio;
        long long actualRecvBwApplication;
        long long actualRecvBwMax;
        
    } CMBandwidthStat, *pCMBandwidthStat;

    
    typedef struct 
    {
        int cnt;
        int startTime;
        int endTime;
        long long packByte;
        long packSend;
        long  packLost;
        double byteRate;
        int rtt;
        int connectDetectTime;
        int p2pInitTime;
        int RoomInitTime;
        int networkType;
        int isRelay;
        NSArray* frameRateList;
        NSArray* lostRateList;
        NSArray* avgRttList;
    } MonitorDataObjC;
    /**
     *  CPU信息
     */
    typedef struct
    {
        /**
         *  App独占的CPU使用率
         */
        float appCPUtilization;
        /**
         *  系统中CPU总使用率
         */
        float sysCPUtilization;
    
    } CMPerformanceStat, *pCMPerformanceStat;
#endif
