//
//  AppDelegate.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "util.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [window makeKeyAndVisible];
    LoginViewController *controller = [[LoginViewController alloc] init];
    [controller setWindow: window];
    self.navigationController = [[BaseNavigationViewController alloc] initWithRootViewController: controller];
    window.rootViewController = self.navigationController;
    [window addSubview:[navigationController view]];
    
    [CONFERENCE_MANAGER createRoom:generateUserId() withAppId:4003 withAppName:@"com.shijie.voipclient"];
    //NSString *userId = [NSString stringWithFormat: @"Nedved@%@", [[UIDevice currentDevice] identifierForVendor].UUIDString];
    //[CONFERENCE_MANAGER createConference: userId];
    [CONFERENCE_MANAGER addDelegate: self];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [CONFERENCE_MANAGER destroyRoom];
    
}

#pragma mark -
#pragma mark ConferenceDelegate

- (void)onLogevent: (CMEngineErrorType)error message:(NSString *)message {
    
    NSString *caption = @"Message";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:caption message:message
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone: YES];
}

- (void) onRemoteVidStreamCreated:(NSString*)nsUid
                    streamId: (NSString *)streamId
{
    NSLog(@"Remote stream created:%@", nsUid);
}

- (void) onRemoteVidStreamRemoved:(NSString*)nsUid
                    streamId: (NSString *)streamId
{
    NSLog(@"Remote stream removed:%@", nsUid);
}

- (void) onRemoteVidResize:(NSString*)nsUid withWidth:(int)width widthHeight:(int)height
{
    NSLog(@"Remote stream resized:%@ %d %d", nsUid, width, height);
}

- (void) onStartCamera:(NSString*)nsPreviewId
{
    NSLog(@"camera started:%@", nsPreviewId);
}

- (void) onStopCamera:(NSString*)nsPreviewId
{
    NSLog(@"camera stopped:%@", nsPreviewId);
}

- (void) onGetFirstVideoSample : (NSString*)uid
{
    NSLog(@"onGetFirstVideoSample");
}

- (void) onLocalVidStreamActived
{
    NSLog(@"local vid stream actived");
}

- (void) onLocalVidStreamDeactived
{
    NSLog(@"local vid stream actived");
}

- (void) onGetConnectionData
{
    NSLog(@"onGetConnectionData");
}

@end
