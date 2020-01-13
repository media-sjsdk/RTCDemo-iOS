//
//  MoreServerSettingsViewController.m
//  ShijeRoomIos
//
//  Copyright (c) 2015年 Shisu.Inc. All rights reserved.
//

#import "MoreServerSettingsViewController.h"
#import "ConferenceManager.h"

static int keyboardHeight=216;

@implementation MoreServerSettingsViewController

@synthesize server;
@synthesize port;
@synthesize remoteName;
@synthesize localName;
@synthesize p2pCallButton;
@synthesize callerSideButton;



- (id)init
{
    self = [super initWithNibName: @"MoreServerSettingsWindow" bundle: nil];
    if (self) {
        self.title = @"Server Settings";
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
    return self;
}

- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];
    
#ifdef NOT_RELEASE
    server.text = CONFERENCE_SESSION.server;
    port.text = CONFERENCE_SESSION.port;
#endif
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [callerSideButton setOn:[prefs boolForKey:@"KEY_CALLER"]];
    [p2pCallButton setOn:[prefs boolForKey:@"KEY_IS_P2P"]];
    [remoteName setText:[prefs stringForKey:@"KEY_REMOTE_NAME"]];
    [localName setText:[prefs stringForKey:@"KEY_LOCAL_NAME"]];
    
    // 设置不显示NavigationBar
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (server.text != nil && ![server.text isEqualToString: @""]
        && port.text != nil && ! [port.text isEqualToString: @""]) {
        
        const char *cServer = [server.text cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cPort = [port.text cStringUsingEncoding:NSUTF8StringEncoding];
        NSString *filename = [NSTemporaryDirectory() stringByAppendingString:@"/vidyoSave.txt"];
        FILE *filePtr = fopen([filename cStringUsingEncoding:NSUTF8StringEncoding], "w");
        NSString *dataFormat = [[NSString alloc] initWithFormat:@"%s:%s", cServer, cPort];
        fwrite([dataFormat cStringUsingEncoding:NSUTF8StringEncoding], [dataFormat length] + 1, 1, filePtr);
        fclose(filePtr);
    }
    
    BOOL isP2P = p2pCallButton.isOn;
    BOOL isCaller = callerSideButton.isOn;
    NSString *remoteNameStr = [remoteName text];
    NSString *localNameStr = [localName text];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setBool:isCaller forKey:@"KEY_CALLER"];
    [prefs setBool:isP2P forKey:@"KEY_IS_P2P"];
    [prefs setObject:remoteNameStr forKey:@"KEY_REMOTE_NAME"];
    [prefs setObject:localNameStr forKey:@"KEY_LOCAL_NAME"];
    [prefs synchronize];
}

-(BOOL) shouldAutorotate {
    return NO;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == server) {
        [port becomeFirstResponder];
    } else if(textField == port) {
        [port resignFirstResponder];
        
    }
    else {
        [textField resignFirstResponder];
        return YES;
    }
    
    
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [server resignFirstResponder];
    [port resignFirstResponder];
    [remoteName resignFirstResponder];
    [localName resignFirstResponder];
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

- (IBAction)reset:(UIButton *)sender {
#ifdef NOT_RELEASE
    server.text = CONFERENCE_SESSION.server;
    port.text = CONFERENCE_SESSION.port;
#endif
}

@end
