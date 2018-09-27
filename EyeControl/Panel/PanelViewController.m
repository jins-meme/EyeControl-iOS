//
//  PanelViewController.m
//  EyeControl
//
//  Created by Celleus on 2017/08/21.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "PanelViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <AWSPolly/AWSPolly.h>
#import <AVFoundation/AVFoundation.h>

#import "OriginalPanelView.h"
#import "ABCPanelView.h"

@interface PanelViewController () <MEMEManagerRealTimeModeDataDelegate,EyeMoveManagerDelegate,NeckManagerDelegate,UITextFieldDelegate,UIScrollViewDelegate> {

    OriginalPanelView *originalPanelView;
    
    UIButton *selectButton;
    NSString *buttonTitle;
    
    UIButton *clearButton;
    UILabel *historyLabel;
    
    CheckView *checkView;
    
    AVAudioPlayer *soundPlayer;
    
    AVAudioPlayer *audioPlayer;
}

@end

@implementation PanelViewController

- (void)loadView {
    [super loadView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
    NSURL *fileUrl  = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    soundPlayer.numberOfLoops = -1;
    if(!error) {
        [soundPlayer prepareToPlay];
    } else {
        NSLog(@"AVAudioPlayer Error");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = NSLocalizedString( @"メッセージパネル",nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                                          self.view.frame.size.width - 20*2,
                                                                          30)];
    descriptionLabel.text = NSLocalizedString( @"左右の視線移動で選択し、まばたき2回で決定。",nil);
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [Common colorWithHex:@"#ffffff"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptionLabel];
    
    
    CGFloat labelH = 30;
    CGFloat historyH = 50;
    CGFloat checkH = 40;
    CGFloat bottomMargin = 10;
    
    originalPanelView = [[OriginalPanelView alloc] initWithFrame:CGRectMake(0,
                                                                            descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height,
                                                                            self.view.frame.size.width,
                                                                            self.view.frame.size.height - (descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelH + historyH + labelH + checkH + bottomMargin + safeAreaBottom))
                                                        delegate:self
                                                          udfKey:ORIGINAL_PANEL_2];
    [self.view addSubview:originalPanelView];
    
    selectButton = originalPanelView.buttonArray[1][1];
    [self selectButtonClear];
    [self selectButtonBorderColor];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                      originalPanelView.frame.origin.y + originalPanelView.frame.size.height,
                                                                      self.view.frame.size.width - 20*2,
                                                                      labelH)];
    messageLabel.text = NSLocalizedString( @"メッセージ",nil);
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.textColor = [Common colorWithHex:@"#ffffff"];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:messageLabel];
    
    UIView *historyLabelBorderView  = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                               messageLabel.frame.origin.y + messageLabel.frame.size.height,
                                                                               self.view.frame.size.width - (10 + 10 + 50 + 10),
                                                                               historyH)];
    [historyLabelBorderView.layer setBorderWidth:2.0];
    [historyLabelBorderView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.view addSubview:historyLabelBorderView];
    
    historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                             0,
                                                             historyLabelBorderView.frame.size.width - (5)*2,
                                                             historyLabelBorderView.frame.size.height - (0)*2)];
    historyLabel.font = [UIFont systemFontOfSize:14];
    historyLabel.textAlignment = NSTextAlignmentCenter;
    historyLabel.minimumScaleFactor = 0.5;
    historyLabel.textColor = [UIColor whiteColor];
    [historyLabelBorderView addSubview:historyLabel];
    
    clearButton = [[UIButton alloc] initWithFrame:CGRectMake(historyLabelBorderView.frame.origin.x + historyLabelBorderView.frame.size.width + 10,
                                                             messageLabel.frame.origin.y + messageLabel.frame.size.height,
                                                             50,
                                                             historyH)];
    [clearButton setTitle:NSLocalizedString( @"消去",nil) forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton.layer setBorderWidth:2.0];
    [clearButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    checkView = [[CheckView alloc] initWithFrame:CGRectMake(0,
                                                            historyLabelBorderView.frame.origin.y + historyLabelBorderView.frame.size.height,
                                                            self.view.frame.size.width,
                                                            labelH + checkH)];
    [self.view addSubview:checkView];
}

- (void)changeButtonTitle:(UIButton *)button {
    buttonTitle = button.titleLabel.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"パネルの変更",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                
                                                NSIndexPath *path = [self getIndexPath:button];
                                                
                                                [originalPanelView.buttonTitleArray[path.section] replaceObjectAtIndex:path.row
                                                                                          withObject:buttonTitle];
                                                [Common setUserDefaults:originalPanelView.buttonTitleArray forKey:originalPanelView.udfKey];
                                                
                                                [button setTitle:buttonTitle forState:UIControlStateNormal];
                                            }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = buttonTitle;
        textField.delegate = self;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSIndexPath *)getIndexPath:(UIButton *)button {
    
    for (NSMutableArray *array in originalPanelView.buttonArray) {
        for (UIButton *btn in array) {
            if (btn == button) {
                return [NSIndexPath indexPathForRow:[array indexOfObject:btn]
                                          inSection:[originalPanelView.buttonArray indexOfObject:array]];
            }
        }
    }
    
    return nil;
}

- (void)call:(BOOL)boolean {
    DLog(@"call:%@", boolean ? @"YES" : @"NO");
    if (boolean) {
        soundPlayer.currentTime = 0;
        [soundPlayer prepareToPlay];
        [soundPlayer play];
    }
    else {
        [soundPlayer stop];
    }
}

- (void)clearText {
    DLog(@"clearText");
    historyLabel.text = @"";
}

- (void)selectButtonBorderColor {
    DLog(@"selectButtonBorderColor");
    
    for (NSMutableArray *array in originalPanelView.buttonArray) {
        for (UIButton *button in array) {
            [button.layer setBorderWidth:2.0];
            if (button == selectButton) {
                [button.layer setBorderColor:[Common colorWithHex:@"#52d0b0"].CGColor];
                [button setTitleColor:[Common colorWithHex:@"#52d0b0"] forState:UIControlStateNormal];
            }
            else {
                [button.layer setBorderColor:[UIColor whiteColor].CGColor];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)selectButtonClear {
    DLog(@"selectButtonClear");
    
    for (NSMutableArray *array in originalPanelView.buttonArray) {
        for (UIButton *button in array) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            button.tag = 0;
        }
    }
}

- (void)speach:(NSString *)text {
    DLog(@"speach:%@",text);
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionAPNortheast1
                                                                                                    identityPoolId:AWS_POOL_ID];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPNortheast1
                                                                         credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    AWSPollySynthesizeSpeechURLBuilderRequest *input = [[AWSPollySynthesizeSpeechURLBuilderRequest alloc] init];
    input.text = text;
    input.outputFormat = AWSPollyOutputFormatMp3;
    input.voiceId = AWSPollyVoiceIdMizuki;
    AWSTask *builder = [[AWSPollySynthesizeSpeechURLBuilder defaultPollySynthesizeSpeechURLBuilder] getPreSignedURL:input];
    
    [builder continueWithBlock:^id(AWSTask *awsTask){
        NSURL *url = awsTask.result;
        DLog(@"url:%@",url)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            NSError *error = nil;
            audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
            
            if (!error) {
                [audioPlayer play];
            }
            else {
                DLog(@"error:%@",error);
            }
        });
        
        return nil;
    }];
    
}

- (void)left:(int)move {
    NSIndexPath *path = [self getIndexPath:selectButton];
    if (path) {
        if (path.row >= move) {
            selectButton = originalPanelView.buttonArray[path.section][path.row - move];
        }
        else {
            if (path.section == 0) {
                selectButton = originalPanelView.buttonArray[[originalPanelView.buttonArray count] - 1][[originalPanelView.buttonArray[path.section] count] - 1];
            }
            else {
                selectButton = originalPanelView.buttonArray[path.section - 1][[originalPanelView.buttonArray[path.section] count] - 1];
            }
        }
        [self selectButtonClear];
        [self selectButtonBorderColor];
    }
}

- (void)right:(int)move {
    NSIndexPath *path = [self getIndexPath:selectButton];
    if (path) {
        if (path.row <= (([originalPanelView.buttonArray[path.section] count] - 1) - move)) {
            selectButton = originalPanelView.buttonArray[path.section][path.row + move];
        }
        else {
            if ([originalPanelView.buttonArray count] - 1 == path.section) {
                selectButton = originalPanelView.buttonArray[0][0];
            }
            else {
                selectButton = originalPanelView.buttonArray[path.section+1][0];
            }
            
        }
        [self selectButtonClear];
        [self selectButtonBorderColor];
    }
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
}

//**************************************************
// UITextFieldDelegate
//**************************************************

// textfieldのエンターキーを押したときの処理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// テキストフィールドの値が変化するたび更新
- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *result = [tf.text stringByReplacingCharactersInRange:range withString:string];
    buttonTitle = result;
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    [super memeRealTimeModeDataReceived:data];
    
    if ([[Common getUserDefaultsForKey:EYE_SWITCH] boolValue]) {
        [[EyeMoveManager sharedInstance] memeRealTimeModeDataReceived:data];
        
        if (data.eyeMoveLeft == 1) {
            [checkView setCheckHighlight:checkView.left1];
        }
        else if (data.eyeMoveLeft == 2) {
            [checkView setCheckHighlight:checkView.left2];
        }
        else if (data.eyeMoveLeft == 3) {
            [checkView setCheckHighlight:checkView.left3];
        }
        else if (data.eyeMoveRight == 1) {
            [checkView setCheckHighlight:checkView.right1];
        }
        else if (data.eyeMoveRight == 2) {
            [checkView setCheckHighlight:checkView.right2];
        }
        else if (data.eyeMoveRight == 3) {
            [checkView setCheckHighlight:checkView.right3];
        }
    }
    
    if ([[Common getUserDefaultsForKey:NECK_SWITCH] boolValue]) {
        [[NeckManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if (data.blinkSpeed) {
        double now = [[NSDate date] timeIntervalSince1970];
        
        [checkView setCheckHighlight:checkView.blink];
        
        if (now - blinkDateDouble <= [[Common getUserDefaultsForKey:Blink_EMC2] floatValue]) {
            if (!selectButton.tag) {
                [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                selectButton.backgroundColor = [Common colorWithHex:@"#52d0b0"];
                selectButton.tag = 1;
                
                if ([[Common getUserDefaultsForKey:READ_SWITCH] boolValue]) {
                    [self speach:selectButton.titleLabel.text];
                }
                    
                historyLabel.text = selectButton.titleLabel.text;
            }
            else {
                
                if (selectButton != clearButton) {
                    [selectButton setTitleColor:[Common colorWithHex:@"#52d0b0"] forState:UIControlStateNormal];
                    selectButton.backgroundColor = [UIColor clearColor];
                }
                else {
                    [clearButton setTitleColor:[Common colorWithHex:@"#52d0b0"] forState:UIControlStateNormal];
                    clearButton.backgroundColor = [UIColor clearColor];
                }
                selectButton.tag = 0;
                
                [self call:NO];
            }
        }
        blinkDateDouble = now;
    }
}

//**************************************************
// EyeMoveManagerDelegate
//**************************************************

- (void)didPeakEyeMove:(EyeMoveManagerDirection)direction count:(int)count eyeMove:(int)eyeMove {
    DLog(@"didPeakEyeMove direction:%d count:%d eyeMove:%d",direction,count,eyeMove);
    
    int move = 0;
    
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
        DialogViewController *viewController = [[DialogViewController alloc] init];
        viewController.viewController = self;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        // モード1
        if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 0) {
            move = 0;
            if (count > 1) {
                move = 1;
                if (abs(eyeMove) > 1) {
                    move = 2;
                }
            }
        }
        // モード2
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 1) {
            move = 0;
            if (count > 1) {
                move = 1;
            }
        }
        // モード3
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 2) {
            move = 0;
            if (count > 1 && abs(eyeMove) > 1) {
                move = 1;
            }
        }
        // モード4
        else {
            move = 0;
            if (abs(eyeMove) > 1) {
                move = 1;
            }
        }
        
        if (direction == EyeMoveManagerDirectionUp) {
            [self down:move];
        }
        else if (direction == EyeMoveManagerDirectionLeft) {
            [self right:move];
        }
        else if (direction == EyeMoveManagerDirectionDown) {
            [self up:move];
        }
        else if (direction == EyeMoveManagerDirectionRight) {
            [self left:move];
        }
        
        [self call:NO];
    }
}

//**************************************************
// NeckManagerDelegate
//**************************************************

- (void)didPeakNeck:(int)direction count:(int)count {
    DLog(@"didPeakNeck direction:%d count:%d",direction,count);
    
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
        DialogViewController *viewController = [[DialogViewController alloc] init];
        viewController.viewController = self;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else if (count >= 2) {
        int move = 1;
        
        if (direction == EyeMoveManagerDirectionUp) {
            [self up:move];
        }
        else if (direction == EyeMoveManagerDirectionLeft) {
            [self left:move];
        }
        else if (direction == EyeMoveManagerDirectionDown) {
            [self down:move];
        }
        else if (direction == EyeMoveManagerDirectionRight) {
            [self right:move];
        }
        
        [self call:NO];
    }
}
- (void)peakNeck:(int)direction {
    DLog(@"peakNeck direction:%d",direction);
    
    if (direction == NeckManagerDirectionLeft) {
        [checkView setCheckHighlight:checkView.left1];
    }
    else if (direction == NeckManagerDirectionRight) {
        [checkView setCheckHighlight:checkView.right1];
    }
}

@end
