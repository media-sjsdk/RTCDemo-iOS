//
//  RoomError.h
//  RoomManager
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  引擎错误类型， 这里面增加类型必须同步在appclientgui.h中EngineError中增加。
 */
typedef NS_ENUM(NSInteger, CMEngineErrorType)
{
    CMENGINE_NO_ERROR,
    CMENGINE_CONNECTION_LOST,
    CMENGINE_UNKNOWN_ERROR
};


/**
 *  用于封装并描述会议中系统发生错误的类
 */
@interface RoomError : NSObject

/**
 *  错误编码
 */
@property (nonatomic, readonly, assign) CMEngineErrorType code;

/**
 *  错误描述
 */
@property (nonatomic, readonly, retain) NSString *desc;

/**
 *  初始化方法
 *
 *  @param code 错误编码
 *  @param desc 错误描述
 *
 *  @return RoomError对象
 */
+ (id) errorWithCode: (CMEngineErrorType)errorCode
                errorDesc: (NSString *)errorDesc;

/**
 *  初始化方法
 *
 *  @param code 错误编码
 *  @param desc 错误描述
 *
 *  @return RoomError对象
 */
- (id) initWithCode: (CMEngineErrorType)errorCode
               errorDesc: (NSString *)errorDesc;

@end
