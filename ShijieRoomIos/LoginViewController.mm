//
//  LoginViewController.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CameraSettingsViewController.h"
#import "MoreServerSettingsViewController.h"
#import "VideoViewController.h"
#import "TuningWindowViewController.h"
#import "XDSDropDownMenu.h"


//using namespace shijie;

@interface LoginViewController ()<RoomDelegate>

@property (nonatomic, retain) VideoViewController *videoViewController;
@property (atomic, assign) BOOL isJoining;
@end

static int keyboardHeight=216;
static NSString* KEY_USER_NAME = @"key_user_name";
static NSString* KEY_CONFERENCE = @"key_conference";
static NSString* KEY_RESOLUTION = @"key_resolution";
static NSString* KEY_SERVER = @"key_server";
static NSString* KEY_ROLE = @"key_role";

@implementation LoginViewController

@synthesize conference;
@synthesize window;
@synthesize speakerSwitch;
@synthesize videoViewController;
@synthesize dropDownMenuArray;
@synthesize buttonArray;
@synthesize remoteName;
@synthesize localName;
@synthesize joinWithoutVideoButton;
@synthesize resolutionDropDownMenu;
@synthesize roleDropDownMenu;
@synthesize role;
@synthesize resolution;
@synthesize serverAddress;

- (id)init
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self = [super initWithNibName: @"LoginWindowIpad" bundle: [NSBundle mainBundle]];
    } else {
        self = [super initWithNibName: @"LoginWindow" bundle: [NSBundle mainBundle]];
    }
    
    if (self) {
        self.title = @"Shijie SDK";
        [CONFERENCE_MANAGER addDelegate: self];
    }
    
    if (self.videoViewController == nil) {
        self.videoViewController = [[VideoViewController alloc] init];
    }
    resolutionarr = @[@"320x180",@"320x180[自适应]",@"640x360",@"640x360[自适应]",@"960x540",@"960x540[自适应]",@"1280x720",@"1280x720[自适应]"];
    resolutionInfolist.clear();
    resolutionInfolist.push_back(resolutionInfo(180,320,NO));
    resolutionInfolist.push_back(resolutionInfo(180,320,YES));
    resolutionInfolist.push_back(resolutionInfo(360,640,NO));
    resolutionInfolist.push_back(resolutionInfo(360,640,YES));
    resolutionInfolist.push_back(resolutionInfo(540,960,NO));
    resolutionInfolist.push_back(resolutionInfo(540,960,YES));
    resolutionInfolist.push_back(resolutionInfo(720,1280,NO));
    resolutionInfolist.push_back(resolutionInfo(720,1280,YES));

    //role
    rolearry =@[@"直播-主播",@"直播-观众",@"会议-与会者"];
    // 设置不显示NavigationBar
    self.navigationController.navigationBarHidden = YES;
    return self;
}
- (IBAction)selcetVideoSize:(id)sender {
    resolutionDropDownMenu.delegate = self;//设置代理
    //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
    [self setupDropDownMenu:resolutionDropDownMenu withTitleArray:resolutionarr andButton:sender andDirection:@"down"];
    //隐藏其它的下拉菜单
    [self hideOtherDropDownMenu:resolutionDropDownMenu];
}
- (IBAction)selectedCallRole:(id)sender {
    roleDropDownMenu.delegate = self;//设置代理
    //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
    [self setupDropDownMenu:roleDropDownMenu withTitleArray:rolearry andButton:sender andDirection:@"down"];
    //隐藏其它的下拉菜单
    [self hideOtherDropDownMenu:roleDropDownMenu];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [localName setText:[prefs stringForKey:KEY_USER_NAME]];
    [joinWithoutVideoButton setOn:[prefs boolForKey:@"KEY_IS_AUDIO_ONLY"]];
    [conference setText:[prefs stringForKey:KEY_CONFERENCE]];
    [serverAddress setText:[prefs stringForKey:KEY_SERVER]];
    _isJoining = false;

}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewDidAppear: animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserPrefs];
    [self setArrays]; //配置buttonArray和dropDownMenuArray
    [self setButtons];//设置按钮边框和圆角
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)setButtons{
    for(UIButton *btn in self.buttonArray){
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
    }
}

- (void)setArrays{
    //将所有按钮加入buttonArray数组
    //初始化所有DropDownMenu下拉菜单
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    resolutionDropDownMenu = [[XDSDropDownMenu alloc] init];
    [resolutionDropDownMenu setSelectedIndex:[prefs integerForKey:KEY_RESOLUTION]];
    [resolution setTitle:resolutionarr[[prefs integerForKey:KEY_RESOLUTION]] forState:UIControlStateNormal];
    
    roleDropDownMenu = [[XDSDropDownMenu alloc] init];
    [roleDropDownMenu setSelectedIndex:[prefs integerForKey:KEY_ROLE]];
    [role setTitle:rolearry[[prefs integerForKey:KEY_ROLE]] forState:UIControlStateNormal];
    
    //将所有DropDownMenu加入dropDownMenuArray数组
    self.dropDownMenuArray = @[resolutionDropDownMenu];
    self.dropDownMenuArray = @[roleDropDownMenu];

    //将所有dropDownMenu的初始tag值设为1000
    for (__strong XDSDropDownMenu *nextDropDownMenu in self.dropDownMenuArray) {
        nextDropDownMenu.tag = 1000;
    }
}

- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andButton:(UIButton *)button andDirection:(NSString *)direction{

    CGRect btnFrame = button.frame; //如果按钮在UIIiew上用这个
    //  CGRect btnFrame = [self getBtnFrame:button];//如果按钮在UITabelView上用这个
    if(dropDownMenu.tag == 1000){
        /*
         如果dropDownMenu的tag值为1000，表示dropDownMenu没有打开，则打开dropDownMenu
         */
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:button withButtonFrame:btnFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];

        //添加到主视图上
        [self.view addSubview:dropDownMenu];
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
    }else {
        /*
         如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
         */
        [dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
        dropDownMenu.tag = 1000;
    }
}

#pragma mark - 隐藏其它DropDownMenu
/*
 在点击按钮的时候，隐藏其它打开的下拉菜单（dropDownMenu）
 */
- (void)hideOtherDropDownMenu:(XDSDropDownMenu *)dropDownMenu{
    for ( int i = 0; i < self.dropDownMenuArray.count; i++ ) {
        if( self.dropDownMenuArray[i] !=  dropDownMenu){
            XDSDropDownMenu *dropDownMenuNext = self.dropDownMenuArray[i];
            CGRect btnFrame = ((UIButton *)self.buttonArray[i]).frame;//如果按钮在UIIiew上用这个
            //          CGRect btnFrame = [self getBtnFrame:self.buttonArray[i]];//如果按钮在UITabelView上用这个
            [dropDownMenuNext hideDropDownMenuWithBtnFrame:btnFrame];
            dropDownMenuNext.tag = 1000;
        }
    }
}

- (void) setDropDownDelegate:(XDSDropDownMenu *)sender{
    sender.tag = 1000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) shouldAutorotate {
    return NO;
}

- (void) loadUserPrefs {
    long local_name_number = arc4random() % 10000000;
    NSNumber *longNumber = [NSNumber numberWithLong:local_name_number];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict_name = @{KEY_USER_NAME:[longNumber stringValue]};
    [prefs registerDefaults:dict_name];
    NSDictionary *dict_conference = @{KEY_CONFERENCE:@"8787"};
    [prefs registerDefaults:dict_conference];

    NSDictionary *dict_server = @{KEY_SERVER:@"mcu.sjsdk.com"};
    [prefs registerDefaults:dict_server];

    NSDictionary *dict_resolution = @{KEY_RESOLUTION:@2};
    [prefs registerDefaults:dict_resolution];
    NSDictionary *dict_role = @{KEY_ROLE:@2};
    [prefs registerDefaults:dict_role];

}

- (void) saveUserPrefs {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[localName text] forKey:KEY_USER_NAME];
    [prefs setObject:[conference text] forKey:KEY_CONFERENCE];
    [prefs setObject:[serverAddress text] forKey:KEY_SERVER];
    [prefs setInteger:[roleDropDownMenu returnSelectedIndex] forKey:KEY_ROLE];
    [prefs setInteger:[resolutionDropDownMenu returnSelectedIndex] forKey:KEY_RESOLUTION];
    [prefs synchronize];
    
}

- (void) showAlert:(NSString*) info {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:info
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)connecting:(id)sender
{
    if (_isJoining) {
        // not work for now
        //showAlert:@"正在加入...";
        return;
    }
    _isJoining = true;
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *d = (AppDelegate *) [app delegate];
    [window sendSubviewToBack:d.navigationController.view];
    [window resignKeyWindow];
    NSString *remote_name = [conference text];
    NSString *local_name = [localName text];
    NSString *nsConference = [conference text];
    NSString *nsServerAddress = [serverAddress text];
    
    [CONFERENCE_SESSION setUid:local_name];
    IosRoomProfile profile;
    profile.joinWithoutVideo = false;
    int role_index = (int)[roleDropDownMenu returnSelectedIndex];
    if(role_index == 0){
        profile.role = CLIENT_ROLE_COHOST;
    }else if(role_index == 1){
        profile.role = CLIENT_ROLE_VIEWER;
    }else if (role_index ==2 ){
        profile.role = CLIENT_ROLE_ATTENDEE;
    }else {
         profile.role = CLIENT_ROLE_ATTENDEE;
    }

    int index = (int)[resolutionDropDownMenu returnSelectedIndex];
    profile.videoWidth = resolutionInfolist[index].width;
    profile.videoHeight = resolutionInfolist[index].height;
    profile.enableAdaptiveResolution = resolutionInfolist[index].resolution_adapter;
    profile.startMixer = false;
    profile.serverAddress = nsServerAddress;
    NSLog(@"videoWidth %d\n", profile.videoWidth);
    NSLog(@"index %d\n", index);
    NSLog(@"videoHeight %d\n", profile.videoHeight);

    [CONFERENCE_SESSION joinRoom:nsConference withLocalName: local_name  withprofile: profile  withAppToken:@"NTFmNTExYWFmMGFhMjFlY2RjYTdjMTdlZDdiYmI2NGFiNzlhMmI3ZS0xNTU2MTcwMTQ4"];
    [DEVICE_MANAGER startAudioDevice:true];
    [CONFERENCE_SESSION setResolution: profile.videoWidth liveHeight:profile.videoHeight frameRate:20];
    [DEVICE_MANAGER setVideoOutputParam:profile.videoWidth height:profile.videoHeight frameRate:20];
    [DEVICE_MANAGER setCameraParam :profile.videoHeight height:profile.videoWidth frameRate:20];
    [CONFERENCE_SESSION unMuteMicrophone];
    [DEVICE_MANAGER setSpeaker:true];
    [DEVICE_MANAGER unMuteSpeaker];
    if (profile.role != CLIENT_ROLE_VIEWER) {
        [DEVICE_MANAGER startCamera];
    }
    [self saveUserPrefs];
}

- (IBAction)switchCamera:(id)sender
{
    static BOOL useBack = TRUE;
    useBack = !useBack;
    [DEVICE_MANAGER switchCamera];
}


- (void)dealloc
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [textField resignFirstResponder];
        return YES;
}

- (IBAction)reset:(UIButton *)sender {
//    server.text = CONFERENCE_SESSION.server;
//    port.text = CONFERENCE_SESSION.port;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [conference resignFirstResponder];
    [remoteName resignFirstResponder];
    [localName resignFirstResponder];
    [serverAddress resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - keyboardHeight);
    
    NSTimeInterval duration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:duration];
    
    if(offset>0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)keyboardOnScreen:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    keyboardHeight = keyboardFrame.size.height;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) show
{
    [window bringSubviewToFront:[super view]];
}

#pragma mark -
#pragma mark RoomDelegate

- (void) onLoad: (BOOL)success {
    
    NSLog(@"onLoad: %d\n", success);
    
}

- (void) onRemoteUserJoined: (NSString *)uid success: (BOOL)success
{
    if ([CONFERENCE_MANAGER.uid isEqualToString: uid]) {
        NSLog(@"Im onRemoteUserJoined:%@",uid);

    } else {
        NSLog(@"Other onRemoteUserJoined: %@",uid);
    }
}

- (void) onLocalUserJoined
{
    NSLog(@"Other Leave: djl uuuuul");
    //LOG(LS_INFO, APP_TRIVAL_MODULE) << "Conference joined." << std::endl;
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *d = (AppDelegate *) [app delegate];
    [d.navigationController pushViewController:self.videoViewController animated:YES];
}

- (void) onLocalUserLeaved:(CMEngineErrorType)error
{
//      NSLog(@"Other Leave: djllllll");
//    UIApplication *app = [UIApplication sharedApplication];
//    AppDelegate *d = (AppDelegate *) [app delegate];
//
//    [d.navigationController popViewControllerAnimated:NO];
    
}


- (void)onRemoteUserLeaved: (NSString *)uid {
    
    if ([CONFERENCE_MANAGER.uid isEqualToString: uid]) {
        NSLog(@"I'm Leave\n");
    } else {
        NSLog(@"Other Leave onRemoteUserLeaved: %@\n", uid);
        [videoViewController RemoveRemoteStreamForView:uid];
    }
}

- (void) onStartCamera
{
    [videoViewController AddRemoteStreamForView:@""];
}

- (void) onStopCamera
{
    [videoViewController RemoveRemoteStreamForView:@""];
}

- (void) onGetFirstVideoSample:(NSString *)uid
{
    if ([CONFERENCE_MANAGER.uid isEqualToString: uid]) {
        NSLog(@"I'm onGetFirstVideoSample\n");
    } else {
        NSLog(@"Other onGetFirstVideoSample: %@\n", uid);
        [videoViewController AddRemoteStreamForView:uid];
    }
}

@end
