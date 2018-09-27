//
//  DialogViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/10.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "DialogViewController.h"

#import "CustomViewController.h"

@interface DialogViewController () <MEMEManagerRealTimeModeDataDelegate,MEMEManagerPairingDelegate,EyeMoveManagerDelegate,NeckManagerDelegate> {
    UIButton *yesButton;
    UIButton *noButton;
    UIButton *selectButton;
}

@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30,
                                                            (self.view.frame.size.height - 100) / 2,
                                                            self.view.frame.size.width - 30*2,
                                                            120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               0,
                                                               view.frame.size.width-10*2,
                                                               view.frame.size.height/2)];
    label.textColor = [UIColor darkGrayColor];
    label.text = NSLocalizedString(@"戻りますか？",nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:label];
    
    noButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                          view.frame.size.height/2,
                                                          view.frame.size.width/2,
                                                          view.frame.size.height/2)];
    [noButton setTitle:NSLocalizedString(@"いいえ",nil) forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [noButton addTarget:self action:@selector(noTouch) forControlEvents:UIControlEventTouchUpInside];
    noButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [view addSubview:noButton];
    
    yesButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width/2,
                                                          view.frame.size.height/2,
                                                          view.frame.size.width/2,
                                                          view.frame.size.height/2)];
    [yesButton setTitle:NSLocalizedString(@"はい",nil) forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [yesButton addTarget:self action:@selector(yesTouch) forControlEvents:UIControlEventTouchUpInside];
    yesButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [view addSubview:yesButton];
    
    selectButton = yesButton;
    [self selectButton];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               view.frame.size.height/2,
                                                               view.frame.size.width,
                                                               1)];
    line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width/2,
                                                             view.frame.size.height/2,
                                                             1,
                                                             view.frame.size.height/2)];
    line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [view addSubview:line2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"viewDidAppear");
    
    [EyeMoveManager sharedInstance].delegate = self;
    [NeckManager sharedInstance].delegate = self;
    [MEMEManager sharedInstance].realTimeModeDataDelegate = self;
    [MEMEManager sharedInstance].pairingDelegate = self;
}

- (void)selectButton {
    DLog(@"selectButton")
    
    [noButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [yesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [selectButton setTitleColor:[Common colorWithHex:@"#57e6be"] forState:UIControlStateNormal];
    [selectButton setTitleColor:[Common colorWithHex:@"#a3ffe5"] forState:UIControlStateHighlighted];
}

- (void)noTouch {
    DLog(@"noTouch")
    [self dismissViewControllerAnimated:YES completion:^{
        [EyeMoveManager sharedInstance].delegate = self.viewController;
        [NeckManager sharedInstance].delegate = self.viewController;
        [MEMEManager sharedInstance].realTimeModeDataDelegate = self.viewController;
        [MEMEManager sharedInstance].pairingDelegate = self.viewController;
    }];
}

- (void)yesTouch {
    DLog(@"yesTouch")
    [self dismissViewControllerAnimated:YES completion:^{
        [self.viewController pop];
    }];
}

- (void)left:(int)move {
    DLog(@"left move:%d",move)
    if (move > 0) {
        if (selectButton == noButton) {
            [self selectButton];
        }
        else if (selectButton == yesButton) {
            selectButton = noButton;
        }
    }
}

- (void)right:(int)move {
    DLog(@"right move:%d",move)
    if (move > 0) {
        if (selectButton == noButton) {
            selectButton = yesButton;
            [self selectButton];
        }
        else if (selectButton == yesButton) {
            
        }
    }
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
}

//**************************************************
// MEMEManagerPairingDelegate
//**************************************************

// ペリフェルとの切断
- (void)memePeripheralDisconnected:(CBPeripheral *)peripheral {
    DLog(@"memePeripheralDisconnected:%@",[peripheral.identifier UUIDString]);
    
    [[MEMEManager sharedInstance].peripherals removeAllObjects];
    
    [self alert:NSLocalizedString(@"MEMEとの接続が切れました",nil) message:@""];
}

//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    
    if ([[Common getUserDefaultsForKey:EYE_SWITCH] boolValue]) {
        [[EyeMoveManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if ([[Common getUserDefaultsForKey:NECK_SWITCH] boolValue]) {
        [[NeckManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if (data.blinkSpeed) {
        double now = [[NSDate date] timeIntervalSince1970];
        if (now - blinkDateDouble <= [[Common getUserDefaultsForKey:Blink_EMC2] floatValue]) {
            
            // 決定
            if (selectButton == noButton) {
                [self noTouch];
            }
            else if (selectButton == yesButton) {
                [self yesTouch];
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
    }
    else if (direction == NeckManagerDirectionRight) {
    }
}


@end
