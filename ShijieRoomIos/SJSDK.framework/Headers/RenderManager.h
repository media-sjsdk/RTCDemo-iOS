#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define EXPORT_OBJC_CLASS __attribute__((visibility("default")))

typedef NS_ENUM(NSInteger, ObjCRenderModeType) {
    OBJC_RENDER_AUTO,
    OBJC_RENDER_FIT,
    OBJC_RENDER_CUT
};

/**
 *  基础类，管理音视频硬件及render。
 */
EXPORT_OBJC_CLASS
@interface RenderManager : NSObject


//-------------------------------------------Device && Obj API Part--------------------------------------//


- (instancetype) init;

/**
 *  销毁当前DeviceManager对象。
 *
 *  销毁后这个DeviceManager对象将无法再被使用
 */
- (void) destroy;


//-------------------------------------------Video API Part--------------------------------------//

// Render related.

/**
 * create a render
 *
 * @param displaySize
 *            the size of the layout
 */
- (UIView*) createRender: (CGRect)displaySize;

/**
 * get a render by the user ID
 *
 * @param streamId
 *            the user ID to mark the render
 */
- (UIView*) getRender: (NSString*) streamId;

/**
 * destory a render
 *
 * @param render
 *            the render that will be destoried
 */
- (void) destroyRender: (UIView*) render;

- (void) setRenderMode: (UIView*) render withRenderMode:(ObjCRenderModeType)mode;

/**
 * bind the render with the user ID together, it should be called right
 * after the render is created
 *
 * @param render
 *            the render to be binded
 * @param streamId
 *            the user id assigned to the render
 */
- (BOOL) bindRenderWithStream: (UIView*) render
                          streamId: (NSString*)streamId
               disableLipSync: (BOOL) disableLipSync;

/**
 * unbind the render with the user ID, it should be called before the render
 * is destoried
 *
 * @param render
 *            the render to be unbinded
 */
- (BOOL) unbindRenderWithStream: (UIView*) render
                            streamId: (NSString*)streamId;

- (BOOL)setShiftUp:(UIView*) render videoRatio:(float) videoRatio videoRatioDelta:(float)videoRatioDelta viewRatio:(float)viewRatio viewRatioDelta:(float)viewRatioDelta shiftUpValue:(float)shiftUpValue;


@end


