//
//  ViewController.m
//  EyeControl
//
//  Created by Celleus on 2017/08/08.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "ViewController.h"


#import "GameMenuViewController.h"
#import "PanelMenuViewController.h"
#import "SettingViewController.h"

@interface ViewController () <MEMEManagerRealTimeModeDataDelegate,UIScrollViewDelegate,EyeMoveManagerDelegate,NeckManagerDelegate> {
    GameMenuViewController *gameMenuViewController;
    PanelMenuViewController *panelMenuViewController;
    SettingViewController *settingViewController;
    
    UIScrollView *scrollView;
    UIButton *leftButton;
    UIButton *rightButton;
    
    CheckView *checkView;
}

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    gameMenuViewController = [[GameMenuViewController alloc] init];
    settingViewController = [[SettingViewController alloc] init];
    panelMenuViewController = [[PanelMenuViewController alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
//    builder.continue(successBlock: { (awsTask: AWSTask<NSURL>) -> Any? in

//    })
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusH + naviH, self.view.frame.size.width, self.view.frame.size.height - (statusH + naviH + safeAreaBottom))];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + self.view.frame.size.width*i,
                                                                      scrollView.frame.size.height / 2 - 300/2,
                                                                      self.view.frame.size.width - 30*2,
                                                                      300)];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"icon_game.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(gameMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 1) {
            [button setImage:[UIImage imageNamed:@"icon_eyecontrol.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(panelMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 2) {
            [button setImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
        }
        [scrollView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.view.frame.size.width*i,
                                                                   button.frame.origin.y + button.frame.size.height + 20,
                                                                   self.view.frame.size.width - 10*2,
                                                                   20)];
        label.font = [UIFont systemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: @"GAME"];
            [attributedText addAttribute:NSKernAttributeName
                                   value:[NSNumber numberWithFloat:5]
                                   range:NSMakeRange(0, attributedText.length)];
            label.attributedText = attributedText;
            label.textColor = [Common colorWithHex:@"#ef2880"];
        }
        else if (i == 1) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: @"EYE CONTROL"];
            [attributedText addAttribute:NSKernAttributeName
                                   value:[NSNumber numberWithFloat:5]
                                   range:NSMakeRange(0, attributedText.length)];
            label.attributedText = attributedText;
            label.textColor = [Common colorWithHex:@"#52d0b0"];
        }
        else if (i == 2) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: @"SETTING"];
            [attributedText addAttribute:NSKernAttributeName
                                   value:[NSNumber numberWithFloat:5]
                                   range:NSMakeRange(0, attributedText.length)];
            label.attributedText = attributedText;
            label.textColor = [Common colorWithHex:@"#fce437"];
        }
        [scrollView addSubview:label];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20 + 44 + 80, self.view.frame.size.width - 10*2, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"左右の視線移動で選択し、まばたき2回で決定。";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:label];
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 + 44, 30, self.view.frame.size.height - (20 + 44))];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftScroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 20 + 44, 30, self.view.frame.size.height - (20 + 44))];
    [rightButton setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightScroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
    
    checkView = [[CheckView alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height - 70 - 10 - safeAreaBottom,
                                                            self.view.frame.size.width,
                                                            70)];
    [self.view addSubview:checkView];
}

- (void)gameMenu {
    DLog(@"gameMenu");
    [self.navigationController pushViewController:gameMenuViewController animated:YES];
}


- (void)panelMenu {
    DLog(@"panelMenu");
    [self.navigationController pushViewController:panelMenuViewController animated:YES];
}

- (void)setting {
    DLog(@"setting");
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)leftScroll {
    DLog(@"leftScroll")
    leftButton.enabled = NO;
    rightButton.enabled = NO;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - scrollView.frame.size.width, 0) animated:YES];
}

- (void)rightScroll {
    DLog(@"rightScroll")
    leftButton.enabled = NO;
    rightButton.enabled = NO;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + scrollView.frame.size.width, 0) animated:YES];
}

- (void)pdf:(NSURL *)url {
    DLog(@"pdf:%@",url);
    
    panelMenuViewController.pdfURL = url;
    [self.navigationController pushViewController:panelMenuViewController animated:YES];
}

- (void)left:(int)move {
    DLog(@"left move:%d",move)
    CGFloat newX = scrollView.contentOffset.x - scrollView.frame.size.width * move;
    if (newX < 0) {
        newX = 0;
    }
    [scrollView setContentOffset:CGPointMake(newX, 0) animated:YES];
}

- (void)right:(int)move {
    DLog(@"right move:%d",move)
    CGFloat newX = scrollView.contentOffset.x + scrollView.frame.size.width * move;
    if (newX > scrollView.frame.size.width*2) {
        newX = scrollView.frame.size.width*2;
    }
    [scrollView setContentOffset:CGPointMake(newX, 0) animated:YES];
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
}

//**************************************************
// UIScrollViewDelegate
//**************************************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.x + (0.5*scrollView.bounds.size.width)) / scrollView.bounds.size.width + 1;
    if (page == 1) {
        leftButton.hidden = YES;
        rightButton.hidden = NO;
    }
    else if (page == 3) {
        leftButton.hidden = NO;
        rightButton.hidden = YES;
    }
    else {
        leftButton.hidden = NO;
        rightButton.hidden = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    DLog(@"scrollViewDidEndScrollingAnimation")
    leftButton.enabled = YES;
    rightButton.enabled = YES;
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
            
            self.view.backgroundColor = [Common colorWithHex:@"516577"];
            [NSThread sleepForTimeInterval:0.2];
            
            // 決定
            int page = (scrollView.contentOffset.x + (0.5*scrollView.bounds.size.width)) / scrollView.bounds.size.width + 1;
            if (page == 1) {
                [self gameMenu];
            }
            else if (page == 2) {
                [self panelMenu];
            }
            else if (page == 3) {
                [self setting];
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
    }
}

//**************************************************
// NeckManagerDelegate
//**************************************************

- (void)didPeakNeck:(int)direction count:(int)count {
    DLog(@"didPeakNeck direction:%d count:%d",direction,count);
    
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
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
    }
}
// 首振りの片道
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
