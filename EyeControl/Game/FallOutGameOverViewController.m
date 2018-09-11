//
//  FallOutGameOverViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/17.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "FallOutGameOverViewController.h"

#import "FallOutGameViewController.h"

@interface FallOutGameOverViewController () {
    CheckView *checkView;
    
    UIButton *backButton;
    UIButton *replayButton;
    UIButton *selectButton;
}

@end

@implementation FallOutGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // スコア
    UILabel *gameoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, statusH + naviH + safeAreaTop + 20, self.view.frame.size.width-20*2, 30)];
    gameoverLabel.backgroundColor = [UIColor clearColor];
    gameoverLabel.textColor = [Common colorWithHex:@"#ef2880"];
    gameoverLabel.textAlignment = NSTextAlignmentCenter;
    gameoverLabel.font = [UIFont boldSystemFontOfSize:25];
    gameoverLabel.text = @"ゲームオーバー";
    [self.view addSubview:gameoverLabel];
    
    // スコア
    UILabel *scoreLable = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    gameoverLabel.frame.origin.y + gameoverLabel.frame.size.height + 20,
                                                                    self.view.frame.size.width-20*2,
                                                                    30)];
    scoreLable.backgroundColor = [UIColor clearColor];
    scoreLable.textColor = [Common colorWithHex:@"#ef2880"];
    scoreLable.textAlignment = NSTextAlignmentCenter;
    scoreLable.font = [UIFont systemFontOfSize:20];
    scoreLable.text = @"スコア";
    [self.view addSubview:scoreLable];
    
    UILabel *scoreLable_ = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     scoreLable.frame.origin.y + scoreLable.frame.size.height,
                                                                     self.view.frame.size.width-20*2,
                                                                     30)];
    scoreLable_.backgroundColor = [UIColor clearColor];
    scoreLable_.textColor = [Common colorWithHex:@"#ffffff"];
    scoreLable_.textAlignment = NSTextAlignmentCenter;
    scoreLable_.font = [UIFont systemFontOfSize:20];
    scoreLable_.text = self.score;
    [self.view addSubview:scoreLable_];
    
    // ハイスコア
    UILabel *highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                        scoreLable_.frame.origin.y + scoreLable_.frame.size.height + 20,
                                                                        self.view.frame.size.width-20*2,
                                                                        30)];
    highScoreLabel.backgroundColor = [UIColor clearColor];
    highScoreLabel.textColor = [Common colorWithHex:@"#ef2880"];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.font = [UIFont systemFontOfSize:20];
    highScoreLabel.text = @"ハイスコア";
    [self.view addSubview:highScoreLabel];
    
    UILabel *highScoreLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                         highScoreLabel.frame.origin.y + highScoreLabel.frame.size.height,
                                                                         self.view.frame.size.width-20*2,
                                                                         30)];
    highScoreLabel_.backgroundColor = [UIColor clearColor];
    highScoreLabel_.textColor =[Common colorWithHex:@"#ffffff"];
    highScoreLabel_.textAlignment = NSTextAlignmentCenter;
    highScoreLabel_.font = [UIFont systemFontOfSize:20];
    highScoreLabel_.text = self.highScore;
    [self.view addSubview:highScoreLabel_];
    
    
    CGFloat buttonSize = 100;
    CGFloat buttonMargin = (self.view.frame.size.width - buttonSize*2) / 3;
    
    // もどる
    backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(buttonMargin,
                                  highScoreLabel_.frame.origin.y + highScoreLabel_.frame.size.height + 40,
                                  buttonSize,
                                  buttonSize);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.layer.cornerRadius = 10;
    backButton.clipsToBounds = YES;
    backButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    backButton.layer.borderWidth = 2;
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitle:@"タイトル" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(gameBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // もう一度
    replayButton = [[UIButton alloc] init];
    replayButton.frame = CGRectMake(buttonMargin + (buttonSize + buttonMargin) * 1,
                                    highScoreLabel_.frame.origin.y + highScoreLabel_.frame.size.height + 40,
                                    buttonSize,
                                    buttonSize);
    replayButton.backgroundColor = [UIColor clearColor];
    replayButton.layer.cornerRadius = 10;
    replayButton.clipsToBounds = YES;
    replayButton.layer.borderColor = [[Common colorWithHex:@"#ef2880"] CGColor];
    replayButton.layer.borderWidth = 2;
    replayButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [replayButton setTitle:@"もう一度" forState:UIControlStateNormal];
    [replayButton setTitleColor:[Common colorWithHex:@"#ef2880"] forState:UIControlStateNormal];
    [replayButton addTarget:self action:@selector(gameReplay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replayButton];
    
    selectButton = replayButton;
    [self selectButton];
    
    
    checkView = [[CheckView alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height - 70 - 10 - safeAreaBottom,
                                                            self.view.frame.size.width,
                                                            70)];
    [self.view addSubview:checkView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gameReplay {
    [self.fallOutGameViewController clearScaffold];
    [self dismissViewControllerAnimated:NO completion:^{
         [self.fallOutGameViewController restart];
    }];
}

- (void)gameBack {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectButton {
    DLog(@"selectButton")
    
    backButton.layer.borderColor = [[Common colorWithHex:@"#ffffff"] CGColor];
    [backButton setTitleColor:[Common colorWithHex:@"#ffffff"] forState:UIControlStateHighlighted];
    replayButton.layer.borderColor = [[Common colorWithHex:@"#ffffff"] CGColor];
    [replayButton setTitleColor:[Common colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
    
    selectButton.layer.borderColor = [[Common colorWithHex:@"#ef2880"] CGColor];
    [selectButton setTitleColor:[Common colorWithHex:@"#ef2880"] forState:UIControlStateNormal];
}

- (void)left:(int)move {
    DLog(@"left move:%d",move)
    if (move > 0) {
        if (selectButton == backButton) {
        }
        else if (selectButton == replayButton) {
            selectButton = backButton;
        }
        [self selectButton];
    }
}

- (void)right:(int)move {
    DLog(@"right move:%d",move)
    if (move > 0) {
        if (selectButton == backButton) {
            selectButton = replayButton;
        }
        else if (selectButton == replayButton) {
            
        }
        [self selectButton];
    }
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
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
            if (selectButton == backButton) {
                [self gameBack];
            }
            else if (selectButton == replayButton) {
                [self gameReplay];
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
